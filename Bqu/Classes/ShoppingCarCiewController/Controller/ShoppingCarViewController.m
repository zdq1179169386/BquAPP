//
//  ShoppingCarViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/9.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "ShoppingCarViewController.h"
#import "OneHouse.h"
#import "GoodsInfoTableViewCell.h"
#import "ShowSelectGoodsView.h"
#import "DeliveryAddressView.h"
#import "FirmOrderTableViewController.h"
#import "NoGoodsInShoppingCar.h"
#import "LoginViewController.h"
#import "GoodsTool.h"
#import "HomeViewController.h"
#import "ShoppingCarTool.h"
#import "EditToolView.h"


#define URL http://58.215.41.6:10017

@interface ShoppingCarViewController ()<UITableViewDelegate,UITableViewDataSource,MySettleDelegate,MyCustomCellDelegate,MyAllSelectDelegate,JumpToLoginOrOtherDelegate,EditToolViewDelagate>

#pragma mark
#pragma mark 正常下需要的数据
@property (nonatomic,strong) EditToolView * editToolView;//编辑状态下显示清空删除等

@property (nonatomic,strong) NoGoodsInShoppingCar *noInfoView;  //当用户没有登入 或者购物车内没有商品时候 在界面上显示这个View；

@property (nonatomic,strong) UITableView * shoppingCarListTableView;//显示购物车内的所有商品信息，表

@property (nonatomic,strong) NSMutableArray *dataArray;//存放购物车内的商品，数组内放着 多个不用商店的对象，对象内的一个属性存放着商品

@property (nonatomic) NSInteger GoodsCount;//商品的种类数量

@property (nonatomic) BOOL islogin;//是否登入状态 0 未登入， 1 登入



#pragma mark
#pragma mark 编辑状态下需要的数据
@property (nonatomic,strong) NSMutableArray *deleteArray ; //被选中的等待删除的  商品数组

@property (nonatomic,strong) UIButton *editBtn;//  导航栏上显示编辑按钮，点击编辑进入编辑页面

@property (nonatomic)BOOL editStatus; //编辑状态，0 表示未编辑，1表示正在编辑状态

@property (nonatomic)BOOL AllSelectToDelete;//全选按钮的值

@end

@implementation ShoppingCarViewController


#pragma mark
#pragma mark 加载进内存
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self buildAllView];//装载视图等资源
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"购物车";
    self.navigationController.navigationBar.translucent = YES;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    [self.view setExclusiveTouch:YES];
}

//装载视图等资源
-(void)buildAllView
{
    
    _editStatus = 0;
    
    // 编辑状态下需要的数组
    _deleteArray = [[NSMutableArray alloc] initWithCapacity:2];
    
    //网络请求下来的商品数组
    _dataArray = [[NSMutableArray alloc] initWithCapacity:2];
    
    //表视图
    _shoppingCarListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49-64) style:UITableViewStyleGrouped];
    _shoppingCarListTableView.delegate = self;
    _shoppingCarListTableView.dataSource = self;
    [self.view addSubview:_shoppingCarListTableView];
    
    //没有商品时候显示的View
    _noInfoView = [[NoGoodsInShoppingCar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _noInfoView.delegate = self;
    [self.view addSubview:_noInfoView];

    
    //nav编辑按钮
    _editBtn = [[UIButton alloc] init];
    _editBtn.frame = CGRectMake(0, 0, 40, 40);
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _editBtn.titleLabel.textAlignment =NSTextAlignmentRight;
    [_editBtn addTarget:self action:@selector(editBtnTouchDown) forControlEvents:UIControlEventTouchDown];
    [_editBtn setTitle:@"   编辑" forState:UIControlStateNormal];
    [_editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_editBtn];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self isLoginInServer];
    _GoodsCount = 0;
    if (_editStatus) {
        [self editBtnTouchDown];
    }
    self.view.userInteractionEnabled = YES;
}

-(EditToolView*)editToolView
{
    if (!_editToolView) {
        //编辑条
        _editToolView = [EditToolView editWithframe:CGRectMake(0, ScreenHeight-57-64-49, ScreenWidth, 57)];
        _editToolView.delegate = self;
        _editToolView.hidden = YES;
        [self.view addSubview:_editToolView];
    }
    return _editToolView;
}

