//
//  PostTableViewCell.m
//  mockagram
//
//  Created by juliapark628 on 7/9/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "PostTableViewCell.h"
#import "DateTools.h"
#import "Parse/Parse.h"

@implementation PostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)refreshDataAtCell:(PostTableViewCell*)cell withPost:(Post*)currPost {
    self.postCreator = currPost.author;
    PFFileObject *userProfileImageFile = self.postCreator[@"profilePicture"];
    
    [userProfileImageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            [self.profilePhotoImageViewButton setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
        }
        else {
            [self.profilePhotoImageViewButton setImage:[UIImage imageNamed:@"image_placeholder"] forState:UIControlStateNormal];
        }
    }];
    
    
    PFFileObject *userImageFile = currPost.image;
    [userImageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            cell.photoImageView.image = [UIImage imageWithData:data];
        }
        else {
            NSLog(@"cannot get image from PFFile");
        }
    }];
    [self.usernameButton setTitle:currPost.userID forState:UIControlStateNormal];
    [self.bottomUsernameButton setTitle:currPost.userID forState:UIControlStateNormal];
    self.captionLabel.text = currPost.caption;
    self.dateCreatedLabel.text = [currPost.updatedAt timeAgoSinceNow];
    
    // NSLog(@"date: %@", currPost.updatedAt);
}

- (IBAction)profilePictureClicked:(id)sender {
    [self goToProfileVC];
}

- (IBAction)topUsernameClicked:(id)sender {
    [self goToProfileVC];
}

- (IBAction)bottomUsernameClicked:(id)sender {
    [self goToProfileVC];
}

- (void)goToProfileVC {
    // FeedViewController.gotoPrfileVC(postCreator);
    
    [_delegate launchProfileVC:self.postCreator];
    
}


@end
