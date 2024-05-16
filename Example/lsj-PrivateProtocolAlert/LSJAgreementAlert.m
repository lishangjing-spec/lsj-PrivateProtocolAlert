//
//  LSJAgreementAlert.m
//  NGCrazyTranslator
//
//  Created by Lishangjing on 2021/3/29.
//  Copyright © 2021 liuny. All rights reserved.
//

#import "LSJAgreementAlert.h"

@interface LSJAgreementAlertTextView : UITextView

@end

@implementation LSJAgreementAlertTextView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return NO;
    }
    
    if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
        UITapGestureRecognizer *tapGestureRecognizer = (UITapGestureRecognizer *)gestureRecognizer;
        if (tapGestureRecognizer.numberOfTapsRequired > 1) {
            return NO;
        }
    }
    
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}


@end


@interface LSJAgreementAlert()<UITextViewDelegate>

@property (nonatomic,strong) UIView *maskView;/**< 背景蒙版 */

@property (nonatomic,strong) UIView *alertContainerView;/**< 弹窗背景 */
@property (nonatomic,strong) UILabel *titleLabel;/**< 弹窗标题 */
@property (nonatomic,strong) LSJAgreementAlertTextView *textView;/**< 内容 */
@property (nonatomic,strong) UIButton *cancelButton;/**< 取消 */
@property (nonatomic,strong) UIButton *sureButton;/**< 同意 */

@property (nonatomic,strong) UIView *lineView1;
@property (nonatomic,strong) UIView *lineView2;

@end

@implementation LSJAgreementAlert

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupAddSubView];
    }
    return self;
}

// MARK: - Public Method

- (void)show:(UIView *)view{
    [self removeFromSuperview];
    
    self.frame = view.bounds;
    [view addSubview:self];
    [self setupLayout];
}

// MARK: - Private Method

- (void)hidden{
    [self removeFromSuperview];
}

- (void)cancelButtonClick{
    [self hidden];
    
    if(_delegate && [_delegate respondsToSelector:@selector(lsjAgreementAlert_cancelClick)]){
        [self.delegate lsjAgreementAlert_cancelClick];
    }
}

- (void)sureButtonClick{
    [self hidden];
    
    if (_delegate && [_delegate respondsToSelector:@selector(lsjAgreementAlert_sureClick)]) {
        [self.delegate lsjAgreementAlert_sureClick];
    }
}

// MARK: - Layout

- (void)setupAddSubView{
    [self addSubview:self.maskView];
    [self addSubview:self.alertContainerView];
    [self.alertContainerView addSubview:self.titleLabel];
    [self.alertContainerView addSubview:self.textView];
    [self.alertContainerView addSubview:self.cancelButton];
    [self.alertContainerView addSubview:self.sureButton];
    [self.alertContainerView addSubview:self.lineView1];
    [self.alertContainerView addSubview:self.lineView2];
}

- (void)setupLayout{
    
    self.maskView.frame = self.bounds;
    
    CGFloat lineHeight = 1.0/[UIScreen mainScreen].scale;
    
    CGFloat containerViewW = 310;
    CGFloat containerViewH = 160;
    self.alertContainerView.frame = CGRectMake((self.frame.size.width-containerViewW) / 2.0, (self.frame.size.height-containerViewH) / 2.0, containerViewW, containerViewH);
    
    self.titleLabel.frame = CGRectMake(0, 15, self.titleLabel.superview.frame.size.width, 22);
    
    self.textView.frame = CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame) + 30, containerViewW - 20, 20);
    
    self.cancelButton.frame = CGRectMake(0, containerViewH - 44, containerViewW / 2.0, 44);
    
    self.sureButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), self.cancelButton.frame.origin.y, CGRectGetWidth(self.cancelButton.frame), CGRectGetHeight(self.cancelButton.frame));
    
    self.lineView1.frame = CGRectMake(0, CGRectGetMinY(self.cancelButton.frame) - lineHeight, containerViewW, lineHeight);
    
    self.lineView2.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMinY(self.cancelButton.frame), lineHeight, CGRectGetHeight(self.cancelButton.frame));
}

