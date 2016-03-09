//
//  FirmOrderTableViewController.m
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "FirmOrderTableViewController.h"
#define ALLGROUPNUM 6
#import "ReceivingInformationTableViewCell.h"
#import "SubmitOrdersTableViewCell.h"
#import "PreferentialTableViewCell.h"
#import "LeaveMessageViewController.h"
#import "SelectOtherAddressTableViewController.h"
#import "SelsctPayWayViewController.h"
#import "AllUseCouponView.h"
#import "GoodsInfoNOBtnTabTableViewCell.h"
#import "DeliveryAddressView.h"
#import "ScoreModel.h"
#import "GoodsTool.h"
#import "GetShopCarSetterInformation.h"
#import "CartProductModel.h"
#import "PreferentialModel.h"
#import "BquTool.h"



@interface FirmOrderTableViewController ()<SubmitOrderDelegate,SelectPreferentialDelegate,selectCouponDelegate>
{
    NSMutableArray *_goodsArray;
    //NSString * _userMark;
    //GetShopCarSetterInformation * _shopCarSetterInformation;
    NSInteger _payFromType;// 0 是购物车结算， 1 是立即购买结算
    NSString* _DiscountAmount;//使用的优惠卷金额
}


@property (nonatomic)UITableView *tableView;

@property (nonatomic,strong)MBProgressHUD *mBProgressHUD;

@property(nonatomic,copy)NSString * userMark;

@property(nonatomic,strong)GetShopCarSetterInformation * shopCarSetterInformation;
@end

@implementation FirmOrderTableViewController

-(instancetype)initWithArray:(NSArray*)goodsArray
{
    if (self = [super init])
    {
        if (goodsArray)
        {
            _goodsArray =[goodsArray mutableCopy];
            _payFromType = 0 ;
        }
    }
    return self;
    
}

//从立即购买的页面 过来购买
-(instancetype)initWithGoods:(GoodsInfomodel*)goods;
{
    if (self = [super init])
    {
        _goodsArray = [[NSMutableArray alloc] init];
        [_goodsArray addObject:goods];
        _payFromType = 1 ;
    }
    return self;
}


- (void)viewDidLoad {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-60) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _userMark = @"";
    _DiscountAmount = @"0";
   
    [self CartConfirmFromType:@"0"];
    [super viewDidLoad];
    self.navigationItem.title = @"确认订单";
    [self createBackBar];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createBackBar
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(backBarClicked) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 30, 21);
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}


- (void)backBarClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---- 获取购物车结算清单 请求----开始
-(void)CartConfirmFromType:(NSString*)adrsid
{
    if (_payFromType == 0)
    {
        [self CartConfirm:adrsid];
    }
    else if (_payFromType == 1)
    {
        [self CartConfirmFromNewBuy:adrsid];
    }
}


//立即购买得到的数据
-(void)CartConfirmFromNewBuy:(NSString*)adrsid
{
    NSString * urlStr =[NSString stringWithFormat:@"%@%@",TEST_URL,@"/API/Cart/ProductConfirm"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[UserManager getMyObjectForKey:accessTokenKey] forKey:@"token"];
    [dic setValue:[UserManager getMyObjectForKey:userIDKey] forKey:@"MemberID"];
    GoodsInfomodel *goods = _goodsArray[0];
    [dic setObject:goods.skuId forKey:@"skuids"];
    [dic setObject:goods.count forKey:@"count"];
    [dic setObject:adrsid forKey:@"adrsid"];
    
    NSString * sign = [HttpTool returnForSign:dic];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserManager getMyObjectForKey:accessTokenKey] forKey:@"token"];
    [dict setValue:[UserManager getMyObjectForKey:userIDKey] forKey:@"MemberID"];
    [dict setObject:goods.skuId forKey:@"skuids"];
    [dict setObject:goods.count forKey:@"count"];
    [dict setObject:adrsid forKey:@"adrsid"];
    dict[@"sign"] = sign;
    
    
    [HttpTool post:urlStr params:dict success:^(id json) {
        NSString *resultCode = json[@"resultCode"];
        //请求成功
        
        NSLog(@"看数据%@",json);
        if (!resultCode.intValue)
        {
            [self removeNewView];
            NSDictionary * dataDic = json[@"data"];
            if (dataDic)
            {
                _shopCarSetterInformation = [[GetShopCarSetterInformation alloc] initWithDic:dataDic];
                
//                ScoreModel * scoreModel = _shopCarSetterInformation.dedMoneyInfo;
//                //保存最大可用积分和比例
//                _maxScore = scoreModel.integral;
                [self submitOrderOrGetCreateOrderMsg:1 url:GetCreateOrderMsgUrl];
                [self.tableView reloadData];
            }
        }
        else
        {
            [self addAlertView];
        }

    } failure:^(NSError *error) {
        if (error.code == NetWorkingErrorCode) {
            
            NSLog(@"error==%@",error);
            [self addNetView];
        }

    }];
}


