//
//  ViewMacro.h
//  XBTouTiao
//
//  Created by xxb on 2017/7/20.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#ifndef ViewMacro_h
#define ViewMacro_h

#define SmallPicWidth (ScreenWidth - 30 - 2 * PicSpacing) / 3 //小图的宽度
#define PicSpacing 10  //图片之间的间隔

//margin
#define TopMargin 10 
#define LeftMargin 15
#define RightMargin 15
#define BottomMargin 10
#define PicTextMarginTop 10 //图文
#define TextSpacing 10//文本间隔

//cellType
typedef NS_ENUM(NSInteger,CellType){
    CellTypeTopTextBottomPic = 0
};

#endif /* ViewMacro_h */
