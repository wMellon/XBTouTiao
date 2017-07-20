//
//  AuthorEvaluateTimeView.m
//  XBTouTiao
//  底部的作者、评论数、时间
//  Created by xxb on 2017/7/19.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "AuthorEvaluateTimeView.h"

@interface AuthorEvaluateTimeView()

@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *evaluateLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *loseInterestBtn;

@end

@implementation AuthorEvaluateTimeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupContentView];
        [self autoLayout];
    }
    return self;
}

-(void)setupContentView{
    _authorLabel = [[UILabel alloc] init];
    setupLabel(_authorLabel);
    [self addSubview:_authorLabel];
    
    _evaluateLabel = [[UILabel alloc] init];
    setupLabel(_evaluateLabel);
    [self addSubview:_evaluateLabel];
    
    _timeLabel = [[UILabel alloc] init];
    setupLabel(_timeLabel);
    [self addSubview:_timeLabel];
    
    _loseInterestBtn = [[UIButton alloc] init];
    [_loseInterestBtn setImage:nil forState:UIControlStateNormal];
    [self addSubview:_loseInterestBtn];
}

-(void)autoLayout{
    [_authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.width.lessThanOrEqualTo(@(100));
        make.height.equalTo(@(_authorLabel.font.pointSize));
        make.bottom.equalTo(self);
    }];
    [_evaluateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_authorLabel.mas_right).offset(10);
        make.top.equalTo(self);
        make.width.lessThanOrEqualTo(@(50));
        make.height.equalTo(@(_evaluateLabel.font.pointSize));
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_evaluateLabel.mas_right).offset(10);
        make.top.equalTo(self);
        make.width.lessThanOrEqualTo(@(100));
        make.height.equalTo(@(_timeLabel.font.pointSize));
    }];
    
}

-(void)setModel:(id)model{
    _authorLabel.text = @"西瓜太爷";
    _evaluateLabel.text = @"99评论";
    _timeLabel.text = @"刚刚";
}

void setupLabel(UILabel *label){
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = RGB(153, 153, 153);
}

@end
