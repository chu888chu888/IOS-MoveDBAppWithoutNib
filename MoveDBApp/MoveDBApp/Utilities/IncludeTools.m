//
//  IncludeTools.m
//  MoveDBApp
//
//  Created by chuguangming on 15/4/1.
//  Copyright (c) 2015年 chu. All rights reserved.
//

#import "IncludeTools.h"
#import <UIKit/UIKit.h>
#define COOKBOOK_PURPLE_COLOR	[UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]
#define showAlert(format, ...) myShowAlert(__LINE__, (char *)__FUNCTION__, format, ##__VA_ARGS__)
@implementation IncludeTools
// Simple Alert Utility
void myShowAlert(int line, char *functname, id formatstring,...)
{
    va_list arglist;
    if (!formatstring) return;
    va_start(arglist, formatstring);
    id outstring = [[NSString alloc] initWithFormat:formatstring arguments:arglist] ;
    va_end(arglist);
    
    NSString *filename = [[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lastPathComponent];
    NSString *debugInfo = [NSString stringWithFormat:@"%@:%d\n%s", filename, line, functname];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:outstring message:debugInfo delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil] ;
    [av show];
}
@end
