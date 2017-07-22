//
//  LeftTextRightImageLayout.h
//  XBTouTiao
//
//  Created by xxb on 2017/7/22.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "BaseLayout.h"
@class AuthorEvaluateTimeLayout;
@class LeftTextRightPicModel;

@interface LeftTextRightPicLayout : BaseLayout

@property(nonatomic, assign) CGRect titleFrame;
@property(nonatomic, assign) CGRect imageFrame;
@property(nonatomic, assign) CGRect footerFrame;
@property(nonatomic, strong) AuthorEvaluateTimeLayout *authorLayout;
@property(nonatomic, assign) CGFloat cellHeight;

-(instancetype)initWithModel:(LeftTextRightPicModel*)model;

@end
