//
//  AllOnTimeModel.h
//  Bqu
//
//  Created by WONG on 15/11/3.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllOnTimeModel : NSObject
@property (nonatomic,strong)NSString *LimitAdv;

@property (nonatomic,strong)NSString *LimitProduct;
@property (nonatomic,strong)NSString *Pid;
@property (nonatomic,strong)NSString *ImgPath;
@property (nonatomic,strong)NSString *LimitPrice;
@property (nonatomic,strong)NSString *Discount;
@property (nonatomic,strong)NSString *MarketPrice;
@property (nonatomic,strong)NSString *ProductName;
@property (nonatomic,strong)NSString *Storage;


+ (AllOnTimeModel *)createModelWithDic:(NSMutableDictionary *)dic;
@end
