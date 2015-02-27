//
//  UIViewController+Functions.m
//  noodleBlue
//
//  Created by apple on 14/12/28.
//  Copyright (c) 2014年 noodles. All rights reserved.
//

#import "UIViewController+Functions.h"

@implementation UIViewController (Functions)

//加上取消按钮
- (void)addCancelButton
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(backHandle)];
    [backButton setTintColor:[UIColor whiteColor]];
    [self.navigationItem setRightBarButtonItem:backButton];
}

- (void)backHandle
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
