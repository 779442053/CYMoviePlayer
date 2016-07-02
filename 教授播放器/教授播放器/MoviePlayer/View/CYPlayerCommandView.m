//
//  CYPlayerCommandView.m
//  Junengwan
//
//  Created by 董招兵 on 16/7/1.
//  Copyright © 2016年 上海触影文化传播有限公司. All rights reserved.
//

#import "CYPlayerCommandView.h"
#import "CYAdjustButton.h"
#import "CYPlayerBottomView.h"

@interface CYPlayerCommandView ()
{
    NSTimer *_timer;
    NSInteger _hiddenCommanndViewCount;
}
@end

@implementation CYPlayerCommandView

- (_Nullable instancetype)initWithFrame:(CGRect)frame delegate:(_Nullable id<CYPlayerCommandViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        _delegate   = delegate;
        [self addSubview:self.topView];

        [self createTopView]; // 创建顶部视图

        [self createBottomView]; // 创建底部视图

        _showPlayerCommandView   = YES;
        _draggingSlider          = NO;
        _hiddenCommanndViewCount = 0;
        self.showBarrageView       = NO;
        [self addTimer];
        
    }
    return self;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self removeTimer];
    [self showPlayerCommandView];
    
}
- (void)addTimer {
    
    [self removeTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(hiddenPlayerCommandView) userInfo:nil repeats:YES];
    
}
- (void)removeTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
        _hiddenCommanndViewCount = 0;
    }
}
/**
 *  显示控制面板
 */
- (void)showPlayerCommandView {
    
    _showPlayerCommandView = YES;

    CGFloat topViewY = 0.0f;
    CGFloat bottomViewY = self.height - self.bottomView.height;
    __weakSelf(self);
    [UIView animateWithDuration:0.30f animations:^{
        __strongSelf(weakSelf);
        strongSelf.topView.alpha    = 1.0f;
        strongSelf.bottomView.alpha = 1.0f;
        [strongSelf.topView setY:topViewY];
        [strongSelf.bottomView setY:bottomViewY];
    }completion:^(BOOL finished) {
        __strongSelf(weakSelf);
        if ([strongSelf.delegate respondsToSelector:@selector(cyPlayerCommandViewDidAppear:)]) {
            [strongSelf.delegate cyPlayerCommandViewDidAppear:strongSelf];
        }
        [self addTimer];
    }];
    
}
/**
 *  隐藏控制面板
 */
- (void)hiddenPlayerCommandView {
    
    _hiddenCommanndViewCount ++;
    if (self.isDraggingSlider) return ;
    if (_timer &&_hiddenCommanndViewCount<5 && !self.showBarrageView) return;
    _showPlayerCommandView = NO;
    [self removeTimer];

    CGFloat topViewY = self.top - self.topView.height;
    CGFloat bottomViewY = self.height + self.bottomView.height;
    __weakSelf(self);
    [UIView animateWithDuration:0.30f animations:^{
        __strongSelf(weakSelf);
        [strongSelf.topView setY:topViewY];
        [strongSelf.bottomView setY:bottomViewY];
        strongSelf.topView.alpha    = 0.0f;
        strongSelf.bottomView.alpha = 0.0f;
    }completion:^(BOOL finished) {
        __strongSelf(weakSelf);
        if ([strongSelf.delegate respondsToSelector:@selector(cyPlayerCommandViewDidDisAppear:)]) {
            [strongSelf.delegate cyPlayerCommandViewDidDisAppear:strongSelf];
        }
    }];
    
}

#pragma mark  - 创建顶部视图的 UI
/**
 *  创建顶部视图
 */
