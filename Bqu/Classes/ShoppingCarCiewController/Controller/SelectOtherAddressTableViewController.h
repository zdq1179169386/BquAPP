//
//  SelectOtherAddressTableViewController.h
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

// 选择其他收获地址页面

#import <UIKit/UIKit.h>
#import "AddressModel.h"
#import "ShopBaseViewController.h"

typedef void(^SelectOtherAddressBlock)(AddressModel*);

@interface SelectOtherAddressTableViewController : ShopBaseViewController

-(void)setBlock:(SelectOtherAddressBlock)block;
@end
