//
//  PromotionAccountModel.h
//  Bqu
//
//  Created by yb on 15/12/10.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromotionAccountModel : NSObject

/**账号*/
@property(nonatomic,strong)NSString * AccountNumber;
/**账户类型  1：支付宝 2：银行卡*/
@property(nonatomic,strong)NSString * Type;
/**银行卡号*/
@property(nonatomic,strong)NSString * BankCardNumber;
/**账户ID*/
@property(nonatomic,strong)NSString * AccountID;


/**<#description#>*/
@property(nonatomic,strong)NSString * BankId;

@end
//"UserId": 5,             //用户ID
//"AccountID": 69,         //账户ID
//"UserName": "王跃霖",    //账户名称
//"Type": 2,               //账户类型  1：支付宝 2：银行卡
//"TypeName": "农业银行",  //账户类型名称
//"CellPhone": "18657119239",  //联系电话
//"BankCardNumber": "6666666666666666666",  //银行卡号
//"AccountNumber": null,             //账号
//"BankBranch": "西湖区支行"       //银行支行
