//
//  SGAVPlayer.m
//  gjb
//
//  Created by 红点 on 2018/3/29.
//  Copyright © 2018年 王梦辉. All rights reserved.
//

#import "SGAVPlayer.h"
@interface SGAVPlayer()
@property (nonatomic, strong) AVPlayerItem *songItem;
//视频总时长
@property (assign, nonatomic) float totalTime;

//当前播放时长
@end

@implementation SGAVPlayer
+(instancetype) shareWithPlayer{
    static SGAVPlayer *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[SGAVPlayer alloc] init];
    });
    return player;
}

- (void)initWithPlayerWithUrl:(NSString *)url WithPlayStausChangeBllock:(PlayStausChange)block {
    self.playStausChange = block;
    NSURL * urlstr  = [NSURL URLWithString:url];
    self.statusModel = [[SGPlayerStatusModel alloc] init];
    //移除观察者
    [self.songItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.songItem removeObserver:self forKeyPath:@"status"];
    //媒体加载状态
    self.songItem = [[AVPlayerItem alloc]initWithURL:urlstr];
    self.player = [[AVPlayer alloc]initWithPlayerItem:self.songItem];
    //播放时间改变时调用
     __weak __typeof(self) weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //当前播放的时间
        NSTimeInterval current = CMTimeGetSeconds(time);
        self.statusModel.playTime = current;
        //视频的总时间
        NSTimeInterval total = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
        //当前进度
        weakSelf.statusModel.playProcess = current/total;
        self.playStausChange(self.statusModel);
    }];
    
    //媒体加载状态
    [self.songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //数据缓冲状态
    [self.songItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    if (@available(iOS 10.0, *)) {
        self.player.automaticallyWaitsToMinimizeStalling = NO;
    } else {
    }
    //自动播放
    if (!self.notStartPlay) {
        //开始播放
        [self play];
    }
    //不自动锁屏
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

//播放
- (void)play {
    [self.player play];
}

//暂停
- (void)pause {
    [self.player pause];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@" self.statusModel====%f",self.statusModel.playProcess);
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown:
                break;
            case AVPlayerStatusReadyToPlay:{
             self.statusModel.totalTime = CMTimeGetSeconds(self.songItem.duration);
            }
                break;
            case AVPlayerStatusFailed:
                break;
            default:
                break;
        }
    }
    //数据缓冲状态
    AVPlayerItem * songItem = object;
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray * array = songItem.loadedTimeRanges;
        //本次缓冲的时间范围
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        //缓冲总长度
        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
        //缓冲比
        self.statusModel.bufferProcess = totalBuffer/self.statusModel.totalTime;
        self.playStausChange(self.statusModel);
    }
}


@end
