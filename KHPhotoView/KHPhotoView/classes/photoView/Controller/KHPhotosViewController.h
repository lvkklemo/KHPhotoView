//
//  KHPhotosViewController.h
//  KHPhotoView
//
//  Created by 宇航 on 17/2/15.
//  Copyright © 2017年 KH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DataBlock)(NSMutableDictionary*data);

@interface KHPhotosViewController : UIViewController

@property(nonatomic,strong)NSMutableDictionary *selectDataDic; //存储选中图片的字典

@property(nonatomic,copy)DataBlock dataBlock;

- (void)setDataBlock:(DataBlock)dataBlock;

@end
