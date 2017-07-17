//
//  MacroDefinition.h
//  XBFramework
//
//  Created by zoenet on 2017/2/21.
//  Copyright © 2017年 xxb. All rights reserved.
//

#ifndef MacroDefinition_h
#define MacroDefinition_h

#pragma mark - 简单访问

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height//获取屏幕高度，兼容性测试
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width//获取屏幕宽度，兼容性测试

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define FontSize(size) [UIFont systemFontOfSize:size];


/**
 项目中有用到设置高度、宽度为1的都用这个设置
 */
#define  SINGLE_LINE_HEIGHT   (1 / [UIScreen mainScreen].scale)

/**
 *  将enum转换成string。
 *  注：只是普通的转换
 *
 *  @param enum
 *
 *  @return
 */
#define enumToString(enum) [NSString stringWithFormat:@"%d", enum]
#define NSIntegerToString(integer) [NSString stringWithFormat:@"%ld",integer]

//弱引用
#define XBWeakSelfDefine __weak typeof(self) weakSelf = self;
#define XBWeakSelf weakSelf

#pragma mark - 通知定义

#define NSNotificationLoginStateChg @"LoginStateChg"  //登录状态改变通知



#endif /* MacroDefinition_h */
