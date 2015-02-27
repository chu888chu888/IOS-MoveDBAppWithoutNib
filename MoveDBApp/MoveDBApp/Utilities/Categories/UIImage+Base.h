//
//  UIImage+Base.h
//  noodleBlue
//
//  Created by apple on 15/2/25.
//  Copyright (c) 2015年 noodles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Base)

//生成指定颜色图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
