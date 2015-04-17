//
//  ViewController.m
//  Demo_download
//
//  Created by WO on 15-4-13.
//  Copyright (c) 2015年 sg. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
{
    
}
@end

@implementation ViewController

@synthesize downloadBtn;
@synthesize downloadingPro;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    downloadBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    downloadBtn.frame = CGRectMake(240, 40, 60, 40);
    
    [downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
    [downloadBtn addTarget:self action:@selector(downLoad) forControlEvents:UIControlEventTouchUpInside];
    
    downloadingPro = [[UIProgressView alloc]initWithFrame:CGRectMake(10, 60, 200, 20)];
    downloadingPro.backgroundColor = [UIColor blackColor];
    [downloadingPro addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:downloadingPro];
    [self.view addSubview:downloadBtn];
}

//AFHTTPSession下载功能
- (void)downLoad
{
    if ([downloadBtn.titleLabel.text isEqualToString:@"下载"]) {
        [downloadBtn setTitle:@"暂停" forState:UIControlStateNormal];
    }else{
        [downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
    }
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:@"http://ghost.25pp.com/soft/pp_mac.dmg"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectectoryUrl = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSLog(@"%f",downloadingPro.progress);
        return [documentsDirectectoryUrl URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@",filePath);
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"下载完成" delegate:self cancelButtonTitle:@"queding" otherButtonTitles: nil]show];
    }];
    [downloadingPro setProgressWithDownloadProgressOfTask:downloadTask animated:YES];
    [downloadTask resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"%@",keyPath);
    NSNumber *number = [change objectForKey:@"new"];
    CGFloat ff = [number floatValue];
    NSLog(@"%.1f%%",ff*100);
}
@end
