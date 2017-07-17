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

#define PageSize 20 //每页20条

typedef NS_ENUM(NSInteger, ScrollSide) {
    ScrollSideLeft = -1,
    ScrollSideRight = 1
};

@interface MainVC ()<UITableViewDataSource,UIScrollViewDelegate, UITableViewDelegate>

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

#pragma mark - tableView

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
    cell.textLabel.text = moduleModel.dataSource[indexPath.row];
    return cell;
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
    
    UITableView *tableView = [[SliderPageReuseManager shareInstance] dequeueReuseableTableViewWithIndex:index];
    if(tableView.isHit){
        //已有，并且可以直接展示的
        NSLog(@"");
    }else if(tableView.isReused){
        //已有，但是需要替换数据源
//        [tableView reloadData];
    }else{
        //新建的
        tableView.dataSource = self;
        tableView.delegate = self;
        [self.mainView.tableScroll addSubview:tableView];
    }
    tableView.frame = CGRectMake(ScreenWidth*index, 0, ScreenWidth, self.mainView.tableScroll.frameHeight);
    [self.mainView.tableScroll layoutIfNeeded];
    [self.mainView.tableScroll setContentOffset:CGPointMake(ScreenWidth * index, 0) animated:NO];
    
    //加载数据----先不要预加载
    if(self.moduleArray.count < self.mainModel.titleArray.count){
        ModuleModel *moduleModel = [MainViewModel getModuleByTitle:self.mainModel.titleArray[self.currentTitleIndex]];
        [self.moduleArray addObject:moduleModel];
    }
    if(!tableView.isHit){
        [tableView reloadData];
    }
}

//加载数据，每次都加载三个tableView的数据
//会根据currentTitleIndex来处理，加载currentTitleIndex及它左右两个model数据
//-(void)loadData{
//    //数据加载
//    //加载当前屏幕要显示的数据
//    if(self.currentTitleIndex > (NSInteger)(self.moduleArray.count - 1)){
//        ModuleModel *moduleModel = [MainViewModel getModuleByTitle:self.mainModel.titleArray[self.currentTitleIndex]];
//        [self.moduleArray addObject:moduleModel];
//    }
//    //加载下一个屏幕要显示的数据
//    if(self.currentTitleIndex + 1 < self.mainModel.titleArray.count &&
//       self.currentTitleIndex + 1 > (NSInteger)(self.moduleArray.count - 1)){
//        ModuleModel *moduleModel = [MainViewModel getModuleByTitle:self.mainModel.titleArray[self.currentTitleIndex + 1]];
//        [self.moduleArray addObject:moduleModel];
//    }
//    //数据渲染
//    switch (self.currentTableView.tag) {
//        case 0:
//        {
//            ModuleModel *moduleModel = self.moduleArray[self.currentTitleIndex];
//            self.currentTableView.titleIndex = self.currentTitleIndex;
//            [self.currentTableView reloadData];
//            if(self.currentTitleIndex < self.moduleArray.count - 1){
//                moduleModel = self.moduleArray[getTitleIndex(self.currentTitleIndex, 1)];
//                ((UITableView*)self.mainView.tableViewArray[1]).titleIndex = getTitleIndex(self.currentTitleIndex, 1);
//                [self.mainView.tableViewArray[1] reloadData];
//            }
//        }
//            break;
//        case 1:
//        {
//            ModuleModel *moduleModel = self.moduleArray[self.currentTitleIndex];
//            self.currentTableView.titleIndex = self.currentTitleIndex;
//            [self.currentTableView reloadData];
//            
//            if(self.currentTitleIndex > 0){
//                NSInteger a = getTitleIndex(self.currentTitleIndex, -1);
//                moduleModel = self.moduleArray[a];
//                ((UITableView*)[self.mainView.tableViewArray firstObject]).titleIndex = getTitleIndex(self.currentTitleIndex, -1);
//                [[self.mainView.tableViewArray firstObject] reloadData];
//            }
//            
//            if(self.currentTitleIndex < self.moduleArray.count - 1){
//                moduleModel = self.moduleArray[getTitleIndex(self.currentTitleIndex, 1)];
//                ((UITableView*)self.mainView.tableViewArray[2]).titleIndex = getTitleIndex(self.currentTitleIndex, 1);
//                [self.mainView.tableViewArray[2] reloadData];
//            }
//        }
//            break;
//        case 2:
//        {
//            ModuleModel *moduleModel = self.moduleArray[self.currentTitleIndex];
//            self.currentTableView.titleIndex = self.currentTitleIndex;
//            [self.currentTableView reloadData];
//            if(self.currentTitleIndex > 0){
//                moduleModel = self.moduleArray[getTitleIndex(self.currentTitleIndex, -1)];
//                ((UITableView*)[self.mainView.tableViewArray firstObject]).titleIndex = getTitleIndex(self.currentTitleIndex, -1);
//                [[self.mainView.tableViewArray firstObject] reloadData];
//            }
//        }
//            break;
//        default:
//            break;
//    }
//}

NSInteger getTitleIndex(NSInteger source, NSInteger offset){
    return (NSInteger)(source + offset);
}
@end
