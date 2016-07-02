//
//  CYMovieViewController.m
//  Junengwan
//
//  Created by 董招兵 on 16/7/1.
//  Copyright © 2016年 上海触影文化传播有限公司. All rights reserved.
//

#import "CYMovieViewController.h"

#import "CYMoviePlayerHorizontalView.h"

@interface CYMovieViewController () <CYMoviePlayerHorizontalViewDelegate>


/**
 *  视频播放器的 view
 */
@property (nonatomic,strong) CYMoviePlayerHorizontalView *moviePlayerView;

@end

@implementation CYMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
}

/**
 *  初始化工作
 */
- (void)setup {
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.moviePlayerView];
    __weakSelf(self);
    [self.moviePlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strongSelf(weakSelf);
        make.edges.equalTo(strongSelf.view);
    }];
    
}
- (CYMoviePlayerHorizontalView *)moviePlayerView {
    if (!_moviePlayerView) {
        _moviePlayerView          = [CYMoviePlayerHorizontalView new];
        _moviePlayerView.playUrl  = [NSURL URLWithString:@"http://7xnujb.com2.z0.glb.qiniucdn.com/zczs02%2Fsj2-001.mp4"];
        _moviePlayerView.delegate = self;
    }
    return _moviePlayerView;
}


/**
 *  返回按钮的点击事件
 */
- (void)cyMoviePlayerHorizontalViewDidSelectBackButton:(CYMoviePlayerHorizontalView *_Nullable)playerHorizontalView {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (void)dealloc {
    
    NSLog(@"---- %s-----",__func__);

}

@end
