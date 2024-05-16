//
//  LSJViewController.m
//  lsj-PrivateProtocolAlert
//
//  Created by lsj on 10/15/2021.
//  Copyright (c) 2021 lsj. All rights reserved.
//

#import "LSJViewController.h"
#import "LSJAgreementAlert.h"


@interface LSJViewController ()<LSJAgreementAlertDelegate>

@property (nonatomic,strong) UIButton *loginButton;

@property (nonatomic,strong) LSJAgreementAlert *agrementAlert;

@end

@implementation LSJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.loginButton];
    self.loginButton.frame = CGRectMake((self.view.frame.size.width - 100) / 2.0, (self.view.frame.size.height - 44) / 2.0, 100, 44);
}

// MARK: - Delegate

- (void)lsjAgreementAlert_sureClick{
    // TODO: 用户已同意，程序可自动勾选上隐私checkBox按钮
    // TODO: 递归调用登录 Function，再次检查登录参数
    NSLog(@"%s", __func__);
}

- (void)lsjAgreementAlert_cancelClick{
    NSLog(@"%s", __func__);
}

- (void)lsjAgreementAlert_privacyPolicyClick{
    // TODO: 跳转隐私政策地址
    NSLog(@"%s", __func__);
}

- (void)lsjAgreementAlert_userAgreementClick{
    // TODO: 跳转用户协议地址
    NSLog(@"%s", __func__);
}

// MARK: - Method

- (void)loginButtonClick{
    [self.agrementAlert show:self.view];
}

// MARK: - Lazy

- (UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [UIButton new];
        _loginButton.backgroundColor = [UIColor blackColor];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (LSJAgreementAlert *)agrementAlert{
    if (!_agrementAlert) {
        _agrementAlert = [LSJAgreementAlert new];
        _agrementAlert.delegate = self;
    }
    return _agrementAlert;
}

@end
