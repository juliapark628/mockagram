//
//  PostTableViewCell.h
//  mockagram
//
//  Created by juliapark628 on 7/9/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PostTableViewCellDelegate

-(void)launchProfileVC:(PFUser *)forProfile;

@end

@interface PostTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *profilePhotoImageViewButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *usernameButton;
@property (weak, nonatomic) IBOutlet UIButton *bottomUsernameButton;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedLabel;

@property (nonatomic) int position;
@property (nonatomic, weak) id<PostTableViewCellDelegate> delegate;
@property (nonatomic, weak) PFUser *postCreator;

- (void)refreshDataAtCell:(PostTableViewCell*)cell withPost:(Post*)currPost;

@end

NS_ASSUME_NONNULL_END
