//
//  ComposeViewController.m
//  mockagram
//
//  Created by juliapark628 on 7/9/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "ComposeViewController.h"
#import "Post.h"
#import "MBProgressHUD.h"

@interface ComposeViewController () < UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIImage* selectedImage;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UITextField *captionTextField;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self automaticallySelectImageSource];
}

- (void)automaticallySelectImageSource {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    // comment this out when running on simulator.
    // imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void) attemptToSetImageSourceToCamera {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Camera" message:@"There is no camera." preferredStyle:(UIAlertControllerStyleAlert)];
        
        // try again by refreshing
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        // add the refresh action to the alert controller
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:^{
            // do nothing
        }];
    }
}

- (void) setImageSourceToLibrary {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = [self resizeImage:originalImage withSize:CGSizeMake(375, 375)];
    
    self.selectedImage = [UIImage imageWithCGImage:editedImage.CGImage];
    self.selectedImageView.image = self.selectedImage;
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

- (IBAction)choosePhotoButtonClicked:(id)sender {
    [self setImageSourceToLibrary];
}

- (IBAction)takePhotoButtonClicked:(id)sender {
    [self attemptToSetImageSourceToCamera];
}



- (IBAction)postBarButtonClicked:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [Post postUserImage:self.selectedImage withCaption:self.captionTextField.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error composing Pos: %@", error.localizedDescription);
        }
        else {
            [self.delegate beginRefresh:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            [MBProgressHUD hideHUDForView:self.view animated:true];
        }
    }];
}

- (IBAction)cancelBarButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
