//
//  PopSelectTableViewCell.h
//  PopSelectView
//
//  Created by 车 on 2018/6/12.
//  Copyright © 2018年 车. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopSelectModel.h"

@interface PopSelectTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imageVLine;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIButton *buttonSelect;


- (IBAction)buttonSelectClick:(id)sender;

- (void)setCellWithModel:(PopSelectModel *)model;
@end
