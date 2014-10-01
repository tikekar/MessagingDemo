//
//  SettingsViewController.m
//  SendHubDemo
//
//  Created by Gauri Tikekar on 9/30/14.
//  Copyright (c) 2014 GauriTikekar. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)onDone:(id)sender {
    // Store the user data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(defaults != nil) {
        [defaults setObject:self.userNameTextField.text forKey:@"username"];
        [defaults setObject:self.apiKeyTextField.text forKey:@"apikey"];
        [defaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserSettingsChanged" object:nil userInfo:nil];
    }
    [self dismissViewControllerAnimated:true completion:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(defaults != nil) {
        NSString *username = [defaults objectForKey:@"username"];
        NSString *apikey = [defaults objectForKey:@"apikey"];
        if(username != nil && apikey != nil) {
            self.userNameTextField.text = username;
            self.apiKeyTextField.text = apikey;
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
