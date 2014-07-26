//
//  PurchaseViewController.m
//  iMovies
//
//  Created by Badri on 25/07/14.
//  Copyright (c) 2014 Badri. All rights reserved.
//

#import "PurchaseViewController.h"

@interface PurchaseViewController ()
@property (nonatomic , retain) IBOutlet UITextField *nameTxt;
@property (nonatomic , retain) IBOutlet UITextField *noofTickets;
@property (nonatomic , retain) IBOutlet UITextField *toatlsAmt;
@property (nonatomic , retain) IBOutlet UITextField *emailAmt;


-(IBAction)purcheseTickets:(id)sender;

@end

@implementation PurchaseViewController

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
    self.title = @"Purchase";
    
    self.view.backgroundColor = [UIColor colorWithRed:114.0/255.0 green:193.0/255.0 blue:216.0/255.0 alpha:1.0];
}
-(IBAction)purcheseTickets:(id)sender {
    if(_nameTxt.text == nil || [_nameTxt.text isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Please enter valid %@",_nameTxt.placeholder] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if(_noofTickets.text == nil || [_noofTickets.text isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Please enter valid %@",_noofTickets.placeholder] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if(_noofTickets.text == nil || [_noofTickets.text isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Please enter valid %@",_noofTickets.placeholder] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if(_emailAmt.text == nil || [_emailAmt.text isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Please enter valid %@",_emailAmt.placeholder] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"iMovies" message:@"You have successfully purchased" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        _nameTxt.text = @"";
        _noofTickets.text = @"";
        _toatlsAmt.text = @"";
        _emailAmt.text = @"";
    }

    
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == _noofTickets) {
        
        int totlAmt  = [[_noofTickets text] integerValue]* [[_movies valueForKey:@"price"] integerValue];
        _toatlsAmt.text = [NSString stringWithFormat:@"%d $",totlAmt];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
