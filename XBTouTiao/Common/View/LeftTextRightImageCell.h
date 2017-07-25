//
//  LeftTextRightImageCell.h
//  XBTouTiao
//  左边文本，右边图片，底下有个作者、评论、时间等
//  Created by xxb on 2017/7/20.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LeftTextRightPicModel;
@class LeftTextRightPicLayout;

@interface LeftTextRightImageCell : UITableViewCell

@property (nonatomic, strong) UIImageView *rightImage;

-(void)setModel:(LeftTextRightPicModel*)model andLayout:(LeftTextRightPicLayout*)layout;
-(void)setImage:(UIImage*)image forName:(NSString*)imageName;

@end
