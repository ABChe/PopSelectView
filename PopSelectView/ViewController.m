//
//  ViewController.m
//  PopSelectView
//
//  Created by 车 on 2018/6/12.
//  Copyright © 2018年 车. All rights reserved.
//

#import "ViewController.h"
#import "PopSelectView.h"
#import "PopSelectModel.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self createUI];
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {
        PopSelectModel *model = [PopSelectModel new];
        model.title = [NSString stringWithFormat:@"%ld",i];
        model.key = [NSNumber numberWithInt:i];
        model.selected = NO;
        [array addObject:model];
    }
    
    PopSelectView *popView =  [[PopSelectView alloc] initWithDataArray:array];
    
    [popView showView];
}

//- (void)createUI {
//    UIWindow *mainWindow = nil;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11) {
//        mainWindow = [[UIApplication sharedApplication].windows firstObject];
//    } else {
//        mainWindow = [[UIApplication sharedApplication].windows lastObject];
//    }
//
//    [mainWindow addSubview:self.view];
//
//
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