- (void)createTopView {
    
    // 顶部状态区的 view
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(CYLayoutConstraintEqualTo(192.0f));
    }];
    // 返回按钮
    [self.topView addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_top).offset(CYLayoutConstraintEqualTo(70.0f));
        make.left.equalTo(self.topView.mas_left).offset(CYLayoutConstraintEqualTo(30.0f));
        make.size.mas_equalTo(CGSizeMake(CYLayoutConstraintEqualTo(180.0f), CYLayoutConstraintEqualTo(90.0f)));
    }];

    // 点击返回按钮的事件
    __weakSelf(self);
    [[self.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        __strongSelf(weakSelf);
        if ([strongSelf.delegate respondsToSelector:@selector(cyPlayerCommandViewDidSelectBackButton:)]) {
            [strongSelf.delegate cyPlayerCommandViewDidSelectBackButton:strongSelf];
        }
    }];
  
    // 弹幕开和关的按钮
    [self.topView addSubview:self.barrageOpenButton];
    [self.barrageOpenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        __strongSelf(weakSelf);
        make.top.equalTo(strongSelf.topView.mas_top).offset(CYLayoutConstraintEqualTo(60.0f));
        make.right.equalTo(strongSelf.topView.mas_right).offset(-CYLayoutConstraintEqualTo(60.0f));
        make.size.mas_equalTo(CGSizeMake(CYLayoutConstraintEqualTo(132.0f), CYLayoutConstraintEqualTo(132.0f)));
    }];
    
    // 发送弹幕的按钮

    [self.topView addSubview:self.sendBarrageBtn];
    [self.sendBarrageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        __strongSelf(weakSelf);
        make.top.equalTo(strongSelf.barrageOpenButton.mas_top);
        make.right.equalTo(strongSelf.barrageOpenButton.mas_left).offset(-CYLayoutConstraintEqualTo(30.0f));
        make.size.equalTo(strongSelf.barrageOpenButton);
    }];
    
    // 影片标题栏
    [self.topView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __strongSelf(weakSelf);
        make.top.bottom.equalTo(strongSelf.backButton);
        make.left.equalTo(strongSelf.backButton.mas_right).offset(CYLayoutConstraintEqualTo(90.0f));
        make.right.equalTo(self.sendBarrageBtn.mas_left).offset(-CYLayoutConstraintEqualTo(90.0f));
    }];
    
    // 设置标题 label
    if ([self.delegate respondsToSelector:@selector(cyPlayerCommandViewSetupMovieTitle:)]) {
        self.titleLabel.text = [self.delegate cyPlayerCommandViewSetupMovieTitle:self];
    }

}

#pragma mark - 创建底部视图 UI
/**
 *  创建底部的 view
 */
- (void)createBottomView {
    
    // 底部视图
    [self addSubview:self.bottomView];
    __weakSelf(self);
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strongSelf(weakSelf);
        make.bottom.equalTo(strongSelf);
        //        make.left.equalTo(self);
        //        make.width.mas_equalTo(568.0f);
        make.left.right.equalTo(strongSelf);
        make.height.mas_equalTo(CYLayoutConstraintEqualTo(192.0f));

    }];
    
    // 暂停或者播放按钮的点击事件
    [[self.bottomView.playButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *playButton) {
        playButton.selected = !playButton.selected;
        __strongSelf(weakSelf);
        if ([strongSelf.delegate respondsToSelector:@selector(cyPlayerCommandViewDidSelectPlayButton:isPlay:)]) {
            [strongSelf.delegate cyPlayerCommandViewDidSelectPlayButton:strongSelf isPlay:!playButton.selected];
        }
    }];

    // 选择上一个按钮的点击事件
    [[self.bottomView.previousButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *previousButton) {
        __strongSelf(weakSelf);
        if ([strongSelf.delegate respondsToSelector:@selector(cyPlayerCommandViewDidSelectPrevioursButton:)]) {
            [strongSelf.delegate cyPlayerCommandViewDidSelectPrevioursButton:strongSelf];
        }
    }];
    
    // 选择了下一个按钮的点击事件
    [[self.bottomView.nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *nextButton) {
        __strongSelf(weakSelf);
        if ([strongSelf.delegate respondsToSelector:@selector(cyPlayerCommandViewDidSelectNextButton:)]) {
            __strongSelf(weakSelf);
            [strongSelf.delegate cyPlayerCommandViewDidSelectNextButton:strongSelf];
        }
    }];
    
    // 滑块的一些点击事件
    [self.bottomView.playerSlider addTarget:self action:@selector(didDragSlider:) forControlEvents:UIControlEventTouchDown];
    [self.bottomView.playerSlider addTarget:self action:@selector(didReplay:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.playerSlider  addTarget:self action:@selector(didReplay:) forControlEvents:UIControlEventTouchUpOutside];
    [self.bottomView.playerSlider  addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    
}

#pragma mark - 懒加载一些视图

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    }
    return _topView;
}

