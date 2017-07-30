//
//  MainViewModel.m
//  XBTouTiao
//
//  Created by xxb on 2017/7/4.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "MainViewModel.h"
#import "MainTitleModel.h"
#import "MainLayout.h"
#import "ModuleModel.h"
#import "TopTextBottomPicModel.h"
#import "AuthorEvaluateTimeModel.h"
#import "TopTextBottomPicLayout.h"
#import "LeftTextRightPicModel.h"
#import "LeftTextRightPicLayout.h"

#define PageSize 20 //每页多少条数据

@implementation MainViewModel

+(NSArray*)getMainTitleModle{
    NSArray *titleArray = @[@"推荐",@"视频",@"热点",@"社会",@"厦门",@"头条号",@"科技之家"];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(NSInteger i = 0; i < titleArray.count; i++){
        MainTitleModel *model = [[MainTitleModel alloc] init];
        model.title = titleArray[i];
        model.vcType = VCTypeDefault;
        [result addObject:model];
    }
    return [result copy];
}

+(MainLayout*)getLayout{
    MainLayout *layout = [[MainLayout alloc] init];
    layout.topViewFrame = CGRectMake(0, 0, ScreenWidth, 40);
    layout.titleScrollFrame = CGRectMake(0, 40, ScreenWidth, TitleBtnHeight);
    
    NSArray *titleArray = [self getMainTitleModle];
    CGFloat sumWitdh = 0;
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:titleArray.count];
    for(MainTitleModel *titleModel in titleArray){
        CGFloat temp = [titleModel.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
        sumWitdh += temp;
        [tempArray addObject:@(temp)];
    }
    layout.allTitleWidth = sumWitdh;
    layout.titleWidth = tempArray;
    return layout;
}

@end
