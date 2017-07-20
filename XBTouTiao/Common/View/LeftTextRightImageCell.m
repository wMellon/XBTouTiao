//
//  LeftTextRightImageCell.m
//  XBTouTiao
//  
//  Created by xxb on 2017/7/20.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "LeftTextRightImageCell.h"
#import "AuthorEvaluateTimeView.h"

@interface LeftTextRightImageCell()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UIImageView *rightImage;
@property (nonatomic, strong) AuthorEvaluateTimeView *footerView;

@end

@implementation LeftTextRightImageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setupContentView];
        [self autoLayout];
    }
    return self;
}

-(void)setupContentView{
    _leftLabel = [[UILabel alloc] init];
    _leftLabel.font = [UIFont systemFontOfSize:15];
    _leftLabel.textColor = [UIColor blackColor];
    _leftLabel.numberOfLines = 0;
    [self.contentView addSubview:_leftLabel];
    
    _rightImage = [[UIImageView alloc] init];
    [self.contentView addSubview:_rightImage];
    
    _footerView = [[AuthorEvaluateTimeView alloc] init];
    [self.contentView addSubview:_footerView];
}

-(void)autoLayout{
    //文本只有一行时，文本居中，footer
    //
    [_rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-RightMargin);
        make.top.equalTo(self.contentView).offset(TopMargin);
        make.width.mas_equalTo(SmallPicWidth);
        make.height.equalTo(_rightImage.mas_width).multipliedBy(0.6);
    }];
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(LeftMargin);
        make.top.equalTo(self.contentView).offset(TopMargin);
        make.right.equalTo(_rightImage.mas_left).offset(-20);
        //高度最少两行，最大三行
        make.height.mas_lessThanOrEqualTo(_leftLabel.font.lineHeight * 3);
        make.height.mas_greaterThanOrEqualTo(_leftLabel.font.lineHeight * 2);
    }];
    [self.contentView layoutIfNeeded];
    //footer的布局
    NSInteger numberOfLines = _leftLabel.frameHeight / _leftLabel.font.lineHeight;
    if(numberOfLines == 3){
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(LeftMargin);
            make.top.equalTo(_rightImage.mas_bottom).offset(TopMargin);
            make.right.equalTo(self.contentView).offset(-RightMargin);
            make.bottom.equalTo(self.contentView).offset(-BottomMargin);
        }];
    }else{
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(LeftMargin);
            make.top.equalTo(_leftLabel.mas_bottom).offset(TopMargin);
            make.right.equalTo(_rightImage.mas_left).offset(-RightMargin);
            make.bottom.equalTo(_rightImage);
            make.bottom.equalTo(self.contentView).offset(-BottomMargin);
        }];
    }
}

-(void)setModel:(id)moodel{
    _leftLabel.text = @"水电费卡萨丁发哭死了公司的噶";
    _rightImage.image = [UIImage imageNamed:@"Default"];
    [_footerView setModel:nil];
}

@end
