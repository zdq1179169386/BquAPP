//
//  SearchController.h
//  Bqu
//
//  Created by WONG on 15/10/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeBaseViewController.h"
#import "BquSearchConditionModel.h"

typedef void (^SearchBlock) (NSString* Id);
typedef void (^SearchNODataBlock)();



@interface SearchController : HomeBaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>


@property (strong, nonatomic)  UICollectionView *collectionView;


//cid 或者 bid ，或者关键字
@property (copy,nonatomic)NSString *keyword;


//筛除
@property (nonatomic,copy) NSString * cid;
@property (nonatomic,copy) NSString * bid;


//@property(nonatomic,copy)NSString * shopId;
@property(nonatomic,strong)BquSearchConditionModel *conditions;

-(void)setblock:(SearchBlock)block;
-(void)setNODataBlock:(SearchNODataBlock)block;

////筛除
//-(void)setSearchCondition:(NSDictionary*)searchConditionDictionary;
-(void)reload;

-(void)text;
@end
