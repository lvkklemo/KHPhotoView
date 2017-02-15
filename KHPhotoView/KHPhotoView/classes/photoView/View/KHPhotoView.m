//
//  KHPhotoView.m
//  KHPhotoView
//
//  Created by 宇航 on 17/2/9.
//  Copyright © 2017年 KH. All rights reserved.
//

#import "KHPhotoView.h"
#import <Photos/Photos.h>
#import "UIView+ViewController.h"
#import "KHPhotosViewController.h"

#define kItemW 90
#define kItemH 90
#define kSpace 10

@interface KHPhotoView ()

@end

@implementation KHPhotoView
{
    UIButton *_addBtn;  //添加按钮
    NSMutableDictionary *_selectImgDic;
    NSInteger _selectIndex;
}

//itemArray的懒加载方法
- (NSMutableArray *)itemArray{
    
    if (_itemArray == nil) {
        _itemArray = [[NSMutableArray alloc] init];
    }
    return _itemArray;
    
}

//复写init方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //指定frame
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, kSpace*4+kItemW*3, kSpace*4+kItemH*3);
        self.backgroundColor = [UIColor grayColor];
        
        _dataList = [[NSMutableArray alloc] init];
        
        //创建添加按钮
        [self createBtn];
        
        //判断是否授权
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
            NSLog(@"相册访问受限");
        }
        
    }
    return self;
}



//创建添加图片的btn
- (void)createBtn{
    
    //初始化
    _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, kItemW, kItemH)];
    
    [_addBtn setImage:[UIImage imageNamed:@"btn_add_photo_n"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_addBtn];
    
}

#pragma mark 按钮点击方法
- (void)addBtnAction:(UIButton *)btn{
    
    //推出相册视图
    KHPhotosViewController *pVC = [[KHPhotosViewController alloc] init];

    if (_selectImgDic != nil) {
        pVC.selectDataDic = _selectImgDic;
    }
//    [pVC setDataBlock:^(NSMutableDictionary *data) {
//        NSLog(@"%@",data);
//    }];
    pVC.dataBlock = ^(NSMutableDictionary *data){
        NSLog(@"%@",data);
        //解析数据
        self.dataList = [self loadDataWithDic:data];
        //初始化字典
        _selectImgDic = [[NSMutableDictionary alloc] init];
        _selectImgDic = data;
    };
    
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:pVC];
    
    [self.viewController presentViewController:navVC animated:YES completion:nil];
    
    //弹出相册后清空所有数组
    _selectImgDic = [[NSMutableDictionary alloc] init];
    _itemArray = [[NSMutableArray alloc] init];
    _dataList = [[NSMutableArray alloc] init];
    
}

//解析数据
- (NSMutableArray *)loadDataWithDic:(NSMutableDictionary *)dic{
    
    NSArray *array = [dic allKeys];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSNumber *key in array) {
        UIImage *image = [dic objectForKey:key];
        [dataArray addObject:image];
    }
    
    return dataArray;
}

//dataList数据源的set方法
- (void)setDataList:(NSMutableArray *)dataList{
    _dataList = dataList;
    
    //创建9宫格
    [self createImgView];
}

//创建九宫格图片视图
- (void)createImgView{
    
    //移除所有图片视图
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    //创建图片视图
    for (int i = 0; i < _dataList.count; i ++) {
        
        //创建图片视图
        UIImageView *item = [[UIImageView alloc] initWithFrame:[self makeFrameWithIndex:i]];
        item.image = _dataList[i];
        
        //添加入子视图数组
        [self.itemArray addObject:item];
        
        [self addSubview:item];
        
    }
    
    //改变添加按钮的位置
    if (_dataList.count >= 9) {
        
        //将按钮隐藏
        _addBtn.hidden = YES;
        
    }else{
        
        //将按钮显示
        _addBtn.hidden = NO;
        [self moveAddBtn];
        
    }
    
}

//根据下标计算frame
- (CGRect)makeFrameWithIndex:(int)index{
    
    int x = ((index%3)+1)*kSpace + (index%3)*kItemW;
    int y = (index/3+1)*kSpace + (index/3)*kItemH;
    
    return CGRectMake(x, y, kItemW, kItemH);
    
}

//改变添加按钮位置方法
- (void)moveAddBtn{
    
    NSInteger index = _dataList.count;
    NSInteger x = ((index%3)+1)*kSpace + (index%3)*kItemW;
    NSInteger y = (index/3+1)*kSpace + (index/3)*kItemH;
    
    _addBtn.frame = CGRectMake(x, y, kItemW, kItemH);
    
}


@end
