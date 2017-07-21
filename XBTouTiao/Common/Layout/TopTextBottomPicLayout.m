//
//  ThreePicLayout.m
//  XBTouTiao
//  
//  Created by xxb on 2017/7/21.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "TopTextBottomPicLayout.h"
#import "TopTextBottomPicModel.h"
#import "AuthorEvaluateTimeLayout.h"

@implementation TopTextBottomPicLayout

-(instancetype)initWithModel:(TopTextBottomPicModel*)model{
    self = [super init];
    if(self){
        [self setModel:model];
    }
    return self;
}

-(void)setModel:(TopTextBottomPicModel*)model{
    //title
    if(model.title.length > 0){
        CGFloat titleHeight = [model.title heightByWidth:[BaseLayout getContentWidth] andFontSize:[TopTextBottomPicLayout getTitleFontSize] andLineSpacing:0];
        if(titleHeight >= [TopTextBottomPicLayout getTitleFont].lineHeight * 2){
            titleHeight = [TopTextBottomPicLayout getTitleFont].lineHeight * 2;
        }
        self.titleFrame = CGRectMake(LeftMargin, TopMargin, [BaseLayout getContentWidth], titleHeight);
    }else{
        self.titleFrame = CGRectMake(LeftMargin, TopMargin, 0, 0);
    }
    //图片
    CGFloat y = CGRectGetMaxY(self.titleFrame) + PicTextMarginTop;
    if(model.picUrlArray.count == 0){
        self.image1Frame = CGRectMake(LeftMargin, y, 0, 0);
        self.image2Frame = CGRectZero;
        self.image3Frame = CGRectZero;
    }else if(model.picUrlArray.count == 1){
        self.image1Frame = CGRectMake(LeftMargin, y, [BaseLayout getContentWidth], [BaseLayout getContentWidth] * 0.6);
        self.image2Frame = CGRectZero;
        self.image3Frame = CGRectZero;
    }else{
        self.image1Frame = CGRectMake(LeftMargin, y, [BaseLayout getSmallPicWidth], [BaseLayout getSmallPicWidth] * 0.6);
        self.image2Frame = CGRectMake(CGRectGetMaxX(self.image1Frame) + PicSpacing, y, [BaseLayout getSmallPicWidth],  [BaseLayout getSmallPicWidth] * 0.6);
        self.image3Frame = CGRectMake(CGRectGetMaxX(self.image2Frame) + PicSpacing, y, [BaseLayout getSmallPicWidth],  [BaseLayout getSmallPicWidth] * 0.6);
    }
    //footer
    self.authorLayout = [[AuthorEvaluateTimeLayout alloc] init];
    [self.authorLayout setModel:model.authorEvaluateTimeModel];
    self.footerFrame = CGRectMake(LeftMargin, CGRectGetMaxY(self.image1Frame) + 10, [BaseLayout getContentWidth], 12);
    self.cellHeight = CGRectGetMaxY(self.footerFrame) + BottomMargin;
}

+(CGFloat)getTitleFontSize{
    return 15;
}
+(UIFont*)getTitleFont{
    return [UIFont systemFontOfSize:[TopTextBottomPicLayout getTitleFontSize]];
}
@end
