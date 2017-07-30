//
//  MainVC.m
//  XBTouTiao
//
//  Created by xxb on 2017/7/4.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "MainVC.h"
#import "MainView.h"
#import "MainLayout.h"
#import "MainViewModel.h"
#import "ModuleModel.h"
#import "SliderPageReuseManager.h"
#import "UIViewController+PagingRefreshLoadMore.h"
#import "UIViewController+TitleIndex.h"
#import "DefaultVC.h"
#import "MainTitleModel.h"
#import "SmartLoader.h"

#define PageSize 20 //每页20条

typedef NS_ENUM(NSInteger, ScrollSide) {
    ScrollSideLeft = -1,
    ScrollSideRight = 1
};

@interface MainVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) MainLayout *mainLayout;
@property (nonatomic, assign) NSInteger currentTitleIndex;//存储当前索引。有个作用：用于控制快速拖拽导致的跳页（即从第一页跳到第3页这种情况）
@property (nonatomic, strong) NSArray *mainTitleArray;//顶部tab菜单数组

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataInit];
    [self setupContentView];
    [self sliderToViewAtIndex:0];
}

-(void)dataInit{
    [SliderPageReuseManager shareInstance].reusePoolMaxSize = 3;
    self.mainTitleArray = [MainViewModel getMainTitleModle];
    self.mainLayout = [MainViewModel getLayout];
    self.currentTitleIndex = 0;
}

-(void)setupContentView{
    self.mainView = [[MainView alloc] initWithTitleArray:_mainTitleArray layout:_mainLayout];
    self.mainView.tableScroll.delegate = self;
    self.view = self.mainView;
    [[SliderPageReuseManager shareInstance] registerClass:[DefaultVC class] forReuseIdentifier:VCTypeDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - delegate

#pragma mark - UIScrollView

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != self.mainView.tableScroll) {
        return;
    }
    double dIndex = scrollView.contentOffset.x / ScreenWidth;
    NSInteger index = (NSInteger)(dIndex+0.5);
    if(self.currentTitleIndex == index){
        return;
    }
    self.currentTitleIndex = index;
    [self sliderToViewAtIndex:(index)];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(scrollView != self.mainView.tableScroll){
        return;
    }
    double dIndex = scrollView.contentOffset.x / ScreenWidth;
    NSInteger index = (NSInteger)(dIndex+0.5);
    if(self.currentTitleIndex == dIndex){
        return;
    }
    
    //拖拽时跳跃的情况处理
    if((index - self.currentTitleIndex) > 1){
        index = self.currentTitleIndex + 1;
        index = index >= self.mainTitleArray.count ? self.mainTitleArray.count - 1 : index;
        [scrollView setContentOffset:CGPointMake(index * ScreenWidth, 0) animated:NO];
    }else if((index - self.currentTitleIndex) < -1){
        index = self.currentTitleIndex - 1;
        index = index < 0 ? 0 : index;
        [scrollView setContentOffset:CGPointMake(index * ScreenWidth, 0) animated:NO];
    }
    self.currentTitleIndex = index;
    [self sliderToViewAtIndex:index];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //保留上次滚动的位置
//    if([scrollView isKindOfClass:[UITableView class]]){
//        UITableView *tableView = (UITableView*)scrollView;
//        if(tableView.titleIndex < self.moduleArray.count){
//            ModuleModel *module = self.moduleArray[tableView.titleIndex];
//            module.contentOffsetY = scrollView.contentOffset.y;
//        }
//    }
}

#pragma mark -PagingRefreshLoadMoreDelegate

//-(void)loadViewDataForTableView:(UITableView*)tableView andPageIndex:(NSString*)pageIndex andBlock:(void(^)(NSInteger count))block{
//    ModuleModel *module = self.moduleArray[self.currentTitleIndex];
//    if([pageIndex isEqualToString:@"1"]){
//        [module.dataSource removeAllObjects];
//        [module.layoutSoure removeAllObjects];
//    }
//    [MainViewModel moreDataByModule:module];
//    [tableView reloadData];
//    block(PageSize);
//}

#pragma mark - action

- (void)sliderToViewAtIndex:(NSInteger)index{
    //titleScroll
    __block NSInteger previousCountW = 0;
    [self.mainLayout.titleWidth enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(idx == index){
            previousCountW += [obj integerValue] / 2;
            *stop = YES;
        }else{
            previousCountW += [obj integerValue];
        }
    }];
    CGFloat halfWidth = self.mainView.titleScroll.frameWidth / 2;
    if(previousCountW <= halfWidth){
        //处于左边
        [self.mainView.titleScroll scrollRectToVisible:CGRectMake(0, 0, self.mainView.titleScroll.frameWidth, self.mainView.titleScroll.frameHeight) animated:YES];
    }else if(self.mainLayout.allTitleWidth - previousCountW <= halfWidth){
        //处于右边
        [self.mainView.titleScroll scrollRectToVisible:CGRectMake(self.mainLayout.allTitleWidth - self.mainView.titleScroll.frameWidth, 0, self.mainView.titleScroll.frameWidth, self.mainView.titleScroll.frameHeight) animated:YES];
    }else{
        //处于中间
        [self.mainView.titleScroll scrollRectToVisible:CGRectMake(previousCountW - halfWidth, 0, self.mainView.titleScroll.frameWidth, self.mainView.titleScroll.frameHeight) animated:YES];
    }
    //设置颜色
    UIButton *btn = self.mainView.titleBtnArray[index];
    [self.mainView.titleBtnArray enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        if(btn == button){
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }];
    
    MainTitleModel *title = _mainTitleArray[index];
    UIViewController *viewController = [self getViewController:index andIdentifier:title.vcType];
    viewController.view.frame = CGRectMake(ScreenWidth*index, 0, ScreenWidth, self.mainView.tableScroll.frameHeight);
    [self.mainView.tableScroll layoutIfNeeded];
    [self.mainView.tableScroll setContentOffset:CGPointMake(ScreenWidth * index, 0) animated:NO];
    
    if(!viewController.isHit){
        [viewController reloadData];
    }
    //【需要优化】这里可能会导致多余的加载动作：当前页面的左右两个页面可能还不需要重新加载
    if(self.currentTitleIndex >= [SmartLoader shareInstance].moduleDict.count){
//        [self loadCurrentData:tableView];
    }else{
        [self loadNextData];
        [self loadPreviousData];
    }
}

