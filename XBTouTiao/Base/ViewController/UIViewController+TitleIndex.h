//
//  UIViewController+TitleIndex.h
//  XBTouTiao
//
//  Created by xxb on 2017/7/28.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TitleIndex)

@property (nonatomic, assign) NSInteger titleIndex;
@property (nonatomic, assign) BOOL isHit;//是否命中，即要找的vc是否已存在于复用池中
@property (nonatomic, assign) BOOL isReused;//是否重用，即vc是否从复用池中取出的，是那么vc就不用重新设置代理等
@property (nonatomic, copy) NSString *identifier;//标识是哪种类型

-(void)reloadData;

@end
