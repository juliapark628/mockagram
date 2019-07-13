//
//  NewAccountViewController.m
//  mockagram
//
//  Created by juliapark628 on 7/8/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "NewAccountViewController.h"
#import "Parse/Parse.h"

@interface NewAccountViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;


@end

@implementation NewAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)createAccountButtonClicked:(id)sender {
    [self createAccount];

}

- (void) createAccount {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    UIImage *defaultImage = [UIImage imageNamed:@"image_placeholder"];
    NSData *imageData = UIImagePNGRepresentation(defaultImage);
    newUser[@"profilePicture"] = [PFFileObject fileObjectWithName:@"profile.png" data:imageData];
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"Account created!");
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}

- (IBAction)backToSigninButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil]; 
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
