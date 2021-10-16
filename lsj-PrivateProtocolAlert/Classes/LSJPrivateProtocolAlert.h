//
//  PrivateProtocolAlert.h
//  JMBaseProject
//
//  Created by 温州天媒软件 on 2021/3/29.
//  Copyright © 2021 liuny. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface LSJPrivateProtocolAlert : UIViewController

@property (nonatomic,strong) NSString *appName;
@property (nonatomic,strong) UIColor *nomalTextColor;
@property (nonatomic,strong) UIColor *highlightColor;


// MARK: 隐私政策
// 设置 URL
@property (nonatomic,strong) NSURL *userAgreementURL;
@property (nonatomic,strong) NSURL *privacyPolicyURL;
// 或者自定义事件
@property (copy, nonatomic) void(^userAgreementClickBlock)(void);
@property (copy, nonatomic) void(^privacyPolicyClickBlock)(void);

// 完成事件
@property (copy, nonatomic) void(^completionBlock)(void);


-(void)show;

@end

NS_ASSUME_NONNULL_END
