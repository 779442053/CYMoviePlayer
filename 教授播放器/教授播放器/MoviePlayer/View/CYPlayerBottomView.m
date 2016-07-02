//
//  CYPlayerBottomView.m
//  Junengwan
//
//  Created by 董招兵 on 16/7/1.
//  Copyright © 2016年 上海触影文化传播有限公司. All rights reserved.
//

#import "CYPlayerBottomView.h"

@implementation CYPlayerBottomView

- (void)awakeFromNib {
    
    self.previousLeft.constant          = CYLayoutConstraintEqualTo(90.0f);
    self.playButtonLeft.constant        = CYLayoutConstraintEqualTo(30.0f);
    self.nextButtonLeft.constant        = CYLayoutConstraintEqualTo(30.0f);
    self.sliderLeft.constant            = CYLayoutConstraintEqualTo(60.0f);
    self.sliderRight.constant           = CYLayoutConstraintEqualTo(60.0f);

    self.previousButtonWidth.constant   = CYLayoutConstraintEqualTo(132.0f);
    self.previousButtonHeight.constant  = self.previousButtonWidth.constant;

    self.timeLabelWidth.constant        = CYLayoutConstraintEqualTo(280.0f);
    self.timeLabelRight.constant        = CYLayoutConstraintEqualTo(60.0f);
    
    [self.playerSlider setThumbImage:[UIImage imageNamed:@"movie_slider"] forState:UIControlStateNormal];
    _playerSlider.backgroundColor       = [UIColor clearColor];
    _playerSlider.minimumTrackTintColor = [UIColor redColor];
    _playerSlider.maximumTrackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3f];
    _playerSlider.minimumValue          = 0.0f;
    
    self.timeLabel.font = CYLayoutConstranitFont(45.0f);
    
    [self insertSubview:self.progressView belowSubview:self.playerSlider];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.playerSlider);
        make.centerY.equalTo(self.playerSlider).offset(CYLayoutConstraintEqualTo(1.5f));
        
    }];
    
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progress = 0.0f;
    }
    return _progressView;
}
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
// 
//    LxDBAnyVar(self.previousButton);
//    
//    
//    
//}

- (void)dealloc {
    
    
    NSLog(@"---- %s-----",__func__);
    
}

@end
