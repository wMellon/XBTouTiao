//
//  NSString+Extend.m
//  XBTouTiao
//
//  Created by xxb on 2017/7/21.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "NSString+Extend.h"

@implementation NSString (Extend)

/**
根据宽度、字体大小、间隔大小返回文本占有的高度

@param width
@param fontSize
@param spacing
@return
*/
- (CGFloat)heightByWidth:(CGFloat)width andFontSize:(CGFloat)fontSize andLineSpacing:(CGFloat)spacing{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    if(spacing != 0){
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:spacing];//调整行间距
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    }
    
    CGFloat height = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle} context:nil].size.height;
    return height;
}

@end
