//
//  KMDiscoverListCell.m
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 03/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import "KMDiscoverListCell.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>

@implementation KMDiscoverListCell
@synthesize timelineImageView,titleLabel;
#pragma mark -
#pragma mark Cell Init Methods

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self SetImageView];
        
    }
    return self;
}
//设置图片的样式
-(void) SetImageView {
    //添加图片
    UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake1(0.0f, 0.0f, [[UIScreen mainScreen] bounds].size.width, 240)];
    //添加icon
    timelineImageView = [[EGOImageView alloc]initWithFrame:CGRectMake1(0.0f, 0.0f, [[UIScreen mainScreen] bounds].size.width, 240)];
    [cellView addSubview:timelineImageView];
    //添加标题
    titleLabel = [[KMGillSansLightLabel alloc]initWithFrame:CGRectMake1(0.0f, 0.0f, [[UIScreen mainScreen] bounds].size.width, 30.0f)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:20.0];
    [cellView addSubview:titleLabel];
    [self.contentView addSubview:cellView];
    
}
CG_INLINE CGRect
CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    CGRect rect;
    rect.origin.x = x * myDelegate.autoSizeScaleX; rect.origin.y = y * myDelegate.autoSizeScaleY;
    rect.size.width = width * myDelegate.autoSizeScaleX; rect.size.height = height * myDelegate.autoSizeScaleY;
    return rect;
}

@end
