//
//  ViewController.h
//  DownLoad
//
//  Created by 王斌 on 2020/3/30.
//  Copyright © 2020 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownLoadModel : NSObject
@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) NSString *staticStr;
@property (nonatomic,strong) NSString *url;
@end

@interface DownLoadCell : UITableViewCell
@property (nonatomic,strong) DownLoadModel *model;

@property (nonatomic,strong) UILabel *label;

@end


@interface ViewController : UIViewController


@end

