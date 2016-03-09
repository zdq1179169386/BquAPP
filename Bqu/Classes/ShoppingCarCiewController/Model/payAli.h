//
//  payAli.h
//  Bqu
//
//  Created by yb on 15/10/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderProductMudel.h"

@protocol PayResultDelegate <NSObject>

-(void)payResult:(BOOL)result ;

@end

@interface payAli : NSObject


-(void)topay:(OrderProductMudel*)product;
@property (nonatomic,weak)id<PayResultDelegate>delegate;
@end
