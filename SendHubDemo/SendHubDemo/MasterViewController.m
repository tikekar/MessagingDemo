//
//  MasterViewController.m
//  SendHubDemo
//
//  Created by Gauri Tikekar on 9/30/14.
//  Copyright (c) 2014 GauriTikekar. All rights reserved.
//

#import "MasterViewController.h"
#import "AppDelegate.h"

#import "DetailViewController.h"
#import "SettingsViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects; // for storing the contacts NSDictionary
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(goToSettings)];

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"username"];
    NSString *apikey = [defaults objectForKey:@"apikey"];
    if(username == nil || apikey == nil) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserSettingsChanged" object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserSettingsChanged:) name:@"UserSettingsChanged" object:nil];

        SettingsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        [self presentViewController:settingsViewController animated:false completion:nil];
    }
    else {
        [self getContacts];
    }
}

// This is called when settings button clicked
-(void) goToSettings {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserSettingsChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserSettingsChanged:) name:@"UserSettingsChanged" object:nil];

    SettingsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self presentViewController:settingsViewController animated:true completion:nil];

}

//After settings are changed and done button clicked from settings page, post this notification.
- (void)onUserSettingsChanged:(NSNotification *)notification {
    [_objects removeAllObjects];
    [self.tableView reloadData];
    [self getContacts];
}

// Get list of contacts.
-(void) getContacts {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"username"];
    NSString *apikey = [defaults objectForKey:@"apikey"];

    NSString *url = [NSString stringWithFormat:@"%@%@%@%@", @"https://api.sendhub.com/v1/contacts/?username=", username, @"&api_key=", apikey];
    NSURL *myURL = [NSURL URLWithString: url];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {

         if(response != nil) {
             if (response != nil && [response isKindOfClass:[NSHTTPURLResponse class]]) {
                 NSHTTPURLResponse* newResp = (NSHTTPURLResponse*)response;
                 if(newResp.statusCode >= 300) {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                                     message:@"Failed to get Contacts"
                                                                    delegate:self
                                                           cancelButtonTitle:@"Okay"
                                                           otherButtonTitles: nil];
                     [alert show];
                 }
                 else {
                     // UI rendering has to be on main thread
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self populateContacts:data];
                     });
                 }
             }
         }
     }];

}

//Populate contacts in the table view
-(void) populateContacts : (NSData *) contactsData {
     NSError *e = nil;
     if(contactsData != nil) {
         NSDictionary *contactsDictionary = [NSJSONSerialization JSONObjectWithData:contactsData options:NSJSONReadingMutableContainers error:&e];
         NSArray *contactsList = [contactsDictionary objectForKey:@"objects"];

         for( int i=0; i < [contactsList count]; i++) {
             NSDictionary *iContact = contactsList[i];
             [self insertContact:iContact];
         }
     }
}

-(void) insertContact : (NSDictionary *) contact {
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:contact atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(void) dealloc {
    if(self) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *object = _objects[indexPath.row];
    cell.textLabel.text = [object objectForKey:@"name"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDate *object = _objects[indexPath.row];
        self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
