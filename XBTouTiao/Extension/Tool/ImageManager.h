//
//  ImageParseTool.h
//  XBTouTiao
//
//  Created by xxb on 2017/7/22.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageManager : NSObject

+(ImageManager*)shareInstance;

-(UIImage*)parseByImageName:(NSString*)imageName andWidth:(CGFloat)width height:(CGFloat)height;
-(UIImage*)getParsedImage:(NSString*)imageName;

@end
