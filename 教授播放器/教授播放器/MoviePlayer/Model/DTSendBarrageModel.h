//
//  DTSendBarrageModel.h
//  剧能玩2.1
//
//  Created by dzb on 15/11/12.
//  Copyright © 2015年 刘森. All rights reserved.
//

#import <Foundation/Foundation.h>

/**弹幕弹出位置的枚举*/
typedef NS_ENUM(NSInteger) {
    /**弹幕在左边的位置*/
    BarrageTextPosionTop,
    /**弹幕在中间的位置*/
    BarrageTextPosionCenter,
    /**弹幕在底部的位置*/
    BarrageTextPosionBottom
} BarrageTextPosion;

/**八个颜色选取的按钮的颜色枚举*/
typedef NS_ENUM(NSInteger,ButtonBackgroudColorType) {
    /**白色*/
    ButtonBackgroudColorWhite,
    /**红色*/
    ButtonBackgroudColorRed,
    /**黄色*/
    ButtonBackgroudColorYellow,
    /**绿色*/
    ButtonBackgroudColorGreen,
    /**蓝色*/
    ButtonBackgroudColorBlue,
    /**粉色*/
    ButtonBackgroudColorPink,
    /**深蓝色*/
    ButtonBackgroudColorDarkBule,
    /**紫色*/
    ButtonBackgroudColorPurple
};


/**
 *  发送弹幕的模型
 */
@interface DTSendBarrageModel : NSObject
/**
 *  text
 */
@property (nonatomic,copy) NSString *text;

/**
 *  font
 */
@property (nonatomic,strong) UIFont *font;

/**
 *  barragePosion
 */
@property (nonatomic,assign) BarrageTextPosion barragePosion;

/**
 *  textColor
 */
@property (nonatomic,strong) UIColor *textColor;

/**
 *  fontSize
 */
@property (nonatomic,assign) CGFloat fontSize;

/**
 *  colorType
 */
@property (nonatomic,assign) ButtonBackgroudColorType colorType;
/**
 *  是否当前用户发的弹幕
 */
@property (nonatomic,assign) BOOL userSelf;

@end
