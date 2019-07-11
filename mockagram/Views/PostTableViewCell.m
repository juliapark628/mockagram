//
//  PostTableViewCell.m
//  mockagram
//
//  Created by juliapark628 on 7/9/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "PostTableViewCell.h"

@implementation PostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshDataAtCell:(PostTableViewCell*)cell withPost:(Post*)currPost {
    PFFileObject *userImageFile = currPost.image;
    [userImageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            cell.photoImageView.image = [UIImage imageWithData:data];
        }
        else {
            NSLog(@"cannot get image from PFFile");
        }
    }];
    self.usernameLabel.text = currPost.userID;
    self.topUsernameLabel.text = currPost.userID; 
    self.captionLabel.text = currPost.caption;
}



@end
