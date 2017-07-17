//
//  PageModel.h
//  XBTouTiao
//
//  Created by xxb on 2017/7/5.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModuleModel : NSObject

@property (nonatomic, assign) NSUInteger titleIndex;//title位于数组的索引，从0开始
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSUInteger tableIndex;//处于第几个table
@property (nonatomic, strong) NSIndexPath *currentIndexPath;//当前处于那一个row
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSUInteger pageIndex;//第几页

@property (nonatomic, assign) BOOL tableLoaded;//table加载是否完成。指的是在需要显示的那一串cell是否完全加载，没有的话，会重新加载一遍
@property (nonatomic, strong) NSMutableArray *needLoadIndexpathArray;//每次滚动后，会重新计算要加载的indexpath

@end
