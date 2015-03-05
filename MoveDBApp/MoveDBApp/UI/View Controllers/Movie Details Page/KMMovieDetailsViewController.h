//
//  KMMovieDetailsViewController.h
//  MoveDBApp
//
//  Created by chuguangming on 15/3/3.
//  Copyright (c) 2015年 chu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMDetailsPageView.h"
#import "KMMovie.h"
#import "KMGillSansLabel.h"

@interface KMMovieDetailsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,
    UICollectionViewDataSource,UICollectionViewDelegate,KMDetailsPageDelegate>
@property (nonatomic)  UIView *navigationBarView;
@property (nonatomic)  UIView *networkLoadingContainerView;
@property (nonatomic)  KMDetailsPageView* detailsPageView;
@property (nonatomic)  KMGillSansLightLabel *navBarTitleLabel;

@property (strong, nonatomic) KMMovie* movieDetails;
@end
