//
//  noFilter.c
//  C_test
//
//  Created by runo on 17/2/17.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#include "noFilter.h"

#include "libavcodec/avcodec.h"
#include "libavformat/avformat.h"
#include "libavcodec/avcodec.h"
#include "libavfilter/buffersink.h"
#include "libavfilter/buffersrc.h"
#include "libavutil/avutil.h"
#include "libavutil/opt.h"
#include "libavutil/pixdesc.h"
#include "libavutil/mathematics.h"


static AVFormatContext *ifmt_ctx;
static AVFormatContext *ofmt_ctx;

static int open_input_file(const char *filename)
{
    int ret;
    unsigned int i;
    ifmt_ctx =NULL;
    if ((ret = avformat_open_input(&ifmt_ctx,filename, NULL, NULL)) < 0) {
        av_log(NULL, AV_LOG_ERROR, "Cannot openinput file\n");
        return ret;
    }
    
    if ((ret = avformat_find_stream_info(ifmt_ctx, NULL))< 0) {
        av_log(NULL, AV_LOG_ERROR, "Cannot findstream information\n");
        return ret;
    }
    
    for (i = 0; i < ifmt_ctx->nb_streams; i++) {
        AVStream*stream;
        AVCodecContext *codec_ctx;
        stream =ifmt_ctx->streams[i];
        codec_ctx =stream->codec;
        /* Reencode video & audio and remux subtitles etc. */
        if (codec_ctx->codec_type == AVMEDIA_TYPE_VIDEO
            ||codec_ctx->codec_type == AVMEDIA_TYPE_AUDIO) {
            /* Open decoder */
            ret =avcodec_open2(codec_ctx,
                               avcodec_find_decoder(codec_ctx->codec_id), NULL);
            if (ret < 0) {
                av_log(NULL, AV_LOG_ERROR, "Failed toopen decoder for stream #%u\n", i);
                return ret;
            }
        }
    }
    printf("-----inputfile info ----\n");
    av_dump_format(ifmt_ctx, 0, filename, 0);
    printf("-----end inputfile info----\n");
    return 0;
}
static int open_output_file(const char *filename)
{
    AVStream*out_stream;
    AVStream*in_stream;
    AVCodecContext*dec_ctx, *enc_ctx;
    AVCodec*encoder;
    int ret;
    unsigned int i;
    ofmt_ctx =NULL;
    avformat_alloc_output_context2(&ofmt_ctx, NULL, NULL, filename);
    if (!ofmt_ctx) {
        av_log(NULL, AV_LOG_ERROR, "Could notcreate output context\n");
        return AVERROR_UNKNOWN;
    }
    for (i = 0; i < ifmt_ctx->nb_streams; i++) {
        out_stream= avformat_new_stream(ofmt_ctx, NULL);
        if (!out_stream) {
            av_log(NULL, AV_LOG_ERROR, "Failedallocating output stream\n");
            return AVERROR_UNKNOWN;
        }
        in_stream =ifmt_ctx->streams[i];
        dec_ctx =in_stream->codec;
        enc_ctx =out_stream->codec;
        
        if (dec_ctx->codec_type == AVMEDIA_TYPE_VIDEO
            ||dec_ctx->codec_type == AVMEDIA_TYPE_AUDIO) {
            /* in this example, we choose transcoding to same codec */
            
            /* In this example, we transcode to same properties(picture size,
             * sample rate etc.). These properties can be changed for output
             * streams easily using filters */
            if (dec_ctx->codec_type == AVMEDIA_TYPE_VIDEO) {
                encoder = avcodec_find_encoder(AV_CODEC_ID_MPEG4);
                enc_ctx->height = dec_ctx->height;
                enc_ctx->width = dec_ctx->width;
                enc_ctx->sample_aspect_ratio = dec_ctx->sample_aspect_ratio;
                /* take first format from list of supported formats */
                enc_ctx->pix_fmt = encoder->pix_fmts[0];
                /* video time_base can be set to whatever is handy andsupported by encoder */
                enc_ctx->time_base = dec_ctx->time_base;
            } else {
                encoder = avcodec_find_encoder(AV_CODEC_ID_AAC);
                enc_ctx->sample_rate = dec_ctx->sample_rate;
                enc_ctx->channel_layout = dec_ctx->channel_layout;
                enc_ctx->channels = av_get_channel_layout_nb_channels(enc_ctx->channel_layout);
                /* take first format from list of supported formats */
                enc_ctx->sample_fmt = encoder->sample_fmts[0];
                AVRational time_base = {1, enc_ctx->sample_rate};
                enc_ctx->time_base = time_base;
            }
            
            /* Third parameter can be used to pass settings to encoder*/
            ret =avcodec_open2(enc_ctx, encoder, NULL);
            if (ret < 0) {
                av_log(NULL, AV_LOG_ERROR, "Cannot openvideo encoder for stream #%u\n", i);
                return ret;
            }
        } else if(dec_ctx->codec_type == AVMEDIA_TYPE_UNKNOWN) {
            av_log(NULL, AV_LOG_FATAL, "Elementarystream #%d is of unknown type, cannot proceed\n", i);
            return AVERROR_INVALIDDATA;
        } else {
            /* if this stream must be remuxed */
            ret =avcodec_copy_context(ofmt_ctx->streams[i]->codec,
                                      ifmt_ctx->streams[i]->codec);
            if (ret < 0) {
                av_log(NULL, AV_LOG_ERROR, "Copyingstream context failed\n");
                return ret;
            }
        }
        if (ofmt_ctx->oformat->flags &AVFMT_GLOBALHEADER)
            enc_ctx->flags |= CODEC_FLAG_GLOBAL_HEADER;
    }
    printf("-----outputfile info ----\n");
    av_dump_format(ofmt_ctx, 0, filename, 1);
    printf("-----end outputfile ----\n");
    if (!(ofmt_ctx->oformat->flags &AVFMT_NOFILE)) {
        ret =avio_open(&ofmt_ctx->pb, filename, AVIO_FLAG_WRITE);
        if (ret < 0) {
            av_log(NULL, AV_LOG_ERROR, "Could notopen output file '%s'", filename);
            return ret;
        }
    }
    /* init muxer, write output file header */
    ret =avformat_write_header(ofmt_ctx, NULL);
    if (ret < 0) {
        av_log(NULL,AV_LOG_ERROR, "Error occurred when openingoutput file\n");
        return ret;
    }
    return 0;
}


