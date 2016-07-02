//
//  CYPlayerBottomView.h
//  Junengwan
//
//  Created by 董招兵 on 16/7/1.
//  Copyright © 2016年 上海触影文化传播有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  播放器底部的工具条
 */
@interface CYPlayerBottomView : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *previousLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playButtonLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextButtonLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelRight;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *previousButtonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *previousButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelWidth;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UISlider *playerSlider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) UIProgressView *progressView;

@end
