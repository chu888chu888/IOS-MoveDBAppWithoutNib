//
//  KMSimilarMoviesViewController.h
//  MoveDBApp
//
//  Created by chuguangming on 15/3/17.
//  Copyright (c) 2015年 chu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMSimilarMoviesViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic)  UICollectionView *collectionView;

@property (nonatomic)  NSArray* moviesDataSource;

@end
