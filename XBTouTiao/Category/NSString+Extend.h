//
//  NSString+Extend.h
//  XBTouTiao
//
//  Created by xxb on 2017/7/21.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extend)

/**
 根据宽度、字体大小、间隔大小返回文本占有的高度

 @param width
 @param fontSize
 @param spacing
 @return
 */
- (CGFloat)heightByWidth:(CGFloat)width andFontSize:(CGFloat)fontSize andLineSpacing:(CGFloat)spacing;

@end
