//
//  CYMoviePlayerView.h
//  Junengwan
//
//  Created by 董招兵 on 16/7/1.
//  Copyright © 2016年 上海触影文化传播有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CYMoviePlayerHorizontalViewDelegate;

@class CYPlayerCommandView , DTShowSendBarrageView;

NS_ASSUME_NONNULL_BEGIN

/**
 *  横向的视频播放器视图
 */
@interface CYMoviePlayerHorizontalView : UIView

/**
 *  播放控制面板的 view
 */
@property (nonatomic,strong,nullable) CYPlayerCommandView *playCommandView;
/**
 *  发送弹幕的 view
 */
@property (nonatomic,strong,nullable) DTShowSendBarrageView *sendBarrageView;

@property (nonatomic,strong,nullable) NSURL *playUrl;

/** delegate  */
@property (nonatomic,weak,nullable) id<CYMoviePlayerHorizontalViewDelegate>delegate;

@end


@protocol CYMoviePlayerHorizontalViewDelegate <NSObject>

@optional

/**
 *  返回按钮的点击事件
 */
- (void)cyMoviePlayerHorizontalViewDidSelectBackButton:(CYMoviePlayerHorizontalView *_Nullable)playerHorizontalView;


@end


NS_ASSUME_NONNULL_END
