//
//  UITextView+CQAdd.m
//  CarServiceLeague
//
//  Created by runo on 16/8/10.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "UITextView+CQAdd.h"
#import <objc/runtime.h>
#import "Masonry.h"

#define ISIOS7 ([UIDevice currentDevice].systemVersion.floatValue>=7.0?1:0)
#define kIsEmptyString(str) (str==nil || \
str==NULL || \
[str isKindOfClass:[NSNull class]] || \
[[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)?YES:NO
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define kNotificationCenter [NSNotificationCenter defaultCenter]

static const void *s_hdfTextViewPlaceholderLabelKey = "s_hdfTextViewPlaceholderLabelKey";
static const void *s_hdfTextViewPlaceholderTextKey = "s_hdfTextViewPlaceholderTextKey";


@interface UIApplication (HDFTextViewHolder)

@end

@implementation UIApplication (HDFTextViewHolder)

- (void)hdf_placehoderTextChange:(NSNotification *)nofitication {
    if (ISIOS7) {
        return;
    }
    UITextView *textView = nofitication.object;
    if ([textView isKindOfClass:[UITextView class]]) {
        if (!kIsEmptyString(textView.text)) {
            textView.hdf_placeholderLabel.text = @"";
        } else {
            textView.hdf_placeholderLabel.text = textView.hdf_placeholder;
        }
    }
}

@end

@interface UITextView (HDFPlaceholderTextView)

@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation UITextView (HDFPlaceholderTextView)

- (void)setPlaceholderLabel:(UILabel *)placeholderLabel {
    objc_setAssociatedObject(self,
                             s_hdfTextViewPlaceholderLabelKey,
                             placeholderLabel,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)placeholderLabel {
    UILabel *label = objc_getAssociatedObject(self, s_hdfTextViewPlaceholderLabelKey);
    
    if (label == nil || ![label isKindOfClass:[UILabel class]]) {
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = self.font;
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor lightGrayColor];
        [self addSubview:label];
        
        WEAKSELF
        self.placeholderLabel = label;
        CGFloat left = ISIOS7 ? 5 : 7;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(weakSelf).insets(UIEdgeInsetsMake(7.5, left, 0, 0));
        }];
        label.enabled = YES;
        [kNotificationCenter addObserver:ISIOS7 ? self : [UIApplication sharedApplication]
                                selector:@selector(hdf_placehoderTextChange:)
                                    name:UITextViewTextDidChangeNotification
                                  object:nil];
        NSLog(@"%p",label);
    }
    return label;
}

@end

@implementation UITextView (CQAdd)

- (void)hdf_placehoderTextChange:(NSNotification *)notification {
    if (ISIOS7) {
        if (!kIsEmptyString(self.text)) {
            self.placeholderLabel.text = @"";
        } else {
            self.placeholderLabel.text = self.hdf_placeholder;
        }
    }
}

- (UILabel *)hdf_placeholderLabel {
    return self.placeholderLabel;
}

- (void)setHdf_placeholder:(NSString *)hdf_placeholder {
    if (kIsEmptyString(hdf_placeholder)) {
        objc_setAssociatedObject(self, s_hdfTextViewPlaceholderLabelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.placeholderLabel removeFromSuperview];
        return;
    }
    
    objc_setAssociatedObject(self,
                             s_hdfTextViewPlaceholderTextKey,
                             hdf_placeholder,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if (!kIsEmptyString(self.text)) {
        self.placeholderLabel.text = @"";
    } else {
        self.placeholderLabel.text = hdf_placeholder;
    }
}

- (NSString *)hdf_placeholder {
    return objc_getAssociatedObject(self, s_hdfTextViewPlaceholderTextKey);
}

- (void)setHdf_placeholderColor:(UIColor *)hdf_placeholderColor {
    self.placeholderLabel.textColor = hdf_placeholderColor;
}

- (UIColor *)hdf_placeholderColor {
    return self.placeholderLabel.textColor;
}

- (void)setHdf_placeholderFont:(UIFont *)hdf_placeholderFont {
    self.placeholderLabel.font = hdf_placeholderFont;
}

- (UIFont *)hdf_placeholderFont {
    return self.placeholderLabel.font;
}

@end
