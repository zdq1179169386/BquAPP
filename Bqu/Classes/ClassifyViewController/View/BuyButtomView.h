//
//  BuyButtomView.h
//  Bqu
//
//  Created by yb on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
#import "AddAndCutBtn.h"
@interface BuyButtomView : UIView

/**商品model*/
@property (nonatomic,strong)ProductModel * product;

/**数量按钮*/
@property(nonatomic,strong)AddAndCutBtn * numberBtn;


/**数量*/
@property(nonatomic,copy)NSString * productCount;


+(instancetype)creatBuyButtomView;
/**确认购买弹出视图的block*/
@property(nonatomic,copy)void(^buyViewBlock)(UIButton * secledBtn);

@end
