//
//  UITextView+CQAdd.h
//  CarServiceLeague
//
//  Created by runo on 16/8/10.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITextView (CQAdd)

/**
 * @author huangyibiao
 *
 * 给UITextView添加placeholder
 *
 * @note 注意，此扩展有点小问题，如果在添加placeholder后，又直接赋值Text属性，则不会自动消失
 *       解决办法是：如果有初始值，先给text，再设置holder
 */

/**
 * 占位提示语
 */
@property (nonatomic, copy)   NSString *hdf_placeholder;

/**
 * 占位提示语的字体颜色
 */
@property (nonatomic, strong) UIColor *hdf_placeholderColor;

/**
 * 占位提示语的字体
 */
@property (nonatomic, strong) UIFont  *hdf_placeholderFont;

/**
 * 占位提示语标签
 */
@property (nonatomic, strong, readonly) UILabel *hdf_placeholderLabel;


@end
