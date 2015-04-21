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
    NSURLSessionDownloadTask *downloadTask;
}
@end

@implementation ViewController

@synthesize downloadBtn;
@synthesize downloadingPro;
@synthesize isDowmloading;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    downloadBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    downloadBtn.frame = CGRectMake(240, 40, 60, 40);
    
    [downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
    [downloadBtn addTarget:self action:@selector(downLoadClick) forControlEvents:UIControlEventTouchUpInside];
    
    downloadingPro = [[UIProgressView alloc]initWithFrame:CGRectMake(10, 60, 200, 20)];
    
    downloadingPro.backgroundColor = [UIColor blackColor];
    [self.downloadingPro addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.view addSubview:downloadingPro];
    [self.view addSubview:downloadBtn];
    [self.downloadingPro removeObserver:self forKeyPath:@"progress"];
}


- (void)downLoadClick
{
    if ([downloadBtn.titleLabel.text isEqualToString:@"下载"]) {
        
        [self beginDownload];
        [downloadBtn setTitle:@"暂停" forState:UIControlStateNormal];
        
    }else{
        [downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
        [downloadTask suspend];
    }
}
//AFHTTPSession下载功能
- (void)beginDownload
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:@"http://ghost.25pp.com/soft/pp_mac.dmg"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    

    
    //下载比例方法（一）
    
    /*
     downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectectoryUrl = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
     
        return [documentsDirectectoryUrl URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@",filePath);
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"下载完成" delegate:self cancelButtonTitle:@"queding" otherButtonTitles: nil]show];
    }];
    [downloadingPro setProgressWithDownloadProgressOfTask:downloadTask animated:YES];
    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        CGFloat t = (CGFloat)totalBytesWritten/(CGFloat)totalBytesExpectedToWrite;
        NSLog(@"%F",t);
        NSLog(@"xxxProgress… %lld...%lld", totalBytesWritten,totalBytesExpectedToWrite);
    }];
    [downloadTask resume];
     */


    
//    记录下载比例方法KVO（二）
    
    NSProgress *progress;
    downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectectoryUrl = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];

        return [documentsDirectectoryUrl URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@",filePath);
        if (!error) {
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"下载完成" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
        }else
        {
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"下载失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
        }

    }];
    [downloadingPro setProgressWithDownloadProgressOfTask:downloadTask animated:YES];
    [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:NULL];
    [downloadTask resume];
     

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"fractionCompleted"]) {
        NSProgress *progress = (NSProgress *)object;
        NSLog(@"Progress… %f", progress.fractionCompleted);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end
