//
//  DTShowSendBarrageView.m
//  剧能玩2.1
//
//  Created by dzb on 15/11/12.
//  Copyright © 2015年 刘森. All rights reserved.
//


#import "DTShowSendBarrageView.h"
#import "DTSendBarrageModel.h"
#import "EightColorButton.h"

#define  angelToRandian(x)  ((x)/180.0*M_PI)
#define  DEF_BorderColor RGBCOLOR(234, 110, 164)
#define  DEF_AllButtonStartX 70.0f // 所有按钮的最左边起点位置
#define  DEF_AllButtonStartY 70.0f  // 所有按钮的起点位置
#define  DEF_AllButtonWidth 35.0f   // 所有按钮的宽度
#define  DEF_AllButtonHeight DEF_AllButtonWidth * 0.68 // 所有按钮的高度
#define  K_MovieRightDuration 0.25 // 向右移动动画的时间
#define  K_MovieBottomDuration 0.2 // 向下移动的动画
@interface DTShowSendBarrageView ()<UITextFieldDelegate>
{
    CGFloat viewWidth ; // 弹幕的 view 的本身宽
    CGFloat viewHieht ; // 弹幕的 view 的本身高
    UIColor *selectColor;// 选择的颜色
    UIFont  *selectFont; // 选择字体大小
    BarrageTextPosion selectPosion; // 选择弹幕的默认位置
    NSMutableArray <UIButton*>*_fontBtnArray;//选择字号大小按钮的数组
    NSMutableArray *_positionArray; // 选择弹幕显示位置的数组
    DTSendBarrageModel *_barrageModel;
    NSMutableArray *_fiveOptionBtnArr; // 选择颜色 字体 对其的六个按钮
    UIButton       *_colorBtn; //颜色的按钮
    NSMutableArray *_eightColorBtnArray; // 八种颜色按钮的数组
    NSMutableArray *_eightColorBtnRectArray;// 八种颜色按钮frame 的数组
    NSArray        *_colorsArray; // 存放八种颜色的数组
}
/**
 *  backButton
 */
@property (nonatomic,strong) UIButton *backBtn;

/**
 *  bgImageView
 */
@property (nonatomic,strong) UIView *bgView;

/**
 *  输入框
 */
@property (nonatomic,strong) UITextField *textField;

/**
 *  sendBtn
 */
@property (nonatomic,strong) UIButton *sendBtn;

@end

@implementation DTShowSendBarrageView

/**
 *  初始化一个弹出弹幕的视图
 *
 *  @param delegate 代理
 *
 *  @return 返回一个实例
 */
- (instancetype)initSendBarrageViewWithDelegate:(id<DTShowSendBarrageViewDelegate>)delegate frame:(CGRect)frame
{
    if (self = [super init]) {
        
        self.frame      = frame;
        self.delegate   = delegate;
        viewWidth = frame.size.width;
        viewHieht = frame.size.height;
        self.bgView =[[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        self.bgView.frame = frame;
        [self addSubview:self.bgView];
        // 设置 view 默认在最底部
        [self setY:viewWidth];
        // 返回的按钮
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setFrame:CGRectMake(10, 25, 30, 30)];
        [backBtn setImage:[UIImage imageNamed:@"hd_idct_back.png"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"hd_icnav_back_dark.png"] forState:UIControlStateHighlighted];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        //输入框backBtn
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake([backBtn right]+20, 25, frame.size.width-150, 35)];
        self.textField.borderStyle = UITextBorderStyleRoundedRect;
        self.textField.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        [self addSubview:self.textField];
        self.textField.textColor = [UIColor whiteColor];
        self.textField.tintColor = DEF_BorderColor;
//        [self.textField becomeFirstResponder];
        self.textField.delegate = self;
        // 发送的按钮
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendBtn setFrame:CGRectMake(viewWidth-60, 25, 40, 30)];
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sendBtn.titleLabel.font = FONT_SIZE(15);
        [sendBtn addTarget:self action:@selector(sendBarrage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendBtn];
        
        // 初始化一个颜色的数组
        _colorsArray = @[[UIColor whiteColor],[UIColor redColor],[UIColor yellowColor],RGBCOLOR(24, 135, 52),RGBCOLOR(45, 141, 229),RGBCOLOR(216, 0, 108),RGBCOLOR(16, 32, 95),[UIColor purpleColor]];
        int colorIndex = arc4random()%_colorsArray.count;
        
        // 创建模型
        _barrageModel               = [DTSendBarrageModel new];
        _barrageModel.fontSize      = 13;
        _barrageModel.textColor     = _colorsArray[colorIndex];
        _barrageModel.colorType     = colorIndex;
        _barrageModel.barragePosion = BarrageTextPosionTop;
        _barrageModel.text          = @"";
        _barrageModel.userSelf      = YES;
        // 初始化5个选项的按钮
        [self addFiveOptionButton];
        // 创建七个颜色的按钮
        [self addEightColorButton];
      // 动画弹出弹幕的 view
        [self performSelector:@selector(showView) withObject:nil afterDelay:0.25f];


    }
    return self;
}
/**
 *   显示发弹幕的 view
 */
