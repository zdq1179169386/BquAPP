//
//  ProductDetailTaxCell.h
//  Bqu
//
//  Created by yb on 15/11/30.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface ProductDetailTaxCell : UITableViewCell


/**<#description#>*/
@property(nonatomic,strong) ProductModel * model;


+(instancetype)ProductDetailTaxCellForTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;

@end
