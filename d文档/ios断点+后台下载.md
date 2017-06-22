###iOS断点+后台下载
> 设计思路是根据写一个通用控件的思路，iOS下载可以用的方式有很多，像之前的URLConnection到现在的URLSession，本例用的是URLSession+URLSessionDownloadTask，断点下载不止可以用这个DownloadTask，还可以用NSURLSessionDataTask,但是还要做到后台下载的只有URLSessionDownloadTask
####思路
使用一个单例来管理所有的downloadtask，并且只实例化一个后台session来管理，这样方便管理回调事件，为每一个请求创建一个downloadFileModel来管理下载状态，缓存。

首先从使用者角度上看分析出只需要如下功能，并且使用者只需要提供一个URL
1、获取下载模型 2、开始下载 3、暂停下载 4、取消下载

下载管理单例类

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
	
