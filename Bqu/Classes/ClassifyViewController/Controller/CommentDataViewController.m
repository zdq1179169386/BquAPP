//
//  CommentDataViewController.m
//  Bqu
//
//  Created by yb on 15/10/21.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "CommentDataViewController.h"
#import "CommentHeaderCell.h"
#import "CommentTablevIewCell.h"
#import "CommentModel.h"
@interface CommentDataViewController ()<UITableViewDataSource,UITableViewDelegate,CommentHeaderCellDelegate,UIWebViewDelegate>

/**好评数*/
@property (nonatomic,copy)NSString * goodComment;
/**坏评数*/
@property (nonatomic,copy)NSString * badComment;
/**中评数*/
@property (nonatomic,copy)NSString * comment;
/**总评数*/
@property (nonatomic,copy)NSString * allComment;
/**数据源*/
@property (nonatomic,strong) NSArray * commentArray;

@property (nonatomic,strong) UITableView * tabelView;
/**web*/
@property (nonatomic,strong)UIWebView * webView;
/**表头*/
@property (nonatomic,weak)UIScrollView * scrollview;

@end

@implementation CommentDataViewController

-(void)dealloc
{
    self.goodComment = nil;
    self.badComment = nil;
    self.comment = nil;
    self.allComment = nil;
    self.commentArray = nil;
    self.tabelView = nil;
    self.productId = nil;
    self.ReviewMark = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOS7_OR_LATER)
    {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    [self initNavBar];
    [self initWeb];
    
}
-(void)initWeb
{
    if (!self.webView) {
        self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        self.webView.delegate = self;
        NSString * urlStr = [NSString stringWithFormat:@"%@/app/ProductComment?pid=%@",WX_URL,self.productId];
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [self.webView loadRequest:request];
        self.webView.scalesPageToFit = YES;
        __weak UIScrollView * scrollView = self.webView.scrollView;
        scrollView.header = [DIYHeader headerWithRefreshingBlock:^{
            [self.webView reload];
        }];
        self.scrollview = scrollView;
        [self.view addSubview:self.webView];
    }
}
-(void)initNavBar
{
    self.title = @"评论";
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHexString:@"#333333"]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"f9f9f9"]];
    UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}
#pragma mark -- webview Delegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [ProgressHud addProgressHudWithView:self.view andWithTitle:@"加载中"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

    [ProgressHud hideProgressHudWithView:self.view];
    [self.scrollview.header endRefreshing];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [ProgressHud hideProgressHudWithView:self.view];
    [self.scrollview.header endRefreshing];
}

