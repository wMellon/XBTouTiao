//
//  MainView.h
//  XBTouTiao
//
//  Created by xxb on 2017/7/4.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainModel;
@class MainLayout;

@interface MainView : UIView

//@property (nonatomic, strong) NSArray *tableViewArray;
@property (nonatomic, strong) UIScrollView *titleScroll;
@property (nonatomic, strong) UIScrollView *tableScroll;
@property (nonatomic, strong) NSMutableArray *titleBtnArray;

-(instancetype)initWithModel:(MainModel*)model layout:(MainLayout*)layout;

@end