- (void)showView
{
    __weakSelf(self);
    [UIView animateWithDuration:0.25f animations:^{
        __strongSelf(weakSelf);
        [strongSelf setY:0];
    }completion:^(BOOL finished) {
        __strongSelf(weakSelf);
        [strongSelf.textField becomeFirstResponder];
        if ([strongSelf.delegate respondsToSelector:@selector(dtShowSendBarrageViewDidAppear:)]) {
            [strongSelf.delegate dtShowSendBarrageViewDidAppear:strongSelf];
        }
    }];
}
/**
 *   返回按钮
 */
- (void)back
{
    [self removeSelf];
}
/**
 *  隐藏发弹幕的 view
 */
- (void)hiddenView
{
    if (self.textField.editing) {
        [self.textField resignFirstResponder];
        self.textField.text = @"";
    }
    @weakify(self);
    [UIView animateWithDuration:0.5 animations:^{
        @strongify(self);
        [self setY:DEF_SCREEN_WIDTH];
    }completion:^(BOOL finished) {
        
    }];
}
/**
 *   点击空白区域移除发弹幕的 view
 *
 *  @param touches  点击的 touchs
 *  @param event    点击事件
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self removeSelf];
}
/**
 *   移除自己
 */
- (void)removeSelf
{
    [self hiddenView];
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(dtShowSendBarrageViewHidden:)]) {
            [self.delegate dtShowSendBarrageViewHidden:self];
        }
    });
}
#pragma mark -发送弹幕
- (void)sendBarrage:(UIButton*)btn
{
    _barrageModel.text = self.textField.text;
    [self hiddenView];
    NSString *location = @"";
    if (_barrageModel.barragePosion == BarrageTextPosionTop) {
        location = @"5";
    }else if (_barrageModel.barragePosion == BarrageTextPosionCenter){
        location = @"1";
    }else if (_barrageModel.barragePosion == BarrageTextPosionBottom){
        location = @"4";
    }
    NSString *contents = _barrageModel.text;
    NSString *fonts = @"|25f|-1|25833";
    NSDictionary *dict = @{
                           @"location"  : location,
                           @"fonts"     : fonts,
                           @"contents"  : contents,
                           @"color"     : _barrageModel.textColor
                           };
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(dtShowSendBarrageViewHidden:)]) {
            [self.delegate dtShowSendBarrageViewHidden:self];
        }
        if ([self.delegate respondsToSelector:@selector(dtShowSendBarrageView:didSendBarrageText:)]) {
            [self.delegate dtShowSendBarrageView:self didSendBarrageText:dict];
        }
    });
}
#pragma mark - 创建5个选项的按钮
- (void)addFiveOptionButton
{
    [self addFontButton];
    [self addPositionView];
}
/**
 *  添加字体的按钮
 */
