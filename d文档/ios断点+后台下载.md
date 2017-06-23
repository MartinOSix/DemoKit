###iOS断点+后台下载
> 设计思路是根据写一个通用控件的思路，iOS下载可以用的方式有很多，像之前的URLConnection到现在的URLSession，本例用的是URLSession+URLSessionDownloadTask，断点下载不止可以用这个DownloadTask，还可以用NSURLSessionDataTask,但是还要做到后台下载的只有URLSessionDownloadTask

####逻辑流程
1、创建后台session 

```
NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identify];
[NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
```

2、实现session代理

```
//session下载中的回调
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
//session下载完成后回调
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
//sessiontask任务结束后回调，就算是后台下载，或是异常退出，当重新打开app时，上次的下载任务还是会走这个回调，所以通过这里来完成后台下载，包括后台中断下载在进入前台恢复
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
```

3、开始下载

```
	//主要是判断有无之前的下载数据
	if (model.cqResumeData) {
        downloadTask = [self.session downloadTaskWithCorrectResumeData:model.cqResumeData];
    }else{
        downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:model.cqDownloadUrl]];
    }
```




####封装思路
使用一个单例来管理所有的downloadtask，并且只实例化一个后台session来管理，这样方便管理回调事件，为每一个请求创建一个downloadFileModel来管理下载状态，缓存。

首先从使用者角度上看分析出只需要如下功能，并且使用者只需要提供一个URL
1、获取下载模型 2、开始下载 3、暂停下载 4、取消下载

######下载管理单例类

```
	//私有属性
	@property (nonatomic, strong) NSURLSession *session;
	@property (nonatomic, strong) NSMutableDictionary *downloadTasks;
	@property (nonatomic, strong) NSMutableDictionary *downloadModels;
	//对外接口
	+(instancetype)shareManager;//获取单例
	-(void)setUpSession;//初始化backgroundSession
	-(DownloadFileModel *)getModelByUrl:(NSString *)url;
	//下面几个可以说对外，但其实还是对downloadModel开放的接口
	-(void)startDownloadWithURL:(NSString *)url;
	-(void)stopTaskWithUrl:(NSString *)url;
	-(void)cancelTaskWithURL:(NSString *)url;
```

######下载任务模型
```
@property(nonatomic,strong) NSString *cqDownloadUrl;
@property(nonatomic,readonly) NSString *cqDownloadFilePath;
@property(nonatomic,strong) NSString *cqSessionTaskId;

@property(nonatomic,strong) NSData  *cqResumeData;
@property(nonatomic,assign) CGFloat cqProgress;
@property(nonatomic,assign) NSUInteger cqTotalLength;
@property(nonatomic,assign) NSUInteger cqCurrentDownloadLength;
@property(nonatomic,assign) DownloadType cqDownloadType;

-(instancetype)initWithUrl:(NSString *)url;
- (void)setCacheFile;
- (void)loadCacheFile;
- (void)checkDownload;
//用户接口
@property(nonatomic,weak) id<NewDownloadFileDelegate> cqDelegate;
-(void)startDownloadTask;
-(void)stopDonwloadTask;
-(void)cancelDownloadTask;
```

###使用方法：

1、 在appdelegate中调用`[[DownloadFileManager shareManager]setUpSession];`初始化session，为了是获取之前下载中断的下载任务，和缓存的任务模型

2、 通过`DownloadFileModel *model = [[DownloadFileManager shareManager]getModelByUrl:url];`获取下载任务模型，只能通过这种，获取，因为如果之前有中断的任务会通过这个方法重新获取回来。

3、设置模型代理`model.cqDelegate = self;`

4、通过模型去执行开始，暂停，取消操作
`[model stopDonwloadTask];[model startDownloadTask];[model cancelDownloadTask];`

5、通过代理方法监听模型下载状态
`-(void)downloadTaskModel:(DownloadFileModel *)taskModel StateChange:(DownloadType)type;
-(void)downloadTaskModel:(DownloadFileModel *)taskModel Progress:(CGFloat)progress;`
