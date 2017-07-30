//
//  MainLayout.h
//  XBTouTiao
//
//  Created by xxb on 2017/7/4.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainLayout : NSObject

#define TitleBtnHeight 30 //高度
#define TitleBtnPadding 15 //间隙

@property (nonatomic, assign) CGRect topViewFrame;//菜单栏上面的view
@property (nonatomic, assign) CGRect titleScrollFrame;//顶部菜单栏的frame
@property (nonatomic, assign) NSUInteger allTitleWidth;//所有标题的宽度，不含空隙
@property (nonatomic, strong) NSMutableArray *titleWidth;

@end
