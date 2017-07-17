//
//  SliderPageReuseManager.m
//  XBTouTiao
//
//  Created by xxb on 2017/7/16.改自SliderPagerController
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "SliderPageReuseManager.h"
#import "UITableView+TitleIndex.h"

@interface SliderPageReuseManager()

@property (nonatomic, strong) NSMutableArray *reusePool;//复用池

@end

@implementation SliderPageReuseManager

+(instancetype)shareInstance{
    static SliderPageReuseManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SliderPageReuseManager alloc] init];
    });
    return manager;
}

- (UITableView *)dequeueReuseableTableViewWithIndex:(NSInteger)index {
    __block UITableView *tableView;
    [self.reusePool enumerateObjectsUsingBlock:^(UITableView *t, NSUInteger idx, BOOL * _Nonnull stop) {
        if(t.titleIndex == index) {
            tableView = t;
            *stop = YES;
        }
    }];
    //复用队列里没有找到
    if (!tableView) {
        //复用队列超过最大容量，取第一个做复用
        if (self.reusePool.count >= self.reusePoolMaxSize) {
            //获取离index最远的那个tableView返回
            __block NSInteger temp = 0;
            [self.reusePool enumerateObjectsUsingBlock:^(UITableView *t, NSUInteger idx, BOOL * _Nonnull stop) {
                //获取最远的
                if(temp == 0 ||
                   temp < labs(t.titleIndex - index)){
                    temp = labs(t.titleIndex - index);
                    tableView = t;
                }
            }];
            tableView.titleIndex = index;
            tableView.isHit = NO;
            tableView.isReused = YES;
            NSLog(@"重用%@", @(tableView.titleIndex));
        }
        //没有超过最大容量，实例化一个新的
        else {
            tableView = [[UITableView alloc]init];
            tableView.titleIndex = index;
            tableView.isReused = NO;
            tableView.isHit = NO;
            [self.reusePool addObject:tableView];
            
            NSLog(@"实例化%@", @(tableView.titleIndex));
        }
        
    }else {
        tableView.isHit = YES;
        tableView.isReused = YES;
        NSLog(@"命中%@", @(tableView.titleIndex));
    }
    return tableView;
}

#pragma mark - properties

-(void)setReusePoolMaxSize:(NSUInteger)reusePoolMaxSize{
    //最小为3
    if(reusePoolMaxSize < 3){
        reusePoolMaxSize = 3;
    }
    _reusePoolMaxSize = reusePoolMaxSize;
    [self reusePool];
}

-(NSMutableArray*)reusePool{
    if(!_reusePool){
        _reusePool = [[NSMutableArray alloc] initWithCapacity:_reusePoolMaxSize];
    }
    return _reusePool;
}
@end
