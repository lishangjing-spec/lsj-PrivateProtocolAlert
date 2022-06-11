//
//  PrivateProtocolAlert.m
//  JMBaseProject
//
//  Created by Lishangjing on 2021/3/29.
//  Copyright © 2021 liuny. All rights reserved.
//

#import "LSJPrivateProtocolAlert.h"
#import "Masonry.h"
#import "YYLabel.h"
#import "NSAttributedString+YYText.h"
#import <SafariServices/SafariServices.h>

#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;
#define LSJPrivateProtocolAlertUserDefaultsKey @"lsj-PrivateProtocolStandard"

@interface LSJPrivateProtocolAlert()

@property (nonatomic,strong) UIView *maskView;/**< 蒙板 */
@property (nonatomic,strong) UIView *containerView;/**< 弹窗容器 */
@property (nonatomic,strong) UILabel *titleLabel;/**< 弹窗 Title */
@property (nonatomic,strong) YYLabel *descLabel;/**< 详细描述文本 */
@property (nonatomic,strong) UIButton *cancelButton;/**< 取消按钮 */

@end

@implementation LSJPrivateProtocolAlert

- (instancetype)init{
    self = [super init];
    if(self){
        self.nomalTextColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        self.highlightColor = [UIColor colorWithRed:74.0/255.0 green:144.0/255.0 blue:226.0/255.0 alpha:1];
        self.userAgreementURL = [NSURL URLWithString:@"https://www.jianshu.com"];
        self.privacyPolicyURL = [NSURL URLWithString:@"https://www.juejin.com"];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        self.appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        self.sureButton.layer.masksToBounds = true;
        self.sureButton.layer.cornerRadius = self.sureButton.frame.size.height/2.0;
        self.sureButton.backgroundColor = [UIColor colorWithRed:83.0/255.0 green:162/255.0 blue:255.0/255.0 alpha:1];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupLayout];
}


// MARK: - Layout


-(void)setupLayout{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Mask View
    [self.view addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // Container View
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(310);
    }];
    
    // Title Label
    [self.containerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView);
        make.top.equalTo(self.containerView.mas_top).offset(24);
    }];
    
    // Desc Label
    [self.containerView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.containerView.mas_left).offset(20);
        make.right.equalTo(self.containerView.mas_right).offset(-20);
    }];
    
    // Sure Button
    [self.containerView addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(30.0);
        make.centerX.equalTo(self.containerView);
    }];
    
    // Cancel Button
    [self.containerView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.sureButton);
        make.top.equalTo(self.sureButton.mas_bottom).offset(5);
        make.centerX.equalTo(self.sureButton);
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-10);
    }];
    
}


// MARK: - Method

-(void)show{
    NSString *guide = [[NSUserDefaults standardUserDefaults] objectForKey:LSJPrivateProtocolAlertUserDefaultsKey];
    if(guide){
        if(self.completionBlock){
            self.completionBlock();
        }   
    }else{
        [UIApplication sharedApplication].delegate.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
        [UIApplication sharedApplication].delegate.window.backgroundColor = [UIColor whiteColor];
        [UIApplication sharedApplication].delegate.window.rootViewController = self;
    }
}


-(void)cancelButtonClick{
    abort();
}

-(void)sureButtonClick{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:LSJPrivateProtocolAlertUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(self.completionBlock){
        self.completionBlock();
    }
}


// MARK: - Lazy
-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [UIView new];
        _maskView.userInteractionEnabled = true;
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.4;
    }
    return _maskView;
}

-(UIView *)containerView{
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 10;
        _containerView.layer.masksToBounds = true;
    }
    return _containerView;
}

-(UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [UILabel new];
    }
    return _titleLabel;
}

-(YYLabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [YYLabel new];
        _descLabel.preferredMaxLayoutWidth = 270;
        _descLabel.numberOfLines = 0;
        
        
        NSString *contentString = [NSString stringWithFormat:@"%@深知个人信息对您的重要性，因此我们将竭尽全力保障用户的隐私信息安全。\n\n您可以阅读完整版《用户协议》《隐私政策》详细了解我们如何保护您的权益。\n\n我们将严格按照政策要求使用和保护您的个人信息，如您同意以上内容，请点击同意，开始使用我们的产品与服务！",self.appName];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
        [attrString addAttribute:NSForegroundColorAttributeName value:self.nomalTextColor range:[contentString rangeOfString:contentString]];
        [attrString addAttribute:NSStrokeColorAttributeName value:self.nomalTextColor range:[contentString rangeOfString:contentString]];
        [attrString addAttribute:NSStrokeWidthAttributeName value:@0 range:[contentString rangeOfString:contentString]];

        NSRange range1 = [contentString rangeOfString:@"《用户协议》"];
        NSRange range2 = [contentString rangeOfString:@"《隐私政策》"];
        
        kWeakSelf(self);
        [attrString yy_setTextHighlightRange:range1 color:self.highlightColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            kStrongSelf(self);
            if(self.userAgreementClickBlock){
                self.userAgreementClickBlock();
            }else{
                SFSafariViewController * safariVC = [[SFSafariViewController alloc]initWithURL:self.userAgreementURL];
                [self presentViewController:safariVC animated:NO completion:nil];
            }
        }];
        
        [attrString yy_setTextHighlightRange:range2 color:self.highlightColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            kStrongSelf(self);
            if(self.privacyPolicyClickBlock){
                self.privacyPolicyClickBlock();
            }else{
                SFSafariViewController * safariVC = [[SFSafariViewController alloc]initWithURL:self.privacyPolicyURL];
                [self presentViewController:safariVC animated:NO completion:nil];
            }
        }];
        [attrString yy_setLineSpacing:5 range:NSMakeRange(0, contentString.length)];
        
        _descLabel.attributedText = attrString;
        _descLabel.font = [UIFont systemFontOfSize:13];
    }
    return _descLabel;
}

-(UIButton *)sureButton{
    if(!_sureButton){
        CGSize size = CGSizeMake(270, 40);
        _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
                
        [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(size.width, size.height));
        }];
        
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_sureButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sureButton setTitle:@"同意，继续使用" forState:UIControlStateNormal];
    }
    return _sureButton;
}



-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton new];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitle:@"不同意，退出" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_cancelButton setTitleColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:.7] forState:UIControlStateNormal];
    }
    return _cancelButton;
}

@end
