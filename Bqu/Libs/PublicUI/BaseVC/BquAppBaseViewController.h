//
//  BquAppBaseViewController.h
//  Bqu
//
//  Created by yb on 15/11/27.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BquAppBaseViewController : UIViewController<NetWorkViewDelegate>


/**404页面*/
@property(nonatomic,strong)NetWorkView * netView;


/**<#description#>*/
@property(nonatomic,assign)BOOL IsHasNetwork;


-(void)hideNetWorkingView;

@end
