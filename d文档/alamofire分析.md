#Alamofire分析
先从Alamofire文件开始

1、 首先看到的是一个`URLConvertible`协议

```
public protocol URLConvertible {
    /// Returns a URL that conforms to RFC 2396 or throws an `Error`.
    ///
    /// - throws: An `Error` if the type cannot be converted to a `URL`.
    ///
    /// - returns: A URL or throws an `Error`.
    func asURL() throws -> URL
}
```
协议中也只有一个方法`asURl`，可以看到这是`reuest`函数中的第一个参数，通过这个协议可以控制输入的url的合法性。
下面分别给`String，URL，URLComponents`实现了这个协议，保证返回的的URL，错误会抛出AFError.invalidURL

2、 看到的第二个协议`URLRequestConvertible`也是众多`reques`方法中的一个方法的参数,这个类似于上面的`URLConvertible`，区别是在下面拓展了这个协议，然后在拓展中给这个协议添加了一个只读属性，属性返回的就是调用了协议中的方法返回`URLRequest`。
其中写了一个`URLRequest`的拓展实现了`URLRequestConvertible`协议，返回的自己。`URLRequest`的第二个拓展，增加了`init：url:method:header`方法。

```
public init(url: URLConvertible, method: HTTPMethod, headers: HTTPHeaders? = nil) throws {
        let url = try url.asURL()

        self.init(url: url)

        httpMethod = method.rawValue

        if let headers = headers {
            for (headerField, headerValue) in headers {
                setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
    }
```
通过这个`init`方法可以包容自己上面写的`URLConvertible`协议和`HTTPMethod`枚举，顺便把数组也一起放入了http头中
从源代码中可以看出可以在定义形参的时候顺便加个判断赋值。

```
func adapt(using adapter: RequestAdapter?) throws -> URLRequest {
        guard let adapter = adapter else { return self }
        return try adapter.adapt(self)
    }
```

这个没看懂，感觉有嵌套

3、 接下来是常用的各种方法的生命（`Data Request`,`Download Request`,`Upload Request`）,这些请求都是直接写在这个文件中的,所以在外部导入之后可以直接用`request()`,也可以用`Alamofire.request(url)`,而上述的方法其实都是连着调用了`SessionManager`中的相应的方法

######SessionManager文件
1、 前面定义了一个`MultipartFormDataEncodingResult`枚举
2、 单例的定义和初始化

```
open static let `default`: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders

        return SessionManager(configuration: configuration)
    }()

```
首先，这里学会了使用关键字定义变量，用执行匿名包的方式来赋值
3、定义了默认的http请求头`defaultHTTPHeaders`
这里有一个 ？？ 语法，针对可选类型，

```
var name: String?
let tur = name ?? "haha"//name有值tur就是name的值，没值就是haha
```

4、		

```
open func request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DataRequest
{
var originalRequest: URLRequest?

        do {
            originalRequest = try URLRequest(url: url, method: method, headers: headers)
            let encodedURLRequest = try encoding.encode(originalRequest!, with: parameters)
            return request(encodedURLRequest)
        } catch {
            return request(originalRequest, failedWith: error)
        }
}

```

便捷的构造方法，形参类型后面有 ？= 表示这个参数可有可无，如果没有穿那么就用这个来替代

`request("baidu")`也通过走这个方法
函数体中，首先根据输入的参数创建了urlRequest
然后将参数parameters添加进URLRequest中
