//
//  PageModel.m
//  XBTouTiao
//
//  Created by xxb on 2017/7/5.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "ModuleModel.h"

@implementation ModuleModel

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [[self title] isEqualToString: [other title]];
}

-(NSUInteger)hash{
    return [[self title] hash];
}

@end
