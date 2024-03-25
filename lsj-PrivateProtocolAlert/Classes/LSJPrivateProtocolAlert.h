//
//  PrivateProtocolAlert.h
//  lsj-PrivateProtocolAlert
//
//  Created by Lishangjing on 2021/3/29.
//  Copyright © 2021 liuny. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN


@protocol LSJPrivateProtocolAlertDelegate <NSObject>

@required

/// 完成
- (void)lsjPrivateProtocolAlert_completion;

@optional

/// 自定义用户协议、隐私政策点击事件
- (void)lsjPrivateProtocolAlert_userAgreementClick;
- (void)lsjPrivateProtocolAlert_privacyPolicyClick;

@end

@interface LSJPrivateProtocolAlert : UIViewController

@property (nonatomic, weak) id<LSJPrivateProtocolAlertDelegate> delegate;

// 自定义确定按钮的样式
@property (nonatomic,strong) UIButton *sureButton;/**< 确认按钮 */

@property (nonatomic,strong) NSString *appName;/**< 设置应用名称  Default: [[NSBundle mainBundle] infoDictionary]*/
@property (nonatomic,strong) UIColor *nomalTextColor;/**<  设置文字颜色 Default: 333333 */
@property (nonatomic,strong) UIColor *highlightColor;/**<  设置《用户协议》《隐私政策》颜色 Default: 4A90E2 */


// MARK: 隐私政策

// 设置 URL
@property (nonatomic,strong) NSURL *userAgreementURL;/**< 用户协议地址 */
@property (nonatomic,strong) NSURL *privacyPolicyURL;/**< 隐私政策地址 */



-(void)show;/**< 显示弹窗 */

@end

NS_ASSUME_NONNULL_END
