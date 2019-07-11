//
//  ProfileViewController.m
//  mockagram
//
//  Created by juliapark628 on 7/9/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserPostCollectionViewCell.h"
#import "Post.h"
#import "Parse/Parse.h"
#import "DetailsViewController.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *userPostsCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImage;

@property (strong, nonatomic) UIImage* profilePicture;
@property (strong, nonatomic) NSArray* userPosts;
@property (strong, nonatomic) NSString *currUsername;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.userPostsCollectionView.dataSource = self;
    self.userPostsCollectionView.delegate = self;
    self.currUsername = [PFUser currentUser].username;
    
    self.usernameLabel.text = self.currUsername;
    // TODO: create a profilePicture field in PFUser
    // TODO: set image view to the current profile picture if it exists
    // self.profilePicture = [PFUser currentUser].profilePicture;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.userPostsCollectionView insertSubview:refreshControl atIndex:0];
    
    [self beginRefresh:nil];
    
    // layout
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*) self.userPostsCollectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.userPostsCollectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)beginRefresh:(UIRefreshControl * _Nullable)refreshControl {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"userID" equalTo:self.currUsername];
    [query orderByDescending:@"createdAt"];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.userPosts = [NSMutableArray arrayWithArray:posts];
            
            [self.userPostsCollectionView reloadData];
            
            [refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UserPostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserPostCollectionViewCell" forIndexPath:indexPath];
    
    Post *post = self.userPosts[indexPath.item];
    
    PFFileObject *userImageFile = post.image;
    [userImageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            cell.photoImageView.image = [UIImage imageWithData:data];
        }
        else {
            NSLog(@"cannot get image from PFFile");
        }
    }];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userPosts.count;
}

- (IBAction)changeProfilePicButton:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
    // TODO: set imageview to class image
    // TODO: send back to server new profile picture
    /*
    PFQuery *query = [PFQuery queryWithClassName:@"GameScore"];
    
    // Retrieve the object by id
    
    [query getObjectInBackgroundWithId:@"xWMyZ4YEGZ" block:^(PFObject *gameScore, NSError *error) {
        // Now let's update it with some new data. In this case, only cheatMode and score
        // will get sent to the cloud. playerName hasn't changed.
        gameScore[@"cheatMode"] = @YES;
        gameScore[@"score"] = @1338;
        [gameScore saveInBackground];
    }];
    */
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = [self resizeImage:originalImage withSize:CGSizeMake(75, 75)];
    
    // TODO: set class' image to this edited image
    self.profilePictureImage.image = [UIImage imageWithCGImage:editedImage.CGImage];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"profileDetailSegue"]) {
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.userPostsCollectionView indexPathForCell:tappedCell];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = self.userPosts[indexPath.row];
    }
}


@end
