//
//  CYMoviePlayerView.m
//  Junengwan
//
//  Created by 董招兵 on 16/7/1.
//  Copyright © 2016年 上海触影文化传播有限公司. All rights reserved.
//

#import "CYMoviePlayerHorizontalView.h"
#import "CYPlayerCommandView.h"
#import "DTShowSendBarrageView.h"
#import <AVFoundation/AVFoundation.h>
#import "CYPlayerBottomView.h"

static const NSString *PlayerItemStatusContext;
static const NSString *PlayerItemLoadedTimeRangesContext;

@interface CYMoviePlayerHorizontalView () <DTShowSendBarrageViewDelegate , CYPlayerCommandViewDelegate,DTSingletonDelegate>

/**
 *  moviePlayer
 */
@property (nonatomic,strong  ) AVPlayer      *moviePlayer;
/**
 *  avplayerItem
 */
@property (nonatomic,weak    ) AVPlayerItem  *playerItem;
/**
 *  avplayLayer
 */
@property (nonatomic,strong  ) AVPlayerLayer *playerLayer;

@property (nonatomic, strong ) id            timeObserver;
@property (nonatomic,assign  ) BOOL          isPlaying;
@property (nonatomic,strong  ) UIImageView        *animationImageView;
@property (nonatomic,strong)   NSMutableArray *animationImages;

@end

@implementation CYMoviePlayerHorizontalView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
        
    }
    return self;
}

#pragma mark - 懒加载一些控件

/**
 *  播放器控制面板
 */
- (CYPlayerCommandView *)playCommandView {
    if (!_playCommandView) {
        _playCommandView = [[CYPlayerCommandView alloc] initWithFrame:CGRectZero delegate:self];
    }
    return _playCommandView;
}
- (AVPlayerLayer *)playerLayer
{
    if (!_playerLayer) {
        _playerLayer              = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayer];
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return _playerLayer;
}

- (AVPlayer *)moviePlayer {
    if (!_moviePlayer) {
        _moviePlayer = [[AVPlayer alloc] init];
    }
    return _moviePlayer;
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
    [self bringSubviewToFront:self.playCommandView];
    
}
- (UIImageView *)animationImageView {
    if (!_animationImageView) {
        _animationImageView        = [[UIImageView alloc] init];
        _animationImageView.image  = [UIImage imageNamed:@"movieloading-1"];
        _animationImageView.hidden = YES;
    }
    return _animationImageView;
}
- (NSMutableArray *)animationImages {
    if (!_animationImages) {
        NSMutableArray *array                       = [NSMutableArray array];
        for (NSInteger i                            = 1; i < 6; i++) {
            NSString *imageName                     = [NSString stringWithFormat:@"movieloading-%ld.png", (long)i];
            UIImage *image                          = [UIImage imageNamed:imageName];
            [array addObject:image];
        }
        _animationImages                            = array;
    }
    return _animationImages;
}
#pragma mark - 初始化工作

- (void)setup {
    
    [self addSubview:self.playCommandView];
    // 添加播放器控制面板
    __weakSelf(self);
    [self.playCommandView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strongSelf(weakSelf);
        make.edges.equalTo(strongSelf);
    }];
    
    [self.layer addSublayer:self.playerLayer];
    self.isPlaying  = NO;
    
    // 延迟显示是 loadingView
    [self addSubview:self.animationImageView];
    [self.animationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(CYLayoutConstraintEqualTo(600.0f), CYLayoutConstraintEqualTo(600.0f)));
    }];
    
    // 监听程序运行时状态
    [DTSingleton addDelegate:self];
    
}

- (void)setPlayUrl:(NSURL *)playUrl {
    if (!playUrl) return;
    _playUrl   = playUrl;
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:_playUrl];
    [self replacePlayeRitem:item];
}

#pragma mark - 切换影片内容
/**
 *  切换影片内容
 */
- (void)replacePlayeRitem:(AVPlayerItem *)playerItem {
    
    [self.moviePlayer replaceCurrentItemWithPlayerItem:playerItem];
    [self.moviePlayer play];
    [self addMoviePlayerObserverForItem:playerItem];
    
    
}

