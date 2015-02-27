//
//  UIImage+Base.m
//  noodleBlue
//
//  Created by apple on 15/2/25.
//  Copyright (c) 2015年 noodles. All rights reserved.
//

#import "UIImage+Base.h"

@implementation UIImage (Base)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
