#SVProgressHUD分析
这个开源框架的主要作用就是用来做临时的显示信息
######首先从`show`函数入手
```
+ (void)show {
    [self showWithStatus:nil];
}
```
从上面看出show函数调用了`showshowWithStatus：`这个函数
进一步看在`showshowWithStatus：`中调用了`+ (void)showProgress:(float)progress status:(NSString*)status `,其实可以观察其他所有showProgress和showWithStatus函数，可以看到其最终都会调用`+ (void)showProgress:(float)progress status:(NSString*)status `，其他函数只是对相应位置进行的配置。
仔细查看下面的函数会发现`showInfo,showSuccess,showError,showImage`都会调用`showImage:status:duration`

而上述两个汇总的方法则调用的其实是单例实例化出来的对象的对象方法
首先分析这个`-(void)showProgress:(float)progress status:(NSString*)status `

```
-(void)showProgress:(float)progress status:(NSString*)status {
    __weak SVProgressHUD *weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong SVProgressHUD *strongSelf = weakSelf;
        if(strongSelf){
            // Update / Check view hierachy to ensure the HUD is visible
            [strongSelf updateViewHierachy];
            // Reset imageView and fadeout timer if an image is currently displayed
            strongSelf.imageView.hidden = YES;
            strongSelf.imageView.image = nil;
            
            if(strongSelf.fadeOutTimer) {
                strongSelf.activityCount = 0;
            }
            strongSelf.fadeOutTimer = nil;
            
            // Update text and set progress to the given value
            strongSelf.statusLabel.text = status;
            strongSelf.progress = progress;
            
            // Choose the "right" indicator depending on the progress
            if(progress >= 0) {
                // Cancel the indefiniteAnimatedView, then show the ringLayer
                [strongSelf cancelIndefiniteAnimatedViewAnimation];
                
                // Add ring to HUD and set progress
                [strongSelf.hudView addSubview:strongSelf.ringView];
                [strongSelf.hudView addSubview:strongSelf.backgroundRingView];
                strongSelf.ringView.strokeEnd = progress;
                
                // Updat the activity count
                if(progress == 0) {
                    strongSelf.activityCount++;
                }
            } else {
                // Cancel the ringLayer animation, then show the indefiniteAnimatedView
                [strongSelf cancelRingLayerAnimation];
                
                // Add indefiniteAnimatedView to HUD
                [strongSelf.hudView addSubview:strongSelf.indefiniteAnimatedView];
                if([strongSelf.indefiniteAnimatedView respondsToSelector:@selector(startAnimating)]) {
                    [(id)strongSelf.indefiniteAnimatedView startAnimating];
                }
                
                // Update the activity count
                strongSelf.activityCount++;
            }
            
            // Show
            [strongSelf showStatus:status];
        }
    }];
    }

```

1. 先weak后strong保证循环引用，block是持有SVProgressHUD对象，但是SVProgress对象并不持有block，if(strongSelf){}保证在使用Strongself之前的时候self没有被释放才使用，而且strongself保证在使用strongself时不会释放
2. `[strongSelf updateViewHierachy]`将屏蔽输入的view提到最外层
3. 隐藏imageView，这个在下面显示方法中用到
4. 如果之前有设置隐藏timer的话，那么直接设置显示数为0，因为现在显示新的就当以前的已经隐藏掉了。
5. 设置文字和进度
6. 判断这是是显示进度还是显示菊花
7. 显示进度：取消上次显示的菊花，设置进度，如果不是更新进度那么显示器数量++
8. 显示菊花：取消上次显示的进度，设置菊花，显示器数量++
9. `showStatus：`添加到View上显示

#####- (void)showImage:(UIImage*)image status:(NSString*)status duration:(NSTimeInterval)duration 
```
- (void)showImage:(UIImage*)image status:(NSString*)status duration:(NSTimeInterval)duration {
    __weak SVProgressHUD *weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong SVProgressHUD *strongSelf = weakSelf;
        if(strongSelf){
            // Update / Check view hierachy to ensure the HUD is visible
            [strongSelf updateViewHierachy];
            
            // Reset progress and cancel any running animation
            strongSelf.progress = SVProgressHUDUndefinedProgress;
            [strongSelf cancelRingLayerAnimation];
            [strongSelf cancelIndefiniteAnimatedViewAnimation];
            
            // Update imageView
            UIColor *tintColor = strongSelf.foregroundColorForStyle;
            UIImage *tintedImage = image;
            if([strongSelf.imageView respondsToSelector:@selector(setTintColor:)]) {
                if (tintedImage.renderingMode != UIImageRenderingModeAlwaysTemplate) {
                    tintedImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                }
                strongSelf.imageView.tintColor = tintColor;
            } else {
                tintedImage = [strongSelf image:image withTintColor:tintColor];
            }
            strongSelf.imageView.image = tintedImage;
            strongSelf.imageView.hidden = NO;
            
            // Update text
            strongSelf.statusLabel.text = status;
            
            // Show
            [strongSelf showStatus:status];
            
            // An image will dismissed automatically. Therefore we start a timer
            // which then will call dismiss after the predefined duration
            strongSelf.fadeOutTimer = [NSTimer timerWithTimeInterval:duration target:strongSelf selector:@selector(dismiss) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:strongSelf.fadeOutTimer forMode:NSRunLoopCommonModes];
        }
    }];
}
```

1. 重置进度，取消进度动画和菊花动画
2. 显示图片
3. 也是通过`showStatus:`显示
4. 设置退出timer，启动Runloop保证timer有效

其主要显示工作逻辑通过上述函数分析得出，其他的设置之类的是依附于这个主逻辑之间，通过这个逻辑拓展所得，其使用可以参考github官方demo
