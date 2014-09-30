//
//  SendMessageViewController.m
//  SendHubDemo
//
//  Created by Gauri Tikekar on 9/30/14.
//  Copyright (c) 2014 GauriTikekar. All rights reserved.
//

#import "SendMessageViewController.h"

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onSendMessage:(id)sender {

    NSData *postData = [self getJson];
    if(postData == nil) {
        return;
    }

    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://api.sendhub.com/v1/messages/?username=3237451658&api_key=88a04d0d9cfbeaf839d59b2d8478a7324c1b6eb1"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {

         if(data != nil) {
             NSLog([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
         }
         if (error != nil) {
             // NSLog(@"Failed to send message: %@", error);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                             message:@"Failed to Send Message"
                                                            delegate:self
                                                   cancelButtonTitle:@"Okay"
                                                   otherButtonTitles: nil];
             
             [alert show];
         }
     }];
}

-(NSData *) getJson {
    NSError *error = nil;
    NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
    [phoneNumbers addObject:[self.contactDetails objectForKey:@"number"]];
    // [phoneNumbers addObject:@"12"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:phoneNumbers forKey:@"contacts"];
    [dict setObject:self.messageText.text forKey:@"text"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];

    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(jsonString);
    }
    return jsonData;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
