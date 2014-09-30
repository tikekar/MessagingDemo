//
//  DetailViewController.h
//  SendHubDemo
//
//  Created by Gauri Tikekar on 9/30/14.
//  Copyright (c) 2014 GauriTikekar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendMessageViewController.h"

@interface DetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) SendMessageViewController *sendMessageViewController;


@end
