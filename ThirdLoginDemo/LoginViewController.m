//
//  LoginViewController.m
//  ThirdLoginDemo
//
//  Created by 仙女🎀 on 2018/3/28.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "LoginViewController.h"
#import "WXApi.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

#define APPID @"wxd930ea5d5a258f4f"
#define SECRET @"secret"

@interface LoginViewController ()<WXDelegate> {
    AppDelegate *appDele;
}

@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([WXApi isWXAppInstalled]) {
        self.wxBtn.hidden = NO;
    } else {
        self.wxBtn.hidden = YES;
    }
}

//
- (IBAction)wechatLogin:(id)sender {
    SendAuthReq *rep = [[SendAuthReq alloc] init];
    rep.scope = @"snsapi_userinfo";
    rep.openID = APPID;
    rep.state = @"123";
    appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDele.wxDelegate = self;
    
    [WXApi sendReq:rep];
//    if ([WXApi isWXAppInstalled]) {//已安装微信
//    } else {
//        //没安装微信，隐藏登录按钮
//    }
}

//
- (IBAction)qqLogin:(id)sender {
    
}

#pragma mark -- wechat
- (void)loginSuccessByCode:(NSString *)code {
    __weak typeof (*&self) weakSelf = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json",@"text/plain", nil];
    
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", APPID, SECRET, code];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", dic);
        
        [weakSelf requestUserInfoByToken:[dic valueForKey:@"access_token"] openId:[dic valueForKey:@"openid"]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@", error.localizedDescription);
    }];
}

- (void)requestUserInfoByToken:(NSString *)token openId:(NSString *)openId {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", token, openId];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"");
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@", error.localizedDescription);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
