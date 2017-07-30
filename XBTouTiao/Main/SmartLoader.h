//
//  SmartLoader.h
//  XBTouTiao
//  智能加载器，用于控制是否加载下一页面/上一页面
//  Created by xxb on 2017/7/29.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmartLoader : NSObject

@property (nonatomic, strong) NSMutableDictionary *moduleDict;

+(instancetype)shareInstance;

@end
