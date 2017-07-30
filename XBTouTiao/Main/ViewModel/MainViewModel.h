//
//  MainViewModel.h
//  XBTouTiao
//
//  Created by xxb on 2017/7/4.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MainTitleModel;
@class MainLayout;
@class ModuleModel;

#define VCTypeDefault @"VCTypeDefault"  //默认的vc

@interface MainViewModel : NSObject

+(NSArray*)getMainTitleModle;

+(MainLayout*)getLayout;

@end
