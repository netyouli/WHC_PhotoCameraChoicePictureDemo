//
//  WHC_PhotoListCell.m
//  work
//
//  Created by WHC on 14-6-23.
//  Copyright (c) 2014年 WHC. All rights reserved.
//

/*
 *  qq:712641411
 *  iOS大神qq群:460122071
 *  gitHub:https://github.com/netyouli
 *  csdn:http://blog.csdn.net/windwhc/article/category/3117381
 */


#import "WHC_PhotoListCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "WHC_Asset.h"
#define kCellHeight  (80.0)
#define kPad         (5.0)

@interface WHC_PhotoListCell (){
    NSArray          *  assetGroup;
    NSMutableArray   *  overlayImageArr;
    NSMutableArray   *  imageViewArr;
}

@end

@implementation WHC_PhotoListCell

+ (CGFloat)cellHeight{
    return kCellHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UITapGestureRecognizer  * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellForTapGesture:)];
        [self addGestureRecognizer:tapGesture];
        
        imageViewArr = [NSMutableArray arrayWithCapacity:4];
        overlayImageArr = [NSMutableArray arrayWithCapacity:4];
        [self setAssets:assetGroup];
    }
    return self;
}

-(void)setAssets:(NSArray*)assets{
    
    assetGroup = assets;
    for (UIImageView  * iv in imageViewArr) {
        [iv removeFromSuperview];
    }
    for (UIImageView * iv in overlayImageArr) {
        [iv removeFromSuperview];
    }
    NSInteger  count = assetGroup.count;
    for (NSInteger i = 0; i < count; i++) {
        WHC_Asset  * whcAS = assetGroup[i];
        if(i < imageViewArr.count){
            UIImageView  * tempImageView = imageViewArr[i];
            tempImageView.image = [UIImage imageWithCGImage:whcAS.asset.thumbnail];
        }else{
            UIImageView  * tempImageView = [[UIImageView alloc]initWithImage:[UIImage imageWithCGImage:whcAS.asset.thumbnail]];
            [imageViewArr addObject:tempImageView];
        }
        if(i < overlayImageArr.count){
            UIImageView  * tempOverlayImageView = overlayImageArr[i];
            tempOverlayImageView.hidden = !whcAS.selected;
        }else{
            UIImageView  * tempOverlayImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Overlay.png"]];
            tempOverlayImageView.hidden = !whcAS.selected;
            [overlayImageArr addObject:tempOverlayImageView];
        }
    }
}

-(void)layoutSubviews{
    
    NSInteger  count = assetGroup.count;
    CGFloat  width = (CGRectGetWidth([UIScreen mainScreen].bounds) - (_listColumn + 1) * kPad) / _listColumn;
    for (NSInteger i = 0; i < count; i++) {
        UIImageView  * imageView = imageViewArr[i];
        imageView.frame = CGRectMake(i * width + (i + 1) * kPad, kPad, width, kCellHeight - kPad);
        [self addSubview:imageView];
        
        UIImageView  * overlayImageView = overlayImageArr[i];
        overlayImageView.frame = CGRectMake(i * width + (i + 1) * kPad, kPad, width, kCellHeight - kPad);
        [self addSubview:overlayImageView];
    }
}

-(void)cellForTapGesture:(UITapGestureRecognizer *)tap{
    
    CGFloat  width = (CGRectGetWidth([UIScreen mainScreen].bounds) - (_listColumn + 1) * kPad) / _listColumn;
    CGPoint  point = [tap locationInView:self];
    CGRect   frame = CGRectMake(kPad, kPad, width, kCellHeight - kPad);
    for (NSInteger i = 0; i < assetGroup.count; i++) {
        if(CGRectContainsPoint(frame, point)){
            BOOL  choiceState = NO;
            if(_delegate && [_delegate respondsToSelector:@selector(WHCPhotoListIsMoreChoicePhoto)]){
                choiceState = [_delegate WHCPhotoListIsMoreChoicePhoto];
            }
            WHC_Asset  * whcAS = assetGroup[i];
            if(choiceState){
                whcAS.selected = !whcAS.selected;
                UIImageView * overlayImageView = overlayImageArr[i];
                overlayImageView.hidden = !whcAS.selected;
            }else{
                if(whcAS.selected){
                    whcAS.selected  = NO;
                    UIImageView * overlayImageView = overlayImageArr[i];
                    overlayImageView.hidden = YES;
                    if(_delegate && [_delegate respondsToSelector:@selector(WHCPhotoListCancelChoicePhoto)]){
                        [_delegate WHCPhotoListCancelChoicePhoto];
                    }
                }
            }
            break;
        }
        frame.origin.x += width + kPad;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
