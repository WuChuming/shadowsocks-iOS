//
//  RunInBackground.h
//  audioBg
//
//  Created by niu_o0 on 2017/9/1.
//  Copyright © 2017年 niu_o0. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunInBackground : NSObject

+ (instancetype)sharedBg;

// 调用此方法后，程序进入后台也不会死掉
- (void)startRunInbackGround;

// 停止播放音乐
- (void)stopAudioPlay;
@end


