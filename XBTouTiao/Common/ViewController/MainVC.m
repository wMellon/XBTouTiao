//
//  MainVC.m
//  XBTouTiao
//
//  Created by xxb on 2017/7/4.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "MainVC.h"
#import "MainView.h"
#import "MainModel.h"
#import "MainLayout.h"
#import "MainViewModel.h"
#import "ModuleModel.h"
#import "UITableView+TitleIndex.h"
#import "SliderPageReuseManager.h"
#import "TopTextBottomPicCell.h"
#import "LeftTextRightImageCell.h"
#import "TopTextBottomPicLayout.h"
#import "TopTextBottomPicModel.h"
#import "ImageManager.h"
#import "LeftTextRightPicModel.h"
#import "LeftTextRightPicLayout.h"
#import "UIViewController+PagingRefreshLoadMore.h"

#define PageSize 20 //每页20条

typedef NS_ENUM(NSInteger, ScrollSide) {
    ScrollSideLeft = -1,
    ScrollSideRight = 1
};

@interface MainVC ()<UITableViewDataSource,UIScrollViewDelegate, UITableViewDelegate,PagingRefreshLoadMoreDelegate>

@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) MainModel *mainModel;
@property (nonatomic, strong) MainLayout *mainLayout;
@property (nonatomic, strong) NSMutableArray<ModuleModel*> *moduleArray;
@property (nonatomic, assign) NSInteger currentTitleIndex;//存储当前索引。有个作用：用于控制快速拖拽导致的跳页（即从第一页跳到第3页这种情况）
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
    self.mainModel = [MainViewModel getModel];
    self.mainLayout = [MainViewModel getLayout];
    self.moduleArray = [[NSMutableArray alloc] initWithCapacity:self.mainModel.titleArray.count];
    self.currentTitleIndex = 0;
}

-(void)setupContentView{
    self.mainView = [[MainView alloc] initWithModel:self.mainModel layout:self.mainLayout];
    self.mainView.tableScroll.delegate = self;
    self.view = self.mainView;
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
        index = index >= self.mainModel.titleArray.count ? self.mainModel.titleArray.count - 1 : index;
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
    if([scrollView isKindOfClass:[UITableView class]]){
        UITableView *tableView = (UITableView*)scrollView;
        ModuleModel *module = self.moduleArray[tableView.titleIndex];
        module.contentOffsetY = scrollView.contentOffset.y;
    }
}

#pragma mark - tableView

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.titleIndex >= self.moduleArray.count){
        return 0;
    }
    ModuleModel *moduleModel = self.moduleArray[tableView.titleIndex];
    
    id unknownLayout = moduleModel.layoutSoure[indexPath.row];
    if([unknownLayout isKindOfClass:[TopTextBottomPicLayout class]]){
        TopTextBottomPicLayout *layout = (TopTextBottomPicLayout*)unknownLayout;
        return layout.cellHeight;
    }else if([unknownLayout isKindOfClass:[LeftTextRightPicLayout class]]){
        LeftTextRightPicLayout *layout = (LeftTextRightPicLayout*)unknownLayout;
        return layout.cellHeight;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.titleIndex >= self.moduleArray.count){
        return 0;
    }
    ModuleModel *moduleModel = self.moduleArray[tableView.titleIndex];
    return moduleModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.titleIndex >= self.moduleArray.count){
        return nil;
    }
    ModuleModel *moduleModel = self.moduleArray[tableView.titleIndex];
    id unknownModel = moduleModel.dataSource[indexPath.row];
    if([unknownModel isKindOfClass:[TopTextBottomPicModel class]]){
        
        TopTextBottomPicModel *model = moduleModel.dataSource[indexPath.row];
        TopTextBottomPicLayout *layout = moduleModel.layoutSoure[indexPath.row];
        
        TopTextBottomPicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TopTextBottomPicCell class])];
        [cell setModel:model andLayout:layout];
        //在这里开启加载、解析图片
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [model.picUrlArray enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL * _Nonnull stop) {
                UIImage *image = [[ImageManager shareInstance] parseByImageName:imageName andWidth:layout.image1Frame.size.width height:layout.image1Frame.size.height];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(idx == 0){
                        cell.imageView1.image = image;
                    }else if(idx == 1){
                        cell.imageView2.image = image;
                    }else if(idx == 2){
                        cell.imageView3.image = image;
                    }
                });
            }];
        });
        return cell;
    }else if([unknownModel isKindOfClass:[LeftTextRightPicModel class]]){
        LeftTextRightImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LeftTextRightImageCell class])];
        LeftTextRightPicModel *model = moduleModel.dataSource[indexPath.row];
        LeftTextRightPicLayout *layout = moduleModel.layoutSoure[indexPath.row];
        [cell setModel:model andLayout:layout];
        //在这里开启加载、解析图片
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            UIImage *image = [[ImageManager shareInstance] parseByImageName:model.imageName andWidth:layout.imageFrame.size.width height:layout.imageFrame.size.height];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.rightImage.image = image;
            });
        });
        return cell;
    }else{
        return nil;
    }
}

