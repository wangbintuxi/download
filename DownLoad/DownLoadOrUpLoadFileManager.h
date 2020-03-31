//
//  DownLoadOrUpLoadFileManager.h
//  DownLoad
//
//  Created by 王斌 on 2020/3/30.
//  Copyright © 2020 王斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownLoadOrUpLoadFileManager : NSObject
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
+ (instancetype)getInstance;

#pragma mark -下载文件
/**
 *  根据url判断是否已经保存到本地了
 *
 *  @param created 文件的创建时间  通过和fileName拼接成完整的文件路径
 *
 *  @param fileName 文件的名字
 *
 *  @return YES：本地已经存在，NO：本地不存在
 */
- (BOOL)isSavedFileToLocalWithCreated:(UInt32)created fileName:(NSString *)fileName;

/**
 *  根据文件的创建时间 设置保存到本地的路径
 *
 *  @param created  创建时间
 *  @param fileName 名字
 *
 *  @return return value description
 */
-(NSString *)setPathOfDocumentsByFileCreated:(UInt32)created fileName:(NSString *)fileName;

/**
 *  根据文件类型、名字、创建时间获得本地文件的路径，当文件不存在时，返回nil
 *
 *  @param fileName 文件名字
 *  @param created  文件在服务器创建的时间
 *
 *  @return description
 */
- (NSURL *)getLocalFilePathWithFileName:(NSString *)fileName fileCreated:(UInt32)created;

/**
 *  @brief 下载文件
 *
 *  @param requestURL 下载的url
 *  @param fileName   文件名字
 *  @param created    文件服务器创建时间
 *  @param completionHandler    success
 *  @param progress   progress
 */
- (void)downloadFileUrl:(NSString*)requestURL
                      fileName:(NSString *)fileName
                   fileCreated:(UInt32)created
               downloadSuccess:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler
                      progress:(void (^)(float progress))progress;

/**
 *  取消下载，并删除本地已经下载了的部分
 *
 *  @param created  文件在服务器创建的时间
 *  @param fileName 文件的名字
 */
- (void)cancleDownLoadFileWithServiceCreated:(UInt32)created fileName:(NSString *)fileName;

/**
 *  下载暂停
 */
- (void)downLoadPause;

/**
 *  下载继续
 */
- (void)downLoadResume;
@end

NS_ASSUME_NONNULL_END