#pragma mark - CYPlayerCommandViewDelegate

/**
 *  获取影片的标题
 */
- (NSString *_Nullable)cyPlayerCommandViewSetupMovieTitle:(CYPlayerCommandView *_Nullable)playerCommandView {
    return @"总裁在上我在下第一季";
}

/**
 *  点击了返回的按钮
 */
- (void)cyPlayerCommandViewDidSelectBackButton:(CYPlayerCommandView *_Nullable)playerCommandView {
    
    [self.moviePlayer pause];
    [self.moviePlayer removeTimeObserver:self.timeObserver];
    
    if ([self.delegate respondsToSelector:@selector(cyMoviePlayerHorizontalViewDidSelectBackButton:)]) {
        [self.delegate cyMoviePlayerHorizontalViewDidSelectBackButton:self];
    }
    
}

/**
 *  发送弹幕的按钮被点击了
 */
- (void)cyPlayerCommandViewDidSelectSendBarrageButton:(CYPlayerCommandView *_Nullable)playerCommandView {
    
    
    [self.playCommandView hiddenPlayerCommandView];
    self.playCommandView.userInteractionEnabled = NO;
    [self removeSendBarrageView];
    
    DTShowSendBarrageView *barrageView = [[DTShowSendBarrageView alloc] initSendBarrageViewWithDelegate:self frame:self.playCommandView.bounds];
    self.sendBarrageView               = barrageView;
    [self.moviePlayer pause];
    
    [self insertSubview:barrageView aboveSubview:self.playCommandView];
    
}

/**
 *  打开或者关闭弹幕
 */
- (void)cyPlayerCommandViewDidSelectBarrageButton:(CYPlayerCommandView *)playerCommandView isSelct:(BOOL)isSelect {
    
    
}

/**
 *  选择了上一个按钮
 */
- (void)cyPlayerCommandViewDidSelectPrevioursButton:(CYPlayerCommandView *_Nullable)playerCommandView {
    
    
}
/**
 *  选择了下一个按钮
 */
- (void)cyPlayerCommandViewDidSelectNextButton:(CYPlayerCommandView *_Nullable)playerCommandView {
    
    
}

/**
 *  暂停或者播放
 */
- (void)cyPlayerCommandViewDidSelectPlayButton:(CYPlayerCommandView *_Nullable)playerCommandView isPlay:(BOOL)isPlay {
    
    if (isPlay) {
        [self.moviePlayer play];
    } else {
        [self.moviePlayer pause];
    }
    
}

/**
 *  视图出现
 */
- (void)cyPlayerCommandViewDidAppear:(CYPlayerCommandView *_Nullable)playerCommandView {
//        playerCommandView.userInteractionEnabled = YES;
}
/**
 *  视图消失
 */
- (void)cyPlayerCommandViewDidDisAppear:(CYPlayerCommandView *_Nullable)playerCommandView {
//        playerCommandView.userInteractionEnabled = YES;
    
}
/**
 *  开始拖拽滑块
 */
- (void)cyPlayerCommandView:(CYPlayerCommandView *)playerCommandView didTouchSlider:(UISlider *)slider {
    
    [self.moviePlayer pause];
    self.playCommandView.bottomView.playButton.selected = NO;
    
}
/**
 *  滑块的值发生改变
 */
- (void)cyPlayerCommandView:(CYPlayerCommandView *)playerCommandView didReplaySlider:(UISlider *)slider {
    self.playCommandView.bottomView.playButton.selected = NO;
    
    [self.moviePlayer play];
    
}
/**
 *  结束拖拽滑块
 */
