//
//  LeftTextRightImageLayout.m
//  XBTouTiao
//
//  Created by xxb on 2017/7/22.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "LeftTextRightPicLayout.h"
#import "AuthorEvaluateTimeLayout.h"
#import "LeftTextRightPicModel.h"

@implementation LeftTextRightPicLayout

-(instancetype)initWithModel:(LeftTextRightPicModel*)model{
    self = [super init];
    if(self){
        [self setModel:model];
    }
    return self;
}

-(void)setModel:(LeftTextRightPicModel*)model{
    if(model.imageName.length > 0){
        self.imageFrame = CGRectMake(ScreenWidth - [BaseLayout getSmallPicWidth] - RightMargin, TopMargin, [BaseLayout getSmallPicWidth], [BaseLayout getSmallPicWidth] * 0.6);
    }else{
        self.imageFrame = CGRectZero;
    }
    if(model.title.length > 0){
        CGFloat width = self.imageFrame.origin.x - LeftMargin - TextSpacing;
        CGFloat height = [model.title heightByWidth:width andFontSize:15 andLineSpacing:0];
        if(height > [UIFont systemFontOfSize:15].lineHeight * 3){
            height = [UIFont systemFontOfSize:15].lineHeight * 3;
        }
        self.titleFrame = CGRectMake(LeftMargin, TopMargin, width, height);
    }else{
        self.titleFrame = CGRectZero;
    }
    if(self.imageFrame.size.height - self.titleFrame.size.height > 12){
        self.footerFrame = CGRectMake(LeftMargin, CGRectGetMaxY(self.imageFrame) - 12, self.imageFrame.origin.x - self.titleFrame.origin.x - 10, 12);
        self.authorLayout = [[AuthorEvaluateTimeLayout alloc] initWithFrame:self.footerFrame andModel:model.authorModel];
        self.cellHeight = CGRectGetMaxY(self.imageFrame) + BottomMargin;
    }else{
        self.footerFrame = CGRectMake(LeftMargin, CGRectGetMaxY(self.imageFrame) + 10, [BaseLayout getContentWidth], 12);
        self.authorLayout = [[AuthorEvaluateTimeLayout alloc] initWithFrame:self.footerFrame andModel:model.authorModel];
        self.cellHeight = CGRectGetMaxY(self.authorLayout.frame) + BottomMargin;
    }
}

@end
