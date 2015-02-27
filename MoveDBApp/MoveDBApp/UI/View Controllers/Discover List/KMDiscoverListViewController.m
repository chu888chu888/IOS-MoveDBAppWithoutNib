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
#import "UIView+MJAlertView.h"
NSString * const KMDiscoverListMenuCellReuseIdentifier = @"Drawer Cell";
@interface KMDiscoverListViewController ()

@property (nonatomic, strong) NSMutableArray* dataSource;

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
    
    _KMDiscoverActivityIndicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _KMDiscoverActivityIndicatorView.center=self.view.center;
    [_KMDiscoverActivityIndicatorView startAnimating];
    [self.view addSubview:_KMDiscoverActivityIndicatorView];
    
    
    [self setupTableView];
    [self requestMovies];
    
}
-(void) loadView {
    
    [super loadView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Setup Methods

- (void)setupTableView
{
    //通过代码自定义代码单元格与单元表头
    [self.tableView registerClass:[KMDiscoverListCell class] forCellReuseIdentifier:KMDiscoverListMenuCellReuseIdentifier];

    //去掉边框线
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor blackColor]];
    //设定导航条

    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    self.navigationItem.title=@"Discover";
    
    //设定刷新条
    self.refreshControl=[[UIRefreshControl alloc]initWithFrame:CGRectMake(0, -44, 320, 44)];
    [self.refreshControl addTarget:self action:@selector(refreshFeed) forControlEvents:UIControlEventValueChanged];
    [self.tableView.tableHeaderView addSubview:self.refreshControl];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 240;
}
#pragma mark -
#pragma mark Network Requests methods
- (void)requestMovies
{
    KMDiscoverListCompletionBlock completionBlock = ^(NSArray* data, NSString* errorString)
    {
        //停止下拉与等待效果
        [self.refreshControl endRefreshing];
        [_KMDiscoverActivityIndicatorView stopAnimating];
        
        if (data != nil)
        {
            [self processData:data];
        }
        else
        {
            //[self.networkLoadingViewController showErrorView];
            //加入显示错误的提示
            [UIView addMJNotifierWithText:@"网络故障请重试" dismissAutomatically:YES];
        }

    };
    KMDiscoverSource* source = [KMDiscoverSource discoverSource];
    [source getDiscoverList:@"1" completion:completionBlock];
}



- (void)refreshFeed
{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"一头驴在拼命的跑...."];
    [self requestMovies];
}



#pragma mark -
#pragma mark Fetched Data Processing

- (void)processData:(NSArray*)data
{
    if ([data count] == 0)
    {
        [UIView addMJNotifierWithText:@"没有读取到内容,请重试" dismissAutomatically:YES];
    }
    else
    {
        if (!self.dataSource)
        {
            self.dataSource = [[NSMutableArray alloc] init];
        }
        self.dataSource = [NSMutableArray arrayWithArray:data];
        [self.tableView reloadData];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"数据为:%lu",(unsigned long)[self.dataSource count]);
    return [self.dataSource count];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KMDiscoverListCell* cell = (KMDiscoverListCell*)[tableView dequeueReusableCellWithIdentifier:KMDiscoverListMenuCellReuseIdentifier forIndexPath:indexPath];
    [cell.timelineImageView setImageURL:[NSURL URLWithString:[[self.dataSource objectAtIndex:indexPath.row] movieOriginalBackdropImageUrl]]];
    //NSLog(@"图片地址:%@",[[self.dataSource objectAtIndex:indexPath.row] movieOriginalBackdropImageUrl]);
    
    [cell.titleLabel setText:[[self.dataSource objectAtIndex:indexPath.row] movieTitle]];
    return cell;
    
}


@end
