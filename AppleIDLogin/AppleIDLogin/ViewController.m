//
//  ViewController.m
//  AppleIDLogin
//
//  Created by ejiang on 2020/3/25.
//  Copyright © 2020 ejiang. All rights reserved.
//

#import "ViewController.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import <AuthenticationServices/ASAuthorizationAppleIDProvider.h>
#import <AuthenticationServices/ASAuthorizationPasswordProvider.h>



@interface ViewController ()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton* loginBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 130, 50)];
    loginBtn.backgroundColor=[UIColor blueColor];
    [loginBtn setTitle:@"AppleID Login" forState:(UIControlStateNormal)];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    loginBtn.center=self.view.center;
    [loginBtn addTarget:self action:@selector(appleIdLogin) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:loginBtn];
    
}


-(void)appleIdLogin
{
    if (@available(iOS 13.0,*))
    {
        ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
        ASAuthorizationAppleIDRequest *authAppleIDRequest = [provider createRequest];
        authAppleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[authAppleIDRequest]];
        authorizationController.delegate = self;
        authorizationController.presentationContextProvider = self;
        [authorizationController performRequests];
    }
}

#pragma mark ASAuthorizationControllerDelegate
//成功
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization NS_SWIFT_NAME(authorizationController(controller:didCompleteWithAuthorization:))
{
    if([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]])
    {
        ASAuthorizationAppleIDCredential *authorizeCredential = authorization.credential;
        NSString * nickname = authorizeCredential.fullName.givenName;
        NSString * userID = authorizeCredential.user;
        NSString * email = authorizeCredential.email;
        NSData * authorizationCode = authorizeCredential.authorizationCode;
        NSData * identityToken =authorizeCredential.identityToken;
        
        NSLog(@"\n%@\n", nickname);
        NSLog(@"%@\n", userID);
        NSLog(@"%@\n", email);
        NSLog(@"%@\n", authorizationCode);
        NSLog(@"%@\n", [[NSString alloc] initWithData:identityToken encoding:NSUTF8StringEncoding] );
 
    }
}

//失败
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  NS_SWIFT_NAME(authorizationController(controller:didCompleteWithError:))
{
    NSLog(@"\n%@\n%@\n",error.domain,error.userInfo);
}

#pragma mark ASAuthorizationControllerPresentationContextProviding
-(ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller
{
    return self.view.window;
}

@end
