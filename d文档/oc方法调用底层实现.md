###runtime下OC方法调用底层实现
1、OC中调用方法就是向对象发送消息。
执行一个[person sepak]方法其实就是向person对象发送一个speak的消息
而执行过程可以分为以下步骤

2、首先通过产找person对象结构体中cache链表下的方法，如果有则直接调用

3、cache没有找person中methodlist中有没有对应方法，有则调用，并把方法添加到cache中，没有则进入动态决议

4、动态决议涉及到的函数

```
+ (BOOL)resolveClassMethod:(SEL)sel
+ (BOOL)resolveInstanceMethod:(SEL)sel
```
两个函数都是表示要处理的方法是否被动态决议了，区别只是类函数决议还是对象函数决议，一般返回no，如果要进行动态决议，那么重载这里的方法，返回yes，如果返回yes那么系统会再从person的methodlist中再找一次这个函数，如果还是没找到就接着进行下一步，如果找到了就执行函数，一般会在这里进行函数的动态添加操作

5、动态决议不通过则会进入到消息转发，

```
- (id)forwardingTargetForSelector:(SEL)aSelector
```

消息转发的意义是当这个方法在当前类中不能响应的时候，可以抓发到其他对象去响应，而其他对象就是通过这个函数的返回值来获取

6、第二种消息抓发

```
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;
- (void)forwardInvocation:(NSInvocation *)anInvocation;

```
先调用第一个方法，返回一个函数签名，返回之后，接着会调用第二个函数进行函数调用，可以在第一个函数中设置invocation的Target，函数最终响应的Target中的Sel函数

7、如果上述函数都失败了，那么就会进入最后的步骤
`-(void)doesNotRecognizeSelector:(SEL)aSelector`抛出异常