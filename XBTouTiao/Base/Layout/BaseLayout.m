//
//  BaseLayout.m
//  XBTouTiao
//
//  Created by xxb on 2017/7/21.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "BaseLayout.h"

@implementation BaseLayout

+(CGFloat)getContentWidth{
    static CGFloat contentWidth = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        contentWidth = ScreenWidth - LeftMargin - RightMargin;
    });
    return contentWidth;
}

+(CGFloat)getSmallPicWidth{
    static CGFloat smallPicWidth = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        smallPicWidth = ([self getContentWidth] - PicSpacing * 2) / 3;
    });
    return smallPicWidth;
}
@end
