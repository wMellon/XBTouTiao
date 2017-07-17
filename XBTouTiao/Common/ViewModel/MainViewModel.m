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
    moduleModel.titleIndex = [titleArray indexOfObject:titleArray];
    moduleModel.title = title;
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:PageSize];
    for(int i = 0; i < PageSize; i ++){
        [tempArray addObject:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", moduleModel.title, moduleModel.title, moduleModel.title, moduleModel.title, moduleModel.title, moduleModel.title, moduleModel.title, @(i)]];
    }
    moduleModel.dataSource = tempArray;
    moduleModel.pageIndex = 0;
    return moduleModel;
}

@end
