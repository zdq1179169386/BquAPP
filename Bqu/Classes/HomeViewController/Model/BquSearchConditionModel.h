//
//  BquSearchConditionModel.h
//  Bqu
//
//  Created by yb on 15/12/10.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BquSearchConditionModel : NSObject
//分类编号(默认传0)
@property(nonatomic,copy)NSString*cid;
@property(nonatomic,copy)NSString*cidName;

//品牌编号(默认传0)
@property(nonatomic,copy)NSString*bid;
@property(nonatomic,copy)NSString*bidName;

//店铺编号((默认传0)
@property(nonatomic,copy)NSString*shopid;
@property(nonatomic,copy)NSString*shopidName;

//国家ID
@property(nonatomic,copy)NSString*countryid;
@property(nonatomic,copy)NSString*countryidName;

-(void)setValueFromDic:(NSDictionary*)dic;
-(void)clearAllData;
-(void)cleardata:(NSString*)ID;
@end
