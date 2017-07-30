//
//  BaseViewModel.h
//  XBTouTiao
//
//  Created by xxb on 2017/7/29.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ModuleModel;

@interface BaseViewModel : NSObject

+(ModuleModel*)getModuleByTitle:(NSString*)title;

/**
 获取数据

 @param index 索引是标题数组里面的索引
 @return 数据
 */
+(ModuleModel*)getModuleByIndex:(NSInteger)index;
+(void)moreDataByModule:(ModuleModel*)module;

@end