//购物车内购买的商品
-(void)CartConfirm:(NSString*)adrsid
{
    NSString * urlStr =[NSString stringWithFormat:@"%@%@",TEST_URL,CartConfirmURL];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[UserManager getMyObjectForKey:accessTokenKey] forKey:@"token"];
    [dic setValue:[UserManager getMyObjectForKey:userIDKey] forKey:@"MemberID"];
    NSString *cartids = @"";
    for ( int i = 0 ; i < _goodsArray.count; i++)
    {
        GoodsInfomodel * submitGoods  = _goodsArray[i];
        if (i == (_goodsArray.count - 1))
        {
            cartids = [cartids stringByAppendingFormat:@"%@",submitGoods.cartItemId];
        }
        else
        {
            cartids = [cartids stringByAppendingFormat:@"%@,",submitGoods.cartItemId];
        }
    }
    [dic setValue:cartids forKey:@"cartids"];
    [dic setValue:adrsid forKey:@"adrsid"];
    
    NSString * sign = [HttpTool returnForSign:dic];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserManager getMyObjectForKey:accessTokenKey] forKey:@"token"];
    [dict setValue:[UserManager getMyObjectForKey:userIDKey] forKey:@"MemberID"];
    [dict setValue:cartids forKey:@"cartids"];
    [dict setValue:adrsid forKey:@"adrsid"];
    dict[@"sign"] = sign;
    [HttpTool post:urlStr params:dict success:^(id json) {
        NSString *resultCode = json[@"resultCode"];
        //NSLog(@"resultCode==%@,%@",resultCode,json[@"message"]);
        //请求成功
        if (!resultCode.intValue)
        {
            [self removeNewView];
            NSDictionary * dataDic = json[@"data"];
            _shopCarSetterInformation = [[GetShopCarSetterInformation alloc] initWithDic:dataDic];
//            ScoreModel * scoreModel = _shopCarSetterInformation.dedMoneyInfo;
//            //保存最大可用积分和比例
//            _maxScore = scoreModel.integral;
            [self submitOrderOrGetCreateOrderMsg:1 url:GetCreateOrderMsgUrl];
            [self.tableView reloadData];

        }
        else
        {
            [self addAlertView];
        }
    } failure:^(NSError *error) {
        if (error.code == NetWorkingErrorCode) {
           
            NSLog(@"error==%@",error);
            [self addNetView];
        }
    }];
}
#pragma mark ---- 获取购物车结算清单 请求----结束


//添加netView
-(void)addNetView
{
    if(_shopCarSetterInformation.cartProductModels.count== 0)
    {
        [self.view addSubview:self.netView];
        self.netView.delegate = self;
    }
    
}

-(void)removeNewView
{
    for (UIView * view  in self.view.subviews)
    {
        if (view == self.netView)
        {
            [self.netView removeFromSuperview];
            break;
        }
    }
}

-(void)addAlertView
{
    UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器请求数据失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [view show];
}

-(void)NetWorkViewDelegate:(NetWorkView *)view withBtn:(UIButton *)btn
{
  [self CartConfirmFromType:@"0"];
}

