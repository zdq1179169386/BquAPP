//
//  ReturnGoodsController.m
//  Bqu
//
//  Created by yb on 15/10/27.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ReturnGoodsController.h"
#import "ApplyForRefundCell.h"
#import "ApplyForRefundAlertView.h"
#import "RefundOrderDetailController.h"

@interface ReturnGoodsController ()<UITableViewDataSource,UITableViewDelegate>
{
    int _row;
    NSArray * _array;
    NSTimer * timer;
}
@property(nonatomic,strong)UITableView * tableView;

/**物流方式,no是其他方式*/
@property (nonatomic,assign)BOOL  logistics;

@end

@implementation ReturnGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (IOS7_OR_LATER)
    {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    [self initNav];
    [self initTable];
}
-(void)initNav
{
    self.title = @"填写退货物流";
    UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.logistics = YES;
    _row = 0;
    _array = [NSArray arrayWithObjects:@"请选择物流方式", @"顺丰",@"EMS",@"其他",nil];
    
    
   
    
}
#pragma mark -- 提交申请
-(void)commitApply:(UIButton*)btn
{
    NSIndexPath * index0 = [NSIndexPath indexPathForRow:0 inSection:0];
    ApplyForRefundCell * cell0 = (ApplyForRefundCell*)[self.tableView cellForRowAtIndexPath:index0];
    
    NSIndexPath * index1 = [NSIndexPath indexPathForRow:1 inSection:0];
    ApplyForRefundCell * cell1 = (ApplyForRefundCell*)[self.tableView cellForRowAtIndexPath:index1];
    
    NSIndexPath * index2 = [NSIndexPath indexPathForRow:2 inSection:0];
    ApplyForRefundCell * cell2 = (ApplyForRefundCell*)[self.tableView cellForRowAtIndexPath:index2];
    
    NSIndexPath * index3 = [NSIndexPath indexPathForRow:3 inSection:0];
    ApplyForRefundCell * cell3 = (ApplyForRefundCell*)[self.tableView cellForRowAtIndexPath:index3];
    
    NSString * ExpressCompanyName = nil;
    NSString * ShipOrderNumber = nil;
    NSString * GoodsReturnRemark = nil;
    if (self.logistics) {
        if (cell2.textView.text.length==0 || cell1.textField.text.length==0) {
            [ProgressHud addProgressHudWithView:self.view andWithTitle:@"不能为空"];
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerOver) userInfo:nil repeats:YES];
            return;
            
        }else
        {
            ExpressCompanyName = cell0.btn.text;
            ShipOrderNumber = cell1.textField.text;
            GoodsReturnRemark = cell2.textView.text;
            [self returnGoods:ExpressCompanyName with:ShipOrderNumber with:GoodsReturnRemark];
        }
        
    }else
    {
        //其他物流方式
        if (cell2.textField.text.length==0 || cell1.textField.text.length==0||cell3.textView.text.length==0) {
            [ProgressHud addProgressHudWithView:self.view andWithTitle:@"不能为空"];
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerOver) userInfo:nil repeats:YES];
            return;
        }else
        {
            ExpressCompanyName = cell1.textField.text;
            ShipOrderNumber = cell2.textField.text;
            GoodsReturnRemark = cell3.textView.text;
           
            [self returnGoods:ExpressCompanyName with:ShipOrderNumber with:GoodsReturnRemark];

        }
        
    }
    
    
   
}
- (void)timerOver {
    
    [ProgressHud hideProgressHudWithView:self.view];
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}
#pragma mark -- 退货
-(void)returnGoods:(NSString*)ExpressCompanyName with:(NSString*)ShipOrderNumber with:(NSString*)GoodsReturnRemark
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/api/order/refund/AddUserShip",TEST_URL];
    //创建，安字段创建
    NSString * memberId = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    NSString * sellerName = [UserManager getMyObjectForKey:userNameKey];
    if (memberId && token && sellerName) {
        
        NSDictionary * dict = @{@"refundId":self.refundId,@"MemberID":memberId,@"ExpressCompanyName":ExpressCompanyName,@"ShipOrderNumber":ShipOrderNumber,@"GoodsReturnRemark":GoodsReturnRemark,@"token":token,@"SellerName":sellerName};
        NSString * realSign = [HttpTool returnForSign:dict];
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:dict];
        dic[@"sign"] = realSign;
        
        __block ReturnGoodsController * blockSelf = self;
        [HttpTool post:urlStr params:dic success:^(id json) {
            
            NSLog(@"%@",json);
            if (!json[@"error"]) {
                NSString * str = json[@"message"];
                
                if ([str isEqualToString:@"操作成功"]) {
                    [ProgressHud addProgressHudWithView:self.view andWithTitle:str];
                    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerOverSuccess) userInfo:nil repeats:NO];
                 
                }else
                {
                    str = [str substringWithRange:NSMakeRange(3, str.length-3)];
                    [ProgressHud addProgressHudWithView:self.view andWithTitle:str];
                    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerOver) userInfo:nil repeats:NO];
                }
                
            }else
            {
               
            }
        } failure:^(NSError *error) {
            
            
        }];
    }
    

}
#pragma mark --成功后的跳转方法
-(void)timerOverSuccess
{
    [ProgressHud hideProgressHudWithView:self.view];
    //申请完成，再跳到售后但详情页
    RefundOrderDetailController * vc = [[RefundOrderDetailController alloc] init];
    vc.refundId = self.refundId;
    [self.navigationController pushViewController:vc animated:YES];
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initTable
{
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [[UIView alloc] init];
        [self.tableView registerClass:[ApplyForRefundCell class] forCellReuseIdentifier:@"cell"];
        [self.view addSubview:self.tableView];
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-64-50, ScreenWidth, 50)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, ScreenWidth-10, 40)];
        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:@"提交申请" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(commitApply:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 5;
        btn.clipsToBounds = YES;
        [view addSubview:btn];
        
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [view addSubview:line];

    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.logistics) {
        return 3;
    }else
    {
        return 4;

    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplyForRefundCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.textField.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        
        NSString * str = [NSString stringWithFormat:@"  * 物流公司"];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
        [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
        cell.label.attributedText = attr;
        cell.btn.text = [_array objectAtIndex:_row];
        return cell;
    }else if(indexPath.row ==1)
    {
        if (self.logistics) {
            NSString * str = [NSString stringWithFormat:@"  * 物流单号"];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
            cell.label.attributedText = attr;
            cell.rightImage.hidden = YES;
            cell.btn.hidden = YES;
            cell.textField.hidden = NO;
            cell.textField.placeholder = @"物流单号";
            
        }else
        {
            NSString * str = [NSString stringWithFormat:@"  * 公司名称"];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
            cell.label.attributedText = attr;
            cell.rightImage.hidden = YES;
            cell.btn.hidden = YES;
            cell.textField.hidden = NO;
            cell.textField.placeholder = @"其他物流公司";
        }
       
        
        return cell;
    }else if (indexPath.row==2)
    {
        if (self.logistics) {
            NSString * str = [NSString stringWithFormat:@"  * 退货说明"];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
            cell.label.attributedText = attr;
            cell.rightImage.hidden = YES;
            cell.btn.hidden = YES;
            cell.textField.hidden = YES;
            cell.textView.hidden = NO;
            
        }else
        {
            NSString * str = [NSString stringWithFormat:@"  * 物流单号"];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
            cell.label.attributedText = attr;
            cell.rightImage.hidden = YES;
            cell.btn.hidden = YES;
            cell.textField.hidden = NO;
            cell.textField.placeholder = @"物流单号";
            
        }
        
    }else if (indexPath.row==3)
    {
        if (self.logistics) {
            return nil;
            
        }else
        {
            NSString * str = [NSString stringWithFormat:@"  * 退货说明"];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
            cell.label.attributedText = attr;
            cell.rightImage.hidden = YES;
            cell.btn.hidden = YES;
            cell.textField.hidden = YES;
            cell.textView.hidden = NO;
            

        }
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.logistics) {
        if (indexPath.row==2) {
            return 100;
        }else
        {
              return 44;
        }
      
    }else
    {
        if (indexPath.row==3) {
            return 100;
        }else
        {
            return 44;

        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    if (indexPath.row==0) {
        NSArray * array = [NSArray arrayWithObjects:@"顺丰",@"EMS",@"其他",nil];

        ApplyForRefundAlertView * alertView = [[ApplyForRefundAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) withDelegate:self withTitle:@"请选择物流" withArray:array withIndexPath:indexPath];
        [window addSubview:alertView];
    }
    
}
-(void)ApplyForRefundAlertViewBtnClick:(ApplyForRefundAlertView*)view withStr:(NSString *)title withIndexPath:(NSIndexPath*)index withRow:(int)row
{
    if (index.row==0) {
        _row = row+1;
        if ([title isEqualToString:@"其他"]) {
            self.logistics = NO;
        }else
        {
            self.logistics = YES;
        }
        
    }
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
