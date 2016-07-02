//
//  CYPlayerCommandView.h
//  Junengwan
//
//  Created by 董招兵 on 16/7/1.
//  Copyright © 2016年 上海触影文化传播有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CYPlayerCommandViewDelegate;


@class CYAdjustButton,CYPlayerBottomView;
/**
 *  播放器控制面板的 view
 */
@interface CYPlayerCommandView : UIView

/**
 *  顶部视图
 */
@property (nonatomic,strong,nullable) UIView             *topView;
/**
 *  底部视图
 */
@property (nonatomic,strong,nullable) CYPlayerBottomView *bottomView;

/** backButton  */
@property (nonatomic,strong,nullable) CYAdjustButton     *backButton;

/** titleLabel  */
@property (nonatomic,strong,nullable) UILabel            *titleLabel;

/** sendBarrageBtn */
@property (nonatomic,strong,nullable) CYAdjustButton     *sendBarrageBtn;

/** barrageOpenBtn  */
@property (nonatomic,strong,nullable) CYAdjustButton     *barrageOpenButton;

/** delegate  */
@property (nonatomic,weak,nullable) id<CYPlayerCommandViewDelegate>delegate;
/**
 *  是否正在显示播放面板
 */
@property (nonatomic,assign,readonly,getter=isShowPlayerCommandView) BOOL showPlayerCommandView;
/**
 *  是否正在拖拽播放进度条
 */
@property (nonatomic,assign,readonly,getter=isDraggingSlider) BOOL draggingSlider;

@property (nonatomic,assign,getter=isSHowBarrageView) BOOL showBarrageView;

/**
 *  构造方法
 */
- (_Nullable instancetype)initWithFrame:(CGRect)frame delegate:(_Nullable id<CYPlayerCommandViewDelegate>)delegate;

/**
 *  显示播放器控制面板
 */
- (void)showPlayerCommandView;
/**
 *  隐藏播放器控制面板
 */
- (void)hiddenPlayerCommandView;


@end



@protocol CYPlayerCommandViewDelegate <NSObject>

@required

/**
 *  获取影片的标题
 */
- (NSString *_Nullable)cyPlayerCommandViewSetupMovieTitle:(CYPlayerCommandView *_Nullable)playerCommandView;


@optional

/**
 *  点击了返回的按钮
 */
- (void)cyPlayerCommandViewDidSelectBackButton:(CYPlayerCommandView *_Nullable)playerCommandView;

/**
 *  发送弹幕的按钮被点击了
 */
- (void)cyPlayerCommandViewDidSelectSendBarrageButton:(CYPlayerCommandView *_Nullable)playerCommandView;

/**
 *  打开或者关闭弹幕
 */
- (void)cyPlayerCommandViewDidSelectBarrageButton:(CYPlayerCommandView *_Nullable)playerCommandView isSelct:(BOOL)isSelect;

/**
 *  选择了上一个按钮
 */
- (void)cyPlayerCommandViewDidSelectPrevioursButton:(CYPlayerCommandView *_Nullable)playerCommandView;
/**
 *  选择了下一个按钮
 */
- (void)cyPlayerCommandViewDidSelectNextButton:(CYPlayerCommandView *_Nullable)playerCommandView;

/**
 *  暂停或者播放
 */
- (void)cyPlayerCommandViewDidSelectPlayButton:(CYPlayerCommandView *_Nullable)playerCommandView isPlay:(BOOL)isPlay;
/**
 *  视图出现
 */
- (void)cyPlayerCommandViewDidAppear:(CYPlayerCommandView *_Nullable)playerCommandView;
/**
 *  视图消失
 */
- (void)cyPlayerCommandViewDidDisAppear:(CYPlayerCommandView *_Nullable)playerCommandView;
/**
 *  开始点击 slider
 */
- (void)cyPlayerCommandView:(CYPlayerCommandView *_Nullable)playerCommandView didTouchSlider:(UISlider *_Nullable)slider;
/**
 *  改变 slider 的值
 */
- (void)cyPlayerCommandView:(CYPlayerCommandView *_Nullable)playerCommandView didChangeSliderValue:(UISlider *_Nullable)slider;
/**
 *  结束拖拽slider
 */
- (void)cyPlayerCommandView:(CYPlayerCommandView *_Nullable)playerCommandView didReplaySlider:(UISlider *_Nullable)slider;


@end

