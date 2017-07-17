//
//  MainView.m
//  XBTouTiao
//
//  Created by xxb on 2017/7/4.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "MainView.h"
#import "MainModel.h"
#import "MainLayout.h"

#define TitleBtnHeight 30 //高度
#define TitleBtnPadding 15 //间隙

@interface MainView()

@property (nonatomic, strong) MainModel *mainModel;
@property (nonatomic, strong) MainLayout *mainLayout;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation MainView

-(instancetype)initWithModel:(MainModel*)model layout:(MainLayout*)layout{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if(self){
        _mainModel = model;
        _mainLayout = layout;
        _titleBtnArray = [[NSMutableArray alloc] initWithCapacity:_mainModel.titleArray.count];
        [self addSubview:[self topView]];
        [self addSubview:[self titleScroll]];
        [self addSubview:[self lineView]];
        [self addSubview:[self tableScroll]];
    }
    return self;
}


#pragma mark - property

-(UIView *)topView{
    if(!_topView){
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        _topView.backgroundColor = [UIColor redColor];
    }
    return _topView;
}

-(UIScrollView *)titleScroll{
    if(!_titleScroll){
        _titleScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), ScreenWidth, TitleBtnHeight)];
        _titleScroll.contentSize = CGSizeMake(self.mainModel.titleArray.count  * 2 * TitleBtnPadding + self.mainLayout.allTitleWidth, TitleBtnHeight);
        _titleScroll.showsVerticalScrollIndicator = NO;
        _titleScroll.showsHorizontalScrollIndicator = NO;
        //button
        @weakify(self)
        __block CGFloat x = 0;
        [self.mainModel.titleArray enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self)
            CGFloat width = [self.mainLayout.titleWidth[idx] floatValue] + TitleBtnPadding * 2;
            //因为间隙在view层累加，所以在这里更新
            self.mainLayout.titleWidth[idx] = @(width);
            self.mainLayout.allTitleWidth += TitleBtnPadding * 2;
            UIButton *btn = [self setupButton:CGRectMake(x, 0, width, TitleBtnHeight) title:self.mainModel.titleArray[idx]];
            [self.titleScroll addSubview:btn];
            [self.titleBtnArray addObject:btn];
            x += width;
        }];
    }
    return _titleScroll;
}

-(UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleScroll.frame), ScreenWidth, 1)];
        _lineView.backgroundColor = RGB(222, 222, 222);
    }
    return _lineView;
}

-(UIScrollView *)tableScroll{
    if(!_tableScroll){
        CGFloat tempY = CGRectGetMaxY(self.lineView.frame);
        CGFloat tempH = ScreenHeight - tempY;
        _tableScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, tempY, ScreenWidth, tempH)];
        _tableScroll.contentSize = CGSizeMake(ScreenWidth * self.mainModel.titleArray.count, tempH);
        _tableScroll.showsHorizontalScrollIndicator = NO;
        _tableScroll.showsVerticalScrollIndicator = NO;
        _tableScroll.pagingEnabled = YES;
        //tableView
//        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:3];
//        for(NSUInteger i = 0; i < 3; i++){
//            UITableView *tableView = [self setupTableView:CGRectMake(i * ScreenWidth, 0, ScreenWidth, _tableScroll.frameHeight)];
//            tableView.tag = i;
//            [_tableScroll addSubview:tableView];
//            [tempArray addObject:tableView];
//        }
//        _tableViewArray = [tempArray copy];
    }
    return _tableScroll;
}

-(UIButton*)setupButton:(CGRect)frame
                  title:(NSString*)title{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    return btn;
}

static int count = 0;

-(UITableView*)setupTableView:(CGRect)frame{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc] init];
    switch (count) {
        case 0:
            tableView.backgroundColor = [UIColor redColor];
            break;
        case 1:
            tableView.backgroundColor = [UIColor blackColor];
            break;
        case 2:
            tableView.backgroundColor = [UIColor yellowColor];
            break;
        case 3:
            tableView.backgroundColor = [UIColor blueColor];
            break;
        default:
            break;
    }
    count ++;
    return tableView;
}
@end
