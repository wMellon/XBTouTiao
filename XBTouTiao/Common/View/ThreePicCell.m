//
//  ThreePicCell.m
//  XBTouTiao
//
//  Created by xxb on 2017/7/19.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "ThreePicCell.h"
#import "AuthorEvaluateTimeView.h"

@interface ThreePicCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView3;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) AuthorEvaluateTimeView *footerView;

@end

@implementation ThreePicCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setupContentView];
        [self autoLayout];
    }
    return self;
}

-(void)setupContentView{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    
    _imageView1 = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView1];
    
    _imageView2 = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView2];
    
    _imageView3 = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView3];
    self.imageArray = @[_imageView1, _imageView2, _imageView3];
    
    _footerView = [[AuthorEvaluateTimeView alloc] init];
    [self.contentView addSubview:_footerView];
}

-(void)autoLayout{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.lessThanOrEqualTo(@(_titleLabel.font.lineHeight * 2));
    }];
    [self.imageArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:PicSpacing leadSpacing:15 tailSpacing:15];
    [self.imageArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.height.equalTo(_imageView1.mas_width).multipliedBy(0.6);
    }];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(_imageView1.mas_bottom).offset(10);
        make.right.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
}

-(void)setModel:(id)model{
    _titleLabel.text = @"坎坎坷坷扩多军做错错，打开2送蛋糕卡驱蚊扣gas流程控制啊得git与欧普路口一下班覆盖问题大焚枯食淡司法考试";
    _imageView1.image = [UIImage imageNamed:@"Default"];
    _imageView2.image = [UIImage imageNamed:@"Default"];
    _imageView3.image = [UIImage imageNamed:@"Default"];
    [_footerView setModel:nil];
}

@end
