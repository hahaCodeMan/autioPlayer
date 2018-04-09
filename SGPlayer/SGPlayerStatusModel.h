//
//  SGPlayerStatusModel.h
//  gjb
//
//  Created by 红点 on 2018/3/29.
//  Copyright © 2018年 王梦辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGPlayerStatusModel : NSObject
//视频总的长度
@property (nonatomic, assign) NSTimeInterval totalTime;
//当前播放长度
@property (nonatomic, assign) NSTimeInterval playTime;
//当前播放进度
@property (nonatomic, assign) CGFloat playProcess;
//当前缓冲进度
@property (nonatomic, assign) CGFloat bufferProcess;
@end
