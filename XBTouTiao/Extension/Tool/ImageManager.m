//
//  ImageParseTool.m
//  XBTouTiao
//
//  Created by xxb on 2017/7/22.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "ImageManager.h"

@interface ImageManager()

@property (nonatomic, strong) NSCache *systemCache;

@end

@implementation ImageManager

-(instancetype)init{
    self = [super init];
    if(self){
        _systemCache = [[NSCache alloc] init];
        _systemCache.totalCostLimit = 500;//500m?
//        _systemCache.delegate = self;
    }
    return self;
}

+(ImageManager*)shareInstance{
    static ImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ImageManager alloc] init];
    });
    return manager;
}

-(UIImage*)parseByImageName:(NSString*)imageName andWidth:(CGFloat)width height:(CGFloat)height{
    if(imageName.length <= 0){
        return nil;
    }
    if([self getParsedImage:imageName]){
        return [self getParsedImage:imageName];
    }
    UIImage *image = [UIImage imageNamed:imageName];
    CGImageRef imageRef = image.CGImage;
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(imageRef);
    BOOL anyAlpha = (alpha == kCGImageAlphaFirst ||
                     alpha == kCGImageAlphaLast ||
                     alpha == kCGImageAlphaPremultipliedFirst ||
                     alpha == kCGImageAlphaPremultipliedLast);
    if (anyAlpha) {
        return nil;
    }
    // current
    CGColorSpaceModel imageColorSpaceModel = CGColorSpaceGetModel(CGImageGetColorSpace(imageRef));
    CGColorSpaceRef colorspaceRef = CGImageGetColorSpace(imageRef);
    BOOL unsupportedColorSpace = (imageColorSpaceModel == kCGColorSpaceModelUnknown ||
                                  imageColorSpaceModel == kCGColorSpaceModelMonochrome ||
                                  imageColorSpaceModel == kCGColorSpaceModelCMYK ||
                                  imageColorSpaceModel == kCGColorSpaceModelIndexed);
    if (unsupportedColorSpace) {
        colorspaceRef = CGColorSpaceCreateDeviceRGB();
    }
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    // kCGImageAlphaNone is not supported in CGBitmapContextCreate.
    // Since the original image here has no alpha info, use kCGImageAlphaNoneSkipLast
    // to create bitmap graphics contexts without alpha info.
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorspaceRef,
                                                 kCGImageAlphaPremultipliedFirst);//切圆角要设置这个，不然可能会导致裁剪的区域变成黑色；不切圆角的时候不要设置这个属性，否则会进行alpha计算，消耗部分性能；
//    //解码的同时切个圆角
//    CGRect rect = CGRectMake(0, 0, width, height);
//    // 根据一个rect创建一个椭圆
//    CGContextAddEllipseInRect(context, rect);
//    CGContextClip(context);
    // Draw the image into the context and retrieve the new bitmap image without alpha
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef imageRefWithoutAlpha = CGBitmapContextCreateImage(context);
    UIImage *imageWithoutAlpha = [UIImage imageWithCGImage:imageRefWithoutAlpha
                                                     scale:image.scale
                                               orientation:image.imageOrientation];
    if (unsupportedColorSpace) {
        CGColorSpaceRelease(colorspaceRef);
    }
    CGContextRelease(context);
    CGImageRelease(imageRefWithoutAlpha);
    //存到缓存中
    sleep(3);
    [self.systemCache setObject:imageWithoutAlpha forKey:imageName];
    return imageWithoutAlpha;
}

-(UIImage*)getParsedImage:(NSString*)imageName{
    return [self.systemCache objectForKey:imageName];
}

@end