#pragma mark -PagingRefreshLoadMoreDelegate

-(void)loadViewDataForTableView:(UITableView*)tableView andPageIndex:(NSString*)pageIndex andBlock:(void(^)(NSInteger count))block{
    ModuleModel *module = self.moduleArray[self.currentTitleIndex];
    if([pageIndex isEqualToString:@"1"]){
        [module.dataSource removeAllObjects];
        [module.layoutSoure removeAllObjects];
    }
    [MainViewModel moreDataByModule:module];
    [tableView reloadData];
    block(PageSize);
}

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
    
    UITableView *tableView = [self getTableView:index];
    if(tableView.isHit){
        //已有，并且可以直接展示的
//        NSLog(@"");
    }else if(tableView.isReused){
        //已有，但是需要替换数据源
    }else{
        //新建的
        tableView.dataSource = self;
        tableView.delegate = self;
        [self.mainView.tableScroll addSubview:tableView];
    }
    tableView.frame = CGRectMake(ScreenWidth*index, 0, ScreenWidth, self.mainView.tableScroll.frameHeight);
    [self.mainView.tableScroll layoutIfNeeded];
    [self.mainView.tableScroll setContentOffset:CGPointMake(ScreenWidth * index, 0) animated:NO];
    
    //加载数据
    if(self.currentTitleIndex >= self.moduleArray.count){
        [self loadCurrentData:tableView];
    }else{
        [self loadNextData];
        [self loadPreviousData];
    }
}

-(void)loadCurrentData:(UITableView*)tableView{
    @weakify(self)
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @strongify(self)
        ModuleModel *moduleModel = [MainViewModel getModuleByTitle:self.mainModel.titleArray[self.currentTitleIndex]];
        [self.moduleArray addObject:moduleModel];
        if(!tableView.isHit){
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self)
                [self tableViewReload:tableView];
                //以下两个方法并没有进行数据的加载，只是更改tablView的frame而已
                [self loadNextData];
                [self loadPreviousData];
            });
        }
    });
}

-(void)loadNextData{
    //加载后一页面展示的
    if(self.currentTitleIndex + 1 < self.moduleArray.count){
        //已加载过的页面，做预加载处理
        UITableView *nextTableView = [self getTableView:self.currentTitleIndex + 1];
        nextTableView.frame = CGRectMake(ScreenWidth * (self.currentTitleIndex + 1), 0, ScreenWidth, self.mainView.tableScroll.frameHeight);
        [self.mainView.tableScroll layoutIfNeeded];
        if(nextTableView.isHit){
            return;
        }
        nextTableView.titleIndex = self.currentTitleIndex + 1;
        [self tableViewReload:nextTableView];
    }
}

-(void)loadPreviousData{
    //加载前一页面展示的
    if(self.currentTitleIndex - 1 >= 0){
        UITableView *previousTableView = [self getTableView:self.currentTitleIndex - 1];
        previousTableView.frame = CGRectMake(ScreenWidth * (self.currentTitleIndex - 1), 0, ScreenWidth, self.mainView.tableScroll.frameHeight);
        [self.mainView.tableScroll layoutIfNeeded];
        if(previousTableView.isHit){
            return;
        }
        previousTableView.titleIndex = self.currentTitleIndex - 1;
        [self tableViewReload:previousTableView];
    }
}


/**
 重新加载数据，并且会自动滚到之前浏览的位置

 */
-(void)tableViewReload:(UITableView*)tableView{
    ModuleModel *module = self.moduleArray[tableView.titleIndex];
    [tableView setContentOffset:CGPointMake(0, module.contentOffsetY) animated:NO];
    [tableView reloadData];
}

-(UITableView*)getTableView:(NSInteger)index{
    UITableView *tableView = [[SliderPageReuseManager shareInstance] dequeueReuseableTableViewWithIndex:index];
    if(!tableView.isHit){
        //没有命中的tableView一律都要重新初始化
        [self setPRLMTableView:tableView pageSize:PageSize pageBegin:1];
        self.prlmDelegate = self;
    }
    if(!tableView.isReused){
        [tableView registerClass:[TopTextBottomPicCell class] forCellReuseIdentifier:NSStringFromClass([TopTextBottomPicCell class])];
        [tableView registerClass:[LeftTextRightImageCell class] forCellReuseIdentifier:NSStringFromClass([LeftTextRightImageCell class])];
    }
    return tableView;
}
@end
