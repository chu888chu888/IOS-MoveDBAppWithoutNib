//
//  KMNetworkLoadingViewController.h
//  BigCentral
//
//  Created by Kevin Mindeguia on 19/11/2013.
//  Copyright (c) 2013 iKode Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMActivityIndicator.h"

@protocol KMNetworkLoadingViewDelegate <NSObject>

-(void)retryRequest;

@end

@interface KMNetworkLoadingViewController : UIViewController

@property ( nonatomic)  UIView *loadingView;
@property ( nonatomic)  UIView *errorView;
@property ( nonatomic)  UIButton *refreshButton;
@property ( nonatomic)  KMActivityIndicator *activityIndicatorView;
@property ( nonatomic)  UIView *noContentView;

@property (nonatomic) id <KMNetworkLoadingViewDelegate> delegate;

- (void)retryRequest:(id)sender;

- (void)showLoadingView;
- (void)showNoContentView;
- (void)showErrorView;


@end
