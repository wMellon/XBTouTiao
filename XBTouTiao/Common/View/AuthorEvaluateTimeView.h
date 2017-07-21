//
//  AuthorEvaluateTimeView.h
//  XBTouTiao
//  底部的作者、评论数、时间
//  Created by xxb on 2017/7/19.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AuthorEvaluateTimeModel;
@class AuthorEvaluateTimeLayout;

@interface AuthorEvaluateTimeView : UIView

-(void)setModel:(AuthorEvaluateTimeModel*)model andLayout:(AuthorEvaluateTimeLayout*)layout;

@end
