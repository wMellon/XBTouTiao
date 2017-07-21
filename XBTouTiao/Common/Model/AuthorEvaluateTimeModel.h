//
//  AuthorEvaluateTimeModel.h
//  XBTouTiao
//
//  Created by xxb on 2017/7/21.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthorEvaluateTimeModel : NSObject

@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, assign) NSInteger evaluateCount;
@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *evaluateStr;

@end
