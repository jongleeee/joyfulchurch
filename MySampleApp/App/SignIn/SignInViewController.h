//
//  SignInViewController.h
//  MySampleApp
//
//
// Copyright 2017 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-objc v0.15
//
//
#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *anchorView;

// Support code for Facebook provider UI.
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
// Support code for Twitter provider UI.
//@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
// Support code for Google provider UI.
@property (weak, nonatomic) IBOutlet UIButton *googleButton;
// Support code for Amazon provider UI.
//@property (weak, nonatomic) IBOutlet UIButton *amazonButton;
// Support code for custom sign-in provider UI.
@property (weak, nonatomic) IBOutlet UIButton *customProviderButton;
@property (weak, nonatomic) IBOutlet UIButton *customCreateAccountButton;
@property (weak, nonatomic) IBOutlet UIButton *customForgotPasswordButton;
@property (weak, nonatomic) IBOutlet UITextField *customUserIdField;
@property (weak, nonatomic) IBOutlet UITextField *customPasswordField;
@property (weak, nonatomic) IBOutlet UIView *leftHorizontalBar;
@property (weak, nonatomic) IBOutlet UIView *rightHorizontalBar;
@property (weak, nonatomic) IBOutlet UILabel *orSignInWithLabel;

@end
