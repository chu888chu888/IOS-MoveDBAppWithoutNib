//
//  KMDiscoverListViewController.m
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 03/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import "KMDiscoverListViewController.h"
#import "KMDiscoverListCell.h"
#import "KMDiscoverSource.h"
#import "KMMovie.h"
#import "UIView+MJAlertView.h"
#import "AppDelegate.h"
#import "KMMovieDetailsViewController.h"
#import "UIImage+Screenshot.h"
#import "DHSmartScreenshot.h"
#import "DHSmartScreenshot.h"

NSString * const KMDiscoverListMenuCellReuseIdentifier = @"Drawer Cell";
@interface KMDiscoverListViewController ()

@property (nonatomic, strong) NSMutableArray* dataSource;
@property (nonatomic) NSInteger pageIndex;
@end

@implementation KMDiscoverListViewController

#pragma mark -
#pragma mark Init Methods
- (instancetype)init {
    if ((self = [super init])) {
        _pageIndex=1;
    }
    return self;
}

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
    
    //设置刷新按钮
    UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshFeedForRightItem)];
    self.navigationItem.rightBarButtonItem = refreshBarButton;
    //设置保存按钮
    

    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveRightItem)];
    self.navigationItem.leftBarButtonItem = saveBarButton;
    

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取适配屏幕系数,适配6 6p 5s
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    switch (myDelegate.ScreenWidth) {
        case 414:
            return 310;
            break;
        case 375:
            return 280;
        default:
            return 240;
            break;
    }

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
            [UIView addMJNotifierWithText:@"网络故障请重试" dismissAutomatically:YES];
        }

    };
    

    KMDiscoverSource* source = [KMDiscoverSource discoverSource];
    [source getDiscoverList:[NSString stringWithFormat: @"%ld", (long)_pageIndex] completion:completionBlock];
}



- (void)refreshFeed
{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"一头驴在拼命的跑...."];
    //为了保证每一次刷新都是看到不同的信息,我让索引是累加的
    ++_pageIndex;
    [self requestMovies];
}

- (void)refreshFeedForRightItem
{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"一头驴在拼命的跑...."];
    //如果是从导航条上的刷新按钮传递过来的事件的话,我就从第一个索引开始
    _pageIndex=1;
    [self requestMovies];
}

- (void)saveRightItem
{
    /*
    //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
    //UIGraphicsBeginImageContext(self.view.bounds.size);
    UIGraphicsBeginImageContext(self.tableView.bounds.size);
    //renderInContext呈现接受者及其子范围到指定的上下文
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    //返回一个基于当前图形上下文的图片
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();//移除栈顶的基于当前位图的图形上下文
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);//然后将该图片保存到图片库
     */
    
    //UIImage *image = [UIImage screenshot];
    //UIImage *image=[self.tableView screenshot];
    //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//然后将该图片保存到图片库
    
    
    //异步执行队列任务
    dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        [self saveImage];
        
    });
}
-(void)saveImage
{
    UIImage *image = [UIImage screenshot];
    image = [self.tableView screenshotExcludingAllHeaders:YES
                                      excludingAllFooters:NO
                                         excludingAllRows:NO];
    //然后将该图片保存到图片库
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    //更新UI界面,此处调用了GCD主线程队列的方法
    dispatch_queue_t mainQueue= dispatch_get_main_queue();
    dispatch_sync(mainQueue, ^{
        [UIView addMJNotifierWithText:@"截图已经保存在相册" dismissAutomatically:YES];
    });
    
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
    //NSLog(@"图片地址:%@",[[self.dataSource objectAtIndex:indexPath.row] movieOriginalPosterImageUrl]);
    
    [cell.titleLabel setText:[[self.dataSource objectAtIndex:indexPath.row] movieTitle]];
    return cell;
    
}
#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    KMMovieDetailsViewController* viewController = [[KMMovieDetailsViewController alloc]init];
    viewController.movieDetails = [self.dataSource objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

@end
