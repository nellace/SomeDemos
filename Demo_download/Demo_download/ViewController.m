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
    UILabel *label;
}
@end

@implementation ViewController

@synthesize downloadBtn;
@synthesize downloadingPro;
@synthesize isDowmloading;
@synthesize percentLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    downloadBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    downloadBtn.frame = CGRectMake(260, 40, 60, 40);
    [downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
    [downloadBtn addTarget:self action:@selector(downLoadClick) forControlEvents:UIControlEventTouchUpInside];
    
    downloadingPro = [[UIProgressView alloc]initWithFrame:CGRectMake(10, 60, 200, 20)];
    downloadingPro.backgroundColor = [UIColor blackColor];
    [self.downloadingPro addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    percentLabel = [UILabel new];
    percentLabel.frame = CGRectMake(210, 40, 40, 40);
    
    label =[[UILabel alloc]initWithFrame:CGRectMake(0, 100, 320, 300)];
    label.backgroundColor = [UIColor grayColor];
    label.numberOfLines = 0;
    label.text = @"事实证明苹果已经充分掌握了互联网思维下的软件开发先放出来无数的牛逼功能让人期待，然后用个烂一点快速占领市场，最后慢慢的更新修复Bug……当然修Bug的程序员就安排几个，大部分人还在做更加牛逼的新功能……";
    [label sizeToFit];
    [self.view addSubview:label];
    [self moveString:123456 movePath:3];
    
    NSLog(@"%f",label.frame.size.height);
    [self.view addSubview:percentLabel];
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
//    downloadTask.resume
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

//    记录下载比例方法KVO 观察者（二）
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"fractionCompleted"]) {
        NSProgress *progress = (NSProgress *)object;
        int percent = progress.fractionCompleted*100;
        NSLog(@"Progress… %d%@", percent,@"%");
        NSString *percentLabelText = [NSString stringWithFormat:@"%d%@",percent,@"%"];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

// 试一下循环右移

- (void)moveString:(unsigned)str movePath:(int)path
{
    unsigned movePart = str & ~(~0 << path);
    movePart = movePart << (wordlength() - path);
    str = str >> path;
    str = str | movePart;
    NSLog(@"%u",str);
    
}

int wordlength(void)
{
    int i;
    unsigned v = (unsigned)~0;
    
    for (int i = 0; (i = v >>1) > 1; i--) ;
    return i;
}

@end
