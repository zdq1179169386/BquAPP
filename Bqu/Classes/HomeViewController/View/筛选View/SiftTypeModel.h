//
//  SiftTypeModel.h
//  Bqu
//
//  Created by yb on 15/12/9.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SiftTypeModel : NSObject

@property(nonatomic,copy)NSString * name;

@property(nonatomic,copy)NSString * shopId;

@property(nonatomic,copy)NSString *brandId;

@property(nonatomic,copy)NSString *countryId;


+(instancetype)siftTypeModel:(NSDictionary*)dic type:(NSUInteger)type;//0 表示shopID 1表示countryid

+(NSArray*)siftTypeModelFromArray:(NSArray*)array type:(NSUInteger)type;
@end
