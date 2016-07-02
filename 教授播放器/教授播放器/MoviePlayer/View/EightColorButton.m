//
//  EightColorButton.m
//  剧能玩2.1
//
//  Created by dzb on 15/11/12.
//  Copyright © 2015年 刘森. All rights reserved.
//

#import "EightColorButton.h"

@implementation EightColorButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    if (selected) {
        self.layer.borderColor = RGBCOLOR(234, 110, 164).CGColor;
        self.layer.borderWidth = 2;
    }else{
        self.layer.borderColor = nil;
        self.layer.borderWidth = 0;
    }
}

- (void)dealloc
{
    NSLog(@"---- %s-----",__func__);

}
@end
