//
//  EvaluateViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "EvaluateViewController.h"
#import "EvaluateCell.h"
#import "MyOrderViewController.h"

@interface EvaluateViewController ()

@end

@implementation EvaluateViewController
- (void)viewWillAppear:(BOOL)animated
{
    [self createBackBar];
}


#pragma mark    ------------------>   请求数据
- (void)requestData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,addEvaluatelUrl];
//    NSLog(@"评价 %@",urlStr);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"MemberID"] = [UserManager getMyObjectForKey:userIDKey];
    dict[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
    dict[@"OrderId"] = self.orderID;
    dict[@"PackMark"] = self.pack_Str;
    dict[@"DeliveryMark"] = self.delivery_Str;
    dict[@"ServiceMark"] = self.serve_Str;
    
    NSError * error = nil;
    NSData * data = [NSJSONSerialization dataWithJSONObject:self.comentsArr options:NSJSONWritingPrettyPrinted error:&error];
    NSString * dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    dict[@"ProductComments"] = dataStr;
    NSString *realSign = [HttpTool returnForSign:dict];
    dict[@"sign"] = realSign;
    [HttpTool post:urlStr params:dict success:^(id json)
    {
        NSLog(@"评价 message%@",json);
        
        NSString *resC = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
        if ([resC isEqualToString:@"0"])
        {
            [TipView doSomething:^{

                NSArray *ctrlArray = self.navigationController.viewControllers;
                MyOrderViewController *vc = (MyOrderViewController *)[ctrlArray objectAtIndex:1];
                vc.isEvaluate = @"0";
                [self.navigationController popToViewController:[ctrlArray objectAtIndex:1] animated:NO];
            } afterDelayTime:1.5];
            
          [TipView remindAnimationWithTitle:json[@"message"]];
        }
        else
        {
            [TipView doSomething:^{
                
            } afterDelayTime:1.5];
            
            
           [TipView remindAnimationWithTitle:json[@"message"]];
        }

        
    } failure:^(NSError *error) {
        
        
    }];


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的评价";
    self.view.backgroundColor = RGB_A(240, 238, 238);
    
    [self createMainTable];
    
    //初始化评论数组 里面是每个商品的评论
    self.comentsArr = [NSMutableArray array];
    
    //在评论数组加上每个商品的评论内容字典
    NSArray * array = self.order.itemInfoArray;
    for (int i = 0; i<array.count; i++)
    {
        MyOrderItems_Model * item  = array[i];
        NSMutableDictionary *dict =[NSMutableDictionary dictionary];;
        dict[@"orderItmeId"] = item.ID;
        [self.comentsArr addObject:dict];

    }
}

#pragma mark    ----> 表
- (void)createMainTable
{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"EvaluateCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 214;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *tip_Lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, 230, 28)];
    tip_Lab.font = [UIFont systemFontOfSize:12];
    tip_Lab.textColor = [UIColor colorWithHexString:@"#333333"];
    tip_Lab.textAlignment = NSTextAlignmentLeft;
    tip_Lab.text = @"动态评分";
    [view addSubview:tip_Lab];
    
    UILabel *serve_Lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 47, 69, 21)];
    serve_Lab.font = [UIFont systemFontOfSize:12];
    serve_Lab.textColor = [UIColor colorWithHexString:@"#888888"];
    serve_Lab.textAlignment = NSTextAlignmentLeft;
    serve_Lab.text = @"服务态度";
    [view addSubview:serve_Lab];
    UILabel *delivery_Lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 69, 21)];
    delivery_Lab.font = [UIFont systemFontOfSize:12];
    delivery_Lab.textColor = [UIColor colorWithHexString:@"#888888"];
    delivery_Lab.textAlignment = NSTextAlignmentLeft;
    delivery_Lab.text = @"物流速度";
    [view addSubview:delivery_Lab];
    UILabel *pack_Lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 133, 69, 21)];
    pack_Lab.font = [UIFont systemFontOfSize:12];
    pack_Lab.textColor = [UIColor colorWithHexString:@"#888888"];
    pack_Lab.textAlignment = NSTextAlignmentLeft;
    pack_Lab.text = @"动态评分";
    [view addSubview:pack_Lab];
    
    
    CWStarRateView *serve_start = [[CWStarRateView alloc] initWithFrame:CGRectMake(ScreenWidth-137, 47, 120, 22) numberOfStars:5];
    serve_start.delegate = self;
    serve_start.tag = 500;
    serve_start.scorePercent = 0;
    serve_start.allowIncompleteStar = NO;
    serve_start.hasAnimation = YES;
    [view addSubview:serve_start];
    
    CWStarRateView *delivery_start = [[CWStarRateView alloc] initWithFrame:CGRectMake(ScreenWidth-137, 90, 120, 22) numberOfStars:5];
    delivery_start.tag = 501;
    delivery_start.delegate = self;
    delivery_start.scorePercent = 0;
    delivery_start.allowIncompleteStar = NO;
    delivery_start.hasAnimation = YES;
    [view addSubview:delivery_start];
    
    CWStarRateView *pack_start = [[CWStarRateView alloc] initWithFrame:CGRectMake(ScreenWidth-137, 133, 120, 22) numberOfStars:5];
    pack_start.tag = 502;
    pack_start.delegate = self;
    pack_start.scorePercent = 0;
    pack_start.allowIncompleteStar = NO;
    pack_start.hasAnimation = YES;
    [view addSubview:pack_start];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(ScreenWidth-80, 178, 60, 26);
    [commitButton setTitle:@"提交评论" forState:UIControlStateNormal];
    commitButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [commitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commitButton onlyCornerRadius];
    commitButton.backgroundColor = RGB_A(242, 0, 56);
    [commitButton addTarget:self action:@selector(footButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:commitButton];

    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 168, ScreenWidth, 1)];
    topLine.backgroundColor = RGB_A(214, 214, 214);
    [view addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 213, ScreenWidth, 1)];
    bottomLine.backgroundColor = RGB_A(214, 214, 214);
    [view addSubview:bottomLine];
    return view;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [NSArray array];
    array = self.order.itemInfoArray;
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    EvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if (!cell)
    {
        NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:@"EvaluateCell" owner:nil options:nil];
        cell = [xibArray objectAtIndex:0];
        
    }

    NSArray *array = [NSArray array];
    array = self.order.itemInfoArray;
    MyOrderItems_Model *item = array[indexPath.row] ;
    [cell.product_ImgView sd_setImageWithURL:[NSURL URLWithString:item.image] placeholderImage:[UIImage imageNamed:@"个人中心-我的订单&评价商品&商品详情-占位图-118x118-"]];
    cell.productName_Lab.text = item.productName;
    cell.productPrice_Lab.text = [NSString stringWithFormat:@"￥%0.2f",[item.price floatValue]];
    cell.productCount_Lab.text = [NSString stringWithFormat:@"x%d", [item.count intValue]];
    cell.evaluate_TextV.delegate = self;
    cell.evaluate_TextV.tag = 323+indexPath.row;
    cell.evaluate_TextV.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
    cell.evaluate_TextV.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    cell.evaluate_TextV.layer.borderWidth = 1;
    cell.evaluate_TextV.layer.cornerRadius = 4;
    
    cell.cell_star.delegate = self;
    cell.cell_star.scorePercent = 0;
    cell.cell_star.allowIncompleteStar = NO;
    cell.cell_star.hasAnimation = YES;
    cell.cell_star.tag = indexPath.row+503;


    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
      return cell;
}

