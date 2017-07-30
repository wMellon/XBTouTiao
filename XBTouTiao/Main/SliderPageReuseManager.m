//
//  SliderPageReuseManager.m
//  XBTouTiao
//
//  Created by xxb on 2017/7/16.改自SliderPagerController
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "SliderPageReuseManager.h"
#import "UITableView+TitleIndex.h"
#import "UIViewController+TitleIndex.h"

@interface SliderPageReuseManager()

@property (nonatomic, strong) NSMutableDictionary *reuseClasses;
@property (nonatomic, strong) NSMutableArray *reusePool;//复用池

@end

@implementation SliderPageReuseManager

-(instancetype)init{
    self = [super init];
    if(self){
        _reuseClasses = [[NSMutableDictionary alloc] init];
    }
    return self;
}

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

- (void)registerClass:(Class)someClass forReuseIdentifier:(NSString *)identifier{
    [_reuseClasses setObject:someClass forKey:identifier];
}

-(UIViewController*)dequeueReuseableViewControllerWithIndex:(NSInteger)index andIdentifier:(NSString *)identifier{
    __block UIViewController *viewController;
    [self.reusePool enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
        if(vc.titleIndex == index) {
            viewController = vc;
            *stop = YES;
        }
    }];
    //复用队列里没有找到
    if (!viewController) {
        //复用队列超过最大容量，取第一个做复用
        if (self.reusePool.count >= self.reusePoolMaxSize) {
            //获取离index最远的那个tableView返回
            __block NSInteger temp = 0;
            [self.reusePool enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
                //获取最远的
                if(temp == 0 ||
                   temp < labs(vc.titleIndex - index)){
                    temp = labs(vc.titleIndex - index);
                    viewController = vc;
                }
            }];
            if(![viewController.identifier isEqualToString:identifier]){
                //如果是不同类型，那么需要重新实例化
                Class class = [_reuseClasses objectForKey:identifier];
                viewController = [[class alloc] init];
                viewController.identifier = identifier;
            }
            viewController.titleIndex = index;
            viewController.isHit = NO;
            viewController.isReused = YES;
            NSLog(@"重用%@", viewController);
        }
        //没有超过最大容量，实例化一个新的
        else {
            Class class = [_reuseClasses objectForKey:identifier];
            viewController = [[class alloc] init];
            viewController.titleIndex = index;
            viewController.isReused = NO;
            viewController.isHit = NO;
            viewController.identifier = identifier;
            [self.reusePool addObject:viewController];
            NSLog(@"实例化%@", viewController);
        }
        
    }else {
        viewController.isHit = YES;
        viewController.isReused = YES;
        NSLog(@"命中%@", viewController);
    }
    return viewController;
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
