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

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *userPostsCollectionView;
@property (strong, nonatomic) NSArray* userPosts;
@property (strong, nonatomic) NSString *currUsername;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.userPostsCollectionView.dataSource = self;
    self.userPostsCollectionView.delegate = self;
    self.currUsername = [PFUser currentUser].username;
    
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
