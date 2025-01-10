//
//  PrivateProtocolAlert.m
//  lsj-PrivateProtocolAlert
//
//  Created by Lishangjing on 2021/3/29.
//  Copyright © 2021 liuny. All rights reserved.
//

#import "LSJPrivateProtocolAlert.h"
#import <SafariServices/SafariServices.h>

#define LSJPrivateProtocolAlertUserDefaultsKey @"lsj-PrivateProtocolStandard"

@interface LSJPrivateProtocolAlert()<UITextViewDelegate>

@property (nonatomic,strong) UIView *maskView;/**< 蒙板 */
@property (nonatomic,strong) UIView *containerView;/**< 弹窗容器 */
@property (nonatomic,strong) UITextView *descLabel;/**< 详细描述文本 */
@property (nonatomic,strong) UIButton *cancelButton;/**< 取消按钮 */

@end

@implementation LSJPrivateProtocolAlert

- (instancetype)init{
    self = [super init];
    if(self){
        self.nomalTextColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        self.highlightColor = [UIColor colorWithRed:74.0/255.0 green:144.0/255.0 blue:226.0/255.0 alpha:1];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        self.appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        self.sureButton.layer.masksToBounds = true;
        self.sureButton.layer.cornerRadius = self.sureButton.frame.size.height/2.0;
        self.sureButton.backgroundColor = [UIColor colorWithRed:83.0/255.0 green:162/255.0 blue:255.0/255.0 alpha:1];
    }
    return self;
}

-(void)dealloc{
#if DEBUG
    NSLog(@"%s",__func__);
#endif
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
    self.maskView.frame = self.view.frame;
    
    // Container View
    [self.view addSubview:self.containerView];
    CGFloat containerViewW = 310;
    CGFloat containerViewH = 320;
    self.containerView.frame = CGRectMake((self.view.frame.size.width-containerViewW) / 2.0, (self.view.frame.size.height-containerViewH) / 2.0, containerViewW, containerViewH);
        
    // Desc Label
    [self.containerView addSubview:self.descLabel];
    CGFloat descLabelW = 270;
    self.descLabel.frame = CGRectMake(20, 24, descLabelW, 180);
    
    // Sure Button
    [self.containerView addSubview:self.sureButton];
    self.sureButton.frame = CGRectMake(20, CGRectGetMaxY(self.descLabel.frame) + 15, 270, 40);
        
    // Cancel Button
    [self.containerView addSubview:self.cancelButton];
    self.cancelButton.frame = CGRectMake(20, CGRectGetMaxY(self.sureButton.frame) + 5, 270, 40);
    
}


// MARK: - Method

-(bool)show{
    NSString *guide = [[NSUserDefaults standardUserDefaults] objectForKey:LSJPrivateProtocolAlertUserDefaultsKey];
    if(guide){
        if(_delegate && [_delegate respondsToSelector:@selector(lsjPrivateProtocolAlert_completion)]){
            [_delegate lsjPrivateProtocolAlert_completion];
        }
    }else{
        [UIApplication sharedApplication].delegate.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
        [UIApplication sharedApplication].delegate.window.backgroundColor = [UIColor whiteColor];
        [UIApplication sharedApplication].delegate.window.rootViewController = self;
    }
    return !guide;
}


-(void)cancelButtonClick{
    abort();
}

-(void)sureButtonClick{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:LSJPrivateProtocolAlertUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(_delegate && [_delegate respondsToSelector:@selector(lsjPrivateProtocolAlert_completion)]){
        [_delegate lsjPrivateProtocolAlert_completion];
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

-(UITextView *)descLabel{
    if (!_descLabel) {
        _descLabel = [UITextView new];
        _descLabel.editable = NO;// 可编辑的
        _descLabel.selectable = YES;// 可选的
        _descLabel.scrollEnabled = NO;
        _descLabel.textContainerInset = UIEdgeInsetsZero;
        _descLabel.textContainer.lineFragmentPadding = 0;
        _descLabel.linkTextAttributes = @{NSForegroundColorAttributeName:self.highlightColor};
        _descLabel.delegate = self;
        _descLabel.userInteractionEnabled = true;
        _descLabel.backgroundColor = [UIColor whiteColor];
        
        NSString *contentString = [NSString stringWithFormat:@"%@深知个人信息对您的重要性，因此我们将竭尽全力保障用户的隐私信息安全。\n\n您可以阅读完整版《用户协议》《隐私政策》详细了解我们如何保护您的权益。\n\n我们将严格按照政策要求使用和保护您的个人信息，如您同意以上内容，请点击同意，开始使用我们的产品与服务！",self.appName];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
        
        @try {
            [attrString addAttribute:NSForegroundColorAttributeName value:self.nomalTextColor range:[contentString rangeOfString:contentString]];
            [attrString addAttribute:NSStrokeColorAttributeName value:self.nomalTextColor range:[contentString rangeOfString:contentString]];
            [attrString addAttribute:NSStrokeWidthAttributeName value:@0 range:[contentString rangeOfString:contentString]];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 4;// 字体的行间距
            [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:[contentString rangeOfString:contentString]];
            NSRange range1 = [contentString rangeOfString:@"《用户协议》"];
            NSRange range2 = [contentString rangeOfString:@"《隐私政策》"];
            
            [attrString addAttribute:NSLinkAttributeName value:@"userAgreement://" range:range1];
            [attrString addAttribute:NSLinkAttributeName value:@"privacy://" range:range2];
            

        } @catch (NSException *exception) {
            // 兜底，若因为 iOS 系统api崩溃，则不处理，直接返回文字
        } @finally {
                
        }
        
        _descLabel.attributedText = attrString;
        _descLabel.font = [UIFont systemFontOfSize:13];
    }
    return _descLabel;
}


-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    if ([URL.scheme isEqualToString:@"userAgreement"]) {
        if(_delegate && [_delegate respondsToSelector:@selector(lsjPrivateProtocolAlert_userAgreementClick)]){
            [_delegate lsjPrivateProtocolAlert_userAgreementClick];
        }else{
            SFSafariViewController * safariVC = [[SFSafariViewController alloc]initWithURL:self.userAgreementURL];
            [self presentViewController:safariVC animated:NO completion:nil];
        }
        return false;
    }else if([URL.scheme isEqualToString:@"privacy"]){
        if(_delegate && [_delegate respondsToSelector:@selector(lsjPrivateProtocolAlert_privacyPolicyClick)]){
            [_delegate lsjPrivateProtocolAlert_privacyPolicyClick];
        }else{
            SFSafariViewController * safariVC = [[SFSafariViewController alloc]initWithURL:self.privacyPolicyURL];
            [self presentViewController:safariVC animated:NO completion:nil];
        }
        return false;
    }
    return true;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

-(UIButton *)sureButton{
    if(!_sureButton){
        _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 270, 40)];
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
