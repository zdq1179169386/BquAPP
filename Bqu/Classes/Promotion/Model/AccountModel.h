//
//  AccountModel.h
//  Bqu
//
//  Created by WONG on 15/12/9.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountModel : NSObject

@property (nonatomic)NSString *accountStyle;
@property (nonatomic)NSString *subTitle;
@property (nonatomic)NSString *BankId;

@property (nonatomic)BOOL deleteState;

+ (instancetype)accountModel:(NSDictionary *)dic;
@end
