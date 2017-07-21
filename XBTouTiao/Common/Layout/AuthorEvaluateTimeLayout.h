//
//  AuthorEvaluateTimeLayout.h
//  XBTouTiao
//
//  Created by xxb on 2017/7/21.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "BaseLayout.h"
@class AuthorEvaluateTimeModel;

@interface AuthorEvaluateTimeLayout : BaseLayout

@property (nonatomic, assign) CGRect authorFrame;
@property (nonatomic, assign) CGRect evaluateFrame;
@property (nonatomic, assign) CGRect timeFrame;

-(instancetype)initWithFrame:(CGRect)frame andModel:(AuthorEvaluateTimeModel*)model;

-(void)setModel:(AuthorEvaluateTimeModel*)model;

@end
