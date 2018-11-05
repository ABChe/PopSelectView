//
//  ViewController.m
//  PopSelectView
//
//  Created by 车 on 2018/6/12.
//  Copyright © 2018年 车. All rights reserved.
//

#import "ViewController.h"
#import "PopSelectView.h"

@interface ViewController ()<PopSelectViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {
        PopSelectModel *model = [PopSelectModel new];
        model.title = [NSString stringWithFormat:@"%d",i];
        model.key = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i]];
        model.selected = NO;
        [array addObject:model];
    }
    
    PopSelectView *popView =  [[PopSelectView alloc] initWithDataArray:array singleSelect:YES];
    popView.delegate = self;
    [popView showView];
}

- (void)popSelectView:(PopSelectView *)PopSelectView didSelectArray:(NSArray *)array {
    [array enumerateObjectsUsingBlock:^(PopSelectModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@ - %@\n", model.title, model.key);
    }];
}

@end
