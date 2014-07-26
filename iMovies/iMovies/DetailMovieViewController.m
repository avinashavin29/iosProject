//
//  DetailMovieViewController.m
//  iMovies
//
//  Created by Badri on 25/07/14.
//  Copyright (c) 2014 Badri. All rights reserved.
//

#import "DetailMovieViewController.h"
#import "PurchaseViewController.h"

@interface DetailMovieViewController ()
@property (nonatomic , retain) IBOutlet UITextView *starringLbl;
@property (nonatomic , retain) PurchaseViewController *purchaseViewController;

-(IBAction)purcheseTickets:(id)sender;
@end

@implementation DetailMovieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Movie Details";
    
    self.view.backgroundColor = [UIColor colorWithRed:114.0/255.0 green:193.0/255.0 blue:216.0/255.0 alpha:1.0];

    NSMutableString *details = [NSMutableString string];
    [details appendFormat:[NSString stringWithFormat:@"Movie Name: %@\n",_movies.movieName]];
    [details appendFormat:[NSString stringWithFormat:@"MovieDesc: %@\n",_movies.movieDesc]];
    [details appendFormat:[NSString stringWithFormat:@"Genre: %@\n",_movies.genre]];
    [details appendFormat:[NSString stringWithFormat:@"Cast: %@\n",_movies.cast]];
    [details appendFormat:[NSString stringWithFormat:@"ShowTimes: %@\n",_movies.showTimes]];
    [details appendFormat:[NSString stringWithFormat:@"Price : %@\n",_movies.price]];
    _starringLbl.text = details;
    
}
-(IBAction)purcheseTickets:(id)sender {
    
    _purchaseViewController = [[PurchaseViewController alloc]init];
    [_purchaseViewController setMovies:_movies];
    [self.navigationController pushViewController:_purchaseViewController animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
