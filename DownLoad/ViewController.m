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

#define Server_Path @"http://q7zgqhpsj.bkt.clouddn.com/"

@implementation DownLoadModel



@end

@implementation DownLoadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.label = [[UILabel alloc]init];
        self.label.text = @"下载";
        self.label.font = [UIFont systemFontOfSize:15];
        self.label.frame = CGRectMake(220, 5, 100, 40);
        self.label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (void)setModel:(DownLoadModel *)model{
    _model = model;
    self.textLabel.text = model.titleStr;
    self.label.text = model.staticStr;
}

@end









@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;


@property (nonatomic,strong) DownLoadOrUpLoadFileManager *manager;

@property(strong,nonatomic)AVPlayer *player;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];

    
    DownLoadModel *model = [DownLoadModel new];
    model.url = @"HITA%20-%20%E5%85%B0%E8%8A%B7%E9%93%83%E9%9F%B3%C2%B7%E8%AE%B0%E5%85%B0%E7%94%9F%E8%A5%84%E9%93%83.mp3";

    self.manager = [DownLoadOrUpLoadFileManager getInstance];
    // 本地存在
    if ([self.manager isSavedFileToLocalWithCreated:0 fileName:model.url]) {
        model.staticStr = @"播放";
    }else{
        model.staticStr = @"下载";
    }
    model.titleStr = @"HITA 记兰生襄铃";
    
    self.dataArray = [NSMutableArray array];
    [self.dataArray addObject:model];
    
    [self.tableView reloadData];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DownLoadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Down" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DownLoadModel *model = self.dataArray[indexPath.row];
    DownLoadCell *cell = [tableView cellForRowAtIndexPath: indexPath];


    if ([model.staticStr isEqualToString:@"播放"] || [model.staticStr isEqualToString:@"暂停"]) {
          //本地音乐播放
        if (!self.player) {
            NSURL *url_music = [self.manager getLocalFilePathWithFileName:model.url fileCreated:0];

            self.player = [[AVPlayer alloc] initWithURL:url_music];
        }
        
        if(self.player.rate==0){ //说明时暂停
            [self.player play];
            model.staticStr = cell.label.text = @"暂停";

        }else if(self.player.rate==1){//正在播放
            [self.player pause];
            model.staticStr = cell.label.text = @"播放";
        }
        
        
    }else{
        // 下载文件
        [self.manager downloadFileUrl:[NSString stringWithFormat:@"%@%@",Server_Path,model.url] fileName:model.url fileCreated:0 downloadSuccess:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
            NSLog(@"---=---response %@    ---filePath  %@  ----error %@",response,filePath,error);
            if (!error) {
                model.staticStr = cell.label.text = @"播放";
            }else{
                model.staticStr = cell.label.text = @"重新下载";
            }
            
        } progress:^(float progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                model.staticStr = cell.label.text = [NSString stringWithFormat:@"%f%%",progress];
            });
        }];
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 50;
        [_tableView registerClass:[DownLoadCell class] forCellReuseIdentifier:@"Down"];
        
    }
    return _tableView;
}

@end
