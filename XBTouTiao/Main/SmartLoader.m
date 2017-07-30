//
//  SmartLoader.m
//  XBTouTiao
//
//  Created by xxb on 2017/7/29.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "SmartLoader.h"

@implementation SmartLoader

+(instancetype)shareInstance{
    static SmartLoader *loader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loader = [[SmartLoader alloc] init];
        loader.moduleDict = [[NSMutableDictionary alloc] init];
    });
    return loader;
}

@end
