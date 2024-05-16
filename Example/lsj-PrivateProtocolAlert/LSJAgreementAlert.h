//
//  LSJAgreementAlert.h
//  lsj-PrivateProtocolAlert
//
//  Created by Lishangjing on 2021/3/29.
//  Copyright © 2021 liuny. All rights reserved.
//


@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@protocol LSJAgreementAlertDelegate <NSObject>

@required

/// 同意
- (void)lsjAgreementAlert_sureClick;

@optional

/// 取消
- (void)lsjAgreementAlert_cancelClick;

/// 自定义用户协议、隐私政策点击事件
- (void)lsjAgreementAlert_userAgreementClick;
- (void)lsjAgreementAlert_privacyPolicyClick;

@end

@interface LSJAgreementAlert : UIView

@property (nonatomic, weak) id<LSJAgreementAlertDelegate> delegate;

- (void)show:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
