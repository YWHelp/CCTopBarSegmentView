//
//  ViewController.m
//  CCTopBarSegmentView
//
//  Created by changcai on 2017/10/18.
//  Copyright © 2017年 changcai. All rights reserved.
//

#import "ViewController.h"
#import "CCSegmentView.h"
#import "CCPageContentView.h"
#import "TableViewController.h"
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<CCSegmentViewDelegate,CCPageContentViewDelegare>
@property (nonatomic, strong) CCSegmentView *barSegmentView;
@property (nonatomic, strong) CCPageContentView *pageContentView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ViewController

#pragma mark -- Lazy loading --
- (CCSegmentView*)barSegmentView {
    if (!_barSegmentView) {
        _barSegmentView = [[CCSegmentView alloc] initWithFrame:CGRectMake(0, 20,screen_width,44)  titles:nil delegate:self indicatorType:CCIndicatorTypeSpring];
            }
    return _barSegmentView;
}
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.barSegmentView];
    _barSegmentView.titlesArr = @[@"精选", @"电影", @"电视剧", @"综艺", @"NBA", @"娱乐", @"动漫", @"演唱会"];
    for (int i = 0; i < _barSegmentView.titlesArr.count; i++) {
        TableViewController *vc = [[TableViewController alloc]init];
        [self.dataSource addObject:vc];
    }
    self.pageContentView = [[CCPageContentView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height-64) parentVC:self childVCs:[self.dataSource copy]];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
}

#pragma mark  -- CCSegmentViewDelegate --

- (BOOL)segmentTitleView:(CCSegmentView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    [self.pageContentView setPageCententViewCurrentIndex:endIndex];
    return YES;
}
#pragma mark  -- CCPageContentViewDelegare --
- (void)pageContentView:(CCPageContentView *)pageContentView contentOffsetX:(CGFloat)contentOffsetX progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex
{
    [self bottomBarNaughtyWithOffset:contentOffsetX];
    NSLog(@"-----当前偏移量：%f-----",contentOffsetX);
}

- (void)pageContentView:(CCPageContentView *)pageContentView scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    [self.barSegmentView selectedIndex:x/self.view.width];
}

- (void)bottomBarNaughtyWithOffset:(CGFloat)offsetx
{
    if (offsetx < 0)
    {
        offsetx = 0;
    }
    self.barSegmentView.pregressView.isNaugty = YES;
    self.barSegmentView.pregressView.progress = offsetx/screen_width;
}


@end
