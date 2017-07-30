//
//  UIViewController+RefreshLoadMore.m
//  HealthyCity
//
//  Created by zoenet on 2017/3/2.
//  Copyright © 2017年 智业互联网络科技有限公司 艾嘉健康. All rights reserved.
//

#import "UIViewController+PagingRefreshLoadMore.h"
#import "MJRefresh.h"

//宏定义
#define prlmTableKey @"tableView"
#define prlmPageSizeKey @"pageSize"
#define prlmPageBeginKey @"pageBegin"
#define prlmPageIndexKey @"pageIndex"

@implementation UIViewController (PagingRefreshLoadMore)

static NSMutableDictionary *tableViews;

+(void)load{
    tableViews = [[NSMutableDictionary alloc] init];
}

-(void)setPRLMTableView:(UITableView*)tableView
               pageSize:(NSInteger)size
              pageBegin:(NSInteger)index{
    //搞个数组，一旦调用这个方法，就把tableView塞进去。
    //考虑到tableView可能被重用，所以调用这个方法一致视为需要初始化
    //设置begin,index,size
//    NSLog(@"重新初始化tableView%@", getTableKey(tableView));
    NSMutableDictionary *dict = [@{prlmTableKey:tableView,
             prlmPageIndexKey:@(index),
             prlmPageSizeKey:@(size),
             prlmPageBeginKey:@(index)} mutableCopy];
    [tableViews setObject:dict forKey:getTableKey(tableView)];
    
    XBWeakSelfDefine
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //下拉刷新
        [XBWeakSelf rlm_reloadViewData:tableView];
    }];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //上拉加载更多
        [XBWeakSelf rlm_loadMoreDataSource:tableView];
    }];
}

-(void)rlm_reloadViewData:(UITableView*)tableView{
    NSMutableDictionary *dict = [tableViews objectForKey:getTableKey(tableView)];
    [dict setObject:[dict objectForKey:prlmPageBeginKey] forKey:prlmPageIndexKey];
    //        NSLog(@"加载数据%@%@", getTableKey(tableView), [dict objectForKey:prlmPageIndexKey]);
    [self loadViewDataForTableView:tableView andPageIndex:[NSString stringWithFormat:@"%ld", [[dict objectForKey:prlmPageIndexKey] integerValue]] andBlock:^(NSInteger count) {
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer resetNoMoreData];
        if(count < [[dict objectForKey:prlmPageSizeKey] integerValue]){
            [tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

-(void)rlm_loadMoreDataSource:(UITableView*)tableView{
    NSMutableDictionary *dict = [tableViews objectForKey:getTableKey(tableView)];
    [dict setObject:@([[dict objectForKey:prlmPageIndexKey] integerValue] + 1) forKey:prlmPageIndexKey];
    //        NSLog(@"加载数据%@%@", getTableKey(tableView), [dict objectForKey:prlmPageIndexKey]);
    [self loadViewDataForTableView:tableView andPageIndex:[NSString stringWithFormat:@"%ld", [[dict objectForKey:prlmPageIndexKey] integerValue]] andBlock:^(NSInteger count) {
        if(count < [[dict objectForKey:prlmPageSizeKey] integerValue]){
            //没有更多数据了
            [tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [tableView.mj_footer endRefreshing];
        }
    }];
}

/**
 或者重写该方法，该方法带有tableView，适合页面拥有多个tableView时使用
 
 @param tableView tableView
 @param pageIndex 索引
 @param block block
 */
-(void)loadViewDataForTableView:(UITableView*)tableView andPageIndex:(NSString*)pageIndex andBlock:(void(^)(NSInteger count))block{
    
}

NSString *getTableKey(UITableView *tableView){
    return [NSString stringWithFormat:@"%p", tableView];
}

@end
