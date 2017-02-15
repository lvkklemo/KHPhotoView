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

//按钮点击方法
- (void)addBtnAction:(UIButton *)btn{
    
    //推出相册视图
    KHPhotosViewController *pVC = [[KHPhotosViewController alloc] init];

    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:pVC];
    
    [self.viewController presentViewController:navVC animated:YES completion:nil];
    
    //弹出相册后清空所有数组
    _selectImgDic = [[NSMutableDictionary alloc] init];
    _itemArray = [[NSMutableArray alloc] init];
    _dataList = [[NSMutableArray alloc] init];
    
}


@end
