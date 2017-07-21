//
//  AuthorEvaluateTimeLayout.m
//  XBTouTiao
//
//  Created by xxb on 2017/7/21.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "AuthorEvaluateTimeLayout.h"
#import "AuthorEvaluateTimeModel.h"

@implementation AuthorEvaluateTimeLayout

-(instancetype)initWithFrame:(CGRect)frame andModel:(AuthorEvaluateTimeModel*)model{
    self = [super init];
    if(self){
        [self setModel:model];
    }
    return self;
}

-(void)setModel:(AuthorEvaluateTimeModel*)model{
    if(model.authorName.length > 0){
        CGSize size = [model.authorName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        self.authorFrame = CGRectMake(0, 0, size.width, size.height);
    }else{
        self.authorFrame = CGRectZero;
    }
    if(model.evaluateStr.length > 0){
        CGSize size = [model.evaluateStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        self.evaluateFrame = CGRectMake(CGRectGetMaxX(self.authorFrame) + TextSpacing, 0, size.width, size.height);
    }else{
        self.evaluateFrame = CGRectZero;
    }
    if(model.time.length > 0){
        CGSize size = [model.time sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        self.timeFrame = CGRectMake(CGRectGetMaxX(self.evaluateFrame) + TextSpacing, 0, size.width, size.height);
    }else{
        self.timeFrame = CGRectZero;
    }
}


@end
