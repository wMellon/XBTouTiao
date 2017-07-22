//
//  LeftTextRightImageModel.h
//  XBTouTiao
//
//  Created by xxb on 2017/7/22.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AuthorEvaluateTimeModel;

@interface LeftTextRightPicModel : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *imageName;
@property(nonatomic, strong) AuthorEvaluateTimeModel *authorModel;

@end
