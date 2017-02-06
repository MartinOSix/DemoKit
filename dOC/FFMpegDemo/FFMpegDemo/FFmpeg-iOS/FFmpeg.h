//
//  FFmpeg.h
//  FFMpegDemo
//
//  Created by runo on 17/1/16.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#ifndef FFmpeg_h
#define FFmpeg_h


#pragma mark libavcodec
#import "avcodec.h"
#import "avdct.h"
#import "avfft.h"
#import "d3d11va.h"
#import "dirac.h"
#import "dv_profile.h"
#import "dxva2.h"
#import "qsv.h"
#import "vaapi.h"
#import "vda.h"
#import "vda.h"
#import "vdpau.h"
#import "videotoolbox.h"
#import "vorbis_parser.h"
#import "xvmc.h"

#pargma mark libavdevice
#import "avdevice.h"

#pargma mark libavfilter
#import "avfilter.h"
#import "avfiltergraph.h"
#import "buffersink.h"
#import "buffersrc.h"

#pargma mark libavformat
#import "avformat.h"
#import "avio.h"

#pargma mark libavutil
#import "adler32.h"
#import "aes.h"
#import "aes_ctr.h"
#import "attributes.h"
#import "audio_fifo.h"
#import "avassert.h"
#import "avconfig.h"
#import "avstring.h"
#import "avutil.h"
#import "base64.h"
#import "blowfish.h"
#import "bprint.h"
#import "bswap.h"
#import "buffer.h"
#import "camellia.h"
#import "cast5.h"
#import "channel_layout.h"
#import "common.h"
#import "cpu.h"
#import "crc.h"
#import "des.h"
#import "dict.h"
#import "display.h"
#import "downmix_info.h"
#import "error.h"
#import "eval.h"
#import "ffversion.h"
#import "fifo.h"
#import "file.h"
#import "frame.h"
#import "hash.h"
#import "hmac.h"
#import "imgutils.h"
#import "intfloat.h"
#import "intreadwrite.h"
#import "lfg.h"
#import "log.h"
#import "lzo.h"
#import "macros.h"
#import "mastering_display_metadata.h"
#import "mathematics.h"
#import "md5.h"
#import "mem.h"
#import "motion_vector.h"
#import "murmur3.h"
#import "opt.h"
#import "parseutils.h"
#import "pixdesc.h"
#import "pixelutils.h"
#import "pixfmt.h"
#import "random_seed.h"
#import "rational.h"
#import "rc4.h"
#import "replaygain.h"
#import "ripemd.h"
#import "samplefmt.h"
#import "sha.h"
#import "sha512.h"
#import "stereo3d.h"
#import "tea.h"
#import "threadmessage.h"
#import "time.h"
#import "timecode.h"
#import "timestamp.h"
#import "tree.h"
#import "twofish.h"
//#import "version.h"
#import "xtea.h"

#pragma mark libswresample
#import "swresample.h"

#pragma mark libswscale
#import "swscale.h"

#endif /* FFmpeg_h */