- (void)addFontButton
{
    // 放中间五个按钮的数组
    _fiveOptionBtnArr = [NSMutableArray array];
    _fontBtnArray = [NSMutableArray array];
    NSArray *fontNormalImages = @[@"player_input_smalltype_default_icon.png",@"player_input_bigtype_default_icon.png"]; // 选择字号按钮的未选中状态的图片
    NSArray *fontSelectImages = @[@"player_input_smalltype_icon.png",@"player_input_bigtype_icon.png"];
    CGFloat fontBtnX = DEF_AllButtonStartX;
    CGFloat fontBtnY = DEF_AllButtonStartY;
    CGFloat fontBtnW = DEF_AllButtonWidth;
    CGFloat fontBntH = DEF_AllButtonHeight;
    for (int i=0; i<fontNormalImages.count; i++) {
        fontBtnX = fontBtnX+(fontBtnW+10)*i;
        UIButton *fontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [fontBtn setFrame:CGRectMake(fontBtnX, fontBtnY, fontBtnW, fontBntH)];
        [fontBtn setBackgroundImage:[UIImage imageNamed:fontNormalImages[i]] forState:UIControlStateNormal];
        [fontBtn setBackgroundImage:[UIImage imageNamed:fontSelectImages[i]] forState:UIControlStateSelected];
        fontBtn.tag = i+10;
        [self addSubview:fontBtn];
        if (_barrageModel.fontSize ==13.0f&&i==0) {
            fontBtn.selected = YES;
        }else if (_barrageModel.fontSize ==15.0f&&i==1){
            fontBtn.selected = YES;
        }
        [fontBtn addTarget:self action:@selector(fontButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_fontBtnArray addObject:fontBtn];
        [_fiveOptionBtnArr addObject:fontBtn];
    }
}
/**
 *  添加对其方式的按钮
 */
- (void)addPositionView
{
    _positionArray = [NSMutableArray array];
    NSArray *positionNormalImages = @[@"player_input_topbarrage_default_icon.png",@"player_input_rollbarrage_default_icon.png",@"player_input_bottombarrage_default_icon.png"];
    NSArray*positionSelectImages=@[@"player_input_topbarrage_icon.png",@"player_input_rollbarrage_icon.png",@"player_input_bottombarrage_icon.png"];
    CGFloat positionBtnX = 0.0f;
    CGFloat positionBtnY = DEF_AllButtonStartY;
    CGFloat positionBtnW = DEF_AllButtonWidth;
    CGFloat positionBntH = DEF_AllButtonHeight;
    for (int i =0; i<positionNormalImages.count; i++) {
        positionBtnX = [_fontBtnArray[1] frame].origin.x +55+(positionBtnW+10)*i;
        UIButton *positionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [positionBtn setFrame:CGRectMake(positionBtnX, positionBtnY, positionBtnW, positionBntH)];
        [positionBtn setBackgroundImage:[UIImage imageNamed:positionNormalImages[i]] forState:UIControlStateNormal];
        [positionBtn setBackgroundImage:[UIImage imageNamed:positionSelectImages[i]] forState:UIControlStateSelected];
        positionBtn.tag = i+20;
        [self addSubview:positionBtn];
        if (i == _barrageModel.barragePosion) {
            positionBtn.selected = YES;
        }
        [positionBtn addTarget:self action:@selector(positionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_fiveOptionBtnArr addObject:positionBtn];
        [_positionArray addObject:positionBtn];
    }
    // 颜色的按钮
    _colorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _colorBtn.backgroundColor = _barrageModel.textColor;
    _colorBtn.frame = CGRectMake(positionBtnX+positionBtnW+30, positionBtnY, positionBtnW, positionBntH);
    _colorBtn.layer.cornerRadius = 8;
    _colorBtn.layer.masksToBounds = YES;
    _colorBtn.layer.borderColor = DEF_BorderColor.CGColor;
    _colorBtn.layer.borderWidth = 2;
    [_colorBtn addTarget:self action:@selector(colorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_colorBtn];
    
}
/**
 *  创建八个颜色的按钮
 */
- (void)addEightColorButton
{
    _eightColorBtnRectArray = [NSMutableArray array];
    _eightColorBtnArray       = [NSMutableArray array];
    // 设置颜色按钮的初始值
    CGFloat colorBtnX = DEF_AllButtonStartX;
    CGFloat colorBtnY = DEF_AllButtonStartY;
    CGFloat colorBtnW = DEF_AllButtonWidth;
    CGFloat colorBtnH = DEF_AllButtonHeight;
    // 通过 for循环创建8个颜色按钮
    for (int i =0; i<_colorsArray.count; i++) {
        colorBtnX = DEF_AllButtonStartX+(colorBtnW+10)*i;
        CGRect btnRect = CGRectMake(colorBtnX, colorBtnY, colorBtnW, colorBtnH);
        EightColorButton *eightBtn = [EightColorButton buttonWithType:UIButtonTypeCustom];
        [eightBtn setFrame:btnRect];
        eightBtn.tag = i+100;
        eightBtn.backgroundColor = _colorsArray[i];
        [eightBtn addTarget:self action:@selector(eightColorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == _barrageModel.colorType) {
            eightBtn.selected = YES;
        }
        [self addSubview:eightBtn];
        [_eightColorBtnArray addObject:eightBtn];
        [_eightColorBtnRectArray addObject:[NSValue valueWithCGRect:btnRect]];
        [eightBtn setX:-100];
    }
}
#pragma mark - 选择字体的按钮
- (void)fontButtonClick:(UIButton*)button
{
    for (UIButton *btn in _fontBtnArray) {
        btn.selected = NO;
    }
    button.selected = YES;
    if (button.tag ==10) {
        _barrageModel.fontSize = 13;
    }else if (button.tag == 11){
        _barrageModel.fontSize = 15;
    }
}
#pragma mark - 选择了对齐位置
- (void)positionBtnClick:(UIButton*)button
{
    for (UIButton *btn in _positionArray) {
        btn.selected = NO;
    }
    button.selected = YES;
    _barrageModel.barragePosion = button.tag-20;
}
#pragma mark - 让五个选项的按钮做动画
/**
 *  点击了选择颜色的按钮
 *
 *  @param button 颜色的按钮
 */
- (void)colorButtonClick:(UIButton*)button
{
    // 初始化每个按钮做动画的角度值 时间 偏移量
    CGFloat angle = 0.0f;
    CGFloat duration = K_MovieRightDuration;
    CGFloat offset = 450;
    [self beginAnimation:button angle:angle duration:duration moveOffSet:offset];
    // 其他4个按钮一起做动画
    for (UIButton *btn in _fiveOptionBtnArr) {
        duration +=0.08;
        offset +=250;
        angle  -=20;
        [self beginAnimation:btn angle:angle duration:duration moveOffSet:offset];
    }
}
/**
 *  开始向右的动画
 *
 *  @param btn      做动画的按钮
 *  @param angle    角度
 *  @param duration 时间
 *  @param offset   偏移量
 */
- (void)beginAnimation:(UIButton*)btn angle:(CGFloat)angle duration:(CGFloat)duration moveOffSet:(CGFloat)offset
{
    @weakify(self);
    // 角度先反方向递减 后正方向递增
    NSMutableArray *values = [NSMutableArray array];
    for (int i=0; i<30; i++) {
        if (i<=5) {
            angle -=10;
        }else{
            angle+=3;
        }
        [values addObject:@(angelToRandian(angle))];
    }
    // 平移动画
    CABasicAnimation *a1 = [CABasicAnimation animation];
    a1.keyPath = @"transform.translation.x";
    a1.toValue  = @(offset);
    // 旋转动画
    CAKeyframeAnimation *a3 = [CAKeyframeAnimation animation];
    a3.keyPath = @"transform.rotation";
    a3.values = values;
    // 组动画
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
    groupAnima.animations = @[a1, a3];
    //设置组动画的时间
    groupAnima.duration = duration;
    groupAnima.fillMode = kCAFillModeForwards;
    groupAnima.removedOnCompletion = NO;
    [btn.layer addAnimation:groupAnima forKey:@"fiveBtn"];
    // 0.4秒钟后动画停止 可以显示颜色的按钮了
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(K_MovieRightDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self  showEightButtons];
    });
}
/**
 *  八个按钮向下的动画
 */
- (void)showEightColorButtonAnimations
{
    @weakify(self);
    CGFloat duration    = K_MovieBottomDuration;
    CGFloat offset      = 70;
    CGFloat angle       = 0.0f;
    CGFloat buttonIndex = _barrageModel.colorType;
    for (int i =0; i<_eightColorBtnArray.count; i++) {
        BOOL isLeft = YES;
        if (i==buttonIndex) {
            continue;
        }
        // 点击的按钮不做动画,其他按钮便宜不同的角度开始动画 如果点击的按钮 index =0 那么它右边所有按钮 isLeft = NO
        UIButton *btn = _eightColorBtnArray[i];
        if ((btn.tag-100)>buttonIndex) {
            angle = -1.0f;
            isLeft = YES;
        }else if (btn.tag-100<buttonIndex){
            angle = 1.0f;
            isLeft = NO;
        }
        // 角度先反方向递减 后正方向递增 如果做动画的按钮在点击按钮左侧 那么这个按钮讲向反方向旋转,如果
        NSMutableArray *values = [NSMutableArray array];
        for (int i=0; i<40; i++) {
            if (isLeft) {
                angle -=1;
            }else {
                angle +=1;
            }
            [values addObject:@(angelToRandian(angle))];
        }
        // 平移动画
        CABasicAnimation *a1 = [CABasicAnimation animation];
        a1.keyPath = @"transform.translation.y";
        a1.toValue  = @(offset);
        // 旋转动画
        CAKeyframeAnimation *a3 = [CAKeyframeAnimation animation];
        a3.keyPath = @"transform.rotation";
        a3.values = values;
        // 透明的动画
        CABasicAnimation    *a2 = [CABasicAnimation animation];
        a2.keyPath = @"opacity";
        a2.fromValue            = @(1);
        a2.toValue              = @(0);
        // 组动画
        CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
        groupAnima.animations = @[a1, a3,a2];
        //设置组动画的时间
        groupAnima.duration = duration;
        groupAnima.fillMode = kCAFillModeForwards;
        groupAnima.removedOnCompletion = NO;
        [btn.layer addAnimation:groupAnima forKey:@"colorBtn"];
    }
    // 延时0.5秒等动画昨晚后 移除
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(K_MovieBottomDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIButton *btn in _eightColorBtnArray) {
            if (btn.tag-100!=_barrageModel.colorType) {
                [btn.layer removeAnimationForKey:@"colorBtn"];
                [btn setX:-100];
            }
        }
        __weak UIButton *selectBtn = _eightColorBtnArray[_barrageModel.colorType];
        [UIView animateWithDuration:0.15 animations:^{
            selectBtn.frame = _colorBtn.frame;
        }completion:^(BOOL finished) {
            @strongify(self);
            [self showFiveButtonFromTop:selectBtn];
            selectBtn.hidden = YES;
            [selectBtn setX:-100];
        }];
    });
}
/**
 *   从顶部掉落5个按钮
 */