#pragma mark - 页面跳转




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ALLGROUPNUM;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 2 || section == 5) return 1;
    if (section == 1) return _goodsArray.count;
    if (section == 3) return 2;
    return 6;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 80;
    }
    else if (indexPath.section == 1)
    {
        double per = 1;
        if ( ScreenWidth == 414) {
            per = 1.16;
        }

        return 80*per;
    }
    else if (indexPath.section == 2)
    {
        return 40;
    }
    else if (indexPath.section == 3)
    {
        return 50;
    }
    else if (indexPath.section == 4)
    {
        return 40;
    }
    else if (indexPath.section == 5)
    {
        return 50;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        double per = 1;
        if ( ScreenWidth == 414) {
            per = 1.286;
        }
        return 39*per;
    }
    return 0.01;//section头部高度
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        GoodsInfomodel *goods = _goodsArray[0];
        DeliveryAddressView *view = [[DeliveryAddressView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [view setValue:goods.shopName isAllSelect:NO];
        view.selectView.hidden = YES;
        view.storeHouseImage.x = 10;
        view.deliveryAddress.x = 35;
        return view;
    }
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak FirmOrderTableViewController *share = self;
    if (indexPath.section == 0)
    {
        SelectOtherAddressTableViewController *stv = [[SelectOtherAddressTableViewController alloc] init];
        [stv setBlock:^(AddressModel *address) {
            share.shopCarSetterInformation.address = [address copy];
            [share CartConfirmFromType:address.Id];
        }];
        
        [self.navigationController pushViewController:stv animated:YES];
    }
    else if (indexPath.section == 2)
    {
        LeaveMessageViewController *lvc = [[LeaveMessageViewController alloc] init];
        [lvc setMessage:_userMark];
        [lvc setBlock:^(NSString *message) {
            share.userMark =message;
        }];
        [self.navigationController pushViewController:lvc animated:YES];
    }
    else if (indexPath.section == 3 )
    {
        if (indexPath.row == 0 )
        {// 优惠劵 使用
            [self isSelectCouponOnView];
        }
        else  if(indexPath.row == 1)
        {
            [self isUseScore];
        }
    }
}


#pragma mark
#pragma mark------ 是否使用积分 ------开始
-(void)isUseScore
{
    _shopCarSetterInformation.dedMoneyInfo.isUse = !_shopCarSetterInformation.dedMoneyInfo.isUse;
    if(_shopCarSetterInformation.dedMoneyInfo.integral.intValue == 0)
    {
        _shopCarSetterInformation.dedMoneyInfo.isUse = 0;
    }
    else
    {
        [self submitOrderOrGetCreateOrderMsg:1 url:GetCreateOrderMsgUrl];
    }
    [self.tableView  reloadData];
}
#pragma mark------ 是否使用积分 ------结束


#pragma mark
#pragma mark------ 是否弹出优惠劵的界面 ------开始
-(void)isSelectCouponOnView
{
    if (_shopCarSetterInformation.userCoupons.count > 0)
    { // 有可用优惠劵时候 ，跳出选择优惠卷的 视图
        AllUseCouponView *view = [[AllUseCouponView alloc] initWithFrame:CGRectMake(0 ,-50, ScreenWidth, ScreenHeight) deleagte:self coupons:_shopCarSetterInformation.userCoupons];
        [self.view addSubview:view];
    }
    else
    {//没有可用优惠劵时候 弹出提示框
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"" message:@"对不起!您没有可用优惠劵" delegate:nil
                                             cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [view show];
    }
    
}

#pragma mark------ 是否弹出优惠劵的界面-------结束

