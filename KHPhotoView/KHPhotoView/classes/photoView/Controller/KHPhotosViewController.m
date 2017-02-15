//
//  KHPhotosViewController.m
//  KHPhotoView
//
//  Created by 宇航 on 17/2/15.
//  Copyright © 2017年 KH. All rights reserved.
//

#import "KHPhotosViewController.h"
#import <Photos/Photos.h>

typedef void (^imageBlock)(UIImage*imagee);

@interface KHPhotosViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    
    NSMutableArray  * _dataList;
 
}
@end

@implementation KHPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_selectDataDic == nil) {
        //初始化选中图片数组
        _selectDataDic = [[NSMutableDictionary alloc] init];
    }
    
    [self addNavigationItem];
    
    [self getAllPhotos];
    
    [self createCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//添加两侧导航栏按钮
- (void)addNavigationItem{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(leftBtnAct)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnAct)];
    
}

//导航栏按钮方法
//返回
- (void)leftBtnAct{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//确定
- (void)rightBtnAct{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//获取所有图片资源
- (void)getAllPhotos{
    
    //初始化数据源数组
    _dataList = [[NSMutableArray alloc] init];
    
    //创建筛选查询option
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    //查询后的所有图片
    PHFetchResult *result = [PHAsset fetchAssetsWithOptions:options];
    
    //遍历所有资源集合将所有资源添加到数组
    for (PHAsset *asset in result) {
        [_dataList addObject:asset];
    }
}

//创建collectionView
- (void)createCollectionView{
    
    //布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemW = (self.view.bounds.size.width - 50)/4;
    layout.itemSize = CGSizeMake(itemW, itemW);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    //注册单元格
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.view addSubview:_collectionView];
    
}

#pragma mark ------ UICollectionViewDataSource

//返回每组单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _dataList.count;
    
}

//返回单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //单元格复用
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    //判断当前单元格是否存在imageView控件
    if (![cell.contentView viewWithTag:101]) {
        //创建imageView
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        imgView.tag = 101;
        
        [cell.contentView addSubview:imgView];
        
        //添加选中图片
        UIImageView *selectImgV = [[UIImageView alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width - 18, 0, 18, 18)];
        selectImgV.tag = 102;
        selectImgV.image = [UIImage imageNamed:@"checkmark"];
        //默认隐藏
        selectImgV.hidden = YES;
        
        [cell.contentView addSubview:selectImgV];
    }
    
    //获取资源并给单元格赋值
    [self getImageWithAsset:_dataList[indexPath.row] withBlock:^(UIImage *imagee) {
        UIImageView * imageV = [cell viewWithTag:101];
        imageV.image = imagee;
    }];
    
    return cell;
    
}

//获取image
- (void)getImageWithAsset:(PHAsset*)asset withBlock:(imageBlock)block{
    
    //通过asset资源获取图片
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        //回调block
        block(result);
    }];
}

#pragma mark ------ UICollectionViewDelegateFlowLayout
//设置单元格与边缘控件距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}

#pragma mark ------ UICollectionViewDelegate
//点击单元格时调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    UIImageView * checkImgV = [cell viewWithTag:102];
    
    checkImgV.hidden = !checkImgV.hidden;
    
    //向数组中添加图像
    if (checkImgV.hidden == NO) {
        //添加
        [self getImageWithAsset:_dataList[indexPath.row] withBlock:^(UIImage *image) {
            [_selectDataDic setObject:image forKey:@(indexPath.row)];
            NSLog(@"%@",_selectDataDic);
        }];
        
        
    }else{
        //删除
        [self getImageWithAsset:_dataList[indexPath.row] withBlock:^(UIImage *image) {
            [_selectDataDic removeObjectForKey:@(indexPath.row)];
            NSLog(@"%@",_selectDataDic);
        }];
        
        
    }
    

}

@end