- (void)showFiveButtonFromTop:(UIButton*)btn
{
    _colorBtn.hidden = NO;
    _colorBtn.backgroundColor = btn.backgroundColor;
    // 掉落到70位置时的角度值
    __block NSMutableArray *lastAngleArray = [NSMutableArray array];
    CGFloat duration    = 0.1;
    CGFloat offset      = 120;
    CGFloat angle       = 0.0f;
    for (int i =0; i<_fiveOptionBtnArr.count; i++) {
        BOOL isLeft = YES;
        UIButton *btn = _fiveOptionBtnArr[i];
        btn.hidden = NO;
        if (i<=1) {
            angle = -1.0f;
            isLeft = YES;
        }else {
            angle = 1.0f;
            isLeft = NO;
        }
        // 角度先反方向递减 后正方向递增
        NSMutableArray *values = [NSMutableArray array];
        for (int i=0; i<40; i++) {
            if (isLeft) {
                angle -=1;
            }else {
                angle +=1;
            }
            [values addObject:@(angelToRandian(angle))];
        }
        // 平移动画
        CABasicAnimation *a1 = [CABasicAnimation animation];
        a1.keyPath = @"transform.translation.y";
        a1.toValue  = @(offset);
        // 旋转动画
        CAKeyframeAnimation *a3 = [CAKeyframeAnimation animation];
        a3.keyPath = @"transform.rotation";
        a3.values = values;
        [lastAngleArray addObject:[values lastObject]];
        // 图标抖动的效果
        CAKeyframeAnimation *a2 = [CAKeyframeAnimation animation];
        a2.keyPath = @"transform.rotation";
        CGFloat lastAngle = [[lastAngleArray objectAtIndex:i] floatValue];
        a2.values  = @[@(-lastAngle),@(lastAngle),@(0)];
        // 组动画
        CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
        groupAnima.animations = @[a1, a3,a2];
        //设置组动画的时间
        groupAnima.duration = duration;
        groupAnima.fillMode = kCAFillModeForwards;
        groupAnima.removedOnCompletion = NO;
        [btn.layer addAnimation:groupAnima forKey:@"colorBtn"];
    }
    // 延时0.5秒等动画昨晚后 移除
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i=0;i<_fiveOptionBtnArr.count;i++) {
            UIButton *button = _fiveOptionBtnArr[i];
            [button.layer removeAnimationForKey:@"colorBtn"];
            [button setY:70];
            [lastAngleArray removeAllObjects];
            lastAngleArray = nil;
        }
    });
}
#pragma mark - 八个颜色的按钮的动画效果

