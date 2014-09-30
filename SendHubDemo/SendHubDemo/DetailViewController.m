//
//  DetailViewController.m
//  SendHubDemo
//
//  Created by Gauri Tikekar on 9/30/14.
//  Copyright (c) 2014 GauriTikekar. All rights reserved.
//

#import "DetailViewController.h"
#import "SendMessageViewController.h"

@interface DetailViewController (){
    NSMutableArray *_contactDetails; //details of the selected contact
}
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        _contactDetails = [[NSMutableArray alloc] init];

        self.navigationItem.title = [self.detailItem objectForKey:@"name"];

        _contactDetails[0] = [NSString stringWithFormat:@"%@ %@", @"Name:", [self.detailItem objectForKey:@"name"]];
        _contactDetails[1] = [NSString stringWithFormat:@"%@ %@", @"Number:", [self.detailItem objectForKey:@"number"]];;
    }
}
- (IBAction)clickSendMessage:(id)sender {

    SendMessageViewController *sendMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SendMessageViewController"];
    sendMessageViewController.contactDetails = self.detailItem;
    [self presentViewController:sendMessageViewController animated:true completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
    NSDictionary *object = _contactDetails[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

@end
