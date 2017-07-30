//
//  RecommendVC.m
//  XBTouTiao
//
//  Created by xxb on 2017/7/29.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "DefaultVC.h"
#import "DefaultView.h"
#import "BaseViewModel.h"
#import "ModuleModel.h"
#import "UITableView+TitleIndex.h"
#import "TopTextBottomPicLayout.h"
#import "LeftTextRightPicLayout.h"
#import "TopTextBottomPicModel.h"
#import "TopTextBottomPicCell.h"
#import "ImageManager.h"
#import "LeftTextRightPicModel.h"
#import "LeftTextRightImageCell.h"
#import "SmartLoader.h"
#import "UIViewController+TitleIndex.h"
#import "UIViewController+PagingRefreshLoadMore.h"

#define PageSize 20 //每页20条

@interface DefaultVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) DefaultView *defaultView;
@property (nonatomic, strong) ModuleModel *moduleModel;

@end

@implementation DefaultVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupContentView];
    [self reloadData];
}

-(void)setupContentView{
    self.view = self.defaultView;
    _defaultView.tableView.dataSource = self;
    _defaultView.tableView.delegate = self;
    [_defaultView.tableView registerClass:[TopTextBottomPicCell class] forCellReuseIdentifier:NSStringFromClass([TopTextBottomPicCell class])];
    [_defaultView.tableView registerClass:[LeftTextRightImageCell class] forCellReuseIdentifier:NSStringFromClass([LeftTextRightImageCell class])];
    [self setPRLMTableView:_defaultView.tableView pageSize:PageSize pageBegin:1];
}


/**
 重新加载数据，如果之前有滚动偏移的话，也一起应用
 */
-(void)reloadData{
    _moduleModel = [BaseViewModel getModuleByIndex:self.titleIndex];
    [[SmartLoader shareInstance].moduleDict setObject:_moduleModel forKey:@(self.titleIndex)];
    [_defaultView.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - tableView

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_moduleModel.dataSource.count <= 0){
        return 0;
    }
    id unknownLayout = _moduleModel.layoutSoure[indexPath.row];
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
    if(_moduleModel.dataSource.count <= 0){
        return 0;
    }
    return _moduleModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_moduleModel.dataSource.count <= 0){
        return nil;
    }
    id unknownModel = _moduleModel.dataSource[indexPath.row];
    if([unknownModel isKindOfClass:[TopTextBottomPicModel class]]){

        TopTextBottomPicModel *model = _moduleModel.dataSource[indexPath.row];
        TopTextBottomPicLayout *layout = _moduleModel.layoutSoure[indexPath.row];

        TopTextBottomPicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TopTextBottomPicCell class])];
        [cell setModel:model andLayout:layout];
        //在这里开启加载、解析图片
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [model.picUrlArray enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL * _Nonnull stop) {
                UIImage *image = [[ImageManager shareInstance] parseByImageName:imageName andWidth:layout.image1Frame.size.width height:layout.image1Frame.size.height];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(idx == 0){
                        [cell setImage:image forName:imageName andIndex:0];
                    }else if(idx == 1){
                        [cell setImage:image forName:imageName andIndex:1];
                    }else if(idx == 2){
                        [cell setImage:image forName:imageName andIndex:2];
                    }
                });
            }];
        });
        return cell;
    }else if([unknownModel isKindOfClass:[LeftTextRightPicModel class]]){
        LeftTextRightImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LeftTextRightImageCell class])];
        LeftTextRightPicModel *model = _moduleModel.dataSource[indexPath.row];
        LeftTextRightPicLayout *layout = _moduleModel.layoutSoure[indexPath.row];
        [cell setModel:model andLayout:layout];
        //在这里开启加载、解析图片
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            UIImage *image = [[ImageManager shareInstance] parseByImageName:model.imageName andWidth:layout.imageFrame.size.width height:layout.imageFrame.size.height];
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell setImage:image forName:model.imageName];
            });
        });
        return cell;
    }else{
        return nil;
    }
}

#pragma mark - 刷新加载

-(void)loadViewDataForTableView:(UITableView*)tableView
                   andPageIndex:(NSString*)pageIndex
                       andBlock:(void(^)(NSInteger count))block{
    if([pageIndex isEqualToString:@"1"]){
        [self reloadData];
    }else{
        [BaseViewModel moreDataByModule:_moduleModel];
        [_defaultView.tableView reloadData];
    }
    block(PageSize);//表明后面还有数据
}

#pragma mark - 懒加载

-(DefaultView *)defaultView{
    if(!_defaultView){
        _defaultView = [[DefaultView alloc] initWithFrame:self.view.bounds];
    }
    return _defaultView;
}

@end
