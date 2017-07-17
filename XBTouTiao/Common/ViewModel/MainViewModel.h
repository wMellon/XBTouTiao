//
//  MainViewModel.h
//  XBTouTiao
//
//  Created by xxb on 2017/7/4.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MainModel;
@class MainLayout;
@class ModuleModel;

@interface MainViewModel : NSObject

+(MainModel*)getModel;

+(MainLayout*)getLayout;
//根据title获取
+(ModuleModel*)getModuleByTitle:(NSString*)title;

@end