- (void)cyPlayerCommandView:(CYPlayerCommandView *)playerCommandView didChangeSliderValue:(UISlider *)slider {
    
    self.playCommandView.bottomView.playButton.selected = YES;
    
    double currentTime = (double)(slider.value);
    double totalTime   = CMTimeGetSeconds(self.playerItem.duration);
    
    if (currentTime < totalTime-0.01f) {
        
        [self.moviePlayer seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        
    }
    
    
}
#pragma mark - DTShowSendBarrageViewDelegate

/**
 *  隐藏发送弹幕的 view
 *
 *  @param sendBarrageView  发送弹幕的 view
 */
- (void)dtShowSendBarrageViewHidden:(DTShowSendBarrageView*)sendBarrageView {
    
    self.playCommandView.showBarrageView = NO;
    [self removeSendBarrageView];
    [self.moviePlayer play];
    [self.playCommandView showPlayerCommandView];
    self.playCommandView.userInteractionEnabled = YES;
    
}

/**
 *  开使发送弹幕
 *
 *  @param sendBarrageView 发送弹幕的 view
 *  @param text            发送弹幕模型
 */
- (void)dtShowSendBarrageView:(DTShowSendBarrageView *)sendBarrageView didSendBarrageText:(NSDictionary*)dict {
    
    self.playCommandView.showBarrageView = NO;
    
    [self removeSendBarrageView];
    [self.moviePlayer play];
    
}
/**
 *  发送弹幕的视图已经出现
 */
- (void)dtShowSendBarrageViewDidAppear:(DTShowSendBarrageView *)sendBarrageView {
    
}

/**
 *  移除弹幕的 view
 */
- (void)removeSendBarrageView {
    
    if (!self.sendBarrageView) return;
    [self.sendBarrageView removeFromSuperview];
    self.sendBarrageView = nil;
    
}

#pragma mark - 监听播放器状态和移除监听
/**
 *  添加监听
 */
- (void)addMoviePlayerObserverForItem:(AVPlayerItem *)playerItem {
    
    [self removeMoviePlayerObserver];
    
    [playerItem  addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:&PlayerItemStatusContext];
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:&PlayerItemLoadedTimeRangesContext];
    self.playerItem  = playerItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
}
/**
 *  移除监听
 */
- (void)removeMoviePlayerObserver {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}
/**
 *  添加监听播放进度的定时器
 */
- (void)addPlayerProgressTimer {
    
    __weakSelf(self);
    self.timeObserver                          = [self.moviePlayer addPeriodicTimeObserverForInterval:CMTimeMake(3.0, 30.0) queue:NULL usingBlock:^(CMTime time) {
        __strongSelf(weakSelf);
        // 1.更新时间
        strongSelf.playCommandView.bottomView.timeLabel.text = [strongSelf updateTimeString];
        double currentTime = CMTimeGetSeconds(strongSelf.moviePlayer.currentTime);
        // 2.设置进度条的value
        strongSelf.playCommandView.bottomView.playerSlider.value = currentTime;
        
    }];
    
}
/**
 *  播放结束的通知
 */
- (void)playerDidFinished:(NSNotification*)noti {
    
    [self.moviePlayer pause];
    self.isPlaying = NO;
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    __weakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (context == &PlayerItemStatusContext) {
            __strongSelf(weakSelf);
            
            if (strongSelf.moviePlayer.currentItem.status == AVPlayerItemStatusReadyToPlay) {
                double durition = CMTimeGetSeconds(strongSelf.playerItem.duration);
                strongSelf.playCommandView.bottomView.playerSlider.maximumValue = durition;
                [strongSelf addPlayerProgressTimer];
                strongSelf.playCommandView.bottomView.timeLabel.text =  [strongSelf updateTimeString];
                strongSelf.isPlaying  = YES;
            } else if (strongSelf.moviePlayer.currentItem.status == AVPlayerItemStatusUnknown) {
                //                [strongSelf playFinished];
                
            } else if (strongSelf.moviePlayer.currentItem.status == AVPlayerItemStatusFailed) {
                UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"播放视频失败" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alert show];
//                [CYAlertHandle showAlertMessage:@"播放失败"];
                //                [strongSelf playFinished];
                strongSelf.isPlaying = NO;
                
            }
            
        } else if (context == &PlayerItemLoadedTimeRangesContext) {
            __strongSelf(weakSelf);
            NSTimeInterval timeInterval = [strongSelf availableDuration];// 计算缓冲进度
            // 显示缓冲进度条
            CMTime duration = strongSelf.playerItem.duration;
            double totalDuration = CMTimeGetSeconds(duration);
            [strongSelf.playCommandView.bottomView.progressView setProgress:timeInterval / totalDuration animated:NO];
            
            // 缓存 大于 播放 当前时长+3
            if (timeInterval > strongSelf.getCurrentPlayingTime + 3 || (NSInteger)timeInterval == (NSInteger)totalDuration)
            {
                [strongSelf.moviePlayer play];
                [strongSelf stopLoadingAnimation];
                
            } else {
                
                [strongSelf startLoadingAnimation];
                
                [strongSelf.moviePlayer pause];
                
            }
            
        }
        
    });
    
    
}
#pragma mark -计算播放时长和缓存进度