//--------------------选择优惠卷的代理___________________
-(void)selectCoupon:(NSInteger)index
{
    if (_shopCarSetterInformation.userCoupons)
    {
        for (int i = 0 ; i < _shopCarSetterInformation.userCoupons.count ; i++)
        {
            PreferentialModel* coupon =  _shopCarSetterInformation.userCoupons[i];
            if (index == i )
            {
                coupon.isSelect = YES;
            }
            else coupon.isSelect = NO;
        }
        [self submitOrderOrGetCreateOrderMsg:1 url:GetCreateOrderMsgUrl];
        
        [self.tableView reloadData ];
    }
}
//-----------------------------------------------------



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ;
    if (indexPath.section == 0)
    {
//        ReceivingInformationTableViewCell * cell = [[ReceivingInformationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addressCell"];
//        [cell setValue:  _shopCarSetterInformation.address];
        
        ReceivingInformationTableViewCell * cell =[ReceivingInformationTableViewCell receivingInformationTableViewCell:tableView];
        [cell setValue:  _shopCarSetterInformation.address];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    else if (indexPath.section == 1)
    {
        GoodsInfoNOBtnTabTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firmcell"];
        if (cell == nil)
        {
            cell = [[GoodsInfoNOBtnTabTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"firmcell"];
        }
        [cell setValue:_goodsArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
    else if (indexPath.section == 2)
    {
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sellerMessage"];
        cell.textLabel.text = @"买家留言";
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.tintColor = [UIColor colorWithHexString:@"#333333"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
    else if (indexPath.section == 3)
    {
        PreferentialTableViewCell * cell = [[PreferentialTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"scorePreferential"];
        if (indexPath.row == 0)
        {
            //取得可用的优惠卷的个数
            NSInteger couponsCount = _shopCarSetterInformation.userCoupons.count;
            cell.textLabel.text = @"使用优惠劵";
            cell.textLabel.tintColor = [UIColor colorWithHexString:@"#333333"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"可用优惠劵 %lu张",couponsCount];
            
            
            //--------------如果可用优惠卷大于0 字体颜色为红色
            if (couponsCount > 0 )
                cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#E8103C"];
            else cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            //-------------
            
            //---------------如果可用优惠卷使用了，将图标显示为选中
            if ([PreferentialModel whichIsByUse:_shopCarSetterInformation.userCoupons] >= 0)
            {
                [cell setImage:1];
            }
            else
            {
                [cell setImage:0];
            }
            //-------------------------
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.selectBtn.tag = 200;
        }
        else
        {
            cell.textLabel.text = @"使用积分";
            NSInteger   integral = [ScoreModel getMaxScore:_shopCarSetterInformation];
            double   money = [ScoreModel getMaxMoney:_shopCarSetterInformation];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"可用积分 %ld,抵扣 %0.2f",(long)integral,money];
            cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#E8103C"];
            if (integral == 0)  cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            cell.selectBtn.tag = 201;
            [cell setImage:_shopCarSetterInformation.dedMoneyInfo.isUse];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectBtn.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.tintColor = [UIColor colorWithHexString:@"#333333"];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:9];
        cell.delegate = self;
        return cell;
    }
    
    
    else if (indexPath.section == 4)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settle"];
        
        
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"结算";
                break;
            case 1:
            {
                cell.textLabel.text = @"商品合计";
                NSString *goodsPrice = _shopCarSetterInformation.totalAmount;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%0.2f",goodsPrice.doubleValue];
                break;
            }
            case 2:
                cell.textLabel.text = @"使用积分";
                double scoreMoney = 0;
                if (_shopCarSetterInformation.dedMoneyInfo.isUse)
                {
                    scoreMoney =[ScoreModel getMaxMoney:_shopCarSetterInformation];
                }
                cell.detailTextLabel.text = [NSString stringWithFormat:@"-￥%0.2f",scoreMoney];
                break;
            case 3:
                cell.textLabel.text = @"使用优惠劵";
                //double coupon = 0;
                //coupon = [PreferentialModel getCouponPrice: _shopCarSetterInformation.userCoupons];
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"-￥%0.f",_DiscountAmount.doubleValue];
                break;
            case 4:
            {
                cell.textLabel.text = @"运费";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",_shopCarSetterInformation.totalFreight];
                UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-190, 9, 114, 23)];
                view.image = [UIImage imageNamed:@"关税小于50免征_无字"];
                [cell addSubview:view];
                UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 1, 104, 21)];
                lable.textAlignment = NSTextAlignmentCenter;
                lable.backgroundColor = [UIColor whiteColor];
                lable.text =@"满88包邮哦!";
                lable.font = [UIFont systemFontOfSize:12];
                lable.textColor = [UIColor colorWithHexString:@"#e8103c"];
                [view addSubview:lable];
            }
                break;
            case 5:
            {
                cell.textLabel.text = @"税金";
                double maxTax;
                double minTax;
                if (_shopCarSetterInformation.totalTax.doubleValue > _shopCarSetterInformation.pushCustomsTax.doubleValue)
                {
                    maxTax = _shopCarSetterInformation.totalTax.doubleValue;
                    minTax = _shopCarSetterInformation.pushCustomsTax.doubleValue;
                }
                else
                {
                    maxTax = _shopCarSetterInformation.pushCustomsTax.doubleValue;
                    minTax = _shopCarSetterInformation.pushCustomsTax.doubleValue;
                }
                if (minTax <= 50) minTax = 0 ;
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%0.2f",maxTax];
                
                if (maxTax != minTax)
                {
                    UILabel * LineLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-50, 20, 40, 1)];
                    LineLab.backgroundColor = [UIColor colorWithHexString:@"#999999"];
                    [cell addSubview:LineLab]; //在价格上划线

                    if (minTax == 0)
                    {
                        UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-190, 9, 114, 23)];
                        view.image = [UIImage imageNamed:@"关税小于50免征_无字"];
                        [cell addSubview:view];
                        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 1, 104, 21)];
                        lable.backgroundColor = [UIColor whiteColor];
                        lable.text =@"关税≤50，免征哦!";
                        lable.font = [UIFont systemFontOfSize:12];
                        lable.textColor = [UIColor colorWithHexString:@"#e8103c"];
                         lable.textAlignment = NSTextAlignmentCenter;
                        [view addSubview:lable];
                    }
                    else
                    {
                        
                        UILabel *tureLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-230, 15, 150, 10)];
                        tureLab.text= [NSString stringWithFormat:@"优惠后价格：¥%0.2f",minTax];
                        tureLab.font = [UIFont systemFontOfSize:11];
                        tureLab.textAlignment = NSTextAlignmentRight;
                        tureLab.textColor = [UIColor colorWithHexString:@"#999999"];
                        [cell addSubview:tureLab];//真实的税金
                    }
                }
            }
                cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
                break;
                
            default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.tintColor = [UIColor colorWithHexString:@"#333333"];
        cell.detailTextLabel.tintColor = [UIColor colorWithHexString:@"#999999"];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
        return cell;
    }
    
    
    else
    {
        SubmitOrdersTableViewCell *cell = [[SubmitOrdersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"submit"];
        cell.delegate = self;
        NSString * price = [NSString stringWithFormat:@"%0.2f",_shopCarSetterInformation.orderAmount.doubleValue];
        [cell setValue: price ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}



//是付款的价格
# pragma  mark -代理
-(void)submitOrder:(UIButton *)sender
{
    NSString  *url ;
    if (_payFromType == 0)  url = CreateOrderURL; //购物车结算提交需要的 url
    else if (_payFromType == 1) url = CreateOrderFromSkuURL; //立即购买结算提交需要的 url
    [self submitOrderOrGetCreateOrderMsg:0 url:url];
}


-(void)submitOrderOrGetCreateOrderMsg:(NSInteger)type url:(NSString*)url
{
    //请求数据
    // 如果用户没有地址，
    if(_shopCarSetterInformation.address == nil)
    {
        UIAlertView * view = [[UIAlertView alloc] initWithTitle:nil message:@"您还没有设置收货地址，请先去个人中心设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [view show];
    }
    
    //有地址之后才进行提交订单
    else
    {
        NSString * urlStr =[NSString stringWithFormat:@"%@%@",TEST_URL,url];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:[UserManager getMyObjectForKey:accessTokenKey] forKey:@"token"];
        [dic setValue:[UserManager getMyObjectForKey:userIDKey] forKey:@"MemberID"];
        
        //将商品字典化  放进数组中
        NSMutableArray * pArray = [[NSMutableArray alloc] init]; //获取商品信息
        for (int  i = 0 ; i < _shopCarSetterInformation.cartProductModels.count; i++)
        {
            CartProductModel * cartProductModel = _shopCarSetterInformation.cartProductModels[i];
            
            for (int j = 0 ; j < cartProductModel.cartItemModels.count; j++)
            {
                GoodsInfomodel * goodsInfomodel = cartProductModel.cartItemModels[j];
                NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] initWithCapacity:3];
                [dictionary setObject:goodsInfomodel.skuId forKey:@"SkuID"];
                [dictionary setObject:goodsInfomodel.Id forKey:@"ProductID"];
                [dictionary setObject:goodsInfomodel.count forKey:@"Amount"];
                [pArray addObject:dictionary];
            }
        }
        //message 内部字段赋值
        NSString *Integral = [NSString stringWithFormat:@"%ld",(long)[ScoreModel isSelectScoreMaxMoney:_shopCarSetterInformation]];
        NSString *CouponIds = [PreferentialModel whichIDIsByUse:_shopCarSetterInformation.userCoupons];
        // 添加message 字段内容
        NSMutableDictionary * messageDictionary = [[NSMutableDictionary alloc] initWithCapacity:7];
        [messageDictionary setObject:@"3" forKey:@"PlatType"];
        [messageDictionary setObject:_shopCarSetterInformation.address.Id forKey:@"AddressId"];
        [messageDictionary setObject:CouponIds forKey:@"CouponIds"];
         //NSLog(@"%@",[BquTool getDid]);
        [messageDictionary setObject:[BquTool getDid] forKey:@"DistributorId"];
        
        //NSLog(@"%@",[BquTool getDid]);
        //[messageDictionary setObject:@"0" forKey:@"DistributorId"];
        
        
        [messageDictionary setObject: Integral forKey:@"Integral"];
        
        //如果是获取页面数据，将积分替换为最大可用积分
//        NSString * scoreIsUse = [NSString stringWithFormat:@"%f",[ScoreModel isSelectScoreMaxMoney:_shopCarSetterInformation]];
//        if (type!=0) {
//            [messageDictionary setObject: scoreIsUse forKey:@"Integral"];
//        }
        
        [messageDictionary setObject:_userMark forKey:@"UserrMark"];
        [messageDictionary setObject:pArray forKey:@"ProductList"];
        
        //转sign
        NSString * memberId = [[NSUserDefaults standardUserDefaults] objectForKey:userIDKey];
        NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:accessTokenKey];
        
        
        
        NSError * error = nil;
        
        NSData * data = [NSJSONSerialization dataWithJSONObject:messageDictionary options:NSJSONWritingPrettyPrinted error:&error];
        NSString * dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSDictionary * messageDic = @{@"MemberID":memberId,@"token":token,@"message":dataStr};
        NSString * sign = [HttpTool returnForSign:messageDic];
        
        
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setValue:[UserManager getMyObjectForKey:accessTokenKey] forKey:@"token"];
        [dict setValue:[UserManager getMyObjectForKey:userIDKey] forKey:@"MemberID"];
        [dict setValue:sign forKey:@"sign"];
