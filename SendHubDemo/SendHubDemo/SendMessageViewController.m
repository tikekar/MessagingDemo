//
//  SendMessageViewController.m
//  SendHubDemo
//
//  Created by Gauri Tikekar on 9/30/14.
//  Copyright (c) 2014 GauriTikekar. All rights reserved.
//

#import "SendMessageViewController.h"
#import "AppDelegate.h"

@interface SendMessageViewController ()

@end

@implementation SendMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.messageText.delegate = (id)self;

    self.messageText.layer.cornerRadius=8.0f;
    self.messageText.layer.borderColor=[[UIColor blackColor]CGColor];
    self.messageText.layer.borderWidth= 1.0f;
    [self.sendMessageButton setEnabled:FALSE];

    [self.messageText becomeFirstResponder];
    [self.labelMessageSent setHidden:TRUE];

}

//close button click
- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

//send message button click
- (IBAction)onSendMessage:(id)sender {

    [self.messageText resignFirstResponder];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"username"];
    NSString *apikey = [defaults objectForKey:@"apikey"];

    NSData *postData = [self getJson];
    if(postData == nil) {
        return;
    }

    // cast it to unsigned long
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    NSString *sendMsgUrl = [NSString stringWithFormat:@"%@%@%@%@", @"https://api.sendhub.com/v1/messages/?username=", username, @"&api_key=", apikey];

    [request setURL:[NSURL URLWithString:sendMsgUrl]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {

         if(response != nil) {
             if (response != nil && [response isKindOfClass:[NSHTTPURLResponse class]]) {
                 NSHTTPURLResponse* newResp = (NSHTTPURLResponse*)response;
                 if(newResp.statusCode >= 300) {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                                     message:@"Failed to Send Message"
                                                                    delegate:self
                                                           cancelButtonTitle:@"Okay"
                                                           otherButtonTitles: nil];

                     [alert show];
                 }
                 else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self.labelMessageSent setHidden:FALSE];
                     });

                 }
             }

         }

     }];
}

-(NSData *) getJson {
    NSError *error = nil;
    NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
    [phoneNumbers addObject:[self.contactDetails objectForKey:@"number"]];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:phoneNumbers forKey:@"contacts"];
    [dict setObject:self.messageText.text forKey:@"text"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"json did not get generated: %@", error);
    }
    return jsonData;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.labelMessageSent setHidden:TRUE];
    if([self.messageText.text isEqualToString:@""]) {
        [self.sendMessageButton setEnabled:FALSE];
    }
    else {
        [self.sendMessageButton setEnabled:TRUE];
    }
}

@end
