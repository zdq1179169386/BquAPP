//
//  SubClassifyViewController.h
//  Bqu
//
//  Created by yb on 15/10/10.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassifyBaseViewController.h"


@interface SubClassifyViewController : UIViewController


/**<#description#>*/
@property(nonatomic,strong)NSArray * allArray;


/**表1数组源*/
@property(nonatomic,strong)NSMutableArray * levelOneArray;
/**表2数组源*/
@property(nonatomic,strong)NSMutableArray * leveTwoArray;


@end
