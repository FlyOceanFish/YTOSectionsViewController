//
//  YTOSegmentControl.m
//  testaa
//
//  Created by FlyOceanFish on 2017/8/11.
//  Copyright © 2017年 FlyOceanFish. All rights reserved.
//

#import "YTOSegmentControl.h"
#import "YTOSectionTitleCollectionViewCell.h"
#import "UIView+WZLBadge.h"

typedef NS_ENUM(NSUInteger, EffectSide) {
    LEFT,
    RIGHT,
    BOTH,
};
const NSUInteger defaultTextSize = 12;
const NSUInteger selectionIndicatorHeight = 2;
@interface YTOSegmentControl()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)CALayer *selectionIndicatorArrowLayer;
@property(nonatomic,strong)NSIndexPath *preIndexPath;

@property(nonatomic,assign)NSInteger bagedNumber;
@property(nonatomic,assign)NSInteger bagedIndex;
@property(nonatomic,strong)UIColor *badgeBgColor;
@property(nonatomic,strong)UIColor *badgeTextColor;
@property (nonatomic, assign) NSInteger badgeMaximumBadgeNumber;
@end

@implementation YTOSegmentControl
@dynamic selectionIndicatorColor;
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefault];
        [self initUI:frame];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)sectionTitles{
    self = [self initWithFrame:frame];
    if (self) {
        self.sectionTitles = sectionTitles;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *>*)sectionTitles segmentWidthStyle:(YTOSegmentedControlSegmentWidthStyle)segmentWidthStyle{
    self = [self initWithFrame:frame];
    if (self) {
        _sectionTitles = sectionTitles;
        _segmentWidthStyle = segmentWidthStyle;
        [self.collectionView reloadData];
    }
    return self;
}

#pragma mark - Init
- (void)initDefault{
    self.backgroundColor = [UIColor whiteColor];
//    self.selectionIndicatorColor = [UIColor redColor];
    self.selectionIndicatorHeight = selectionIndicatorHeight;
    self.segmentWidthStyle = YTOSegmentedControlSegmentWidthStyleFixed;
    self.selectionIndicatorLocation = YTOSegmentControlSelectionIndicatorLocationDown;
    self.selectedSegmentIndex = 0;
    self.bagedIndex = -1;
    self.defaultBackgroundColor = [UIColor whiteColor];
}
- (void)initUI:(CGRect)frame{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[YTOSectionTitleCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView.layer addSublayer:self.selectionIndicatorArrowLayer];
//    self.collectionView.layer.mask = [self _backgroundLayer:RIGHT];
}

#pragma mark - UICollectionViewDataSource&UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.segmentWidthStyle == YTOSegmentedControlSegmentWidthStyleFixed) {
        return CGSizeMake(CGRectGetWidth(self.bounds)/self.sectionTitles.count,CGRectGetHeight(self.bounds));
    }
    return CGSizeMake([self private_textSizeWidth:indexPath.item], CGRectGetHeight(self.bounds));
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.sectionTitles.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    YTOSectionTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (self.preIndexPath==indexPath) {
        [self private_setSelectionIndicatorArrowLayerOff:cell.frame.origin.x width:CGRectGetWidth(cell.bounds)];
    }
    cell.textLabel.font = self.titleTextFont==nil?[UIFont systemFontOfSize:defaultTextSize]:self.titleTextFont;
    cell.textLabel.text = self.sectionTitles[indexPath.row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.highlightedTextColor = self.selectedTitleTextColor==nil?[UIColor redColor]:self.selectedTitleTextColor;
    cell.textLabel.textColor = (self.titleTextColor==nil?[UIColor blackColor]:self.titleTextColor);
    if (self.bagedIndex==indexPath.row) {
        [self private_setBadgeForCell:cell number:self.bagedNumber index:self.bagedIndex badgeBgColor:self.badgeBgColor badgeTextColor:self.badgeTextColor badgeMaximumBadgeNumber:self.badgeMaximumBadgeNumber];
    }
    if (self.enableSelectedEffect&&self.selectedSegmentIndex==indexPath.row) {
        cell.backgroundColor = self.selectedBackgroundColor;
    }else{
       cell.backgroundColor = self.defaultBackgroundColor;
    }
    if (self.selectedSegmentIndex==indexPath.row) {
        if (self.selectedTitleTextFont) {
            cell.textLabel.font = self.selectedTitleTextFont;
        }
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.preIndexPath&&self.preIndexPath!=indexPath) {
        YTOSectionTitleCollectionViewCell *cell = (YTOSectionTitleCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = self.selectedBackgroundColor;
        if (self.selectedTitleTextFont) {
          cell.textLabel.font = self.selectedTitleTextFont;
        }
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:self.segmentWidthStyle==YTOSegmentedControlSegmentWidthStyleFixed?UICollectionViewScrollPositionNone:UICollectionViewScrollPositionCenteredHorizontally];
        cell = (YTOSectionTitleCollectionViewCell *)[collectionView cellForItemAtIndexPath:self.preIndexPath];
        cell.backgroundColor = self.defaultBackgroundColor;
        cell.textLabel.font = self.titleTextFont==nil?[UIFont systemFontOfSize:defaultTextSize]:self.titleTextFont;
        [collectionView deselectItemAtIndexPath:self.preIndexPath animated:NO];
        [self private_scrollIndicator:indexPath];
        [self _setLayerMask:indexPath.item];

    }
    self.preIndexPath = indexPath;
}
#pragma mark - Action
- (void)yto_setNumber:(NSInteger)number AtIndex:(NSUInteger)index badgeBgColor:(UIColor *)badgeBgColor badgeTextColor:(UIColor *)badgeTextColor badgeMaximumBadgeNumber:(NSInteger)badgeMaximumBadgeNumber{
    NSAssert(index<self.sectionTitles.count, @"请先设置标题，数组越界了");
    YTOSectionTitleCollectionViewCell *cell = (YTOSectionTitleCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if (cell) {
        [self private_setBadgeForCell:cell number:number index:index badgeBgColor:badgeBgColor badgeTextColor:badgeTextColor badgeMaximumBadgeNumber:badgeMaximumBadgeNumber];
    }else{
        _bagedIndex = index;
        _bagedNumber = number;
        _badgeBgColor = badgeBgColor;
        _badgeTextColor = badgeTextColor;
        _badgeMaximumBadgeNumber = badgeMaximumBadgeNumber;
    }
}
#pragma mark - Property
-(void)setEnableSelectedEffect:(BOOL)enableSelectedEffect{
    _enableSelectedEffect = enableSelectedEffect;
    if (_enableSelectedEffect) {
        self.collectionView.layer.mask = [self _backgroundLayer:LEFT];
    }else{
        self.collectionView.layer.mask = nil;
    }
}
-(void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor{
    _selectedBackgroundColor = selectedBackgroundColor;
    [self.collectionView reloadData];
}
-(void)setSectionTitles:(NSArray<NSString *> *)sectionTitles{
    _sectionTitles = sectionTitles;
    [self.collectionView reloadData];
}
-(void)setSelectionIndicatorHeight:(CGFloat)selectionIndicatorHeight{
    _selectionIndicatorHeight = selectionIndicatorHeight;
    self.selectionIndicatorArrowLayer.frame = CGRectMake(self.selectionIndicatorArrowLayer.frame.origin.x+self.selectionIndicatorEdgeInsets.left, self.selectionIndicatorArrowLayer.frame.origin.y,CGRectGetWidth(self.selectionIndicatorArrowLayer.bounds)-self.selectionIndicatorEdgeInsets.left-self.selectionIndicatorEdgeInsets.right, _selectionIndicatorHeight);
}
-(void)setSelectionIndicatorColor:(UIColor *)selectionIndicatorColor{
    self.selectionIndicatorArrowLayer.backgroundColor = selectionIndicatorColor.CGColor;
}
-(UIColor *)selectionIndicatorColor{
    return [UIColor colorWithCGColor:self.selectionIndicatorArrowLayer.backgroundColor];
}
-(CALayer *)selectionIndicatorArrowLayer{
    if (_selectionIndicatorArrowLayer == nil) {
        _selectionIndicatorArrowLayer = [[CALayer alloc] init];
        _selectionIndicatorArrowLayer.backgroundColor = self.selectionIndicatorColor.CGColor;
    }
    return _selectionIndicatorArrowLayer;
}
-(void)setSegmentWidthStyle:(YTOSegmentedControlSegmentWidthStyle)segmentWidthStyle{
    _segmentWidthStyle = segmentWidthStyle;
    if (_segmentWidthStyle==YTOSegmentedControlSegmentWidthStyleDynamic) {
        [self.collectionView reloadData];
    }
}
-(void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex{
    if (selectedSegmentIndex<self.sectionTitles.count) {
        if (self.preIndexPath) {
            YTOSectionTitleCollectionViewCell *cell = (YTOSectionTitleCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.preIndexPath];
            cell.backgroundColor = self.defaultBackgroundColor;
            cell.textLabel.font = self.titleTextFont==nil?[UIFont systemFontOfSize:defaultTextSize]:self.titleTextFont;
        }
        self.preIndexPath = [NSIndexPath indexPathForRow:selectedSegmentIndex inSection:0];
        [self private_scrollIndicator:self.preIndexPath];
        [self.collectionView selectItemAtIndexPath:self.preIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        YTOSectionTitleCollectionViewCell *cell = (YTOSectionTitleCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.preIndexPath];
        cell.backgroundColor = self.selectedBackgroundColor;
        if (self.selectedTitleTextFont) {
            cell.textLabel.font = self.selectedTitleTextFont;
        }
        [self _setLayerMask:selectedSegmentIndex];
    }
    
}
-(void)setSelectionIndicatorLocation:(YTOSegmentedControlSelectionIndicatorLocation)selectionIndicatorLocation{
    _selectionIndicatorLocation = selectionIndicatorLocation;
    if (_selectionIndicatorLocation==YTOSegmentedControlSelectionIndicatorLocationNone) {
        [self.selectionIndicatorArrowLayer removeFromSuperlayer];
    }else if (_selectionIndicatorLocation==YTOSegmentControlSelectionIndicatorLocationUp){
        self.selectionIndicatorArrowLayer.frame = CGRectMake(self.selectionIndicatorArrowLayer.frame.origin.x, 0, CGRectGetWidth(self.selectionIndicatorArrowLayer.bounds), CGRectGetHeight(self.selectionIndicatorArrowLayer.bounds));
    }
    if (self.selectedSegmentIndex==0) {
        self.preIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self private_scrollIndicator:self.preIndexPath];
    }
}
-(void)setSelectionIndicatorEdgeInsets:(UIEdgeInsets)selectionIndicatorEdgeInsets{
    _selectionIndicatorEdgeInsets = selectionIndicatorEdgeInsets;
    self.selectionIndicatorArrowLayer.frame = CGRectMake(self.selectionIndicatorArrowLayer.frame.origin.x+self.selectionIndicatorEdgeInsets.left, self.selectionIndicatorArrowLayer.frame.origin.y,CGRectGetWidth(self.selectionIndicatorArrowLayer.bounds)-self.selectionIndicatorEdgeInsets.left-self.selectionIndicatorEdgeInsets.right, _selectionIndicatorHeight);
}
#pragma mark - Private
- (void)private_scrollIndicator:(NSIndexPath *)indexPath{
    [UIView animateWithDuration:0.2 animations:^{
        YTOSectionTitleCollectionViewCell *cell = (YTOSectionTitleCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        [self private_setSelectionIndicatorArrowLayerOff:cell.frame.origin.x width:CGRectGetWidth(cell.bounds)];
        if (self.indexChangeBlock) {
            self.indexChangeBlock(indexPath.row);
        }
    }];
}
- (void)private_setBadgeForCell:(YTOSectionTitleCollectionViewCell *)cell number:(NSInteger)number index:(NSInteger)index badgeBgColor:(UIColor *)badgeBgColor badgeTextColor:(UIColor *)badgeTextColor badgeMaximumBadgeNumber:(NSInteger)badgeMaximumBadgeNumber{
    CGPoint point = CGPointMake(-((CGRectGetWidth(cell.frame)-[self private_textSizeWidth:index])/2.0-12), (CGRectGetHeight(cell.frame)-cell.textLabel.font.lineHeight)/2.0);
    cell.textLabel.badgeCenterOffset = point;
    if (badgeBgColor) {
        cell.textLabel.badgeBgColor = badgeBgColor;
    }
    if (badgeTextColor) {
        cell.textLabel.badgeTextColor = badgeTextColor;
    }
    if (badgeMaximumBadgeNumber>0) {
        cell.textLabel.badgeMaximumBadgeNumber = badgeMaximumBadgeNumber;
    }
    [cell.textLabel showNumberBadgeWithValue:number];
}
- (CGFloat)private_textSizeWidth:(NSUInteger)index{
    NSString *string = self.sectionTitles[index];
    return ceil([string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(self.bounds)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSBackgroundColorAttributeName:[UIFont systemFontOfSize:defaultTextSize]} context:nil].size.width)+1;
}
- (void)private_setSelectionIndicatorArrowLayerOff:(CGFloat)offX width:(CGFloat)width{
    if (self.selectionIndicatorLocation==YTOSegmentControlSelectionIndicatorLocationDown) {
        self.selectionIndicatorArrowLayer.frame = CGRectMake(offX+self.selectionIndicatorEdgeInsets.left,CGRectGetHeight(self.frame)-self.selectionIndicatorHeight,width-self.selectionIndicatorEdgeInsets.left-self.selectionIndicatorEdgeInsets.right, self.selectionIndicatorHeight);
    }else if (self.selectionIndicatorLocation==YTOSegmentControlSelectionIndicatorLocationUp){
        self.selectionIndicatorArrowLayer.frame = CGRectMake(offX+self.selectionIndicatorEdgeInsets.left,0,width-self.selectionIndicatorEdgeInsets.left-self.selectionIndicatorEdgeInsets.right, self.selectionIndicatorHeight);
    }
}
- (void)_setLayerMask:(NSInteger)index{
    if (self.enableSelectedEffect) {
        if (index==0) {
            self.collectionView.layer.mask = [self _backgroundLayer:LEFT];
        }else if (index==self.sectionTitles.count-1){
            self.collectionView.layer.mask = [self _backgroundLayer:RIGHT];
        }else{
            self.collectionView.layer.mask = [self _backgroundLayer:BOTH];
        }
    }else{
        self.collectionView.layer.mask = nil;
    }

}
- (CALayer *)_backgroundLayer:(EffectSide)side{
    CGFloat height = 40;
    CGFloat itemWidth = CGRectGetWidth(self.bounds)/self.sectionTitles.count;
    CGFloat width = CGRectGetWidth(self.bounds);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineJoinStyle:kCGLineJoinBevel];
    if (side==RIGHT) {
        [path moveToPoint:CGPointZero];
        [path addLineToPoint:CGPointMake(itemWidth, 0)];
        [path addCurveToPoint:CGPointMake(itemWidth-10, height) controlPoint1:CGPointMake(itemWidth-12, 10) controlPoint2:CGPointMake(itemWidth+6, height-10)];
        
        [path addLineToPoint:CGPointMake(0, height)];
        [path moveToPoint:CGPointMake(itemWidth, 0)];
        [path addLineToPoint:CGPointMake(width, 0)];
        [path addLineToPoint:CGPointMake(width, height)];
        [path addLineToPoint:CGPointMake(itemWidth, height)];
        [path addLineToPoint:CGPointMake(itemWidth, 0)];
        [path addLineToPoint:CGPointMake(0, 0)];
    }else if (side==LEFT){
        [path moveToPoint:CGPointZero];
        [path addLineToPoint:CGPointMake(itemWidth, 0)];
        [path addLineToPoint:CGPointMake(itemWidth, height)];
        [path addLineToPoint:CGPointMake(0, height)];
        [path addLineToPoint:CGPointZero];
        
        [path moveToPoint:CGPointMake(itemWidth, 0)];
        [path addCurveToPoint:CGPointMake(itemWidth+20, height) controlPoint1:CGPointMake(itemWidth+15, 10) controlPoint2:CGPointMake(itemWidth-6, height-5)];
        [path addLineToPoint:CGPointMake(width, height)];
        [path addLineToPoint:CGPointMake(width, 0)];
        [path addLineToPoint:CGPointMake(itemWidth, 0)];

        

    }else{
        
    }
    CAShapeLayer *_bezierLineLayer = [CAShapeLayer layer];
    _bezierLineLayer.fillColor = [[UIColor blackColor] CGColor];
    _bezierLineLayer.lineWidth = 1;
    _bezierLineLayer.lineCap = kCALineCapRound;
    _bezierLineLayer.path = path.CGPath;
    return _bezierLineLayer;
}
@end
