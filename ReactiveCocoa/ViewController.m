//
//  ViewController.m
//  ReactiveCocoa
//
//  Created by xiushan.fan on 7/8/15.
//  Copyright (c) 2015年 frank   . All rights reserved.
//

#import "ViewController.h"
#import "RWDummySignInService.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *signInButton;
@property (strong, nonatomic) IBOutlet UILabel *signInFailureText;

- (IBAction)signInButtonTouched:(id)sender;


@property (nonatomic) BOOL passwordIsValid;
@property (nonatomic) BOOL usernameIsValid;
@property (strong, nonatomic) RWDummySignInService *signInService;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateUIState];
    
    self.signInService = [RWDummySignInService new];
    
    // handle text changes for both text fields
    [self.usernameTextField addTarget:self action:@selector(usernameTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(passwordTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
    
    // initially hide the failure message
    self.signInFailureText.hidden = YES;
}

- (BOOL)isValidUsername:(NSString *)username {
    return username.length > 3;
}

- (BOOL)isValidPassword:(NSString *)password {
    return password.length > 3;
}

- (IBAction)signInButtonTouched:(id)sender {
    // disable all UI controls
    self.signInButton.enabled = NO;
    self.signInFailureText.hidden = YES;
    
    // sign in
    [self.signInService signInWithUsername:self.usernameTextField.text
                                  password:self.passwordTextField.text
                                  complete:^(BOOL success) {
                                      self.signInButton.enabled = YES;
                                      self.signInFailureText.hidden = success;
                                      if (success) {
                                          [self performSegueWithIdentifier:@"signInSuccess" sender:self];
                                      }
                                  }];
}


// updates the enabled state and style of the text fields based on whether the current username
// and password combo is valid
- (void)updateUIState {
    self.usernameTextField.backgroundColor = self.usernameIsValid ? [UIColor clearColor] : [UIColor yellowColor];
    self.passwordTextField.backgroundColor = self.passwordIsValid ? [UIColor clearColor] : [UIColor yellowColor];
    self.signInButton.enabled = self.usernameIsValid && self.passwordIsValid;
}

- (void)usernameTextFieldChanged {
    self.usernameIsValid = [self isValidUsername:self.usernameTextField.text];
    [self updateUIState];
}

- (void)passwordTextFieldChanged {
    self.passwordIsValid = [self isValidPassword:self.passwordTextField.text];
    [self updateUIState];
}

@end
