//
//  AppDelegate.h
//  ThirdLoginDemo
//
//  Created by 仙女🎀 on 2018/3/28.
//  Copyright © 2018年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WXDelegate <NSObject>

-(void)loginSuccessByCode:(NSString *)code;
-(void)shareSuccessByCode:(int) code;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, weak) id<WXDelegate> wxDelegate;

@end

