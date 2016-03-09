//
//  SelectOtherAddressTableViewController.m
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "SelectOtherAddressTableViewController.h"

#import "ReceivingInformationTableViewCell.h"
#import "AddAddressViewController.h"
#import "ShoppingCarTool.h"

@interface SelectOtherAddressTableViewController ()<UITableViewDataSource,UITableViewDelegate,addAddressDelegate>


@property (nonatomic)NSMutableArray * addressIDArray;
@property (nonatomic)UITableView * tableView;
@property (nonatomic)NSMutableArray *arrAddress;
@property (nonatomic,strong)SelectOtherAddressBlock block;
@end

@implementation SelectOtherAddressTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64-50) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self createBackBar];
    self.navigationItem.title = @"选择收货地址";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addButton];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.addressIDArray = [[NSMutableArray alloc] init];
    [self loadAddress:1];
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

-(void)addButton
{
    UIButton * addBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, ScreenHeight - 50-64, ScreenWidth-20, 44)];
    addBtn.backgroundColor = [UIColor colorWithHexString:@"#e8103c"];
    addBtn.layer.cornerRadius = 4;
    [addBtn setTitle:@"添加新地址" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(newAddress) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:addBtn];
}

-(void)newAddress
{
    AddAddressViewController * avc = [[AddAddressViewController alloc] init];
    avc.delegate = self;
    [self.navigationController pushViewController: avc animated:YES];
}

-(void)loadAddress:(int)type
{
    _arrAddress= [[NSMutableArray alloc] initWithCapacity:4];
    [ShoppingCarTool requestAllAddress:^(id json) {
        NSArray *data = json[@"data"];
        
        NSString *resultCode = json[@"resultCode"];
        //请求成功
        if (!resultCode.intValue)
        {
            //先把无网络状态View 去除
            [self removeNewView];
            
            NSArray * array = data;
            
            if (![array isKindOfClass:[NSNull class]] && array.count > 0)
            {
                //默认地址保存到数组第一个
                AddressModel *DefaultAddress;
                //如果是第一次请求
                if (type == 1) {
                    [self.addressIDArray removeAllObjects];
                }
                for (NSDictionary *dictory in array)
                {
                    AddressModel* addressModel = [AddressModel addressModelWithAlladdressDict:dictory];
                    
                    //如果是默认地址，就先保存起来，
                    if(addressModel.isDefault.boolValue)
                    {
                        DefaultAddress = addressModel;
                    }
                    else
                    {
                        [self.arrAddress addObject:addressModel];
                    }
                    //如果是第一次请求
                    if (type ==1)
                    {
                        [self.addressIDArray addObject:addressModel.Id];
                    }
                }
                // 有默认地址时候才进行插入
                if(DefaultAddress) [self.arrAddress insertObject:DefaultAddress atIndex:0];
                
            }
            
            if  (type == 2)
            {
                AddressModel *address  = nil;
                //如果只有一个地址
                if (self.addressIDArray.count == 0)
                {
                    address = _arrAddress[0];
                }
                else
                {
                    for (AddressModel *model in self.arrAddress)
                    {
                        // 是否有这个model
                        BOOL have = NO;
                        for ( id ID in self.addressIDArray)
                        {
                            NSString * idStr = [NSString stringWithFormat:@"%@",ID];
                            NSString * addStr = [NSString stringWithFormat:@"%@",model.Id];
                            if ([addStr isEqualToString: idStr]){
                                //如果相等，就是有这个值
                                have = YES;
                                break;
                            }
                        }
                        //没有这个值，就是新加地址
                        if (!have) {
                            address = model;
                            break;
                        }
                    }
                }
                if (_block)
                {
                    _block(address);
                }
                [self.navigationController popViewControllerAnimated:YES];
                return ;
            }
            [self.tableView reloadData];
        }
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
    if (self.arrAddress.count == 0) {
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
    [self loadAddress:1];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arrAddress.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReceivingInformationTableViewCell *cell = [ReceivingInformationTableViewCell receivingInformationTableViewCell:tableView];
    // 设置 无箭头
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    [cell setValue:_arrAddress[indexPath.section]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_block)
    {
        AddressModel *address = _arrAddress[indexPath.section];
        _block(address);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addAddressSave:(NSDictionary *)dic
{
    [self loadAddress:2];
   // AddressModel *address = [[AddressModel alloc] init];
}

-(void)setBlock:(SelectOtherAddressBlock)block
{
    _block = block;
}
@end
