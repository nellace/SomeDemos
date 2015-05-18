//
//  ViewController.h
//  Demo_download
//
//  Created by WO on 15-4-13.
//  Copyright (c) 2015年 sg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic,strong) UIProgressView *downloadingPro;
@property (nonatomic,strong) UIButton *downloadBtn;
@property (nonatomic,assign) BOOL isDowmloading;
@property (nonatomic,strong) UILabel *percentLabel;
@end

