//
//  SendMessageViewController.h
//  SendHubDemo
//
//  Created by Gauri Tikekar on 9/30/14.
//  Copyright (c) 2014 GauriTikekar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendMessageViewController : UIViewController

@property (nonatomic) NSDictionary *contactDetails;
@property (weak, nonatomic) IBOutlet UITextView *messageText;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (weak, nonatomic) IBOutlet UILabel *labelMessageSent;

@end
