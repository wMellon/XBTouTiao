//
//  ThreePicLayout.h
//  XBTouTiao
//  用于ThreePicCell的layout
//  Created by xxb on 2017/7/21.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseLayout.h"
@class TopTextBottomPicModel;
@class AuthorEvaluateTimeLayout;

@interface TopTextBottomPicLayout : BaseLayout

@property (nonatomic, assign) CGRect titleFrame;
@property (nonatomic, assign) CGRect image1Frame;
@property (nonatomic, assign) CGRect image2Frame;
@property (nonatomic, assign) CGRect image3Frame;
@property (nonatomic, assign) CGRect footerFrame;
@property (nonatomic, strong) AuthorEvaluateTimeLayout *authorLayout;
@property (nonatomic, assign) CGFloat cellHeight;

-(instancetype)initWithModel:(TopTextBottomPicModel*)model;
-(void)setModel:(TopTextBottomPicModel*)model;

+(CGFloat)getTitleFontSize;
+(UIFont*)getTitleFont;

@end
