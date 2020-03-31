//
//  DownLoadOrUpLoadFileManager.m
//  DownLoad
//
//  Created by 王斌 on 2020/3/30.
//  Copyright © 2020 王斌. All rights reserved.
//

#import "DownLoadOrUpLoadFileManager.h"
#import <AFNetworking/AFNetworking.h>

#define LOCAL_SAVE_PATH @"download"

@implementation DownLoadOrUpLoadFileManager

+ (instancetype)getInstance
{
    static DownLoadOrUpLoadFileManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DownLoadOrUpLoadFileManager alloc]init];
    });
    return manager;
}

/**
 *  根据url判断是否已经保存到本地了
 *
 *  @param fileName 文件的url
 *
 *  @return YES：本地已经存在，NO：本地不存在
 */
- (BOOL)isSavedFileToLocalWithCreated:(UInt32)created fileName:(NSString *)fileName
{
    // 判断是否已经离线下载了
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%d/%@", LOCAL_SAVE_PATH, created, fileName]];
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    
    if ([filemanager fileExistsAtPath:path]) {
        return YES;
    }
    return NO;
}

/**
 *  根据文件的创建时间 设置保存到本地的路径
 *
 *  @param created  创建时间
 *  @param fileName 名字
 *
 *  @return return value description
 */
-(NSString *)setPathOfDocumentsByFileCreated:(UInt32)created fileName:(NSString *)fileName
{
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%d", LOCAL_SAVE_PATH, created]];
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if (![filemanager fileExistsAtPath:path]) {
        [filemanager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

/**
 *  根据文件类型、名字、创建时间获得本地文件的路径，当文件不存在时，返回nil
 *
 *
 *  @param fileName 文件名字
 *  @param created  文件在服务器创建的时间
 *
 *  @return 本地文件的路径，当文件不存在时，返回nil
 */
- (NSURL *)getLocalFilePathWithFileName:(NSString *)fileName fileCreated:(UInt32)created
{
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%d", LOCAL_SAVE_PATH, created]];
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSArray *fileList = [filemanager subpathsOfDirectoryAtPath:path error:nil];
    
    if ([fileList containsObject:fileName]) {
        NSString *fileUrltemp = [NSString stringWithFormat:@"%@/%@", path, fileName];
        NSURL *url = [NSURL fileURLWithPath:fileUrltemp];
        return url;
    }
    return nil;
}

/**
 *  @brief 下载文件
 *
 *  @param requestURL 下载的url
 *
 *  @param fileName   文件名字
 *  @param created    文件服务器创建时间
 *  @param completionHandler    success
 *  @param progress   progress
 */
- (void)downloadFileUrl:(NSString*)requestURL
                      fileName:(NSString *)fileName
                   fileCreated:(UInt32)created
               downloadSuccess:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler
                      progress:(void (^)(float progress))progress
{
    /* 下载地址 */
    NSURL *url = [NSURL URLWithString:requestURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    /* 下载路径 */
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", [self setPathOfDocumentsByFileCreated:created fileName:fileName], fileName];
        
    
    AFURLSessionManager *downLoadOperation = [[AFURLSessionManager alloc]init];
    
    /* 开始请求下载 */
    self.downloadTask = [downLoadOperation downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress.fractionCompleted * 100);
        NSLog(@"下载进度：%.0f％", downloadProgress.fractionCompleted * 100);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //如果需要进行UI操作，需要获取主线程进行操作
        });
        /* 设定下载到的位置 */
        return [NSURL fileURLWithPath:filePath];
                
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
         NSLog(@"下载完成");
        completionHandler(response,filePath,error);
    }];
    [self.downloadTask resume];
}
/**
 *  取消下载，并删除本地已经下载了的部分
 *
 *  @param created  文件在服务器创建的时间
 *  @param fileName 文件的名字
 */
- (void)cancleDownLoadFileWithServiceCreated:(UInt32)created fileName:(NSString *)fileName;
{
    [self.downloadTask cancel];
    // 删除本地文件
    NSString *localSavePath = [NSString stringWithFormat:@"%@/%@", [self setPathOfDocumentsByFileCreated:created fileName:fileName], fileName];
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if ([filemanager fileExistsAtPath:localSavePath]) {
        [filemanager removeItemAtPath:localSavePath error:nil];
    }
}

// 下载暂停
- (void)downLoadPause
{
    [self.downloadTask suspend];
}
// 下载继续
- (void)downLoadResume
{
    [self.downloadTask resume];
}

@end
