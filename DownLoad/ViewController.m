//
//  ViewController.m
//  DownLoad
//
//  Created by 王斌 on 2020/3/30.
//  Copyright © 2020 王斌. All rights reserved.
//

#import "ViewController.h"
#import "DownLoadOrUpLoadFileManager.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,strong) UIButton *btn;

@property(strong,nonatomic)AVPlayer *palyer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:(UIProgressViewStyleDefault)];
    [self.progressView setTrackTintColor:UIColor.clearColor];
    [self.progressView setProgressTintColor:[UIColor blueColor]];
    self.progressView.frame = CGRectMake(0, 80, 300, 2);
    [self.view addSubview:self.progressView];
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn setTitle:@"下载" forState:UIControlStateNormal];
    [self.btn setBackgroundColor:[UIColor redColor]];
    self.btn.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:self.btn];
    [self.btn addTarget:self action:@selector(download) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
- (void)download{
        
    NSString *path = @"http://q7zgqhpsj.bkt.clouddn.com/";

    NSString *url = @"HITA%20-%20%E5%85%B0%E8%8A%B7%E9%93%83%E9%9F%B3%C2%B7%E8%AE%B0%E5%85%B0%E7%94%9F%E8%A5%84%E9%93%83.mp3";

    DownLoadOrUpLoadFileManager *manager = [DownLoadOrUpLoadFileManager getInstance];
    if ([manager isSavedFileToLocalWithCreated:0 fileName:url]) {
        
          //本地音乐播放
        NSURL *url_music = [manager getLocalFilePathWithFileName:url fileCreated:0];

        self.palyer = [[AVPlayer alloc] initWithURL:url_music];
        
        [self.palyer play];
    }else{
        [manager downloadFileUrl:[NSString stringWithFormat:@"%@%@",path,url] fileName:url fileCreated:0 downloadSuccess:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
            NSLog(@"---=---response %@    ---filePath  %@  ----error %@",response,filePath,error);
        } progress:^(float progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressView.progress = progress;
            });
        }];
    }
}

@end
