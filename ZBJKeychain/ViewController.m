//
//  ViewController.m
//  ZBJKeychain
//
//  Created by 王刚 on 15/12/2.
//  Copyright © 2015年 ZBJ. All rights reserved.
//

#import "ViewController.h"
#import "ZBJKeychain.h"

#define SERVICE_NAME @"ANY_NAME_FOR_YOU"
#define GROUP_NAME @"YOUR_APP_ID.com.apps.shared" //GROUP NAME should start with application identifier.


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic, strong) ZBJKeychain *keychain;

@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.keychain = [[ZBJKeychain alloc] initWithService:SERVICE_NAME withGroup:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)save:(id)sender {
    
    if (self.usernameTextField.text.length > 0 && self.emailTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        
        NSData *usernameData = [self.usernameTextField.text dataUsingEncoding:NSUTF8StringEncoding];
        NSData *emailValue = [self.emailTextField.text dataUsingEncoding:NSUTF8StringEncoding];
        NSData *passwrod = [self.passwordTextField.text dataUsingEncoding:NSUTF8StringEncoding];

        BOOL result = [self.keychain setObject:usernameData forKey:@"username"];
        result = [self.keychain setObject:emailValue forKey:@"email"];
        result = [self.keychain setObject:passwrod forKey:@"password"];
        
        if(result) {
            NSLog(@"Successfully added data");
        } else {
            NSLog(@"Failed to  add data");
        }
    }
}
- (IBAction)load:(id)sender {
    
    NSData * usernameData =[self.keychain objectForKey:@"username"];
    NSData *emailData = [self.keychain objectForKey:@"email"];
    NSData *passwordData = [self.keychain objectForKey:@"password"];
    
    if(usernameData == nil) {
        NSLog(@"Keychain data not found");
        self.usernameTextField.text = nil;
        self.emailTextField.text = nil;
        self.passwordTextField.text = nil;
    } else {
        NSString *username = [[NSString alloc] initWithData:usernameData encoding:NSUTF8StringEncoding];
        NSString *email = [[NSString alloc] initWithData:emailData encoding:NSUTF8StringEncoding];
        NSString *password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
        
        NSLog(@"username is =%@", username);
        NSLog(@"email is =%@", email);
        NSLog(@"password is =%@", password);
        
        
        self.usernameTextField.text = username;
        self.emailTextField.text = email;
        self.passwordTextField.text = password;
    }
    
}
- (IBAction)update:(id)sender {
    
    if (self.usernameTextField.text.length > 0 && self.emailTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        
        NSData *usernameData = [self.usernameTextField.text dataUsingEncoding:NSUTF8StringEncoding];
        NSData *emailValue = [self.emailTextField.text dataUsingEncoding:NSUTF8StringEncoding];
        NSData *passwrod = [self.passwordTextField.text dataUsingEncoding:NSUTF8StringEncoding];
        
        BOOL result = [self.keychain updateObject:usernameData forKey:@"username"];
        result = [self.keychain updateObject:emailValue forKey:@"email"];
        result = [self.keychain updateObject:passwrod forKey:@"password"];
        
        if(result) {
            NSLog(@"Successfully update data");
        } else {
            NSLog(@"Failed to  update data");
        }
    }
    
}

- (IBAction)remove:(id)sender {
    
    BOOL result = [self.keychain removeObjectForKey:@"username"];
    result = [self.keychain removeObjectForKey:@"email"];
    result = [self.keychain removeObjectForKey:@"password"];
    
    if(result) {
        NSLog(@"Successfully remove data");
        self.usernameTextField.text = nil;
        self.emailTextField.text = nil;
        self.passwordTextField.text = nil;

    } else {
        NSLog(@"Failed to remove data");
    }
    
}


@end
