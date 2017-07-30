//
//  UIViewController+TitleIndex.m
//  XBTouTiao
//
//  Created by xxb on 2017/7/28.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "UIViewController+TitleIndex.h"
#import <objc/runtime.h>

@implementation UIViewController (TitleIndex)

-(NSInteger)titleIndex{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

-(void)setTitleIndex:(NSInteger)titleIndex{
    objc_setAssociatedObject(self, @selector(titleIndex), @(titleIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)isHit{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

-(void)setIsHit:(BOOL)isHit{
    objc_setAssociatedObject(self, @selector(isHit), @(isHit), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)isReused{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

-(void)setIsReused:(BOOL)isReused{
    objc_setAssociatedObject(self, @selector(isReused), @(isReused), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString*)identifier{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setIdentifier:(NSString*)identifier{
    objc_setAssociatedObject(self, @selector(identifier), identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)dataInitWithTitle:(NSString*)title{}
-(void)reloadData{}

@end
