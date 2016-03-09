//
//  GoodsDetailViewController.h
//  Bqu
//
//  Created by yb on 15/10/12.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ClassifyBaseViewController.h"

typedef enum {
       IsTheOne = 0,
       IsTheTwo = 1,
       IsTheThree = 2,
}BtnType;

@interface GoodsDetailViewController : ClassifyBaseViewController

/**商品的id*/
@property (nonatomic,copy)NSString * productId;

@property (nonatomic,assign)BtnType btnType;
@end
