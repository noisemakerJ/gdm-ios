//
//  uploadViewController.m
//  SidebarDemo
//
//  Created by Nishant on 25/10/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//
#import "interViewController.h"
#import "Reachability.h"
#import "uploadViewController.h"
#import "MainViewController.h"
#import "SWRevealViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Parse/Parse.h>
#import "ty2ViewController.h"
#import "parViewController.h"
@interface uploadViewController ()

@end

@implementation uploadViewController
@synthesize scrollView;
@synthesize textVD2;
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_activityInd stopAnimating];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
    {
        fbrequest = [FBRequest requestForMe];
        
        [fbrequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            //        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            fbid = userData[@"id"];
            NSLog(@"fb? %@",fbid);
            NSLog(@"%@", [self validateUser:fbid]);
            
            if([[self validateUser:fbid] isEqualToString:@"1"]){
                
             
            }
            else {

                [self performSegueWithIdentifier:@"up2home" sender:self];
    
                
                
            }
            
        }];
    }
    else{
        [self performSegueWithIdentifier:@"up2home" sender:self];
        
        
        
    }

//    imageView.image = nil;
//    largeText.text = nil;
//    smallText.text = nil;
}
-(NSString *)validateUser:(NSString*)userid {
    
    
    NSString * post = [[NSString alloc] initWithFormat:@"id=%@",userid];
    NSData * postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
    NSString * postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.gooddeedmarathon.com/check-ios.php?id=%@",userid]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    return returnString;
}
-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{

        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            interViewController *interViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"interViewController"];
            // If you are using navigation controller, you can call
            [self.navigationController pushViewController:interViewController animated:NO];
            
        });
    };
    
    [reach startNotifier];

    
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
}
- (void) threadStartAnimating:(id)data {
    [_activityInd startAnimating];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark -
#pragma mark UITextViewDelegate methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqual:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    smallText.delegate = self;
    largeText.delegate = self;
    textvvd.selected = YES;

    UIColor *borderColor = [UIColor colorWithRed:105.0/255.0 green:190.0/255.0 blue:40.0/255.0 alpha:1.0];
    [imageView.layer setBorderColor:borderColor.CGColor];
    [imageView.layer setBorderWidth:3.0];
    smallText.hidden = YES;
    imageView.hidden = YES;

    

    

    
    //Navigation Logo
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 129, 41)];// Here you can set View width and height as per your requirement for displaying titleImageView position in navigationba
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navlogo.png"]];
    titleImageView.frame = CGRectMake(0, 0,129 , 41); // Here I am passing origin as (45,5) but can pass them as your requirement.
    [backView addSubview:titleImageView];
    //titleImageView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = backView;
    
    [textVD2 setBackgroundImage:[UIImage imageNamed:@"sub-text_green.png"] forState:UIControlStateSelected];
    
    msg = smallText.text;


    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    _sidebarButton.tintColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)upload {
    
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
    {
        fbrequest = [FBRequest requestForMe];
        
        [fbrequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            //        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            fbid = userData[@"id"];
            NSLog(@"fb? %@",fbid);
            NSLog(@"%@", [self validateUser:fbid]);
            
            
    
    
        NSLog(@"yoyoyo%@", fbid);
if ([[self validateUser:fbid] isEqualToString:@"1"] ) {
    
        
                NSLog(@"nslgggewwerwer");
            
                if ([checkMedia isEqual:@"image"] && (image)) {

        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        
        if(imageData){
            NSLog(@"Image Uploading...");
            
        }


        
        NSString *urlString = [NSString stringWithFormat:@"https://www.gooddeedmarathon.com/upload.php?msg=%@&prof_id=%@",smallText.text,fbid];

        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449"
        ;
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"ipodfile.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",returnString);
        if ([returnString isEqualToString:@"0"]){
            [_activityInd stopAnimating];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Error uploading image, Please try again."
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            alert = nil;
            
        }
        else if (returnString){
            // - code after image is uploaded
            ty2ViewController *ty2ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ty2ViewController"];
            
            ty2ViewController.Check = @"image";
            ty2ViewController.UplImg = image;
        ty2ViewController.msgTxt = smallText.text;
        ty2ViewController.fb_id = fbid;
        ty2ViewController.fb_name = fbname;
            ty2ViewController.idname = returnString;
        [self.navigationController pushViewController:ty2ViewController animated:YES];
       }
        else{
            [_activityInd stopAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Error uploading image, Please try again."
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            alert = nil;
        
        }

        
    }

    else if ([checkMedia isEqual:@"video"] && (moviePath)){
        NSLog(@"asas");
        
        NSData *data = [NSData dataWithContentsOfFile:moviePath];
        
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSString *urlString = [NSString stringWithFormat:@"https://www.gooddeedmarathon.com/upload.php?msg=%@&prof_id=%@",smallText.text,fbid];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        
        //video
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"yo.mp4\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: video/quicktime\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:data]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //set the body to the request
        [request setHTTPBody:body];
        
        // send the request
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        

        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",returnString);
        if ([returnString isEqualToString:@"0"]){
            [_activityInd stopAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Error uploading video, Please try again."
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            alert = nil;
            
            
        }
        else if (returnString){
            // - code after image is uploaded
            ty2ViewController *ty2ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ty2ViewController"];
            
            ty2ViewController.Check = @"image";
            ty2ViewController.UplImg = thumbnail;
            ty2ViewController.msgTxt = smallText.text;
            ty2ViewController.fb_id = fbid;
            ty2ViewController.fb_name = fbname;
            ty2ViewController.idname = returnString;
            [self.navigationController pushViewController:ty2ViewController animated:YES];
        }
        else{
        [_activityInd stopAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Error uploading video. Please try again."
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            alert = nil;
        }

    }
    
    else if (largeText.text.length > 0){

        NSString * post = [[NSString alloc] initWithFormat:@"msg=%@&prof_id=%@",largeText.text,fbid];
        NSLog(@" msg - %@ fb - %@",largeText.text,fbid);
        NSData * postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
        NSString * postLength = [NSString stringWithFormat:@"%d",[postData length]];
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.gooddeedmarathon.com/upload.php"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",returnString);
        if([returnString isEqualToString:@"0"]){
            [_activityInd stopAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Error uploading text. Please try again."
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            alert = nil;
            smallText.text = Nil;
        }
        else if (returnString){
            ty2ViewController *ty2ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ty2ViewController"];
            ty2ViewController.UplImg = thumbnail;
            ty2ViewController.largeValue = largeText.text;
            ty2ViewController.Check = @"text";
            ty2ViewController.fb_id = fbid;
            ty2ViewController.fb_name = fbname;
            ty2ViewController.idname = returnString;

            [self.navigationController pushViewController:ty2ViewController animated:YES];
        }
        else{
            [_activityInd stopAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Error uploading text. Please try again."
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            alert = nil;
        
        }
    
    }
    else {
        [_activityInd stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please upload your good deed before submitting."
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    
    }
    
}
                else if ([[self validateUser:fbid] isEqualToString:@"0"])
                {
                    NSLog(@"elsee ");
                    [_activityInd stopAnimating];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@"Please Register to continue."
                                                                   delegate:self
                                                         cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    alert = nil;
            
                }
            

            
            
            //fb check
            
            
        }];
    }
    else{
    
        [_activityInd stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please login to continue."
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
    
    

    
}






- (IBAction)textVD {
    imagevvd.selected = NO;
    videovvd.selected = NO;
    galleryvvd.selected = NO;
    textvvd.selected = YES;
    largeText.text = nil;
    imageView.hidden = YES;
    smallText.hidden = YES;
    largeText.hidden = NO;
    checkMedia = @"text";
    
//     [btn3 setImage:[UIImage imageNamed:@"first.png"] forState:UIControlStateNormal]
    
}

- (IBAction)imageVD {
    check2 = nil;
    imagevvd.selected = YES;
    videovvd.selected = NO;
    galleryvvd.selected = NO;
    textvvd.selected = NO;
    imageView.hidden = NO;
    smallText.hidden = NO;
    smallText.text = nil;
    largeText.hidden = YES;
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [picker setShowsCameraControls:YES];
    [picker setAllowsEditing:YES];
    [self presentViewController:picker animated:YES completion:NULL];
    picker = nil;
    
}


-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

-(IBAction)backgroundTouched:(id)sender
{
    [sender resignFirstResponder];
}
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (UTTypeEqual(kUTTypeMovie,
                    (__bridge CFStringRef)[info objectForKey:UIImagePickerControllerMediaType]))
    {
        checkMedia = @"video";
        NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
        
        [self dismissViewControllerAnimated:NO completion:nil];
        // Handle a movie capture
        if (CFStringCompare (( CFStringRef) mediaType, kUTTypeMovie, 0)
            == kCFCompareEqualTo) {
            
            moviePath = [[info objectForKey:
                          UIImagePickerControllerMediaURL] path];
            
            
        }
        NSURL *videoURL = [NSURL fileURLWithPath:moviePath];
        
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
        
        thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        [imageView setImage:thumbnail];
        NSLog(@"%@",thumbnail);
        
        //Player autoplays audio on init
        [player stop];
        player = nil;
        
        
    }
    else{
        checkMedia = @"image";
        if([check2 isEqualToString:@"gallery"]){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self dismissViewControllerAnimated:YES completion:NULL];
        [imageView setImage:image];
        }
        else{
            image = [info objectForKey:UIImagePickerControllerEditedImage];
            [self dismissViewControllerAnimated:YES completion:NULL];
            [imageView setImage:image];
        }
    }
    
    
}

- (IBAction)videoVD {
    imagevvd.selected = NO;
    videovvd.selected = YES;
    galleryvvd.selected = NO;
    textvvd.selected = NO;
    imageView.hidden = NO;
    smallText.hidden = NO;
    smallText.text = nil;
    largeText.hidden = YES;
    
    [self startCameraControllerFromViewController: self
                                    usingDelegate: self];
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    [cameraUI setVideoQuality:UIImagePickerControllerQualityTypeMedium];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose movie capture
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    cameraUI.videoMaximumDuration = 15.0f;
    
    [controller presentViewController: cameraUI animated: YES completion:nil];
    return YES;
}

- (IBAction)galleryVD {
    check2 = @"gallery";
    imagevvd.selected = NO;
    videovvd.selected = NO;
    galleryvvd.selected = YES;
    textvvd.selected = NO;
    smallText.hidden = NO;
    largeText.hidden = YES;
    imageView.hidden = NO;
    smallText.text = Nil;
    picker2 = [[UIImagePickerController alloc] init];
    picker2.delegate = self;
    [picker2 setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    picker2.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage,nil];
        [picker setAllowsEditing:YES];
    [self presentViewController:picker2 animated:YES completion:NULL];
    picker2 = nil;
    
    
}


@end
