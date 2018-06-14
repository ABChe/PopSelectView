//
//  PopSelectTableViewCell.m
//  PopSelectView
//
//  Created by 车 on 2018/6/12.
//  Copyright © 2018年 车. All rights reserved.
//

#import "PopSelectTableViewCell.h"

@implementation PopSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.buttonSelect setBackgroundImage:[UIImage imageNamed:@"CellNotSelected"] forState:UIControlStateNormal];
    [self.buttonSelect setBackgroundImage:[UIImage imageNamed:@"CellBlueSelected"] forState:UIControlStateSelected];
    self.buttonSelect.userInteractionEnabled = NO;
}

- (void)setCellWithModel:(PopSelectModel *)model {
    self.labelTitle.text = model.title;
    self.buttonSelect.selected = model.selected;
}

- (IBAction)buttonSelectClick:(id)sender {
    self.buttonSelect.selected = !self.buttonSelect.selected;
}
@end
