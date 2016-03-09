//
//  StaticJumpToAppViewController.m
//  Bqu
//
//  Created by yb on 15/12/11.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "StaticJumpToAppViewController.h"
#import "BquTool.h"
#import "SataicViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "GoodsDetailViewController.h"
#import "SearchListCollectionVC.h"
#import "SearchViewController.h"
#import "ProductModel.h"
#import "HttpTool.h"
#import "FirmOrderTableViewController.h"



@interface StaticJumpToAppViewController ()

@end

@implementation StaticJumpToAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)url:(NSString*)url
{
    NSLog(@"%@",url);
    [BquTool urlAnalysis:url success:^(NSDictionary *data) {
        NSInteger index = [data[@"type"] integerValue];
       UrlType type = (UrlType)index ;
        switch (type) {     
            case UrlTypeNil:
                break;
                
            case UrlTypeActivitywap:
            {
                SataicViewController * vc = [[SataicViewController alloc] init];
                NSString * url = data[@"url"];
                vc.url =url;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            case UrlTypeLogin:
            {
                [self login];
            }
                break;
                
            case UrlTypeUserRegister:
            {
                RegisterViewController * vc = [[RegisterViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            case UrlTypeProductDetail:
            {
                GoodsDetailViewController * goodsDetailViewController = [[GoodsDetailViewController alloc] init];
                goodsDetailViewController.productId =data[@"pid"];
                goodsDetailViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:goodsDetailViewController animated:YES];
            }
                break;
                
            case UrlTypeTopicDetail:
            {
                SearchListCollectionVC *jumpVC = [[SearchListCollectionVC alloc]init];
                jumpVC.TopicId = data[@"tid"];
                jumpVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:jumpVC animated:YES];
            }
                break;
                
            case UrlTypeAddToCart:
            {
                [self addProductToShoppingCart:data[@"skuid"]];
            }
                break;
                
            case UrlTypeProductConfirm:
            {
//                GoodsDetailViewController * goodsDetailViewController = [[GoodsDetailViewController alloc] init];
//                goodsDetailViewController.productId =data[@"skuid"];
//                goodsDetailViewController.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:goodsDetailViewController animated:YES];

                [self getdetail:(NSString*)data[@"skuid"]];
                //立即购买 先放弃。进入详情页面
            }
                break;
                
            case UrlTypeAddFavoriteProduct:
            {
                [self addFavoriteProduct:data[@"skuid"]];
            }
                break;
                
            case UrlTypeSearch:
            {
                [self search:data];
            }
                break;
                
            default:
                break;
        }
        
    }];
}

//登入
-(void)login
{
    LoginViewController * vc = [[LoginViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 添加商品到购物车接口
-(void)addProductToShoppingCart:(NSString*)skuid
{
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/API/Cart/AddToCart",TEST_URL];
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    
    //    NSLog(@"%@,%@,%@",self.product.Id,memberID,token);
    if (!skuid || !memberID || !token ) {
        return;
    }
    NSDictionary * signDict = @{@"MemberID":memberID,@"token":token,@"skuid":skuid,@"count":@"1"};
    NSString * signStr = [HttpTool returnForSign:signDict];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"skuid"] = skuid;
    dic[@"count"] = @"1";
    dic[@"MemberID"] = memberID;
    dic[@"token"] = token;
    dic[@"sign"] = signStr;
    
    [HttpTool post:urlStr params:dic success:^(id json) {
        
        NSString * str = json[@"message"];
        NSString * resultCode = json[@"resultCode"];
        if (resultCode.intValue == 0) {
            [ProgressHud addProgressHudWithView:self.view andWithTitle:@"加入成功" withTime:1 withType:MBProgressHUDModeText];
        }else
        {
            str = [str substringWithRange:NSMakeRange(3, str.length-3)];
            [ProgressHud addProgressHudWithView:self.view andWithTitle:str withTime:1 withType:MBProgressHUDModeText];
            
        }
    } failure:^(NSError *error) {
    }];
}

//先获取商品详情，在进行订单页面
-(void)getdetail:(NSString*)skuid
{
    //获得商品详情
    NSString *_uid;
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    
    if (!memberID && !token) {
        [self login];
    }else if (memberID && token)
    {
        _uid = memberID;
    }
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/api/home/product/detail",TEST_URL];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:skuid forKey:@"pid"];
    [dict setObject:_uid forKey:@"uid"];
    
    NSString * signStr = [HttpTool returnForSign:dict];
    dict[@"sign"] = signStr;
    
    [HttpTool post:urlStr params:dict success:^(id json) {
        NSString * resultCode = json[@"resultCode"];
        if (resultCode.intValue == 0)
        {
            ProductModel * model = [ProductModel objectWithKeyValues:json[@"data"]];
            //立即支付  点击之后调转到订单页面
            [self buyNow:model];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark--立即支付  点击之后调转到订单页面
-(void)buyNow:(ProductModel *)model
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/API/Cart/GetUserIntegral",TEST_URL];
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    NSString * sign = nil;
    if (memberID && token)
    {
        [dict setObject:memberID forKey:@"MemberID"];
        [dict setObject:token forKey:@"token"];
        
        sign  = [HttpTool returnForSign:dict];
        dict[@"sign"] = sign;
        [HttpTool post:urlStr params:dict success:^(id json) {
            NSString * resultCode = json[@"resultCode"];
            if (resultCode.intValue == 0)
            {
                GoodsInfomodel *goods = [[GoodsInfomodel alloc] init];
                goods.skuId = model.DefaultSkuId;
                goods.Id = model.Id;
                goods.imgUrl = model.ImageUrl;
                goods.name = model.ProductName;
                goods.price = model.SalePrice;
                goods.count = @"1";
                goods.shopId = model.ShopName;
                goods.shopName = model.ShopName;
                goods.tradeType = model.TradeType;
                goods.taxRate = model.TaxRate;
                
                FirmOrderTableViewController * commitOrder_VC = [[FirmOrderTableViewController alloc] initWithGoods:goods];
                [self.navigationController pushViewController:commitOrder_VC animated:YES];

            }
        } failure:^(NSError *error)
         {}];
    }
}



#pragma mark -- 收藏请求
-(void)addFavoriteProduct:(NSString*)skuid
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/api/home/AddFavoriteProduct",TEST_URL];
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    //    NSLog(@"%@,%@,%@",self.product.Id,memberID,token);
    if (memberID && token) {
        
        NSDictionary * signDict = @{@"pid":skuid,@"MemberID":memberID,@"token":token};
        NSString * signStr = [HttpTool returnForSign:signDict];
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:signDict];
        dic[@"sign"] = signStr;
        
        [HttpTool post:urlStr params:dic success:^(id json) {
            
            //        NSLog(@"%@",json[@"message"]);
            if (!json[@"error"]) {
                //收藏成功，改变图片
                
                [ProgressHud showHUDWithView:self.view withTitle:@"收藏成功" withTime:1.5];
            }else
            {
                
                
            }
            
        } failure:^(NSError *error) {
        }];
        
    }
    
}


//搜索
-(void)search:(NSDictionary*)dic
{
    SearchViewController * svc = [[SearchViewController alloc] init];
    svc.keyWord = dic[@"keyword"]? dic[@"keyword"]:nil;
    BquSearchConditionModel *model = nil;
    if (dic[@"cid"] ||dic[@"bid"] ||dic[@"shopid"] ||dic[@"countryid"])
    {
        model = [[BquSearchConditionModel alloc] init];
        [model setValueFromDic:dic];
    }
    svc.conditions = model;
    svc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:svc animated:YES];
}

@end
