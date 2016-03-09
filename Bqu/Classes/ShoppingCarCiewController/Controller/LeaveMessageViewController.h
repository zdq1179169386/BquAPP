//
//  LeaveMessageViewController.h
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

// 买家留言页面

#import <UIKit/UIKit.h>
#import "ShopBaseViewController.h"

typedef void (^LeaveMessageBlock) (NSString *message);


@interface LeaveMessageViewController : ShopBaseViewController

//设置已经有的留言
-(void)setMessage:(NSString*)leaveMessage;

//设置回调
-(void)setBlock:(LeaveMessageBlock)block;
@end