#pragma  mark
#pragma  mark-------去逛逛代理按钮
-(void)jumpToLoginOrOther:(UIButton*)sender
{
    if (sender.tag == 100)
    {
        LoginViewController *view = [[LoginViewController alloc] init];
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
    }
    else if(sender.tag == 101)
    {
        self.tabBarController.selectedIndex = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"gotohomeVC" object:self];
    }
}


#pragma  mark
#pragma  mark-------判断是否登入－－－－－－开始
-(void)isLoginInServer
{
    [ShoppingCarTool isLogin:^(BOOL success) {
        if (success)
        {
            _islogin = 1;
            [_noInfoView LoginStatus];
            [self requestForData];
        }
        else
        {
            _islogin = 0;
            //未登入状态
            [self.noInfoView noLoginStatus];
            [self showCountOfShopping:0];
        }
    } failure:^(NSError *error) {
    }];
}

-(void)requestForData
{
    [ShoppingCarTool GetCartInfo:^(id json) {
        NSString *resultCode = json[@"resultCode"];
        //请求成功
        if (!resultCode.intValue)
        {
            //先把无网络状态View 去除
            [self removeNewView];
            
            NSArray *dataArray = json[@"data"];
            [self.dataArray removeAllObjects];
            
            if (dataArray != nil && dataArray.count > 0)
            {
                //设置编辑按钮有效
                self.editBtn.hidden = NO;
                
                for (NSArray * array2 in dataArray)
                {
                    //新建一个店面，存放这个店面的商品
                    OneHouse *onehouse = [OneHouse oneHouseWithID:1 shopName:@"待定"];
                    
                    for ( NSDictionary *dic in array2)
                    {
                        //将所有商品放进一个店面中
                        GoodsInfomodel *goods = [[GoodsInfomodel alloc] initWithDict:dic];
                        [onehouse addOneGoods:goods];
                        _GoodsCount++;
                    }
                    
                    GoodsInfomodel *temp =onehouse.goods[0];
                    onehouse.shopId =[temp.shopId integerValue];
                    onehouse.shopName = temp.shopName;
                    
                    //将店面放进数组中保存
                    [self.dataArray addObject:onehouse];
                }
                [self showCountOfShopping:_GoodsCount];
            }
            else
            {
                [self.noInfoView LoginNOGoodsStatus];
                [self showCountOfShopping:0];
            }
            //重新加载视图
            //[self.shoppingCarListTableView.header endRefreshing];
            [self.shoppingCarListTableView reloadData];
        }
        //请求失败
        else
        {
            [self addAlertView];
        }
        
    } failure:^(NSError *error) {
        [self addNetView];
    }];
}

