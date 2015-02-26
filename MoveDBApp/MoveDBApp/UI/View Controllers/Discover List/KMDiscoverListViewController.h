//
//  KMDiscoverListViewController.h
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 03/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMNetworkLoadingViewController.h"

@interface KMDiscoverListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, KMNetworkLoadingViewDelegate>

@property (nonatomic)  UIView *networkLoadingContainerView;
@property (nonatomic)  UITableView *tableView;

@end
