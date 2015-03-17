//
//  KMSimilarMoviesViewController.m
//  MoveDBApp
//
//  Created by chuguangming on 15/3/17.
//  Copyright (c) 2015年 chu. All rights reserved.
//

#import "KMSimilarMoviesViewController.h"
#import "StoryBoardUtilities.h"
#import "KMMovie.h"
#import "KMMoviePosterCell.h"
#import "KMMovieDetailsViewController.h"
#import "UIImageView+WebCache.h"

#define kVerticalMarginForCollectionViewItems 0
#define fDeviceWidth [UIScreen mainScreen].bounds.size.width
#define fDeviceHeight [UIScreen mainScreen].bounds.size.height
@interface KMSimilarMoviesViewController ()

@end

@implementation KMSimilarMoviesViewController


#pragma mark -
#pragma mark View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (!self.moviesDataSource)
        self.moviesDataSource = [[NSArray alloc] init];
    
  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"moviesDatasource:%@",[self.moviesDataSource objectAtIndex:0]);
    KMMovie *tmp=[self.moviesDataSource objectAtIndex:0];
    NSLog(@"moveieTitle:%@",tmp.movieTitle);
    [self setupCollectionViewLayout];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark CollectionView Layout

- (void)setupCollectionViewLayout
{
    /*
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.collectionView=[[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    //注册cell和ReusableView（相当于头部）
    [self.collectionView registerClass:[KMMoviePosterCell class] forCellWithReuseIdentifier:@"KMMoviePosterCell"];
     */
    UICollectionViewFlowLayout* interfaceBuilderFlowLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    
    CGSize viewSize = self.view.bounds.size;
    
    CGFloat cellAspectRatio = interfaceBuilderFlowLayout.itemSize.height / interfaceBuilderFlowLayout.itemSize.width;
    
    UICollectionViewFlowLayout *flowLayoutPort = UICollectionViewFlowLayout.new;
    
    flowLayoutPort.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayoutPort.sectionInset = interfaceBuilderFlowLayout.sectionInset;
    flowLayoutPort.minimumInteritemSpacing = interfaceBuilderFlowLayout.minimumInteritemSpacing;
    flowLayoutPort.minimumLineSpacing = interfaceBuilderFlowLayout.minimumLineSpacing;
    
    if (floor(viewSize.width/interfaceBuilderFlowLayout.itemSize.width) <= 2){
        
        CGFloat itemHeight = (viewSize.width/2.0 - kVerticalMarginForCollectionViewItems) * cellAspectRatio;
        
        flowLayoutPort.itemSize = CGSizeMake(viewSize.width/2.0 - kVerticalMarginForCollectionViewItems, itemHeight);
        
    }else{
        
        CGFloat itemHeight = (viewSize.height/2.0 - kVerticalMarginForCollectionViewItems) * cellAspectRatio;
        
        flowLayoutPort.itemSize = CGSizeMake(viewSize.height/2.0 - kVerticalMarginForCollectionViewItems, itemHeight);
        
    }
    self.collectionView=[[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayoutPort];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    //注册cell和ReusableView（相当于头部）
    [self.collectionView registerClass:[KMMoviePosterCell class] forCellWithReuseIdentifier:@"KMMoviePosterCell"];
    
}

#pragma mark -
#pragma mark UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    NSLog(@"count:%lu",(unsigned long)[self.moviesDataSource count]);
    return [self.moviesDataSource count];
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    KMMoviePosterCell* cell = (KMMoviePosterCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"KMMoviePosterCell" forIndexPath:indexPath];
    [cell.moviePosterImageView sd_setImageWithURL:[NSURL URLWithString:[[self.moviesDataSource objectAtIndex:indexPath.row] movieOriginalPosterImageUrl]]];
    KMMovie *cellKMMovie=[self.moviesDataSource objectAtIndex:indexPath.row];
    [cell.movePosterText setText:cellKMMovie.movieTitle];
    return cell;
    
}
#pragma mark --UICollectionViewDelegateFlowLayout


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake(fDeviceWidth/2,fDeviceHeight/3);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0,0);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
#pragma mark -
#pragma mark UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    KMMovieDetailsViewController* viewController = [[KMMovieDetailsViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController.movieDetails = [self.moviesDataSource objectAtIndex:indexPath.row];
}

@end