//        if (type!=0) {
//            [dict setObject: scoreIsUse forKey:@"Integral"];
//        }
        [dict setValue:dataStr forKey:@"message"];
        
        //NSLog(@"阐述%@",dict);
        if (type == 0)
        {
            //显示遮盖
            [self showLoadingView];
            [HttpTool post:urlStr params:dict success:^(id json){
                
                //移除遮盖
                [self hideLoadingView];
                
                NSString *resultCode = json[@"resultCode"];
                [_mBProgressHUD hide:YES];
                if (resultCode.boolValue == 0 )
                {
                    [self removeNewView];
                    SelsctPayWayViewController * pay = [[SelsctPayWayViewController alloc] init];
                    pay.orderID = json[@"data"];
                    [self.navigationController pushViewController:pay animated:YES];
                }
                else
                {
                    NSString *errorString = [NSString stringWithFormat:@"%@",json[@"message"]];
                    UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:errorString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [view show];
                }
            
            }failure:^(NSError *error) {
                [self hideLoadingView];
                
            }];
        }
        // 获取积分和优惠卷 的请求
        else
        {
            
            //NSLog(@"%@",dict);
            
            [HttpTool post:urlStr params:dict success:^(id json){
                [self removeNewView];
                NSDictionary * resultDic = json[@"data"];
                //NSLog(@"dictdictdictdictdictdicty优惠之后 %@",json);
                if(![resultDic isKindOfClass:[NSNull class]])
                {
                    _shopCarSetterInformation.totalTax = resultDic[@"Tax"];
                    _shopCarSetterInformation.pushCustomsTax = resultDic[@"PushCustomsTax"];
                    _shopCarSetterInformation.totalAmount = resultDic[@"ProductTotalAmount"];
                    _shopCarSetterInformation.orderAmount = resultDic[@"OrderTotalAmount"];
                    _shopCarSetterInformation.totalFreight = resultDic[@"Freight"];
                    _DiscountAmount =resultDic[@"DiscountAmount"];
                    ScoreModel * model =_shopCarSetterInformation.dedMoneyInfo;
                    
                    model.dedMoneyInfo =resultDic[@"IntegralAmount"];
                    NSString * IntegralAmount =resultDic[@"IntegralAmount"];
                    double  integral =  IntegralAmount.doubleValue * model.integralPerMoney.doubleValue;
                    model.integral  = [NSString stringWithFormat:@"%f",integral];
                    //如果使用积分为0 设置积分使用为未使用
                    if(_shopCarSetterInformation.dedMoneyInfo.integral.intValue == 0)
                    {
                        _shopCarSetterInformation.dedMoneyInfo.isUse = 0;
                    }
                    [self.tableView reloadData];
                }
                
            }failure:^(NSError *error) {
                if (error.code == NetWorkingErrorCode) {
                    
                    //NSLog(@"error==%@",error);
                    [self addNetView];
                }

            }];
        }
    }
}