-(void)loadNextData{
    //加载后一页面展示的
    if(self.currentTitleIndex + 1 < [SmartLoader shareInstance].moduleDict.count){
        //已加载过的页面，做预加载处理
        MainTitleModel *title = self.mainTitleArray[self.currentTitleIndex + 1];
        UIViewController *nextViewController = [self getViewController:self.currentTitleIndex + 1 andIdentifier:title.vcType];
        nextViewController.view.frame = CGRectMake(ScreenWidth * (self.currentTitleIndex + 1), 0, ScreenWidth, self.mainView.tableScroll.frameHeight);
        [self.mainView.tableScroll layoutIfNeeded];
        if(nextViewController.isHit){
            return;
        }
        nextViewController.titleIndex = self.currentTitleIndex + 1;
        nextViewController.identifier = title.vcType;
//        [self tableViewReload:nextTableView];
        [nextViewController reloadData];
    }
}

-(void)loadPreviousData{
    //加载前一页面展示的
    if(self.currentTitleIndex - 1 >= 0){
        MainTitleModel *title = self.mainTitleArray[self.currentTitleIndex - 1];
        UIViewController *previousViewController = [self getViewController:self.currentTitleIndex - 1 andIdentifier:title.vcType];
        previousViewController.view.frame = CGRectMake(ScreenWidth * (self.currentTitleIndex - 1), 0, ScreenWidth, self.mainView.tableScroll.frameHeight);
        [self.mainView.tableScroll layoutIfNeeded];
        if(previousViewController.isHit){
            return;
        }
        previousViewController.titleIndex = self.currentTitleIndex - 1;
        previousViewController.identifier = title.vcType;
        [previousViewController reloadData];
    }
}

//-(void)loadCurrentData:(UITableView*)tableView{
//    @weakify(self)
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        @strongify(self)
//        ModuleModel *moduleModel = [MainViewModel getModuleByTitle:self.mainTitleArray[self.currentTitleIndex]];
//        [self.moduleArray addObject:moduleModel];
//        if(!tableView.isHit){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                @strongify(self)
//                [self tableViewReload:tableView];
//                //以下两个方法并没有进行数据的加载，只是更改tablView的frame而已
//                [self loadNextData];
//                [self loadPreviousData];
//            });
//        }
//    });
//}

//-(void)loadNextData{
//    //加载后一页面展示的
//    if(self.currentTitleIndex + 1 < self.moduleArray.count){
//        //已加载过的页面，做预加载处理
//        UITableView *nextTableView = [self getTableView:self.currentTitleIndex + 1];
//        nextTableView.frame = CGRectMake(ScreenWidth * (self.currentTitleIndex + 1), 0, ScreenWidth, self.mainView.tableScroll.frameHeight);
//        [self.mainView.tableScroll layoutIfNeeded];
//        if(nextTableView.isHit){
//            return;
//        }
//        nextTableView.titleIndex = self.currentTitleIndex + 1;
//        [self tableViewReload:nextTableView];
//    }
//}

//-(void)loadPreviousData{
//    //加载前一页面展示的
//    if(self.currentTitleIndex - 1 >= 0){
//        UITableView *previousTableView = [self getTableView:self.currentTitleIndex - 1];
//        previousTableView.frame = CGRectMake(ScreenWidth * (self.currentTitleIndex - 1), 0, ScreenWidth, self.mainView.tableScroll.frameHeight);
//        [self.mainView.tableScroll layoutIfNeeded];
//        if(previousTableView.isHit){
//            return;
//        }
//        previousTableView.titleIndex = self.currentTitleIndex - 1;
//        [self tableViewReload:previousTableView];
//    }
//}


/**
 重新加载数据，并且会自动滚到之前浏览的位置

 */
//-(void)tableViewReload:(UITableView*)tableView{
//    ModuleModel *module = self.moduleArray[tableView.titleIndex];
//    [tableView setContentOffset:CGPointMake(0, module.contentOffsetY) animated:NO];
//    [tableView reloadData];
//}


-(UIViewController*)getViewController:(NSInteger)index andIdentifier:(NSString*)identifier{
    UIViewController *vc = [[SliderPageReuseManager shareInstance] dequeueReuseableViewControllerWithIndex:index andIdentifier:identifier];
    if(!vc.isReused){
        [self addChildViewController:vc];
        [self.mainView.tableScroll addSubview:vc.view];
    }
    return vc;
}
@end
