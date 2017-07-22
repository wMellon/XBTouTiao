//
//  ThreePicCell.h
//  XBTouTiao
//  上面是文本，最多两行，中间是三张/一张图片，底下有个作者、评论、时间等
//  Created by xxb on 2017/7/19.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopTextBottomPicModel;
@class TopTextBottomPicLayout;

@interface TopTextBottomPicCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView3;

-(void)setModel:(TopTextBottomPicModel*)model andLayout:(TopTextBottomPicLayout*)layout;

@end
