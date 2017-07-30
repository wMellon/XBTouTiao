//
//  XBTouTiaoLabel.m
//  XBTouTiao
//
//  Created by xxb on 2017/7/30.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "XBTouTiaoLabel.h"
#import "CoreText/CoreText.h"

@implementation XBTouTiaoLabel

-(void)setCTText:(NSString*)content{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, ![self.backgroundColor isEqual:[UIColor clearColor]], 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context==NULL) {
        return;
    }
    if (![self.backgroundColor isEqual:[UIColor clearColor]]) {
        [self.backgroundColor set];
        CGContextFillRect(context, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    }
    CGContextSetTextMatrix(context,CGAffineTransformIdentity);
    CGContextTranslateCTM(context,0,self.bounds.size.height);
    CGContextScaleCTM(context,1.0,-1.0);
    
    //Determine default text color
    UIColor* textColor = self.textColor;
    
    //Set line height, font, color and break mode
    CGFloat minimumLineHeight = self.font.pointSize,maximumLineHeight = minimumLineHeight, linespace = LineSpace;
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)self.font.fontName, self.font.pointSize,NULL);
    CTLineBreakMode lineBreakMode = kCTLineBreakByWordWrapping;
    CTTextAlignment alignment = CTTextAlignmentFromUITextAlignment(self.textAlignment);
    //Apply paragraph settings
    CTParagraphStyleRef style = CTParagraphStyleCreate((CTParagraphStyleSetting[6]){
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
        {kCTParagraphStyleSpecifierMinimumLineHeight,sizeof(minimumLineHeight),&minimumLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineHeight,sizeof(maximumLineHeight),&maximumLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(linespace), &linespace},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(linespace), &linespace},
        {kCTParagraphStyleSpecifierLineBreakMode,sizeof(CTLineBreakMode),&lineBreakMode}
    },6);
    
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)font,(NSString*)kCTFontAttributeName,
                                textColor.CGColor,kCTForegroundColorAttributeName,
                                style,kCTParagraphStyleAttributeName,
                                nil];
    
    //Create attributed string, with applied syntax highlighting
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    CFAttributedStringRef attributedString = (__bridge CFAttributedStringRef)attributedStr;
    
    //Draw the frame
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    // 创建路径
    CGMutablePathRef path = CGPathCreateMutable();
    // 添加路径
    CGPathAddRect(path, NULL, self.bounds);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, content.length), path, NULL);
    
    //.....
    CFArrayRef lines = CTFrameGetLines(frame);
    // 1.2获取lineRef的个数
    CFIndex lineCount = CFArrayGetCount(lines);
    // 1.3计算需要展示的行树
    NSUInteger numberOfLines = self.numberOfLines != 0 ? MIN(lineCount, self.numberOfLines) : lineCount;
    
    //  2.获取每一行的起始位置数组
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    // 3.遍历需要显示文字的行数，并绘制每一行的现实内容
    for (CFIndex idx = 0; idx < numberOfLines; idx ++) {
        // 3.0获取图形上下文和每一行对应的lineRef
        CGContextRef context = UIGraphicsGetCurrentContext();
        CTLineRef lineRef = CFArrayGetValueAtIndex(lines, idx);
        
        // 3.1设置文本的起始绘制位置
        CGContextSetTextPosition(context, lineOrigins[idx].x, lineOrigins[idx].y);
        
        // 3.2设置是否需要完整绘制一行文字的标记
        BOOL shouldDrawLine = YES;
        
        // 3.3处理最后一行
//        if (idx == numberOfLines - 1 && self.numberOfLines != 0) {
//            // 3.3.1.处理最后一行的文字绘制
//            [self drawLastLineWithLineRef:lineRef];
//            
//            // 3.3.2标记不用完整的去绘制一行文字
//            shouldDrawLine = NO;
//        }
        
        // 3.4绘制完整的一行文字
        if (shouldDrawLine) {
            CTLineDraw(lineRef, context);
        }
    }
    
    
//    [self drawFramesetter:framesetter attributedString:attributedStr textRange:CFRangeMake(0, text.length) inRect:rect context:context];
    CGContextSetTextMatrix(context,CGAffineTransformIdentity);
    CGContextTranslateCTM(context,0,self.bounds.size.height);
    CGContextScaleCTM(context,1.0,-1.0);
    UIImage *screenShotimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    dispatch_async(dispatch_get_main_queue(), ^{
        CFRelease(font);
        CFRelease(framesetter);
        self.layer.contents = (__bridge id)(screenShotimage.CGImage);
    });
}

CTTextAlignment CTTextAlignmentFromUITextAlignment(NSTextAlignment alignment) {
    switch (alignment) {
        case NSTextAlignmentLeft: return kCTLeftTextAlignment;
        case NSTextAlignmentCenter: return kCTCenterTextAlignment;
        case NSTextAlignmentRight: return kCTRightTextAlignment;
        default: return kCTNaturalTextAlignment;
    }
}

@end
