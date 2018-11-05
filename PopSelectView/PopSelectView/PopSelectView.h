//
//  PopSelectView.h
//  PopSelectView
//
//  Created by 车 on 2018/6/12.
//  Copyright © 2018年 车. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopSelectModel.h"

@class PopSelectView;

@protocol PopSelectViewDelegate <NSObject>

- (void)popSelectView:(PopSelectView *)PopSelectView didSelectArray:(NSArray *)array;
@end


@interface PopSelectView : UIView

@property (nonatomic, weak) id <PopSelectViewDelegate> delegate;

- (instancetype)initWithDataArray:(NSArray<PopSelectModel *> *)dataArray singleSelect:(BOOL)singleSelect;

- (void)showView;

@end
