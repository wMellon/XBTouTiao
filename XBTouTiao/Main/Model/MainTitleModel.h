//
//  MainModel.h
//  XBTouTiao
//
//  Created by xxb on 2017/7/4.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 控制器类型

 - VCTypeRecommend:
 */
//typedef NS_ENUM(NSInteger, VCType) {
//    VCTypeRecommend = 1
//};

@interface MainTitleModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *vcType;//控制器

//@property (nonatomic, copy) NSArray *titleArray;
//@property (nonatomic, copy) NSArray *vcTypeArray;

@end
