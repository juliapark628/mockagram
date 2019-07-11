//
//  DetailsViewController.m
//  mockagram
//
//  Created by juliapark628 on 7/10/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "DetailsViewController.h"
#import "Post.h"
#import "DateTools.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *topUsernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *bottomUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@property (nonatomic) BOOL likedByCurrentUser;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFFileObject *userImageFile = self.post.image;
    [userImageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            self.photoImageView.image = [UIImage imageWithData:data];
        }
        else {
            NSLog(@"cannot get image from PFFile");
        }
    }];
    self.topUsernameLabel.text = self.post.userID;
    self.bottomUsernameLabel.text = self.post.userID;
    self.captionLabel.text = self.post.caption;
    self.dateCreatedLabel.text = [self.post.updatedAt timeAgoSinceNow];
    self.likeCountLabel.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
    
    self.likedByCurrentUser = [self.post.likedUsers containsObject:[PFUser currentUser].username];
    [self.likeButton setSelected:self.likedByCurrentUser];
}


- (IBAction)likeButtonClicked:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    if (!self.likedByCurrentUser) {
        // Retrieve the object by id
        [query getObjectInBackgroundWithId:self.post.objectId block:^(PFObject *serverPost, NSError *error) {
            self.post.likeCount = @([self.post.likeCount intValue] + 1);
            serverPost[@"likeCount"] = self.post.likeCount;
            [serverPost addUniqueObject:[PFUser currentUser].username forKey:@"likedUsers"];
            [serverPost saveInBackground];
            
            self.likeCountLabel.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
            [self.likeButton setSelected:YES];
            self.likedByCurrentUser = true;
        }];
    }
    else {
        [query getObjectInBackgroundWithId:self.post.objectId block:^(PFObject *serverPost, NSError *error) {
            self.post.likeCount = @([self.post.likeCount intValue] - 1);
            serverPost[@"likeCount"] = self.post.likeCount;
            [serverPost removeObject:[PFUser currentUser].username forKey:@"likedUsers"];
            [serverPost saveInBackground];
            
            self.likeCountLabel.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
            [self.likeButton setSelected:NO];
            self.likedByCurrentUser = false;
        }];
    }
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
