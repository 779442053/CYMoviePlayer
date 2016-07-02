//
//  DTSendBarrageModel.m
//  剧能玩2.1
//
//  Created by dzb on 15/11/12.
//  Copyright © 2015年 刘森. All rights reserved.
//

#import "DTSendBarrageModel.h"

@implementation DTSendBarrageModel

- (void)setFontSize:(CGFloat)fontSize
{
    _fontSize   = fontSize;
    self.font = FONT_SIZE(fontSize);
}

- (void)dealloc
{
    NSLog(@"---- %s-----",__func__);

}
@end