//- (void)textViewDidEndEditing:(UITextView *)textView;
//
//{
//    EvaluateCell *cell = (EvaluateCell *)[[textView superview] superview];
//    NSIndexPath *path = [self.tableView indexPathForCell:cell];
//    
//    if (textView.tag == path.row + 323)
//    {
//        
//        NSMutableDictionary * comtent = [self.comentsArr objectAtIndex:path.row];
//        comtent[@"content"] = textView.text;
//        [self.comentsArr replaceObjectAtIndex:path.row withObject:comtent];
//        
//    }
//
//}
-(void)textViewDidChange:(UITextView *)textView
{
    EvaluateCell *cell = (EvaluateCell *)[[textView superview] superview];
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    
    if (textView.tag == path.row + 323)
    {
        
        NSMutableDictionary * comtent = [self.comentsArr objectAtIndex:path.row];
        comtent[@"content"] = textView.text;
        [self.comentsArr replaceObjectAtIndex:path.row withObject:comtent];
        
    }
    

}

- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent
{
    if (starRateView.tag == 500)
    {
        self.serve_Str = [NSString stringWithFormat:@"%0.0f",newScorePercent*5];

    }else if (starRateView.tag == 501)
    {
        self.delivery_Str = [NSString stringWithFormat:@"%0.0f",newScorePercent*5];

    }
    else if (starRateView.tag == 502)
    {
        self.pack_Str = [NSString stringWithFormat:@"%0.0f",newScorePercent*5];

    }else
    {
        EvaluateCell *cell = (EvaluateCell *)[[starRateView superview] superview];
        NSIndexPath *path = [self.tableView indexPathForCell:cell];
        
        if (starRateView.tag == path.row +503)
        {
            NSMutableDictionary * comtent = [self.comentsArr objectAtIndex:path.row];
            comtent[@"star"] = [NSString stringWithFormat:@"%0.0f",newScorePercent*5];
            [self.comentsArr replaceObjectAtIndex:path.row withObject:comtent];
        }
        
    }
    
}

- (void)footButtonClick
{
    [self.view endEditing:YES];
    
    for (NSMutableDictionary *did in self.comentsArr)
    {
        NSLog(@"starCount= = %@",did[@"star"]);
        NSLog(@"content= = %@",did[@"content"]);
        NSLog(@"productId= = %@",did[@"orderItmeId"]);
    
    }
    
    
    
    if (![self.pack_Str isEqualToString:@"0" ] && ![self.delivery_Str isEqualToString:@"0"] &&![self.serve_Str isEqualToString:@"0"] )
    {
        for (NSMutableDictionary *did in self.comentsArr)
        {
            NSString *ss = did[@"star"];
            if (ss  == nil)
            {
                [TipView remindAnimationWithTitle:@"星级不可以为0哦~"];

                return;

            }
            
            NSString *cc = did[@"content"];
            if (cc  == nil)
            {
                [TipView remindAnimationWithTitle:@"评论不可以为空哦~"];
                
                return;
                
            }

        }
        [self requestData];
    }
    else
    {
       [TipView remindAnimationWithTitle:@"星级不可以为0哦~"];
        
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<0) {
        [self.view endEditing:YES];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