- (CYAdjustButton *)backButton {
    if (!_backButton) {
        _backButton = [CYAdjustButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"movie_back.png"] forState:UIControlStateNormal];
    }
    return _backButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel                 = [UILabel new];
        _titleLabel.textColor       = [UIColor whiteColor];
        _titleLabel.textAlignment   = NSTextAlignmentLeft;
        _titleLabel.font            = CYLayoutConstranitFont(60.0f);
        _titleLabel.text            = @"";
    }
    return _titleLabel;
}

- (CYAdjustButton *)sendBarrageBtn {
    if (!_sendBarrageBtn) {
        _sendBarrageBtn = [CYAdjustButton buttonWithType:UIButtonTypeCustom];
        [_sendBarrageBtn setBackgroundImage:[UIImage imageNamed:@"sendBarrage"] forState:UIControlStateNormal];
        [_sendBarrageBtn addTarget:self action:@selector(sendBarrageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBarrageBtn;
}

- (CYAdjustButton *)barrageOpenButton {
    if (!_barrageOpenButton) {
        _barrageOpenButton = [CYAdjustButton buttonWithType:UIButtonTypeCustom];
        [_barrageOpenButton setBackgroundImage:[UIImage imageNamed:@"barrageStates"] forState:UIControlStateNormal];
        [_barrageOpenButton setBackgroundImage:[UIImage imageNamed:@"barrageStateClose"] forState:UIControlStateSelected];
        [_barrageOpenButton addTarget:self action:@selector(barrageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _barrageOpenButton;
}

- (CYPlayerBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [CYPlayerBottomView viewFromBundle];
    }
    return _bottomView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.backButton setImageViewFrame:CGRectMake(0.0f,CYLayoutConstraintEqualTo(15.0f),CYLayoutConstraintEqualTo(60.0f), CYLayoutConstraintEqualTo(60.0f))];

}

#pragma mark - 发送弹幕的按钮

- (void)sendBarrageBtnClick:(CYAdjustButton *)sendBarrageButtn {
    sendBarrageButtn.selected = !sendBarrageButtn.selected;
    self.showBarrageView = YES;
    if ([self.delegate respondsToSelector:@selector(cyPlayerCommandViewDidSelectSendBarrageButton:)]) {
        [self.delegate cyPlayerCommandViewDidSelectSendBarrageButton:self];
    }
    
}

/**
 *  弹幕打开或关闭的按钮
 */
- (void)barrageButtonClick:(CYAdjustButton *)barrageButton {
    barrageButton.selected = !barrageButton.selected;

    if ([self.delegate respondsToSelector:@selector(cyPlayerCommandViewDidSelectBarrageButton:isSelct:)]) {
        [self.delegate cyPlayerCommandViewDidSelectBarrageButton:self isSelct:barrageButton.selected];
    }
}

#pragma mark - 播放滑块的点击事件

- (void)didDragSlider:(UISlider*)videoSlider {
    
    _draggingSlider  = YES;
    if ([self.delegate respondsToSelector:@selector(cyPlayerCommandView:didTouchSlider:)]) {
        [self.delegate cyPlayerCommandView:self didTouchSlider:videoSlider];
    }
    [self removeTimer];

}
/**
 *  滑块开始释放的时候
 */
- (void)didReplay:(UISlider *)videoSlider {
    
    _draggingSlider = NO;
    [self performSelector:@selector(hiddenPlayerCommandView) withObject:nil afterDelay:5.0f];
    if ([self.delegate respondsToSelector:@selector(cyPlayerCommandView:didReplaySlider:)]) {
        [self.delegate cyPlayerCommandView:self didReplaySlider:videoSlider];
    }
    [self addTimer];
   
}
/**
 *  滑块的值发生的了改变
 */
- (void)didChangeValue:(UISlider *)videoSlider {
    _draggingSlider = YES;
    if ([self.delegate respondsToSelector:@selector(cyPlayerCommandView:didChangeSliderValue:)]) {
        [self.delegate cyPlayerCommandView:self didChangeSliderValue:videoSlider];
    }
    [self removeTimer];

}

- (void)dealloc {


    NSLog(@"---- %s-----",__func__);


}

@end