//添加netView
-(void)addNetView
{
    if (self.dataArray.count== 0) {
        [self.view addSubview:self.netView];
        self.netView.delegate =self;
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
    [self requestForData];
}

-(void)showCountOfShopping:(NSInteger)count
{
    UITabBarItem * item = [self.tabBarController.tabBar.items objectAtIndex:3];
    if (count == 0)
    {
        [item setBadgeValue:nil];
        _editBtn.hidden = YES;
    }
    else
    {
        [item setBadgeValue:[NSString stringWithFormat:@"%ld",count]];
        _editBtn.hidden = NO;
    }
}


#pragma mark
#pragma mark ------- tableView代理与数据------开始
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    double per = 1;
    if ( ScreenWidth == 414) {
        per = 1.286;
    }
    return 39;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_editStatus) // 编辑状态下 不显示cell 的尾
    {
        return 0.01;
    }
    else
    {
        return 136;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    double per = 1;
    if ( ScreenWidth == 414) {
        per = 1.16;
    }
    return 92*per;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray != nil && self.dataArray.count > 0)
    {
        OneHouse *oneHouse = self.dataArray[section];
        return oneHouse.goods.count;
    }
    else
        return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataArray != nil && self.dataArray.count > 0)
    {
        return self.dataArray.count;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify =  @"indentify";
    GoodsInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[GoodsInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.delegate = self;
    }
    //调用方法，给单元格赋值
    if (![self.dataArray isKindOfClass:[NSNull class] ] && self.dataArray.count>0 )
    {
        OneHouse * house = self.dataArray[indexPath.section];
        GoodsInfomodel *goodsInfoModel = house.goods[indexPath.row];
        cell.goodsModel = goodsInfoModel;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  判断当期是否为选中状态，如果选中状态点击则更改成未选中，如果未选中点击则更改成选中状态
     */
    if (self.dataArray.count > 0)
    {
        OneHouse * house = self.dataArray[indexPath.section];
        GoodsInfomodel *goodsInfoModel = house.goods[indexPath.row];
        if (goodsInfoModel.status.boolValue == 0  || (goodsInfoModel.tradeType.boolValue == 1 && goodsInfoModel.taxRate.integerValue == 0&&goodsInfoModel.isVirtualProduct.boolValue== 0))
        {
            UIAlertView * aview = [[UIAlertView alloc] initWithTitle:@"" message:@"对不起！该商品已失效，请选择其他商品" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [aview show];
        }
        else
        {
            goodsInfoModel.selectState = !goodsInfoModel.selectState;
            if (goodsInfoModel.selectState == 0)
            {
                house.isAllSelect =0;
                _AllSelectToDelete = 0;
                [self.editToolView setIsSelect:_AllSelectToDelete];
            }
            //刷新组
            [self.shoppingCarListTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

//设置分组的尾 显示总价格等信息
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(_editStatus) return nil; //编辑状态下 不显示cell 尾
    else
    {
        ShowSelectGoodsView *view = [[ShowSelectGoodsView alloc] init];
        view.delegate = self;
        view.tag = section;
        if (section < _dataArray.count &&_dataArray!= nil)
        {
            OneHouse * house = _dataArray[section];
            [view setValueNOLine:house.goods];
        }
        return view;
    }
}

//设置分组的头 显示该组所在的库存地
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DeliveryAddressView * view =[[DeliveryAddressView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 39)];;
    view.tag = section;
    view.delegate = self;
    if (self.dataArray.count > 0 && self.dataArray != nil )
    {
        OneHouse * house = self.dataArray[section];
        [view setValue:house.shopName isAllSelect:house.isAllSelect];
    }
    return view;
}
#pragma mark ------- tableView代理与数据------结束


#pragma  mark
#pragma  mark -cell 点击加减的代理实现
-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag
{
    [self.shoppingCarListTableView reloadData];
}


#pragma  mark————每次更新购物车内物品数量的时候 发送请求信息————————开始


#pragma  mark
#pragma  mark -——cell点击结算代理————————————开始
-(void)SettlebtnClick:(UIView *)view andFlag:(int)flag
{
    self.view.userInteractionEnabled = NO;
    
    NSMutableArray * selectGoodsArray = [[NSMutableArray alloc] init];
    NSInteger index = (NSInteger)view.tag;
    if( index < self.dataArray.count)
    {
        OneHouse *tempHouse = self.dataArray[index];
        for (GoodsInfomodel * oneGoods in tempHouse.goods )
        {
            if (oneGoods.selectState)
            {
                [selectGoodsArray addObject:oneGoods];
            }
        }
        
        if (selectGoodsArray.count == 0)
        {
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请至少选择一种商品" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [view show];
        }
        else
        {
            FirmOrderTableViewController *ftv = [[FirmOrderTableViewController alloc] initWithArray:selectGoodsArray];
            ftv.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ftv animated:YES];
        }
    }
}

#pragma  mark
#pragma  mark---每组cell 全选按钮点击的代理实现
-(void)allSelectbtnClick:(UIView *)view sender:(BOOL)sender
{
    //改变单元格选中状态
    NSInteger index = (int)view.tag;
    if (![self.dataArray isKindOfClass:[NSNull class]] && self.dataArray.count>0 && index <self.dataArray.count)
    {
        OneHouse * house = self.dataArray[index];
        house.isAllSelect = !house.isAllSelect;
        if (![house.goods isKindOfClass:[NSNull class]] && house.goods.count > 0)
        {
            for (GoodsInfomodel * oneGoods in house.goods)
            {
                if (!(oneGoods.status.boolValue == 0 ||(oneGoods.tradeType.boolValue == 1 && oneGoods.taxRate.integerValue == 0 && oneGoods.isVirtualProduct.boolValue== 0)))
                {
                    oneGoods.selectState = house.isAllSelect ;//选择状态 更改取反
                    if (oneGoods.selectState == 0) {
                        _AllSelectToDelete = 0;
                        [self.editToolView setIsSelect:_AllSelectToDelete];
                    }
                }
            }
            //刷新表格
            [self.shoppingCarListTableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}
#pragma  mark -————————代理————————————结束




#pragma  mark
#pragma  mark
#pragma  mark
#pragma  mark
#pragma  mark－－－－－－编辑状态下-----------

#pragma  mark点击右上角的 编辑按钮的响应事件
-(void)editBtnTouchDown
{
    [self allSelectToNo:_editStatus];
    _editStatus = !_editStatus; //更改是编辑的状态
    if (_editStatus)
    {
        self.shoppingCarListTableView.frame =CGRectMake(0, 0, ScreenWidth, ScreenHeight-49-64-57);
        [self.editBtn setTitle:@"完成" forState:UIControlStateNormal];
        self.editToolView.hidden = NO;
    }
    else
    {
        self.shoppingCarListTableView.frame =CGRectMake(0, 0, ScreenWidth, ScreenHeight-49-64);
        [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        self.editToolView.hidden = YES;
    }
    [self.shoppingCarListTableView reloadData];
    
}

//将所有商品的选择状态置0
-(void)allSelectToNo:(BOOL)edit
{
    if (![self.dataArray isKindOfClass:[NSNull class]] && self.dataArray.count>0)
    {
        for (OneHouse *house  in _dataArray)
        {
            house.isAllSelect = edit;
            for (GoodsInfomodel * goods in house.goods)
            {
                if(goods.status.boolValue == 0 || (goods.tradeType.boolValue == 1 && goods.taxRate.integerValue == 0&&goods.isVirtualProduct.boolValue== 0) )
                {
                    goods.selectState =NO;
                }
                else  goods.selectState = edit;;
            }
        }
        
    }
    [self.editToolView.allSelectBtn setImage:[UIImage imageNamed:@"xunfalse.png"] forState:UIControlStateNormal];
}


#pragma mark
#pragma mark编辑状态下，点击全选，晴空失效，删除按钮的代理实现
-(void)touchDown:(UIButton *)sender
{
    if (sender.tag == 101)
    {
        [self AllSelectTouchDown:sender];
    }
    else if (sender.tag == 102)
    {
        [self deleteTouchDown:sender];
    }
    else if(sender.tag == 103)
    {
        [self clearTouchDown:sender];
    }
}


#pragma mark
#pragma mark -------底部全选，全选按钮的 点按方法
//增加在底部显示删除 的view
// 点击编辑之后 进入编辑页面， 这是全选按钮的 点按方法
-(void)AllSelectTouchDown:(UIButton*)sender
{
    _AllSelectToDelete = !_AllSelectToDelete;
    if (self.dataArray)
    {
        for(OneHouse * house in _dataArray)
        {
            house.isAllSelect = _AllSelectToDelete;
            for (GoodsInfomodel * oneGoods in house.goods)
            {
                oneGoods.selectState = _AllSelectToDelete ;
            }
        }
        //刷新表格
//        if (_AllSelectToDelete)
//        {
//            [sender setImage:[UIImage imageNamed:@"xuntrue" ] forState:UIControlStateNormal];
//        }
//        else
//        {
//            [sender setImage:[UIImage imageNamed:@"xunfalse" ] forState:UIControlStateNormal];
//        }
        [self.editToolView setIsSelect:_AllSelectToDelete];
        [self.shoppingCarListTableView reloadData];
    }
}



#pragma mark
#pragma mark -------点击清空失效商品;
-(void)clearTouchDown:(UIButton*)sender
{
    NSMutableArray *clearArray = [[NSMutableArray alloc] initWithCapacity:2];
    //寻找失效商品
    for (int i = 0 ; i < self.dataArray.count; i++)
    {
        OneHouse *onehouse = self.dataArray[i];
        for (int j = 0 ; j<onehouse.goods.count; j++)
        {
            GoodsInfomodel * goods = onehouse.goods[j];
            if (goods.status.boolValue == 0 || (goods.tradeType.boolValue == 1 && goods.taxRate.integerValue == 0&&goods.isVirtualProduct.boolValue== 0))
            {
                //如果是失效商品， 加入失效商品的数组内
                [clearArray addObject:goods];
            }
        }
    }
    //如果失效商品数组内没有 对象， 就没有失效商品，那就显示没有失效商品的弹窗
    if (clearArray.count == 0 )
    {
        UIAlertView * view = [[UIAlertView alloc] initWithTitle:nil message:@"没有失效商品了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [view show];
    }
    else// 否则，就是有失效商品，执行清理失效商品的请求，并在本地删除数据
    {
        
        NSString * urlStr =[NSString stringWithFormat:@"%@%@",TEST_URL,RemoveCartInfoURL];
        NSString * token =[UserManager getMyObjectForKey:accessTokenKey];
        NSString * MemberID = [UserManager getMyObjectForKey:userIDKey];
        
        if (token && MemberID)
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setValue:token forKey:@"token"];
            [dic setValue:MemberID forKey:@"MemberID"];
            NSString * sign = [HttpTool returnForSign:dic];
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            [dict setValue:token forKey:@"token"];
            [dict setValue:MemberID forKey:@"MemberID"];
            dict[@"sign"] = sign;
            
            [HttpTool post:urlStr params:dict success:^(id json) {
                //发送请求之后，清理数据
                NSString *resultCode = json[@"resultCode"];
                //请求成功
                if (!resultCode.intValue)
                {
                    [self removeNewView];
                    NSMutableArray *onehouseArrayTemp = [[NSMutableArray alloc] init];
                    for (OneHouse *onehouse in self.dataArray) {
                        [onehouse.goods removeObjectsInArray:clearArray];
                        if (onehouse.goods.count == 0)
                        {
                            [onehouseArrayTemp addObject:onehouse];
                        }
                    }
                    // 如果这个商品所在的仓库没有商品了，那就删除该仓库
                    if (onehouseArrayTemp.count)
                    {
                        [self.dataArray removeObjectsInArray:onehouseArrayTemp];
                        
                    }
                    if (self.dataArray.count == 0)
                    {
                        [self.navigationController popViewControllerAnimated:YES];
                        //[self.delegate editViewDelegate:self.goodsArray];
                    }
                    // 重新加载数据到视图中
                    [self.shoppingCarListTableView reloadData];
                    
                    if (_dataArray.count == 0) {
                        _editBtn.hidden = YES;
                        [self editBtnTouchDown];
                        [_noInfoView LoginNOGoodsStatus];
                    }

                }
                else
                {
                    [self addAlertView];
                }

                
            } failure:^(NSError *error) {
                //NSLog(@"%@",error);
                [self addNetView];
            }];
        }
    }
    
}


#pragma mark
#pragma mark -------底部点击删除选中的商品 点按方法
//点击删除选中的商品
-(void)deleteTouchDown:(UIButton*)sender
{
    if(self.dataArray)
    {
        for(OneHouse * house in self.dataArray)
        {
            for (GoodsInfomodel * oneGoods in house.goods)
            {
                if (oneGoods.selectState == 1 ) {
                    [self.deleteArray addObject:oneGoods];
                }
            }
        }
        if (self.deleteArray.count == 0) {
            UIAlertView * aview = [[UIAlertView alloc] initWithTitle:@"" message:@"您还没有选择需要删除的商品" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [aview show];
        }
        else{
            UIAlertView * aview = [[UIAlertView alloc] initWithTitle:@"" message:@"确定删除该商品吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            aview.tag = 1;
            [aview show];
        }
    }
}


#pragma mark
#pragma mark -------UIAlertView 代理 用来 监听是否删除
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //发送删除选择的商品 请求
        [self requestDeleteCatInfo];// 清除数据
    }
}



#pragma mark
#pragma mark -------发送删除商品的请求 事件
-(void)requestDeleteCatInfo
{
    [ShoppingCarTool requestDeleteCatInfo:self.deleteArray success:^(BOOL success) {
        if (success) {
            
            _GoodsCount -= self.deleteArray.count;
            [self showCountOfShopping:_GoodsCount];
            NSMutableArray *onehouseArrayTemp = [[NSMutableArray alloc] init];
            
            for (OneHouse *onehouse in self.dataArray)
            {
                [onehouse.goods removeObjectsInArray:self.deleteArray];
                if (onehouse.goods.count == 0)
                {
                    [onehouseArrayTemp addObject:onehouse];
                }
            }
            if (onehouseArrayTemp.count)
            {
                [self.dataArray removeObjectsInArray:onehouseArrayTemp];
                
            }
            
            if (self.dataArray.count == 0)
            {
                self.noInfoView.headImage.hidden = YES;
                self.noInfoView.sweetPrompt.hidden = YES;
                self.noInfoView.hidden = NO;
                [self showCountOfShopping:0];
            }
            
            [self.deleteArray removeAllObjects];
            [self.shoppingCarListTableView reloadData];
        }
        
        if (_dataArray.count == 0) {
            _editBtn.hidden = YES;
            [self editBtnTouchDown];
            [_noInfoView LoginNOGoodsStatus];
            
        }
    } failure:^(NSError *error) {
        
        
    }];
    
}






@end
