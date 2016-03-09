//
//  HotHistorySearchCollectionView.m
//  Bqu
//
//  Created by yb on 15/11/19.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "HotHistorySearchCollectionView.h"
#import "HotHistoryCollectionReusableView.h"



@interface HotHistorySearchCollectionView ()

@property (nonatomic,strong)selectSearchKeyBlock block;
@end

@implementation HotHistorySearchCollectionView
-(instancetype)initWithFrame:(CGRect)frame
{
   // UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //
    layout.minimumInteritemSpacing = 10 ;
    layout.minimumLineSpacing = 20 ;
    layout.headerReferenceSize = CGSizeMake(100, 40);
    layout.scrollDirection =  UICollectionViewScrollDirectionVertical ;
    layout.sectionInset =  UIEdgeInsetsMake(10, 10, 20, 10);
    
//    [self registerClass:[HotHistoryCollectionReusableView class] forSupplementaryViewOfKind:@"header" withReuseIdentifier:@"ReuseID"];
    
    [self registerClass:[HotHistoryCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    
      [self registerNib:[UINib nibWithNibName:@"SearchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"searchCell"];
    
    if (self  = [super initWithFrame:frame collectionViewLayout:layout])
    {
        self.delegate = self;
        self.dataSource = self;
        _historySearchArray = [NSMutableArray new];
        _hotSearchArray = [NSMutableArray new];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setKeyBlock:(selectSearchKeyBlock)block
{
    _block = block;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray * array ;
    if (section == 0) array = _historySearchArray;
    else array = _hotSearchArray;
    if (array == nil) return 0;
    return array.count;
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(ScreenWidth, 40);
}

//cell
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    SearchCollectionViewCell * cell = [SearchCollectionViewCell SearchCollectionViewCell:collectionView NSIndexPath:indexPath];
    if (indexPath.section == 0 && _historySearchArray.count > 0)
    {
        KeyWordSizeModul * modul = _historySearchArray[indexPath.row];
        cell.keySize = modul;
    }
    if (indexPath.section == 1 &&_hotSearchArray.count > 0)
    {
        KeyWordSizeModul * modul = _hotSearchArray[indexPath.row];
        cell.keySize = modul;
        [cell hotSearch];
    }
    return cell;
}

//cell 尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KeyWordSizeModul * modul ;
    CGSize  size = CGSizeZero;
    if (indexPath.section == 0 && _historySearchArray.count > 0 && indexPath.row < _historySearchArray.count)
    {
        modul = _historySearchArray[indexPath.row];
        size = CGSizeMake(modul.lenth.integerValue+25, 25);
    }
    else if(indexPath.section == 1 && _hotSearchArray.count > 0 && indexPath.row < _hotSearchArray.count)
    {
        modul = _hotSearchArray[indexPath.row];
        size = CGSizeMake(modul.lenth.integerValue+25, 25);
    }
    return size;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 20, 20, 20);
}

//最小行距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

//点击cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_block)
    {
        NSArray * array;
        if (indexPath.section == 0) array = _historySearchArray;
        else array = _hotSearchArray;
        KeyWordSizeModul * key = array[indexPath.row];
        _block(key.keyWord);
    }
}


//-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    NSString * title ;
//    if(indexPath.section == 0) title = @"最近搜索";
//    else title = @"热门搜索";
//    if (indexPath.section == 0) {
//        HotHistoryCollectionReusableView * reusableView = [HotHistoryCollectionReusableView hotHistoryCollectionReusableView:collectionView kind:kind indexpath:indexPath];
//        //[[HotHistoryCollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
////        //[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
//        reusableView.textLab.text = title;
//        reusableView.deleteDown = @selector(deleteDown);
//        return  reusableView;
//        
//    }else
//    {
//        HotHistoryCollectionReusableView * reusableView = [HotHistoryCollectionReusableView hotHistoryCollectionReusableView:collectionView kind:kind indexpath:indexPath];
////         HotHistoryCollectionReusableView * reusableView = [[HotHistoryCollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
//        reusableView.textLab.text = title;
//        reusableView.deleteBtn.hidden = YES;
//        return  reusableView;
//    }
//
//    
//    
////    if (kind == UICollectionElementKindSectionHeader)
////    {
////        HotHistoryCollectionReusableView * view =  [HotHistoryCollectionReusableView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ReuseID" forIndexPath:indexPath];
////        if(indexPath.section == 0)
////        {
////            
////        }
////        else textLab.text = @"热门搜索";
////        return view;
////    }
////    else
////    {
////        UICollectionReusableView * view = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-35, 0)];
////        return view;
////    }
////    return nil;
//}


-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HotHistoryCollectionReusableView * reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        reusableView  =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        if (indexPath.section==0) {
            reusableView.textLab.text = @"最近搜索";
            reusableView.deleteBtn.hidden = NO;
            __block HotHistorySearchCollectionView *blockView  = self;
            [reusableView setBlock:^{
                [blockView deleteDown];
            }];
        }else
        {
            reusableView.textLab.text = @"热门搜索";
            reusableView.deleteBtn.hidden = YES;
            
        }
    }
    return  reusableView;
    
}

-(void)deleteDown
{
        [KeyWordSizeModul clearHistorySearch];
        _historySearchArray = [KeyWordSizeModul getHistorySearch];
        [self reloadData];
 }

@end

