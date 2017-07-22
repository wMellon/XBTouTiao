//
//  ThreePicCell.m
//  XBTouTiao
//
//  Created by xxb on 2017/7/19.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "TopTextBottomPicCell.h"
#import "AuthorEvaluateTimeView.h"
#import "TopTextBottomPicModel.h"
#import "TopTextBottomPicLayout.h"

@interface TopTextBottomPicCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) AuthorEvaluateTimeView *footerView;

@end

@implementation TopTextBottomPicCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setupContentView];
    }
    return self;
}

-(void)setupContentView{
    [self.contentView addSubview:[self titleLabel]];
    [self.contentView addSubview:[self imageView1]];
    [self.contentView addSubview:[self imageView2]];
    [self.contentView addSubview:[self imageView3]];
    [self.contentView addSubview:[self footerView]];
}

-(UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

-(UIImageView *)imageView1{
    if(!_imageView1){
        _imageView1 = [[UIImageView alloc] init];
    }
    return _imageView1;
}

-(UIImageView *)imageView2{
    if(!_imageView2){
        _imageView2 = [[UIImageView alloc] init];
    }
    return _imageView2;
}

-(UIImageView *)imageView3{
    if(!_imageView3){
        _imageView3 = [[UIImageView alloc] init];
    }
    return _imageView3;
}

-(AuthorEvaluateTimeView *)footerView{
    if(!_footerView){
        _footerView = [[AuthorEvaluateTimeView alloc] init];
    }
    return _footerView;
}

-(void)setModel:(TopTextBottomPicModel*)model andLayout:(TopTextBottomPicLayout*)layout{
    _titleLabel.text = model.title;
    _titleLabel.frame = layout.titleFrame;
    
//    _imageView1.image = [UIImage imageNamed:model.picUrlArray[0]];
    _imageView1.frame = layout.image1Frame;
    
//    _imageView2.image = [UIImage imageNamed:model.picUrlArray[1]];
    _imageView2.frame = layout.image2Frame;
    
//    _imageView3.image = [UIImage imageNamed:model.picUrlArray[2]];
    _imageView3.frame = layout.image3Frame;
    
    [_footerView setModel:model.authorEvaluateTimeModel andLayout:layout.authorLayout];
    _footerView.frame = layout.footerFrame;
}

@end
