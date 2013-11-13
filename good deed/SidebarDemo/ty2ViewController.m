//
//  ty2ViewController.m
//  Good Deed Marathon
//
//  Created by Tejas Hingu on 12/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "ty2ViewController.h"
#import "MainViewController.h"
@interface ty2ViewController ()

@end

@implementation ty2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.ty2ScrollView layoutIfNeeded];
    self.ty2ScrollView.contentSize = self.ty2View.bounds.size;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *mainurl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture",_fb_id];
    NSURL *url = [NSURL URLWithString:mainurl];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    


    _profImg.image = [[UIImage alloc] initWithData:data];
    _msgTextView.text = _msgTxt;
    _imgView.image = _UplImg;
    _lblName.text = _fb_name;
    _profImg.frame = CGRectMake(_profImg.frame.origin.x, _profImg.frame.origin.y,
                                 50, 50);

    NSLog(@"%@ %@ %@",_fb_name,_fb_id, mainurl);
    NSLog(@"%f wid - %f", _profImg.frame.size.height , _profImg.frame.size.width);
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end