
//
//  ThreePicModel.h
//  XBTouTiao
//
//  Created by xxb on 2017/7/21.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AuthorEvaluateTimeModel;

@interface TopTextBottomPicModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray *picUrlArray;
@property (nonatomic, strong) AuthorEvaluateTimeModel *authorEvaluateTimeModel;
@property (nonatomic, assign) CellType cellType;

@end
