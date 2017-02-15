//
//  ViewController.m
//  KHPhotoView
//
//  Created by 宇航 on 17/2/9.
//  Copyright © 2017年 KH. All rights reserved.
//

#import "ViewController.h"
#import "KHPhotoView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    KHPhotoView *photosView = [[KHPhotoView alloc] initWithFrame:CGRectMake(20, 20, 200, 200)];
    
    [self.view addSubview:photosView];
}


-(void)createUI{
    
    UILabel * tt = [UILabel new];
    tt.text = @"相逢何必邂逅";
    tt.frame = CGRectMake(10, 100, 200, 30);
    [self.view addSubview:tt];
    
    tt.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:16.0];
    NSMutableArray *ss = [self subStr:@"相逢何必邂逅https://github.com/TinyQ蜡笔下雪玛莎拉蒂蜡笔下雪玛莎拉蒂蜡笔下雪玛莎拉蒂蜡笔下雪玛莎拉蒂蜡笔下雪玛莎拉蒂https://www.baidu.com发送www.kauuri.com"];
    NSLog(@"%@",ss );
        
}

-(NSMutableArray*)subStr:(NSString *)string{
        
    NSError *error;
    //可以识别url的正则表达式
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
    options:NSRegularExpressionCaseInsensitive error:&error];
        
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    //NSString *subStr;
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    for (NSTextCheckingResult *match in arrayOfAllMatches){
        NSString* substringForMatch;
        substringForMatch = [string substringWithRange:match.range];
        [arr addObject:substringForMatch];
    }
    return arr;
    }
@end
