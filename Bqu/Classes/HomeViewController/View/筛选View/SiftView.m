//
//  SiftView.m
//  Bqu
//
//  Created by yb on 15/11/20.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "SiftView.h"
#import "Bqu_SiftTypeView.h"
#import "BquSiftTypeTableViewCell.h"
#import "BquSearchHttpTool.h"


@interface SiftView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)Bqu_SiftTypeView * siftTypeView;

@property (nonatomic ,strong)UITableView *  tableViewClassify;

@property (nonatomic,copy)SiftViewBlock block;

@property (nonatomic, assign)NSUInteger index;

@end


@implementation SiftView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.Classifys = [[NSMutableArray alloc] initWithObjects:[NSMutableArray new],[NSMutableArray new],[NSMutableArray new], nil];
        [self reloadData];
        
        __block SiftView * blockSiftView = self;
        _siftTypeView = [[Bqu_SiftTypeView alloc] initWithFrame:CGRectMake(0, 0, 90, frame.size.height)];
        [_siftTypeView setBqu_SiftTypeViewBlock:^(NSUInteger index) {
            blockSiftView.index  = index;
            [blockSiftView.tableViewClassify reloadData];
        }];
        [self addSubview:_siftTypeView];
        
        
        _tableViewClassify = [[UITableView alloc] initWithFrame:CGRectMake(90, 0, ScreenWidth-90,frame.size.height) style:UITableViewStylePlain];
        _tableViewClassify.tag = 200;
        _tableViewClassify.delegate = self;
        _tableViewClassify.dataSource = self;
        _tableViewClassify.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableViewClassify];
        
        self.index = 0;
        [self line:CGRectMake(90, 0, 1,frame.size.height)];
        
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
    if (_Classifys.count>_index) {
        NSArray * dataArray = _Classifys[_index];
        return dataArray.count;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = _Classifys[_index];
    BquSiftTypeTableViewCell * cell = [BquSiftTypeTableViewCell bquSiftTypeTableViewCell:tableView];
    cell.model =array[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
       NSArray *array = _Classifys[_index];
        if(_block && indexPath.row < array.count)
        {
            _block(array[indexPath.row]);
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

-(void)reloadData
{
    //请求发货地
    [BquSearchHttpTool requestAllBondedAreas:^(id json) {
        NSString * resultCode = json[@"resultCode"];
        if (!resultCode.boolValue) {
            NSArray * dataArray = json[@"data"];
            NSArray *BondedAreasArray = [SiftTypeModel siftTypeModelFromArray:dataArray type:0];
            NSMutableArray * data = self.Classifys[0];
            for (int i = 0 ; i < BondedAreasArray.count; i++) {
                SiftTypeModel *model = BondedAreasArray[i];
                [data addObject:model];
            }
        
             [self.tableViewClassify reloadData];
        }
        
    } failure:^(NSError *error) {
    
    }];
    //请求国家
    [BquSearchHttpTool requestAllCountry:^(id json) {
        NSString * resultCode = json[@"resultCode"];
        if (!resultCode.boolValue) {
            NSArray * dataArray = json[@"data"];
            NSArray *CountryArray = [SiftTypeModel siftTypeModelFromArray:dataArray type:1];
            NSMutableArray * data = self.Classifys[1];
            for (int i = 0 ; i < CountryArray.count; i++) {
                SiftTypeModel *model = CountryArray[i];
                [data addObject:model];
            }
             [self.tableViewClassify reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
   
}
-(void)reloadTableView
{
    [self.tableViewClassify reloadData];
}

@end