static int encode_write_frame(AVFrame *filt_frame, unsigned int stream_index, int*got_frame) {
    int ret;
    int got_frame_local;
    AVPacket enc_pkt;
    int (*enc_func)(AVCodecContext *, AVPacket *, const AVFrame *, int*) =
    (ifmt_ctx->streams[stream_index]->codec->codec_type ==
     AVMEDIA_TYPE_VIDEO) ? avcodec_encode_video2 : avcodec_encode_audio2;
    if (!got_frame)
        got_frame =&got_frame_local;
    av_log(NULL,AV_LOG_INFO, "Encoding frame\n");
    /* encode filtered frame */
    enc_pkt.data =NULL;
    enc_pkt.size =0;
    av_init_packet(&enc_pkt);
    ret =enc_func(ofmt_ctx->streams[stream_index]->codec, &enc_pkt,
                  filt_frame, got_frame);
    av_frame_free(&filt_frame);
    if (ret < 0)
        return ret;
    if (!(*got_frame))
        return 0;
    /* prepare packet for muxing */
    enc_pkt.stream_index = stream_index;
    enc_pkt.dts =av_rescale_q_rnd(enc_pkt.dts,
                                  ofmt_ctx->streams[stream_index]->codec->time_base,
                                  ofmt_ctx->streams[stream_index]->time_base,
                                  (AV_ROUND_NEAR_INF|AV_ROUND_PASS_MINMAX));
    enc_pkt.pts =av_rescale_q_rnd(enc_pkt.pts,
                                  ofmt_ctx->streams[stream_index]->codec->time_base,
                                  ofmt_ctx->streams[stream_index]->time_base,
                                  (AV_ROUND_NEAR_INF|AV_ROUND_PASS_MINMAX));
    enc_pkt.duration = av_rescale_q(enc_pkt.duration,
                                    ofmt_ctx->streams[stream_index]->codec->time_base,
                                    ofmt_ctx->streams[stream_index]->time_base);
    av_log(NULL,AV_LOG_DEBUG, "Muxing frame\n");
    /* mux encoded frame */
    ret =av_interleaved_write_frame(ofmt_ctx, &enc_pkt);
    return ret;
}
static int filter_encode_write_frame(AVFrame *frame, unsigned int stream_index)
{
    int ret;
    AVFrame*filt_frame;
    av_log(NULL,AV_LOG_INFO, "Pushing decoded frame tofilters\n");
    /* push the decoded frame into the filtergraph */
    
    if (ret < 0) {
        av_log(NULL, AV_LOG_ERROR, "Error whilefeeding the filtergraph\n");
        return ret;
    }
    /* pull filtered frames from the filtergraph */
    while (1) {
        filt_frame= av_frame_alloc();
        if (!filt_frame) {
            ret =AVERROR(ENOMEM);
            break;
        }
        av_log(NULL, AV_LOG_INFO, "Pullingfiltered frame from filters\n");
        ret =av_frame_copy(filt_frame, frame);
        if (ret < 0) {
            /* if nomore frames for output - returns AVERROR(EAGAIN)
             * if flushed and no more frames for output - returns AVERROR_EOF
             * rewrite retcode to 0 to show it as normal procedure completion
             */
            if (ret == AVERROR(EAGAIN) || ret == AVERROR_EOF)
                ret= 0;
            av_frame_free(&filt_frame);
            break;
        }
        filt_frame->pict_type = AV_PICTURE_TYPE_NONE;
        ret =encode_write_frame(filt_frame, stream_index, NULL);
        if (ret < 0)
            break;
    }
    return ret;
}
static int flush_encoder(unsigned int stream_index)
{
    int ret;
    int got_frame;
    if(!(ofmt_ctx->streams[stream_index]->codec->codec->capabilities&
         CODEC_CAP_DELAY))
        return 0;
    while (1) {
        av_log(NULL, AV_LOG_INFO, "Flushingstream #%u encoder\n", stream_index);
        ret =encode_write_frame(NULL, stream_index, &got_frame);
        if (ret < 0)
            break;
        if (!got_frame)
            return 0;
    }
    return ret;
}

