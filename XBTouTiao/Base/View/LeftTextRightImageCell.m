//
//  LeftTextRightImageCell.m
//  XBTouTiao
//  
//  Created by xxb on 2017/7/20.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "LeftTextRightImageCell.h"
#import "AuthorEvaluateTimeView.h"
#import "LeftTextRightPicModel.h"
#import "LeftTextRightPicLayout.h"

@interface LeftTextRightImageCell()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) AuthorEvaluateTimeView *footerView;
@property (nonatomic, copy) NSString *imageName;

@end

@implementation LeftTextRightImageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setupContentView];
    }
    return self;
}

-(void)setupContentView{
    [self.contentView addSubview:[self rightImage]];
    [self.contentView addSubview:[self leftLabel]];
    [self.contentView addSubview:[self footerView]];
}

-(UIImageView *)rightImage{
    if(!_rightImage){
        _rightImage = [[UIImageView alloc] init];
    }
    return _rightImage;
}

-(UILabel *)leftLabel{
    if(!_leftLabel){
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont systemFontOfSize:15];
        _leftLabel.textColor = [UIColor blackColor];
        _leftLabel.numberOfLines = 0;
    }
    return _leftLabel;
}

-(AuthorEvaluateTimeView *)footerView{
    if(!_footerView){
        _footerView = [[AuthorEvaluateTimeView alloc] init];
    }
    return _footerView;
}

-(void)setModel:(LeftTextRightPicModel*)model andLayout:(LeftTextRightPicLayout*)layout{
    _imageName = model.imageName;
    _leftLabel.text = model.title;
    _leftLabel.frame = layout.titleFrame;
    
    _rightImage.frame = layout.imageFrame;
    
    [_footerView setModel:model.authorModel andLayout:layout.authorLayout];
    _footerView.frame = layout.footerFrame;
}

#pragma mark - 重写

-(void)prepareForReuse{
    self.imageName = nil;
    self.rightImage.image = nil;
}

-(void)setImage:(UIImage*)image forName:(NSString*)imageName{
    if(self.imageName.length > 0 && [self.imageName isEqualToString:imageName]){
        self.rightImage.image = image;
    }
}

@end
