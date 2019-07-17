//
//  FeedViewController.m
//  mockagram
//
//  Created by juliapark628 on 7/8/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "FeedViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "PostTableViewCell.h"
#import "Post.h"
#import "DetailsViewController.h"
#import "OtherProfileViewController.h"
#import "ComposeViewController.h"

@interface FeedViewController () <UITableViewDataSource, UITableViewDelegate, PostTableViewCellDelegate, ComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *feedTableView;
@property (strong, nonatomic) NSMutableArray* feedPosts;

@end

@implementation FeedViewController

static int MAX_POSTS_IN_FEED = 20;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.feedTableView.dataSource = self;
    self.feedTableView.delegate = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.feedTableView insertSubview:refreshControl atIndex:0];
    
    [self beginRefresh:nil]; // TODO: combined load feed and begin refresh so that endrefresh can be called in completion block
}

- (void)beginRefresh:(UIRefreshControl * _Nullable)refreshControl {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    query.limit = MAX_POSTS_IN_FEED;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.feedPosts = [NSMutableArray arrayWithArray:posts];
            
            [self.feedTableView reloadData];
            
            [refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.feedPosts count] < MAX_POSTS_IN_FEED) {
        return [self.feedPosts count];
    }
    else {
     
         return MAX_POSTS_IN_FEED;
    
     }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostTableViewCell"];
    
    Post *currPost = self.feedPosts[indexPath.row];

    [cell refreshDataAtCell:cell withPost:currPost];
    cell.position = (int)indexPath.row;
    cell.delegate = self;
    
    return cell;
}



- (IBAction)logoutButtonClicked:(id)sender {
    [self logoutUser];
}

- (void)logoutUser {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        appDelegate.window.rootViewController = loginViewController;
    }];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([[segue identifier] isEqualToString:@"feedDetailSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.feedTableView indexPathForCell:tappedCell];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = self.feedPosts[indexPath.row];
    } else if ([[segue identifier] isEqualToString:@"composeSegue"]) {
        
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
}


- (void)launchProfileVC:(nonnull PFUser *)forProfile {
    // instantiate OtherProfileViewController
    // OtherProfileViewController.profiletoShow = forProfile
    // present(OtherProfileViewController)
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navViewController = [storyboard instantiateViewControllerWithIdentifier:@"otherProfileNavViewController"];
    OtherProfileViewController *otherProfileVC = navViewController.viewControllers[0];
    otherProfileVC.user = forProfile;
    [self presentViewController:navViewController animated:YES completion:nil];
}

@end
