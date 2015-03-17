//
//  KMMovieDetailsViewController.m
//  MoveDBApp
//
//  Created by chuguangming on 15/3/3.
//  Copyright (c) 2015年 chu. All rights reserved.
//

#import "KMMovieDetailsViewController.h"
#import "KMMovieDetailsCell.h"
#import "KMMovieDetailsDescriptionCell.h"
#import "KMMovieDetailsSimilarMoviesCell.h"
#import "KMSimilarMoviesCollectionViewCell.h"
#import "KMMovieDetailsPopularityCell.h"
#import "KMMovieDetailsCommentsCell.h"
#import "KMMovieDetailsViewAllCommentsCell.h"
#import "KMComposeCommentCell.h"
#import "KMMovieDetailsSource.h"
#import "KMSimilarMoviesSource.h"
#import "UIImageView+WebCache.h"
#import "UIView+MJAlertView.h"
#import "KMSimilarMoviesViewController.h"
@interface KMMovieDetailsViewController ()
@property (nonatomic, strong) NSMutableArray* similarMoviesDataSource;
@property (assign) CGPoint scrollViewDragPoint;
@end

@implementation KMMovieDetailsViewController
#pragma mark -
#pragma mark View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    //去掉导航条
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    //去掉滑动支持
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestMovieDetails];
    [self setupDetailsPageView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Setup

- (void)setupDetailsPageView
{
    self.detailsPageView=[[KMDetailsPageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.detailsPageView.tableViewDataSource = self;
    self.detailsPageView.tableViewDelegate = self;
    self.detailsPageView.tableViewSeparatorColor = [UIColor clearColor];
    self.detailsPageView.delegate = self;
    [self.view addSubview:_detailsPageView];
}

- (void)setupNavbarButtons
{

}

#pragma mark -
#pragma mark Network Request Methods

- (void)requestSimilarMovies
{
    KMSimilarMoviesCompletionBlock completionBlock = ^(NSArray* data, NSString* errorString)
    {
        if (data != nil)
        {
            [self processSimilarMoviesData:data];
        }
        else
        {
            [UIView addMJNotifierWithText:@"网络故障请重试" dismissAutomatically:YES];
        }
        
    };
    KMSimilarMoviesSource* source = [KMSimilarMoviesSource similarMoviesSource];
    [source getSimilarMovies:self.movieDetails.movieId numberOfPages:@"1" completion:completionBlock];
}

- (void)requestMovieDetails
{
    KMMovieDetailsCompletionBlock completionBlock = ^(KMMovie* movieDetails, NSString* errorString)
    {
        if (movieDetails != nil)
        {
            [self processMovieDetailsData:movieDetails];
        }
        else
        {
            [UIView addMJNotifierWithText:@"网络故障请重试" dismissAutomatically:YES];
        }
        
    };
    KMMovieDetailsSource* source = [KMMovieDetailsSource movieDetailsSource];
    [source getMovieDetails:self.movieDetails.movieId completion:completionBlock];
}
#pragma mark -
#pragma mark Fetched Data Processing

- (void)processSimilarMoviesData:(NSArray*)data
{
    if ([data count] == 0)
    {
        [UIView addMJNotifierWithText:@"无类似的影片" dismissAutomatically:YES];
    }
    else
    {
        if (!self.similarMoviesDataSource)
        {
            self.similarMoviesDataSource = [[NSMutableArray alloc] init];
        }
        self.similarMoviesDataSource = [NSMutableArray arrayWithArray:data];
        [self.detailsPageView reloadData];
    }
}

- (void)processMovieDetailsData:(KMMovie*)data
{
    self.movieDetails = data;
    [self requestSimilarMovies];
}

#pragma mark -
#pragma mark UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // A much nicer way to deal with this would be to extract this code to a helper class, that would take care of building the cells.
    UITableViewCell* cell = nil;
    
    switch (indexPath.row) {
        case 0:
        {
            KMMovieDetailsCell *detailsCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsCell"];
            
            if(detailsCell == nil)
                detailsCell = [KMMovieDetailsCell movieDetailsCell];
            
            [detailsCell.posterImageView setImageURL:[NSURL URLWithString:self.movieDetails.movieThumbnailBackdropImageUrl]];
            detailsCell.movieTitleLabel.text = self.movieDetails.movieTitle;
            detailsCell.genresLabel.text = self.movieDetails.movieGenresString;
            
            cell = detailsCell;
        }
            break;
        case 1:
        {
            KMMovieDetailsDescriptionCell *descriptionCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsDescriptionCell"];
            
            if(descriptionCell == nil)
                descriptionCell = [KMMovieDetailsDescriptionCell movieDetailsDescriptionCell];
            
            descriptionCell.movieDescriptionLabel.text = self.movieDetails.movieSynopsis;
            
            cell = descriptionCell;
        }
            break;
        case 2:
        {
            KMMovieDetailsSimilarMoviesCell *contributionCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsSimilarMoviesCell"];
            
            if(contributionCell == nil)
                contributionCell = [KMMovieDetailsSimilarMoviesCell movieDetailsSimilarMoviesCell];
            
            [contributionCell.viewAllSimilarMoviesButton addTarget:self action:@selector(viewAllSimilarMoviesButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            cell = contributionCell;
        }
            break;
        case 3:
        {
            KMMovieDetailsPopularityCell *popularityCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsPopularityCell"];
            
            if(popularityCell == nil)
                popularityCell = [KMMovieDetailsPopularityCell movieDetailsPopularityCell];
            
            popularityCell.voteAverageLabel.text = self.movieDetails.movieVoteAverage;
            popularityCell.voteCountLabel.text = self.movieDetails.movieVoteCount;
            popularityCell.popularityLabel.text = self.movieDetails.moviePopularity;
            
            cell = popularityCell;
        }
            break;
        case 4:
        {
            KMMovieDetailsCommentsCell *commentsCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsCommentsCell"];
            
            if(commentsCell == nil)
                commentsCell = [KMMovieDetailsCommentsCell movieDetailsCommentsCell];
            
            commentsCell.usernameLabel.text = @"Kevin Mindeguia";
            commentsCell.commentLabel.text = @"Macaroon croissant I love tiramisu I love chocolate bar chocolate bar. Cheesecake dessert croissant sweet. Muffin gummies gummies biscuit bear claw. ";
            [commentsCell.cellImageView setImage:[UIImage imageNamed:@"kevin_avatar"]];
            
            cell = commentsCell;
        }
            break;
        case 5:
        {
            KMMovieDetailsCommentsCell *commentsCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsCommentsCell"];
            
            if(commentsCell == nil)
                commentsCell = [KMMovieDetailsCommentsCell movieDetailsCommentsCell];
            
            commentsCell.usernameLabel.text = @"Andrew Arran";
            commentsCell.commentLabel.text = @"Chocolate bar carrot cake candy canes oat cake dessert. Topping bear claw dragée. Sugar plum jelly cupcake.";
            [commentsCell.cellImageView setImage:[UIImage imageNamed:@"scrat_avatar"]];
            
            cell = commentsCell;
        }
            break;
        case 6:
        {
            KMMovieDetailsViewAllCommentsCell *viewAllCommentsCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsViewAllCommentsCell"];
            
            if(viewAllCommentsCell == nil)
                viewAllCommentsCell = [KMMovieDetailsViewAllCommentsCell movieDetailsAllCommentsCell];
            
            cell = viewAllCommentsCell;
        }
            break;
        case 7:
        {
            KMComposeCommentCell *composeCommentCell = [tableView dequeueReusableCellWithIdentifier:@"KMComposeCommentCell"];
            
            if(composeCommentCell == nil)
                composeCommentCell = [KMComposeCommentCell composeCommentsCell];
            
            cell = composeCommentCell;
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.contentView.backgroundColor = [UIColor clearColor];
    if ([cell isKindOfClass:[KMMovieDetailsSimilarMoviesCell class]])
    {
        KMMovieDetailsSimilarMoviesCell* similarMovieCell = (KMMovieDetailsSimilarMoviesCell*)cell;
        [similarMovieCell setCollectionViewDataSourceDelegate:self index:indexPath.row];
    }
    if ([cell isKindOfClass:[KMMovieDetailsCommentsCell class]])
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // A much nicer way to deal with this would be to extract this code to a helper class, that would take care of building the cells.
    CGFloat height = 0;
    
    if (indexPath.row == 0)
        height = 120;
    else if (indexPath.row == 1)
        height = 119;
    else if (indexPath.row == 2)
    {
        if ([self.similarMoviesDataSource count] == 0)
            height = 0;
        else
            height = 143;
    }
    else if (indexPath.row == 3)
        height = 67;
    else if (indexPath.row >= 4 && indexPath.row < 6)
        height = 100;
    else if (indexPath.row == 6)
        height = 49;
    else if (indexPath.row == 7)
        height = 62;
    return height;
}
#pragma mark -
#pragma mark UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return [self.similarMoviesDataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    KMSimilarMoviesCollectionViewCell* cell = (KMSimilarMoviesCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"KMSimilarMoviesCollectionViewCell" forIndexPath:indexPath];
    [cell.cellImageView setImageURL:[NSURL URLWithString:[[self.similarMoviesDataSource objectAtIndex:indexPath.row] movieThumbnailPosterImageUrl]]];
    return cell;
}
#pragma mark -
#pragma mark UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    KMMovieDetailsViewController* viewController = [KMMovieDetailsViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController.movieDetails = [self.similarMoviesDataSource objectAtIndex:indexPath.row];
}
#pragma mark -
#pragma mark KMDetailsPageDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.scrollViewDragPoint = scrollView.contentOffset;
}

- (CGPoint)detailsPage:(KMDetailsPageView *)detailsPageView tableViewWillBeginDragging:(UITableView *)tableView;
{
    return self.scrollViewDragPoint;
}

- (UIViewContentMode)contentModeForImage:(UIImageView *)imageView
{
    return UIViewContentModeTop;
}

- (UIImageView*)detailsPage:(KMDetailsPageView*)detailsPageView imageDataForImageView:(UIImageView*)imageView;
{
    __block UIImageView* blockImageView = imageView;
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:[self.movieDetails movieOriginalBackdropImageUrl]] completed:^ (UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if ([detailsPageView.delegate respondsToSelector:@selector(headerImageViewFinishedLoading:)])
            [detailsPageView.delegate headerImageViewFinishedLoading:blockImageView];
    }];
    
    return imageView;
}

- (void)detailsPage:(KMDetailsPageView *)detailsPageView tableViewDidLoad:(UITableView *)tableView
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)detailsPage:(KMDetailsPageView *)detailsPageView headerViewDidLoad:(UIView *)headerView
{
    [headerView setAlpha:0.0];
    [headerView setHidden:YES];
}
#pragma mark -
#pragma mark Action Methods

- (void)viewAllSimilarMoviesButtonPressed:(id)sender
{
    KMSimilarMoviesViewController* viewController = [[KMSimilarMoviesViewController alloc] init];
    viewController.moviesDataSource = self.similarMoviesDataSource;
    [self.navigationController pushViewController:viewController animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
