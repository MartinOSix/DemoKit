//
//  ViewController10.m
//  animationDemo
//
//  Created by runo on 16/9/29.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController10.h"
/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)
@interface ViewController10 ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property(nonatomic,strong) NSArray *images;
@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) NSString *subType;

@end

@implementation ViewController10

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.images = @[
                    [UIImage imageNamed:@"1.png"],
                    [UIImage imageNamed:@"2.png"],
                    [UIImage imageNamed:@"3.png"],
                    [UIImage imageNamed:@"4.png"]
                    ];
    self.imageView.image = [self.images firstObject];
    
    UIPickerView *pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 400, kScreenWidth, 150)];
    pickView.delegate = self;
    pickView.dataSource = self;
    [self.view addSubview:pickView];
    self.type = kCATransitionFade;
    self.subType = kCATransitionFromRight;
}
- (IBAction)btnclick:(id)sender {
    
    CATransition *transition = [CATransition animation];
    transition.type = self.type;
    transition.subtype = self.subType;
    [self.imageView.layer addAnimation:transition forKey:nil];
    UIImage *currentImage = self.imageView.image;
    NSUInteger index = [self.images indexOfObject:currentImage];
    index = (index + 1)%self.images.count;
    self.imageView.image = self.images[index];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [self getTypeFrom:row Compent:component];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.type = [self getTypeFrom:row Compent:component];
    }else{
        self.subType = [self getTypeFrom:row Compent:component];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 11;
    }else{
        return 4;
    }
}


-(NSString *)getTypeFrom:(NSInteger )row Compent:(NSInteger) component{
    NSString *returntyp = nil;
    if (component == 0) {
        switch (row) {
            case 0:
                returntyp = kCATransitionFade;break;
                break;
            case 1:
                returntyp = kCATransitionMoveIn;break;
            case 2:
                returntyp = kCATransitionPush;break;
            case 3:
                returntyp = kCATransitionReveal;break;
            case 4:
                returntyp = @"oglFlip";break;//立体翻滚
            case 5:
                returntyp = @"suckEffect";break;
            case 6:
                returntyp = @"rippleEffect";break;
            case 7:
                returntyp = @"pageCurl";break;
            case 8:
                returntyp = @"pageUnCurl";break;
            case 9:
                returntyp = @"cameraIrisHollowOpen";break;
            case 10:
                returntyp = @"cameraIrisHollowClose";break;
                
            default:
                break;
        }
    }else{
        
        switch (row) {
            case 0:
                returntyp = kCATransitionFromRight;break;
            case 1:
                returntyp = kCATransitionFromLeft;break;
            case 2:
                returntyp = kCATransitionFromTop;break;
            case 3:
                returntyp = kCATransitionFromBottom;break;
            default:
                break;
        }
        
    }
    return returntyp;
}


@end
