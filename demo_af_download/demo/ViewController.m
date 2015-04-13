//
//  ViewController.m
//  demo
//
//  Created by WO on 15-3-24.
//  Copyright (c) 2015年 sg. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPSessionManager.h"
#import "UIProgressView+AFNetworking.h"
@interface ViewController ()
{
    UIProgressView *pro;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(240, 40, 60, 40);
    pro.backgroundColor = [UIColor blackColor];
    [btn setTitle:@"开始下载" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(downLoad) forControlEvents:UIControlEventTouchUpInside];
    pro = [[UIProgressView alloc]initWithFrame:CGRectMake(10, 60, 200, 20)];
    pro.backgroundColor = [UIColor blackColor];
    [self.view addSubview:pro];
    [self.view addSubview:btn];
}

//AFHTTPSession下载功能
- (void)downLoad
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:@"http://ghost.25pp.com/soft/pp_mac.dmg"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectectoryUrl = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSLog(@"%f",pro.progress);
        return [documentsDirectectoryUrl URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@",filePath);
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"下载完成" delegate:self cancelButtonTitle:@"queding" otherButtonTitles: nil]show];
    }];
    [pro setProgressWithDownloadProgressOfTask:downloadTask animated:YES];
    [downloadTask resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
