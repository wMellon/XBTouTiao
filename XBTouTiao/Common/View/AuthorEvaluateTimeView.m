//
//  AuthorEvaluateTimeView.m
//  XBTouTiao
//
//  Created by xxb on 2017/7/19.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "AuthorEvaluateTimeView.h"
#import "AuthorEvaluateTimeModel.h"
#import "AuthorEvaluateTimeLayout.h"

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
    }
    return self;
}

-(void)setupContentView{
    [self addSubview:[self authorLabel]];
    [self addSubview:[self evaluateLabel]];
    [self addSubview:[self timeLabel]];
    [self addSubview:[self loseInterestBtn]];
}

-(UILabel *)authorLabel{
    if(!_authorLabel){
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = [UIFont systemFontOfSize:12];
        _authorLabel.textColor = RGB(153, 153, 153);
    }
    return _authorLabel;
}

-(UILabel *)evaluateLabel{
    if(!_evaluateLabel){
        _evaluateLabel = [[UILabel alloc] init];
        _evaluateLabel.font = [UIFont systemFontOfSize:12];
        _evaluateLabel.textColor = RGB(153, 153, 153);
    }
    return _evaluateLabel;
}

-(UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = RGB(153, 153, 153);
    }
    return _timeLabel;
}

-(UIButton *)loseInterestBtn{
    if(!_loseInterestBtn){
        _loseInterestBtn = [[UIButton alloc] init];
    }
    return _loseInterestBtn;
}

-(void)setModel:(AuthorEvaluateTimeModel*)model andLayout:(AuthorEvaluateTimeLayout*)layout{
    _authorLabel.text = model.authorName;
    _authorLabel.frame = layout.authorFrame;
    
    _evaluateLabel.text = model.evaluateStr;
    _evaluateLabel.frame = layout.evaluateFrame;
    
    _timeLabel.text = model.time;
    _timeLabel.frame = layout.timeFrame;
}


@end
