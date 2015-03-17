//
//  KMMoviePosterCell.m
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 05/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import "KMMoviePosterCell.h"

@implementation KMMoviePosterCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        self.moviePosterImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame))];
        [self addSubview:self.moviePosterImageView];
        
        self.movePosterText = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.moviePosterImageView.frame), CGRectGetWidth(self.frame)-10, 20)];
        self.movePosterText.textAlignment = NSTextAlignmentCenter;
        self.movePosterText.textColor=[UIColor whiteColor];
        [self addSubview:self.movePosterText];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
