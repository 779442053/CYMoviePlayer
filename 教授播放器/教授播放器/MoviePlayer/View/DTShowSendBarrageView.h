//
//  DTShowSendBarrageView.h
//  剧能玩2.1
//
//  Created by dzb on 15/11/12.
//  Copyright © 2015年 刘森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DTShowSendBarrageView;
@class MyTextField;
@class DTSendBarrageModel;
@protocol DTShowSendBarrageViewDelegate <NSObject>

@optional
/**
 *  隐藏发送弹幕的 view
 *
 *  @param sendBarrageView  发送弹幕的 view
 */
- (void)dtShowSendBarrageViewHidden:(DTShowSendBarrageView*)sendBarrageView;
/**
 *  开使发送弹幕
 *
 *  @param sendBarrageView 发送弹幕的 view
 *  @param text            发送弹幕模型
 */
- (void)dtShowSendBarrageView:(DTShowSendBarrageView *)sendBarrageView didSendBarrageText:(NSDictionary*)dict;

/**
 *  发送弹幕的view 已经出现了
 */
- (void)dtShowSendBarrageViewDidAppear:(DTShowSendBarrageView *)sendBarrageView;


@end

@interface DTShowSendBarrageView : UIView

/**
 *  初始化一个弹出弹幕的视图
 *
 *  @param delegate 代理
 *
 *  @return 返回一个实例
 */
- (instancetype)initSendBarrageViewWithDelegate:(id<DTShowSendBarrageViewDelegate>)delegate frame:(CGRect)frame;

/**
 *  delegate
 */
@property (nonatomic,weak) id<DTShowSendBarrageViewDelegate>delegate;



@end