#pragma mark -- 返回按钮
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark -- 获取所有评价
-(void)requestForAllComment
{

    // 获取商品评价数／商品评分
    NSString * urlStr1 = [NSString stringWithFormat:@"%@/api/home/Product/Comment/List",TEST_URL];
    
    NSDictionary * dict1 = @{@"pid":self.productId,@"type":@"0",@"page":@"1",@"pagesize":@"20"};
    NSString * sign1 = [HttpTool returnForSign:dict1];
    
    NSMutableDictionary * dict2 = [NSMutableDictionary dictionary];
    dict2[@"pid"] = self.productId;
    dict2[@"type"] = @"0";
    dict2[@"page"] = @"1";
    dict2[@"pagesize"] = @"20";
    dict2[@"sign"] = sign1;
    
    [HttpTool post:urlStr1 params:dict2 success:^(id json) {
        
//        NSLog(@"__%@",json[@"data"]);
        if (!json[@"error"]) {
           
            
            NSDictionary * dic = (NSDictionary *)json[@"data"];
            NSArray * array = [CommentModel objectArrayWithKeyValuesArray:dic[@"comments"]];
            self.commentArray = [self modelFrameWithModel:array];

            self.goodComment = dic[@"goodComment"];
            self.badComment = dic[@"badComment"];
            self.comment = dic[@"comment"];
            self.allComment = [NSString stringWithFormat:@"%lu",(unsigned long)array.count];
//            CommentModel * model = [array lastObject];
//            NSLog(@"%@",model.ReviewContent);
            
            
            
        }
        [self.tabelView reloadData];
       
    } failure:^(NSError *error) {
        
    }];
}
-(NSArray *)modelFrameWithModel:(NSArray*)models
{
    NSMutableArray * frames = [NSMutableArray array];
    for (CommentModel *model in models) {
        
        CommentModelFrame * f =  [[CommentModelFrame alloc] init];
        f.comment = model;
        [frames addObject:f];
    }
    return frames;
}
#pragma mark -- 获取所有好评
-(void)requestForAllGoodComment
{
    // 获取商品评价数／商品评分
    NSString * urlStr1 = [NSString stringWithFormat:@"%@/api/home/Product/Comment/List",TEST_URL];
    
    NSDictionary * dict1 = @{@"pid":self.productId,@"type":@"1",@"page":@"1",@"pagesize":@"20"};
    NSString * sign1 = [HttpTool returnForSign:dict1];
    
    NSMutableDictionary * dict2 = [NSMutableDictionary dictionary];
    dict2[@"pid"] = self.productId;
    dict2[@"type"] = @"1";
    dict2[@"page"] = @"1";
    dict2[@"pagesize"] = @"20";
    dict2[@"sign"] = sign1;
    
    [HttpTool post:urlStr1 params:dict2 success:^(id json) {
                NSLog(@"__%@",json[@"data"]);
        
        if (!json[@"error"]) {
            
            NSDictionary * dic = (NSDictionary *)json[@"data"];
            NSArray * array = [CommentModel objectArrayWithKeyValuesArray:dic[@"comments"]];
            self.commentArray = [self modelFrameWithModel:array];
        }
        [self.tabelView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 获取所有中评
-(void)requestForComment
{
    // 获取商品评价数／商品评分
    NSString * urlStr1 = [NSString stringWithFormat:@"%@/api/home/Product/Comment/List",TEST_URL];
    
    NSDictionary * dict1 = @{@"pid":self.productId,@"type":@"2",@"page":@"1",@"pagesize":@"20"};
    NSString * sign1 = [HttpTool returnForSign:dict1];
    
    NSMutableDictionary * dict2 = [NSMutableDictionary dictionary];
    dict2[@"pid"] = self.productId;
    dict2[@"type"] = @"2";
    dict2[@"page"] = @"1";
    dict2[@"pagesize"] = @"20";
    dict2[@"sign"] = sign1;
    
    [HttpTool post:urlStr1 params:dict2 success:^(id json) {
        NSLog(@"__%@",json[@"data"]);
        
        if (!json[@"error"]) {
            
            NSDictionary * dic = (NSDictionary *)json[@"data"];
            NSArray * array = [CommentModel objectArrayWithKeyValuesArray:dic[@"comments"]];
            self.commentArray = [self modelFrameWithModel:array];
        }
        [self.tabelView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 获取所有差评
-(void)requestForBadComment
{
    // 获取商品评价数／商品评分
    NSString * urlStr1 = [NSString stringWithFormat:@"%@/api/home/Product/Comment/List",TEST_URL];
    
    NSDictionary * dict1 = @{@"pid":self.productId,@"type":@"3",@"page":@"1",@"pagesize":@"20"};
    NSString * sign1 = [HttpTool returnForSign:dict1];
    
    NSMutableDictionary * dict2 = [NSMutableDictionary dictionary];
    dict2[@"pid"] = self.productId;
    dict2[@"type"] = @"3";
    dict2[@"page"] = @"1";
    dict2[@"pagesize"] = @"20";
    dict2[@"sign"] = sign1;
    
    [HttpTool post:urlStr1 params:dict2 success:^(id json) {
        NSLog(@"__%@",json[@"data"]);
        
        if (!json[@"error"]) {
            
            NSDictionary * dic = (NSDictionary *)json[@"data"];
            NSArray * array = [CommentModel objectArrayWithKeyValuesArray:dic[@"comments"]];
            self.commentArray = [self modelFrameWithModel:array];
        }
        [self.tabelView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 初始化表
-(void)initTabelView
{
    if (!self.tabelView) {
        self.tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        self.tabelView.delegate = self;
        self.tabelView.dataSource = self;
        self.tabelView.tableFooterView = [[UIView alloc] init];
        [self.tabelView registerClass:[CommentHeaderCell class] forCellReuseIdentifier:@"header"];
//        [self.tabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        self.tabelView.backgroundColor = [UIColor colorWithHexString:@"#F2f1f1"];
        [self.tabelView registerClass:[CommentTablevIewCell class] forCellReuseIdentifier:@"cell"];

        [self.view addSubview:self.tabelView];
    }
    
}
#pragma mark -- tableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArray.count+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        CommentHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"header" forIndexPath:indexPath];
        if (!cell) {
            cell = [[CommentHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"header"];
            
        }
        cell.ReviewMark = self.ReviewMark;
        cell.allComment = self.allComment;
        cell.goodComment = self.goodComment;
        cell.comment = self.comment;
        cell.badComment = self.badComment;
        cell.delegate = self;
        return cell;
    }else
    {
        CommentTablevIewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[CommentTablevIewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
            
        }
        if (self.commentArray.count>0) {
             cell.modelFrame = [self.commentArray objectAtIndex:indexPath.row-1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;

    }
     return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 && indexPath.row ==0) {
        
        return 80;
    }
    else
    {
        if (0<self.commentArray.count) {
            CommentModelFrame * frame = [self.commentArray objectAtIndex:indexPath.row-1];
            return frame.cellHeight;

        }else
            return 0;
    }
}
#pragma mark -- CommentHeaderCellDelegate
-(void)CommentHeaderCellBtnClick:(CommentHeaderCell*)cell withBtn:(UIButton *)btn
{
    cell.isSelecctedBtn = btn.tag;
    switch (btn.tag) {
        case 111://全部
        {
            [self requestForAllComment];
        }
            break;
        case 222://好评
        {

            [self requestForAllGoodComment];
        }
            break;
        case 333://中评
        {
           
            [self requestForComment];
        }
            break;
        case 444://差评
        {
           
            [self requestForBadComment];
        }
            break;
            
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