// MARK: - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    if ([URL.scheme isEqualToString:@"userAgreement"]) {
        if(_delegate && [_delegate respondsToSelector:@selector(lsjAgreementAlert_userAgreementClick)]){
            [_delegate lsjAgreementAlert_userAgreementClick];
        }
        return false;
    }else if([URL.scheme isEqualToString:@"privacy"]){
        if(_delegate && [_delegate respondsToSelector:@selector(lsjAgreementAlert_privacyPolicyClick)]){
            [_delegate lsjAgreementAlert_privacyPolicyClick];
        }
        return false;
    }
    return true;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    textView.selectedRange = NSMakeRange(0, 0);
}


// MARK: - Lazy

- (UIView *)alertContainerView{
    if (!_alertContainerView) {
        _alertContainerView = [UIView new];
        _alertContainerView.backgroundColor = [UIColor whiteColor];
        _alertContainerView.layer.cornerRadius = 15;
        _alertContainerView.userInteractionEnabled = true;
    }
    return _alertContainerView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        _titleLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"同意隐私条款";
    }
    return _titleLabel;
}


- (LSJAgreementAlertTextView *)textView{
    if (!_textView) {
        _textView = [LSJAgreementAlertTextView new];
        _textView.editable = NO;// 可编辑的
        _textView.selectable = TRUE;// 可选的
        _textView.scrollEnabled = NO;
        _textView.textContainerInset = UIEdgeInsetsZero;
        _textView.textContainer.lineFragmentPadding = 0;
        
        UIColor *highlightColor = [UIColor colorWithRed:47.0/255.0 green:74.0/255.0 blue:254.0/255.0 alpha:1];
        _textView.linkTextAttributes = @{NSForegroundColorAttributeName:highlightColor};
        _textView.delegate = self;
        _textView.userInteractionEnabled = true;
        _textView.backgroundColor = [UIColor whiteColor];
        
        NSString *contentString = @"阅读并同意《用户协议》及《隐私政策》";
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
        UIColor *nomalTextColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];;
        [attrString addAttribute:NSForegroundColorAttributeName value:nomalTextColor range:[contentString rangeOfString:contentString]];
        [attrString addAttribute:NSStrokeColorAttributeName value:nomalTextColor range:[contentString rangeOfString:contentString]];
        [attrString addAttribute:NSStrokeWidthAttributeName value:@0 range:[contentString rangeOfString:contentString]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 4;// 字体的行间距
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:[contentString rangeOfString:contentString]];
        NSRange range1 = [contentString rangeOfString:@"《用户协议》"];
        NSRange range2 = [contentString rangeOfString:@"《隐私政策》"];
        [attrString addAttribute:NSLinkAttributeName value:@"userAgreement://" range:range1];
        [attrString addAttribute:NSLinkAttributeName value:@"privacy://" range:range2];
        
        _textView.attributedText = attrString;
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.textAlignment = NSTextAlignmentCenter;
    }
    return _textView;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton new];
        [_cancelButton setTitle:@"不同意" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [UIButton new];
        [_sureButton setTitle:@"我同意" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor colorWithRed:47.0/255.0 green:74.0/255.0 blue:254.0/255.0 alpha:1] forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _sureButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIView *)lineView1{
    if (!_lineView1) {
        _lineView1 = [UIView new];
        _lineView1.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:0.8];
    }
    return _lineView1;
}

- (UIView *)lineView2{
    if (!_lineView2) {
        _lineView2 = [UIView new];
        _lineView2.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:0.8];
    }
    return _lineView2;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [UIView new];
        _maskView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _maskView.userInteractionEnabled = true;
        [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonClick)]];
    }
    return _maskView;
}

@end
