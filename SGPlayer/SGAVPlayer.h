//
//  SGAVPlayer.h
//  gjb
//
//  Created by 红点 on 2018/3/29.
//  Copyright © 2018年 王梦辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGPlayerStatusModel.h"
#import <AVKit/AVKit.h>
//播放状态改变时调用
 typedef void(^PlayStausChange)(SGPlayerStatusModel *model);
@interface SGAVPlayer : NSObject
//不自动播放（默认自动播放）
@property (nonatomic, assign) BOOL notStartPlay;
//播放状态model
@property (nonatomic, strong) SGPlayerStatusModel *statusModel;
//player
@property (nonatomic, strong) AVPlayer *player;

//播放状态改变block
@property (nonatomic, copy) PlayStausChange playStausChange;

+(instancetype) shareWithPlayer;
//初始化
- (void)initWithPlayerWithUrl:(NSString *)url WithPlayStausChangeBllock:(PlayStausChange)block;

- (void)play;
- (void)pause;
@end
