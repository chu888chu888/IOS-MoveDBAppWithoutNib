//
//  KMDiscoverListViewController.m
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 03/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import "KMDiscoverListViewController.h"
#import "StoryBoardUtilities.h"
#import "KMDiscoverListCell.h"
#import "KMDiscoverSource.h"
#import "KMMovie.h"


@interface KMDiscoverListViewController ()

@property (nonatomic, strong) NSMutableArray* dataSource;
@property (nonatomic, strong) KMNetworkLoadingViewController* networkLoadingViewController;

@end

@implementation KMDiscoverListViewController

#pragma mark -
#pragma mark Init Methods


- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self requestMovies];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Setup Methods

- (void)setupTableView
{
    
    self.refreshControl=[[UIRefreshControl alloc]initWithFrame:CGRectMake(0, -44, 320, 44)];
    [self.refreshControl addTarget:self action:@selector(refreshFeed) forControlEvents:UIControlEventValueChanged];
    [self.tableView.tableHeaderView addSubview:self.refreshControl];
    self.tableView.rowHeight=70.0f;
}
#pragma mark -
#pragma mark Container Segue Methods

- (void) prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[NSString stringWithFormat:@"%s", class_getName([KMNetworkLoadingViewController class])]])
    {
        self.networkLoadingViewController = segue.destinationViewController;
        self.networkLoadingViewController.delegate = self;
    }
}

#pragma mark -
#pragma mark Network Requests methods

- (void)refreshFeed
{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"一只驴正在跑..."];
    [self requestMovies];
}

- (void)requestMovies
{
    KMDiscoverListCompletionBlock completionBlock = ^(NSArray* data, NSString* errorString)
    {
        [self.refreshControl endRefreshing];
        if (data != nil)
            [self processData:data];
        else
            [self.networkLoadingViewController showErrorView];
    };
    KMDiscoverSource* source = [KMDiscoverSource discoverSource];
    [source getDiscoverList:@"1" completion:completionBlock];
}

#pragma mark -
#pragma mark Fetched Data Processing

- (void)processData:(NSArray*)data
{
    if ([data count] == 0)
        [self.networkLoadingViewController showNoContentView];
    else
    {
        [self hideLoadingView];
        if (!self.dataSource)
            self.dataSource = [[NSMutableArray alloc] init];
        self.dataSource = [NSMutableArray arrayWithArray:data];
        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma mark KMNetworkLoadingViewDelegate

-(void)retryRequest;
{
    [self requestMovies];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return 0;
    
    //return 10;
    NSLog(@"数据为:%lu",(unsigned long)[self.dataSource count]);
    return [self.dataSource count];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"basic-cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil==cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    cell.textLabel.text=[[self.dataSource objectAtIndex:indexPath.row] movieTitle];
    return cell;
    
}

#pragma mark -
#pragma mark KMNetworkLoadingViewController Methods

- (void)hideLoadingView
{
    [UIView transitionWithView:self.view duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void)
     {
         [self.networkLoadingContainerView removeFromSuperview];
     } completion:^(BOOL finished) {
         [self.networkLoadingViewController removeFromParentViewController];
         self.networkLoadingContainerView = nil;
     }];
}

@end
