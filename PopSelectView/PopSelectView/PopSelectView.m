//
//  PopSelectView.m
//  PopSelectView
//
//  Created by 车 on 2018/6/12.
//  Copyright © 2018年 车. All rights reserved.
//

#import "PopSelectView.h"
#import "PopSelectTableViewCell.h"
#import "PopSelectModel.h"

#pragma mark -

#define kPopThemeColor [UIColor cyanColor]
#define kMaskButtonTag 7777
#define kPopTopViewHeight  50
#define kPopCellHeight     48
#define kPopBottomViewHeight 50
#define kMaxShowRowCount 5
#define kScreenWidth     CGRectGetWidth([[UIScreen mainScreen] bounds])
#define kScreenHeight    CGRectGetHeight([[UIScreen mainScreen] bounds])

static NSString *PopCellMain = @"PopCellMain";

@interface PopSelectView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *tabelView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSIndexPath *lastSelectedIndexPath;

@property (nonatomic, assign, getter = isSingleSelect) BOOL singleSelect;
@end


@implementation PopSelectView

#pragma mark -

- (instancetype)initWithDataArray:(NSArray<PopSelectModel *> *)dataArray singleSelect:(BOOL)singleSelect{
    self = [super init];
    if (self) {
        self.dataArray = [NSArray arrayWithArray:dataArray];
        self.selectedArray = [NSMutableArray array];
        self.singleSelect = singleSelect;
        
        [self topViewAddSubviews];
        [self bottomViewAddSubviews];
        
        [self addSubview:self.topView];
        [self addSubview:self.tabelView];
        [self addSubview:self.bottomView];
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat topViewHeight = kPopTopViewHeight;
    CGFloat tableViewHeight = kPopCellHeight * ((self.dataArray.count < kMaxShowRowCount) ? self.dataArray.count : kMaxShowRowCount);
    CGFloat bottomViewHeight = kPopBottomViewHeight;
    
    self.frame = CGRectMake(0, 0, kScreenWidth - 80 * 2, topViewHeight + tableViewHeight + bottomViewHeight);
    self.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
    
    self.topView.frame =CGRectMake(0, 0, CGRectGetWidth(self.frame), topViewHeight);
    self.tabelView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), CGRectGetWidth(self.frame), tableViewHeight);
    self.bottomView.frame = CGRectMake(0,CGRectGetMaxY(self.tabelView.frame), CGRectGetWidth(self.frame), bottomViewHeight);
    
    [self resetTopViewSubViewsFrame];
    [self resetBottomViewSubViewsFrame];
}


#pragma mark - UItableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PopCellMain forIndexPath:indexPath];
    [cell setCellWithModel:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isSingleSelect)
    {
        // 单选
        if (indexPath == self.lastSelectedIndexPath) {
            [self deselectCellAtIndexPath:indexPath];
            self.lastSelectedIndexPath = nil;
        } else {
            [self deselectCellAtIndexPath:self.lastSelectedIndexPath];
            [self selectCellAtIndexPath:indexPath];
            self.lastSelectedIndexPath = indexPath;
        }
    }
    else
    {
        // 多选
        PopSelectModel *model = self.dataArray[indexPath.row];
        
        if (model.isSelected) {
            [self deselectCellAtIndexPath:indexPath];
            self.lastSelectedIndexPath = nil;
        } else {
            [self selectCellAtIndexPath:indexPath];
            self.lastSelectedIndexPath = indexPath;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kPopCellHeight;
}


#pragma mark - Method

- (void)selectCellAtIndexPath:(NSIndexPath *)indexPath {
    PopSelectTableViewCell *cell = [self.tabelView cellForRowAtIndexPath:indexPath];
    [cell buttonSelectClick:cell.buttonSelect];

    PopSelectModel *model = self.dataArray[indexPath.row];
    model.selected = YES;
    [self.selectedArray addObject:model];
    
}

- (void)deselectCellAtIndexPath:(NSIndexPath *)indexPath {
    if(!indexPath) return;
    
    PopSelectTableViewCell *cell = [self.tabelView cellForRowAtIndexPath:indexPath];
    [cell buttonSelectClick:cell.buttonSelect];

    PopSelectModel *model = self.dataArray[indexPath.row];
    [self.selectedArray removeObject:model];
    model.selected = NO;
}

- (void)showView{
    UIWindow *mainWindow = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11) {
        mainWindow = [[UIApplication sharedApplication].windows firstObject];
    } else {
        mainWindow = [[UIApplication sharedApplication].windows lastObject];
    }
    
    // 遮罩
    UIButton *mask = [[UIButton alloc] init];
    mask.tag = kMaskButtonTag;
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = 0.4;
    [mask addTarget:self action:@selector(tapMask) forControlEvents:UIControlEventTouchUpInside];
    mask.frame = [UIScreen mainScreen].bounds;
    
    self.layer.cornerRadius = 10;
    self.layer.borderColor = kPopThemeColor.CGColor;
    self.layer.borderWidth = 1.f;
    self.clipsToBounds = YES;
    
    [mainWindow addSubview:mask];
    [mainWindow addSubview:self];
}

- (void)tapMask {
    UIWindow *mainWindow = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11) {
        mainWindow = [[UIApplication sharedApplication].windows firstObject];
    } else {
        mainWindow = [[UIApplication sharedApplication].windows lastObject];
    }
    
    UIButton *mask = [mainWindow viewWithTag:kMaskButtonTag];
    [mask removeFromSuperview];
    [self removeFromSuperview];
}

- (void)clickSureButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(popSelectView:didSelectArray:)]) {
        [self.delegate popSelectView:self didSelectArray:self.selectedArray];
    }
    [self tapMask];
}

- (void)clickCancelButton {
    [self tapMask];
}


#pragma mark - TopView

- (void)topViewAddSubviews {
    [self.topView addSubview:self.titleLabel];
}

- (void)resetTopViewSubViewsFrame {
    self.titleLabel.frame = self.topView.frame;
}


#pragma mark - BottomView

- (void)bottomViewAddSubviews {
    [self.bottomView addSubview:self.sureButton];
    [self.bottomView addSubview:self.cancelButton];
}

- (void)resetBottomViewSubViewsFrame {
    self.sureButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.bottomView.frame) / 2, CGRectGetHeight(self.bottomView.frame));
    self.cancelButton.frame = CGRectMake(CGRectGetWidth(self.bottomView.frame) / 2, 0, CGRectGetWidth(self.bottomView.frame) / 2, CGRectGetHeight(self.bottomView.frame));
}


#pragma mark - lazyLoading

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:15.f];
        _titleLabel.text = @"请选择";
        _titleLabel.backgroundColor = kPopThemeColor;
    }
    return _titleLabel;
}
- (UIView *)topView {
    if (_topView == nil) {
        _topView = [[UIView alloc] init];
    }
    return _topView;
}

- (UITableView *)tabelView {
    if (_tabelView == nil) {
        _tabelView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        [_tabelView registerNib:[UINib nibWithNibName:@"PopSelectTableViewCell" bundle:nil] forCellReuseIdentifier:PopCellMain];
    }
    return _tabelView;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}

- (UIButton *)sureButton {
    if (_sureButton == nil) {
        _sureButton = [[UIButton alloc] init];
        _sureButton.backgroundColor = kPopThemeColor;
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.backgroundColor = kPopThemeColor;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end
