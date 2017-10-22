//
//  RealBackgroundTask.m
//  Mi
//
//  Created by hy on 15/7/11.
//  Copyright (c) 2015年 MiTech. All rights reserved.
//

#import "SWBackgroundTask.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface SWBackgroundTask(){
    __block UIBackgroundTaskIdentifier _bgTask;
    __block dispatch_block_t _expirationHandler;
    __block NSTimer * _timer;
    __block AVAudioPlayer *_player;
    
    //任务配置
    NSInteger _timerInterval;
    id _target;
    SEL _selector;
    
    //是否应该开始后台任务
    NSTimeInterval _startTime;
    ShouldRunBGTaskCallback _shouldRunBackgroundTask;
    
    NSURL * _soundFileURL;
}
@end


@implementation SWBackgroundTask

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(id)init {
    self = [super init];
    if (self) {
        [self onServiceInit];
    }
    return self;
}

- (void)onServiceInit{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sw_startBackgroundTasks) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sw_stopBackgroundTask) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
    _expirationHandler = nil;
    //init audio file
    const char bytes[] = {0x52, 0x49, 0x46, 0x46, 0x26, 0x0, 0x0, 0x0, 0x57, 0x41, 0x56, 0x45, 0x66, 0x6d, 0x74, 0x20, 0x10, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, 0x44, 0xac, 0x0, 0x0, 0x88, 0x58, 0x1, 0x0, 0x2, 0x0, 0x10, 0x0, 0x64, 0x61, 0x74, 0x61, 0x2, 0x0, 0x0, 0x0, 0xfc, 0xff};
    NSData* data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    
    // Build the path to the database file
    NSString * filePath = [[self getDocPath] stringByAppendingPathComponent: @"background.wav"];
    [data writeToFile:filePath atomically:YES];
    
    _soundFileURL = [NSURL fileURLWithPath:filePath];
    
    //默认为空任务
    _timerInterval = 60;
    _target = self;
    _selector = @selector(emptyTask);
}

-(NSString *) getDocPath {
    NSString * g_docPath = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    g_docPath = [[NSString alloc] initWithString:(NSString*)[paths objectAtIndex:0]];
    
    return g_docPath;
}

-(void)sw_shouldRunBackgroundTask:(ShouldRunBGTaskCallback)shouldRunBGTask{
    _shouldRunBackgroundTask = shouldRunBGTask;
}


-(void)sw_setBackgroundTask:(NSInteger)time sw_target:(id)target sw_selector:(SEL)selector{
    _timerInterval = time;
    _target = target;
    _selector = selector;
}

-(void)sw_startBackgroundTasks{
    _startTime = [[NSDate date] timeIntervalSince1970];
    if (_shouldRunBackgroundTask && _shouldRunBackgroundTask(_startTime)) {
        NSLog(@"[BGTASK] should start task, start now!");
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioInterrupted:) name:AVAudioSessionInterruptionNotification object:nil];
        [self playAudio];
    }else{
//        sw_LOG_INFO(@"[BGTASK] no need to start background task");
    }
}

-(void)audioInterrupted:(NSNotification*)notification {
//    sw_LOG_INFO(@"[BGTASK]audio play is interrupted, data=%@", notification.userInfo);
    
    id info = notification.userInfo;
    id interType = info[AVAudioSessionInterruptionTypeKey];
    
    //处理被中断的情况
    if ([interType isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]]) {
//        sw_LOG_INFO(@"[BGTASK] interrupt begin, stop audio now");
        [self stopAudio];
    }else if([interType isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeEnded]]){
//        sw_LOG_INFO(@"[BGTASK] interrupt ended, play audio now");
        [self playAudio];
    }
}

-(void) playAudio
{
    _bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:_expirationHandler];
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        NSError * error;
       
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error: &error];
            
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_soundFileURL error:&error];
        _player.volume = 0.01;
//        _player.numberOfLoops = -1; //Infinite
        _player.numberOfLoops = 0;
        [_player prepareToPlay];
        [_player play];
        
        if(_timer && [_timer isValid]){
            [_timer invalidate];
            _timer = nil;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timerInterval target:_target selector:_selector userInfo:nil repeats:YES];
    });
}

-(void) emptyTask {
    double remainingTime =  [[UIApplication sharedApplication] backgroundTimeRemaining ];
    NSLog(@"background time remaining:%lf", remainingTime);
    
    if (_shouldRunBackgroundTask && !_shouldRunBackgroundTask(_startTime)) {
        [self sw_stopBackgroundTask];
    }else {
        
        //检查是否有足够的后台执行时间，不足则重新开始音乐播放
        if(remainingTime <= _timerInterval ){
            [self playAudio];
        }
    }
}

-(void) stopAudio
{
    if (_timer && [_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
    
    if( _player && [_player isPlaying]){
        [_player stop];
    }
    
    if(_bgTask != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:_bgTask];
        _bgTask=UIBackgroundTaskInvalid;
    }
}
-(BOOL) running
{
    if(_bgTask == UIBackgroundTaskInvalid)
        return FALSE;
    return TRUE;
}

-(void)sw_stopBackgroundTask
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:nil];
    [self stopAudio];
}
@end