/**
 *  返回 当前 视频 播放时长
 */
- (double)getCurrentPlayingTime {
    
    double currentTime = CMTimeGetSeconds(self.playerItem.currentTime);
    return currentTime;
    
}
/**
 *  返回 当前 视频 缓存时长
 */
- (NSTimeInterval)availableDuration {
    
    NSArray *loadedTimeRanges = [[self.moviePlayer currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    
    return result;
}

- (NSString*)updateTimeString
{
    NSTimeInterval currentTime = CMTimeGetSeconds(self.moviePlayer.currentItem.currentTime);
    NSTimeInterval duration = CMTimeGetSeconds(self.moviePlayer.currentItem.duration);
    return [self stringWithCurrentTime:currentTime duration:duration];
}
- (NSString *)stringWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration
{
    NSInteger dMin = duration / 60;
    NSInteger dSec = (NSInteger)duration % 60;
    NSInteger cMin = currentTime / 60;
    NSInteger cSec = (NSInteger)currentTime % 60;
    NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld", dMin, dSec];
    NSString *currentString = [NSString stringWithFormat:@"%02ld:%02ld", cMin, cSec];
    return [NSString stringWithFormat:@"%@/%@", currentString, durationString];
}

#pragma mark - 网络延迟时的加载动画

/**
 *  开始加载的动画
 */
- (void)startLoadingAnimation {
    
    self.animationImageView.hidden               = NO;
    self.animationImageView.animationImages      = self.animationImages;
    self.animationImageView.animationDuration    = 1.0f;
    self.animationImageView.animationRepeatCount = MAXFLOAT;
    [self.animationImageView startAnimating];
    [self.animationImages    removeAllObjects];
    self.animationImages                         = nil;
    
}
/**
 *  停止加载的动画
 */
- (void)stopLoadingAnimation {
    
    [self.animationImageView stopAnimating];
    self.animationImageView.animationImages = nil;
    self.animationImageView.hidden        = YES;
    
}

#pragma mark - 监听程序运行的状态

- (void)applicationWillResignActive:(UIApplication *)application {
    
    [self moviePlayerPauseWhenApplicationResignActive];
    
}
/**
 *  应用被强退
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    
    [self moviePlayerPauseWhenApplicationResignActive];
    
}

/**
 *  程序开始活跃
 */
- (void)applicationDidActive:(UIApplication *)application {
    
    [self moviePlayerPlayWhenApplicationDidActive];
    
}
/**
 *  程序进入后台后停止播放视频
 */
- (void)moviePlayerPauseWhenApplicationResignActive {
    
    [self.moviePlayer pause];
    self.moviePlayer.volume = 0.0f;
    [self.moviePlayer removeTimeObserver:self.timeObserver];
    self.playCommandView.bottomView.playButton.selected = YES;
    
}
/**
 *  当程序活跃时继续播放视频
 */
- (void)moviePlayerPlayWhenApplicationDidActive {
    
    [self.moviePlayer play];
    self.moviePlayer.volume = 1.0f;
    [self addPlayerProgressTimer];
    self.playCommandView.bottomView.playButton.selected = NO;
    [self.playCommandView showPlayerCommandView];
    
}

- (void)dealloc {
    
    [self removeMoviePlayerObserver];
    self.timeObserver = nil;

    NSLog(@"---- %s-----",__func__);
}


@end
