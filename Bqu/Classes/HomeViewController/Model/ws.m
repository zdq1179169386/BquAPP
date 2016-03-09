//
//  ws.m
//  Mindjet
//
//  Created by heide on 15/10/24.
//  Copyright (c) 2015年 dxinfo. All rights reserved.
//

#import "ws.h"

@implementation ws

- (void) getDataFromDictionary : (NSDictionary *) dic {
    ws * model = [[ws alloc] init];
    model.toplcimage = dic[@"TopIcImage"];
    NSArray * ary = dic[@"TopIcModule"];
    for (NSDictionary * dictionary in ary) {
        model.modulename = dictionary[@"ModuleName"];
        NSArray * array = dictionary[@"ModuleProduct"];
        for (NSDictionary * dic in array) {
            self.comment = dic[@"Comment"];
            self.imageURL = dic[@"ImageUrl"];
            self.marketprice = dic[@"MarketPrice"];
            self.minsaleprice = dic[@"MinSalePrice"];
            self.moods = dic[@"Moods"];
            self.productld = dic[@"ProductId"];
            self.productname = dic[@"ProductName"];
            self.salecount = dic[@"SaleCount"];
        }
    }
    model.toplcname = dic[@"TopIcName;"];
}
@end
