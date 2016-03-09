//
//  RefundMessage.h
//  Bqu
//
//  Created by yb on 15/10/28.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>
#define Margin 12 
@interface RefundMessage : NSObject


/**订单id*/
@property(nonatomic,copy)NSString * OrderId;


/**主键id*/
@property(nonatomic,copy)NSString * OrderItemId;



/**父售后单id*/
@property(nonatomic,copy)NSString * ParentRefundId;



/**退款金额*/
@property(nonatomic,copy)NSString * Amount;


/**操作状态*/
@property(nonatomic,copy)NSString * AuditText;


/**退款金额*/
@property(nonatomic,copy)NSString * BankName;

///**买家发货信息*/
//@property(nonatomic,strong)NSString * DeliveThings;

/**操作日期*/
@property(nonatomic,copy)NSString * OperaData;


/**收款人*/
@property(nonatomic,copy)NSString * Payee;


/**退款账号*/
@property(nonatomic,copy)NSString * PayeeAccount;

/**原因*/
@property(nonatomic,copy)NSString * Reason;


/**退款方式*/
@property(nonatomic,copy)NSString * RefundAccount;

/**重新申请售后期限*/
@property(nonatomic,copy)NSString * RefundGoodsLimitDay;


/**退款说明*/
@property(nonatomic,copy)NSString * RefundMoneyReMark;


/**商家备注*/
@property(nonatomic,copy)NSString * SellerRemark;



/**仅退款还是退货退款*/
@property(nonatomic,copy)NSString * RefundMode;

//SellerAudit:0,默认；1，待商家审核；2，待买家发货；3，待商家收货；4，商家拒绝；5，商家审核通过
//AdminAudit：6，待平台审核；7，审核通过
/**平台状态*/
@property(nonatomic,copy)NSString * AdminAudit;


/**卖家状态*/
@property(nonatomic,copy)NSString * SellerAudit;



///**卖家收货信息*/
//@property(nonatomic,strong)NSString * TakeAddress;

//_________________________________________________________

/**物流公司*/
@property(nonatomic,strong)NSString * ExpressCompanyName;

/**快递单号*/
@property(nonatomic,strong)NSString * ShipOrderNumber;

/**退货说明(发货时填写)*/
@property(nonatomic,strong)NSString * GoodsReturnRemark;


/**收货地址*/
@property(nonatomic,strong)NSString * SenderAddress;

/**联系电话*/
@property(nonatomic,strong)NSString * SenderPhone;

/**联系人*/
@property(nonatomic,strong)NSString * SenderName;


/**之前订单的状态,1 为订单退款，没有二次申请的机会，2，3 有*/
@property(nonatomic,assign)int  orderStatus;

@end


@interface RefundMessageFrame : NSObject


/**之前订单的状态,1 为订单退款，没有二次申请的机会，2，3 有*/
@property(nonatomic,copy)NSString * orderStatusF;

/**<#description#>*/
@property(nonatomic,strong)RefundMessage * message;

/**评论用户*/
@property(nonatomic,assign)CGRect  NameF;
/**评论内容*/
@property(nonatomic,assign)CGRect  ContentF;
/**评论日期*/
@property(nonatomic,assign)CGRect  DateF;

@property(nonatomic,assign)CGRect  bgImageF;


/**btn*/
@property(nonatomic,assign)CGRect  btnF;

@property(nonatomic,assign)CGRect  line1F;
@property(nonatomic,assign)CGRect  line2F;

/**cellde高度*/
@property(nonatomic,assign)CGFloat  cellHeight;


@end
