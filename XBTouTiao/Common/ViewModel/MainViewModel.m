//
//  MainViewModel.m
//  XBTouTiao
//
//  Created by xxb on 2017/7/4.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "MainViewModel.h"
#import "MainModel.h"
#import "MainLayout.h"
#import "ModuleModel.h"
#import "TopTextBottomPicModel.h"
#import "AuthorEvaluateTimeModel.h"
#import "TopTextBottomPicLayout.h"
#import "LeftTextRightPicModel.h"
#import "LeftTextRightPicLayout.h"

#define PageSize 20 //每页多少条数据

@implementation MainViewModel

+(MainModel*)getModel{
    MainModel *model = [[MainModel alloc] init];
    model.titleArray = @[@"推荐",@"视频",@"热点",@"社会",@"厦门",@"头条号",@"科技之家"];
    return model;
}

+(MainLayout*)getLayout{
    MainLayout *layout = [[MainLayout alloc] init];
    NSArray *titleArray = [self getModel].titleArray;
    CGFloat sumWitdh = 0;
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:titleArray.count];
    for(NSString *title in titleArray){
        CGFloat temp = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
        sumWitdh += temp;
        [tempArray addObject:@(temp)];
    }
    layout.allTitleWidth = sumWitdh;
    layout.titleWidth = tempArray;
    return layout;
}

+(ModuleModel*)getModuleByTitle:(NSString*)title{
//    NSLog(@"加载“%@”数据", title);
    NSArray *titleArray = [self getModel].titleArray;
    ModuleModel *moduleModel = [[ModuleModel alloc] init];
    moduleModel.dataSource = [[NSMutableArray alloc] initWithCapacity:PageSize];
    moduleModel.layoutSoure = [[NSMutableArray alloc] initWithCapacity:PageSize];
    moduleModel.titleIndex = [titleArray indexOfObject:titleArray];
    moduleModel.title = title;
    for(int i = 0; i < PageSize; i ++){
        randomModel(moduleModel);
    }
    moduleModel.pageIndex = 0;
    return moduleModel;
}

void randomModel(ModuleModel *moduleModel){
    NSArray *array = @[@(CellTypeTopTextBottomPic), @(CellTypeLeftTextRightPic)];
    NSInteger index = arc4random() % array.count;
    CellType cellType = [array[index] integerValue];
    switch (cellType) {
        case CellTypeTopTextBottomPic:
        {
            TopTextBottomPicModel *model = [[TopTextBottomPicModel alloc] init];
            model.title = randomTitle();
            model.picUrlArray = [MainViewModel getImage:3];
            AuthorEvaluateTimeModel *author = [[AuthorEvaluateTimeModel alloc] init];
            author.authorName = @"呱呱";
            author.evaluateCount = randomEvaluate();
            author.evaluateStr = [NSString stringWithFormat:@"%ld评论", (long)author.evaluateCount];
            author.time = @"9小时前";
            model.authorEvaluateTimeModel = author;
            [moduleModel.dataSource addObject:model];
            TopTextBottomPicLayout *layout = [[TopTextBottomPicLayout alloc] initWithModel:model];
            [moduleModel.layoutSoure addObject:layout];
        }
            break;
        case CellTypeLeftTextRightPic:
        {
            LeftTextRightPicModel *model = [[LeftTextRightPicModel alloc] init];
            model.title = randomTitle();
            model.imageName = [MainViewModel getImage:1];
            
            AuthorEvaluateTimeModel *author = [[AuthorEvaluateTimeModel alloc] init];
            author.authorName = @"呱呱";
            author.evaluateCount = randomEvaluate();
            author.evaluateStr = [NSString stringWithFormat:@"%ld评论", (long)author.evaluateCount];
            author.time = @"9小时前";
            model.authorModel = author;
            [moduleModel.dataSource addObject:model];
            LeftTextRightPicLayout *layout = [[LeftTextRightPicLayout alloc] initWithModel:model];
            [moduleModel.layoutSoure addObject:layout];
        }
            break;
        default:
            break;
    }
}

NSString* randomTitle(){
    NSArray *titleArray = @[@"坎坎坷坷扩多军多军所多军钢结构钢结构",@"达克赛德卡卡更快的看看工作餐接口报感觉阿萨德看看钢结构",@"达克赛德卡卡更快的看看工作餐接口报感觉阿萨德看看钢结构坎坎坷坷扩多军多军所多军"];
    return titleArray[arc4random() % titleArray.count];
}

NSInteger randomEvaluate(){
    NSArray *evaluateArray = @[@(0),@(10),@(88),@(888)];
    return [evaluateArray[arc4random() % evaluateArray.count] integerValue];
}

static NSArray *imageArray;
static NSUInteger imageIndex;
/**
 获取多少个图片，不重复

 */
+(id)getImage:(NSUInteger)count{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageArray = [[NSBundle mainBundle] pathsForResourcesOfType:@"JPG" inDirectory:@""];
    });
    if(imageArray.count - 1 < imageIndex + 3){
        imageIndex = 0;
    }
    if(count == 1){
        return imageArray[imageIndex++];
    }else{
        return @[imageArray[imageIndex++],imageArray[imageIndex++],imageArray[imageIndex++]];
    }
}

+(void)moreDataByModule:(ModuleModel*)module{
    for(int i = 0; i < PageSize; i ++){
        randomModel(module);
    }
}

#pragma mark - 图片操作

+(void)parsePic:(id)pics{
    if([pics isKindOfClass:[NSArray class]]){
        
    }else if([pics isKindOfClass:[NSString class]]){
        
    }
}

@end