- (void)eightColorBtnClick:(UIButton*)button
{
    for (UIButton *btn in _eightColorBtnArray) {
        btn.selected = NO;
    }
    button.selected = YES;
    _barrageModel.colorType = button.tag -100;
    _barrageModel.textColor = _colorsArray[_barrageModel.colorType];
    // 八个按钮向下的按钮
    [self showEightColorButtonAnimations];
}
/**
 *  从左边做动画显示8个按钮
 */
- (void)showEightButtons
{
    [self removeFiveButtonAnimations];
    // 挨个显示颜色的按钮
    CGFloat durition = 0.1f;
    for (int i =0; i<_eightColorBtnArray.count; i++) {
        __weak UIButton *btn = _eightColorBtnArray[i];
        if (i==_barrageModel.colorType) {
            btn.hidden = NO;
        }
        CGRect rect = [self getButtonFrameAtIndex:i];
        CGFloat endX = rect.origin.x;
        [UIView animateWithDuration:durition animations:^{
            [btn setX:endX];
        }];
        durition +=0.05;
    }
}
#pragma mark - 移除动画的操作
/**
 *  移除5个按钮的动画
 */
- (void)removeFiveButtonAnimations
{
    // 把颜色的按钮置空 后边选择其他按钮后再给它赋值
    _colorBtn.hidden = YES;
    [_colorBtn.layer removeAnimationForKey:@"fiveBtn"];
    for (UIButton *btn in _fiveOptionBtnArr) {
        btn.hidden = YES;
        [btn.layer removeAnimationForKey:@"fiveBtn"];
        [btn setY:-50];
    }
}
/**
 *  得到一个按钮的 frame 从数组中取出
 *
 *  @param index 数组中的索引
 *
 *  @return 返回一个 frame
 */
- (CGRect)getButtonFrameAtIndex:(NSInteger)index
{
    NSValue *value = _eightColorBtnRectArray[index];
    CGRect rect = CGRectZero;
    [value getValue:&rect];
    return rect;
}

- (void)dealloc
{
    NSLog(@"---- %s-----",__func__);
}
#pragma mark - 输入框代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length>20) {
//        SHOW_ALERT(@"弹幕字数不能超过20个字数!");
        return NO;
    }
    return YES;
}

@end