#pragma  mark
#pragma  mark --- 两个使用优惠卷上 和 使用积分上的  点击按钮的 代理事件－－－－开始
-(void)selectPreferential:(UIButton*)sender
{
    if(sender.tag == 200)//点击选择优惠卷按钮
    {
        //如果没有选择优惠卷，点击之后 跳转到选择优惠
        
        NSInteger index = [PreferentialModel whichIsByUse:_shopCarSetterInformation.userCoupons];
        if ( index < 0)
        {
            [self isSelectCouponOnView];
        }
        else  //已经有选择的优惠劵，那就执行把优惠卷的选择设置为 不选择
        {
            
            PreferentialModel* coupon =  _shopCarSetterInformation.userCoupons[index];
            coupon.isSelect = NO;
            [self submitOrderOrGetCreateOrderMsg:1 url:GetCreateOrderMsgUrl];
            [self.tableView reloadData];
        }
        
        
    }
    else if (sender.tag == 201)//点击选择积分按钮
    {
        [self isUseScore];
    }
}

- (void)showLoadingView
{
    if (!_mBProgressHUD)
    {
        // 基于哪个view?
        UIView *baseView = self.navigationController.view ? self.navigationController.view : self.view;
        _mBProgressHUD = [[MBProgressHUD alloc] initWithView:baseView];
        _mBProgressHUD.labelText = @" 正在提交";
        _mBProgressHUD.color = [UIColor blackColor];//这儿表示无背景
        [baseView addSubview:_mBProgressHUD];
        
    }
    
    [_mBProgressHUD show:YES];
}

-(void)hideLoadingView
{
    _mBProgressHUD.hidden = YES;
}

#pragma  mark
#pragma  mark --- 更换收件地址代理事件－－－－开始
//-(void)SelectOtherAddress:(AddressModel*)newAddress
//{
//    _shopCarSetterInformation.address = [newAddress copy];
//    [self CartConfirmFromType:newAddress.Id];
//    
//}


-(void)dealloc
{
    self.tableView = nil;
}

@end
