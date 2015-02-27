//
//  NSString+Base.h
//  noodleBlue
//
//  Created by apple on 15/1/7.
//  Copyright (c) 2015年 noodles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base)

+ (NSString *)getDayFormatWith:(NSString *)inputTime;
+ (NSString*)getWeekFormatWith:(NSString*)inputDateString;
+ (NSString*)getTimeFormatWith:(NSString*)inputTimeString;
- (BOOL)isPhoneString;
- (BOOL)isCodeString;
- (BOOL)isEmailString;

@end
