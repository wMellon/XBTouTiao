//
//  SliderPageReuseManager.h
//  XBTouTiao
//
//  Created by xxb on 2017/7/16.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SliderPageReuseManager : NSObject

@property (nonatomic, assign) NSUInteger reusePoolMaxSize;//复用池最大值

+(instancetype)shareInstance;
- (UITableView *)dequeueReuseableTableViewWithIndex:(NSInteger)index;

@end