int _fmain(int argc,char const * argv[])
{
    int ret;
    AVPacket packet;
    AVFrame *frame= NULL;
    enum AVMediaType type;
    unsigned int stream_index;
    unsigned int i;
    int got_frame;
    int (*dec_func)(AVCodecContext *, AVFrame *, int *, const AVPacket*);
    if (argc != 3) {
        av_log(NULL, AV_LOG_ERROR, "Usage: %s<input file> <output file>\n", argv[0]);
        return 1;
    }
    av_register_all();
    avformat_network_init();
    avfilter_register_all();
    if ((ret = open_input_file(argv[1])) < 0)
        goto end;
    if ((ret = open_output_file(argv[2])) < 0)
        goto end;
    int totalpacket = 1000;
    /* read all packets */
    while (totalpacket--) {
        
        if ((ret= av_read_frame(ifmt_ctx, &packet)) < 0)
            break;
        stream_index = packet.stream_index;
        type =ifmt_ctx->streams[packet.stream_index]->codec->codec_type;
        av_log(NULL, AV_LOG_DEBUG, "Demuxergave frame of stream_index %u\n",
               stream_index);
        {
            /* remux this frame without reencoding */
            packet.dts = av_rescale_q_rnd(packet.dts,
                                          ifmt_ctx->streams[stream_index]->time_base,
                                          ofmt_ctx->streams[stream_index]->time_base,
                                          (AV_ROUND_NEAR_INF|AV_ROUND_PASS_MINMAX));
            packet.pts = av_rescale_q_rnd(packet.pts,
                                          ifmt_ctx->streams[stream_index]->time_base,
                                          ofmt_ctx->streams[stream_index]->time_base,
                                          (AV_ROUND_NEAR_INF|AV_ROUND_PASS_MINMAX));
            ret =av_interleaved_write_frame(ofmt_ctx, &packet);
            if (ret < 0)
                goto end;
        }
        av_packet_unref(&packet);
    }
    
    av_write_trailer(ofmt_ctx);
end:
    av_packet_unref(&packet);
    av_frame_free(&frame);
    for (i = 0; i < ifmt_ctx->nb_streams; i++) {
        avcodec_close(ifmt_ctx->streams[i]->codec);
        if (ofmt_ctx && ofmt_ctx->nb_streams >i && ofmt_ctx->streams[i] &&ofmt_ctx->streams[i]->codec)
            avcodec_close(ofmt_ctx->streams[i]->codec);
        
    }
    avformat_close_input(&ifmt_ctx);
    if (ofmt_ctx &&!(ofmt_ctx->oformat->flags & AVFMT_NOFILE))
        avio_close(ofmt_ctx->pb);
    avformat_free_context(ofmt_ctx);
    if (ret < 0)
        av_log(NULL, AV_LOG_ERROR, "Erroroccurred\n");
    return (ret? 1:0);
}
