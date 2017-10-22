//
//  RealBackgroundTask.h
//  Mi
//
//  Created by hy on 15/7/11.
//  Copyright (c) 2015年 MiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL (^ShouldRunBGTaskCallback)(NSTimeInterval);

@interface SWBackgroundTask : NSObject

//设置后台运行任务，供后台定时执行的target和selector，目前未使用
-(void)sw_setBackgroundTask:(NSInteger)time sw_target:(id)target sw_selector:(SEL)selector;

//是否应该（继续）运行后台任务的回调block，会定时调用，如果Block返回NO，则停止后台任务
-(void)sw_shouldRunBackgroundTask:(ShouldRunBGTaskCallback)shouldRunBGTask;

//启动后台任务
-(void)sw_startBackgroundTasks;

//停止后台任务
-(void)sw_stopBackgroundTask;

@end
