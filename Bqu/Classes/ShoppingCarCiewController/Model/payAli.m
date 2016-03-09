
//  payAli.m
//  Bqu
//
//  Created by yb on 15/10/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "payAli.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>


@implementation payAli


-(void)topay:(OrderProductMudel*)product;
{
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088021241019224";
    NSString *seller = @"yb@bqu.com";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAKbfnicqPEUAyCvGzuvsUyTmw/o/LOx0eYSlrTQia3zagqnt/aH3fnEvcfGj5crV4BgF7vreaA8H8EE+9z7Qt0Qk0EO0+BYkn9hVtiQX8rCUNuxAFNFngsoycCfgPzye9MFB8wQunJRpplAopjhsR/XZl3IqJ7NoNbmaz/FdjxCZAgMBAAECgYAdJumhG+7Fezp881FIw9NOmgXYnNrDQCHOe4cDmZO/jwjOmOX7OppbOZelSCWnxq9MYxT5vIrfPVrKey6EScAKHiWT9DUTWzkJQdRpBdJVdDeiwd8D+jwr63WSJyt3Dur+ZNXORuhslzzl37zmb7xte9fNyG8d7ruwceByHg/fFQJBAN1cPHuSCb9rqByFSiftN/2HHlt7x4ZWGwqbmeXxutVzf/srgbxCudU6+eLz5rQ1ybEWHM0QM6tbnaQRefy6fxcCQQDA/J+XG94ad8Wi2XMCWT94AbtjzyGCL5Cv5whcKKcNgCcB3HsTA7Y62z8X0Z6OZRnW3L/nZA0wzBXkQTSfSDvPAkAskkHrb8BetsKm23/PAkjf17EZIpdOSVAwlpwqXL4N9K+0V1JMIfNhJ/rg49N0PdBaw+UQtU5yFoRrYMl7ReIJAkAaoQEYZbUA6/PuY5jWAyCZ24tS21rhTtTlILjrloRufXdkb1rgJcv4VRZgoAED3vlwx2cHc6vKRu7iXwj2zY3LAkEAz56eMnJdGqX1mTh3hxijnx1+Yf7VCSzH56OJnv7qMRI5pVPEJhmtCPqgwgG2lzN+jRrIX2rEZQ55RoQJjX3q1Q==";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = product.orderID; //订单ID（由商家自行制定）
    order.productName = product.productName; //商品标题
    order.productDescription = product.productDescription; //商品描述
    order.amount = product.amount; //商品价格
    
    NSString * testNotifyURL = [NSString stringWithFormat:@"%@/API/Order/PayNotify",TEST_URL];
    order.notifyURL =  testNotifyURL; //回调URL
//    order.notifyURL = @"http://wx.bqu.com/Pay/NotifyApp";
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"Bqu";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    NSString *orderString = nil;
    if (signedString != nil)
    {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        
         //在调用支付宝的时候，无法唤醒网页版，增加了这段代码 ，在回调方法 里面也写了这段代码
        NSArray *array = [[UIApplication sharedApplication] windows];
        UIWindow* win=[array objectAtIndex:0];
        [win setHidden:NO];
        
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic)
         {
             NSLog(@"resultDic%@",resultDic);
             NSString *resultStatus = resultDic[@"resultStatus"];
             if ( resultStatus.integerValue == 9000)
             {
                 [self.delegate payResult:YES];
             }
             else
             {
                 [self.delegate payResult:NO];
             }
         }];
        
    }
}
@end
