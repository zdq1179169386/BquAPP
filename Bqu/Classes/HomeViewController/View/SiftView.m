//
//  SiftView.m
//  Bqu
//
//  Created by yb on 15/11/20.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "SiftView.h"

@interface SiftView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)UITableView * tableViewAllBand;

@property (nonatomic ,strong)UITableView *  tableViewClassify;

@property (nonatomic,strong)UIButton *promoteBtn;

@property (nonatomic,strong)NSArray * Bands;

@property (nonatomic,strong)NSArray * Classifys;

@property (nonatomic,strong)SiftViewBlock block;

@end


@implementation SiftView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor= [UIColor whiteColor];
        _tableViewAllBand = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 100, frame.size.height) style:UITableViewStylePlain];
        _tableViewAllBand.tag = 100;
        _tableViewAllBand.delegate = self;
        _tableViewAllBand.dataSource = self;
        [self addSubview:_tableViewAllBand];
        
        _tableViewClassify = [[UITableView alloc] initWithFrame:CGRectMake(100, 40, self.frame.size.width-100, self.frame.size.height) style:UITableViewStylePlain];
        _tableViewClassify.tag = 200;
        _tableViewClassify.delegate = self;
        _tableViewClassify.dataSource = self;
        [self addSubview:_tableViewClassify];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(17, 0, 100, 40)];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.text = @"仅看促销";
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = [UIColor colorWithHexString:@"#333333"];
        [self addSubview:lab];
        
        UILabel * line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.width,1)];
        line2.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [self addSubview:line2];
        
        [self line:CGRectMake(_tableViewAllBand.width, 40, 1,6*40)];
        [self line:CGRectMake(0, 40, self.width,1)];
        [self line:CGRectMake(0, self.height+40, self.width,1)];
        
        NSString * st = @"品牌";
        _Bands  = [NSArray arrayWithObjects:st,nil];
        
        NSString * s1 = @"111";
        NSString * s2 = @"222";
        NSString * s3 = @"111";
        NSString * s4 = @"222";
        _Classifys = [NSArray arrayWithObjects:s1,s2,s3,s4, nil];
        
        _promoteBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width -60  , 2  , 36, 36)];
        [_promoteBtn addTarget:self action:@selector(promoteDown:) forControlEvents:UIControlEventTouchDown];
        [_promoteBtn setImage:[UIImage imageNamed:@"B区-搜索列表页筛选"] forState:UIControlStateNormal];
        [self addSubview:_promoteBtn];
    }
    return self;
}

-(void)line:(CGRect)frame
{
    UILabel * line = [[UILabel alloc] initWithFrame:frame];
    line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    [self addSubview:line];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableViewAllBand) {
        return _Bands.count;
    }
    else return _Classifys.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"1"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"1"];
    }
    if (tableView == _tableViewAllBand) {
        cell.textLabel.text = _Bands[indexPath.row];
    }
    else cell.textLabel.text = _Classifys[indexPath.row];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableViewAllBand) {
    }
    else {
        NSString * st = _Classifys[indexPath.row];
        if(_block)
        {
        _block(st);
        }
    }
    
}

-(void)setBlock:(SiftViewBlock)block
{
    _block = block;
    
}
-(void)animateWithDuration:(CGFloat)time rect:(CGRect)rect;
{
    [UIView animateWithDuration:time animations:^{
        self.frame = rect;
    }];
}

#warning -----点击促销为实现 图片
-(void)promoteDown:(UIButton*)sender
{
    if(_block)
    {
        _block(@"促销");
    }
    
}
@end
