//
//  OntimeModel.h
//  Bqu
//
//  Created by WONG on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OntimeModel : NSObject
@property (nonatomic ,copy)NSArray *dataAry;
@property (nonatomic ,copy)NSString *totalCount;
@property (nonatomic ,copy)NSString *resultCode;
@property (nonatomic ,copy)NSString *message;
@property (nonatomic ,copy)NSString *errors;
@property (nonatomic ,copy)NSString *ImageUrl;
@property (nonatomic ,copy)NSString *ProductId;

@property (nonatomic ,copy)NSString *Storage;

+ (OntimeModel *)createOntimeModel:(NSDictionary *)dic;

@end
