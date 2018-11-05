//
//  PopSelectModel.h
//  PopSelectView
//
//  Created by 车 on 2018/6/13.
//  Copyright © 2018年 车. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PopSelectModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign, getter=isSelected) BOOL selected;

@end
