//
//  TopicDetailModel.h
//  Bqu
//
//  Created by WONG on 15/10/23.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicDetailModel : NSObject

@property (nonatomic,copy)NSString *ProductId;
@property (nonatomic,copy)NSString *ProductName;
@property (nonatomic,copy)NSString *MinSalePrice;
@property (nonatomic,copy)NSString *MarketPrice;
@property (nonatomic,copy)NSString *ImageUrl;
@property (nonatomic,copy)NSString *Moods;
@property (nonatomic,copy)NSString *SaleCount;
@property (nonatomic,copy)NSString *Comment;


+(TopicDetailModel *)createDetailModelWithDic:(NSDictionary *)dic;
@end
