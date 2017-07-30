//
//  UIViewController+RefreshLoadMore.h
//  HealthyCity
//
//  Created by zoenet on 2017/3/2.
//  Copyright © 2017年 智业互联网络科技有限公司 艾嘉健康. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PagingRefreshLoadMore)

//@property(nonatomic, weak) id<PagingRefreshLoadMoreDelegate> prlmDelegate;

/**
 需要使用时，调用这个方法传入参数，再重写底下的方法就行

 @param tableView tableView
 @param size size
 @param index 开始的索引
 */
-(void)setPRLMTableView:(UITableView*)tableView
               pageSize:(NSInteger)size
              pageBegin:(NSInteger)index;

/**
 或者重写该方法，该方法带有tableView，适合页面拥有多个tableView时使用
 
 @param tableView tableView
 @param pageIndex 索引
 @param block block
 */
-(void)loadViewDataForTableView:(UITableView*)tableView
                   andPageIndex:(NSString*)pageIndex
                       andBlock:(void(^)(NSInteger count))block;
@end
