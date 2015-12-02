//
//  ZBJKeychain.m
//  ZBJKeychain
//
//  Created by 王刚 on 15/12/2.
//  Copyright © 2015年 ZBJ. All rights reserved.
//

#import "ZBJKeychain.h"

@interface ZBJKeychain()

@property (nonatomic, strong) NSString *service;
@property (nonatomic, strong) NSString *group;


@end

@implementation ZBJKeychain


- (id) initWithService:(NSString *) service withGroup:(NSString*)group
{
    self = [super init];
    if(self)
    {
        _service = [NSString stringWithString:service];
        
        if(group) {
            _group = [NSString stringWithString:group];
        }
    }
    
    return  self;
}
- (NSMutableDictionary* )prepareDict:(NSString *) key
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    /**
     kSecClass -> type of item which is kSecClassGenericPassword
     kSecAttrGeneric -> Generic attribute key.
     kSecAttrAccount -> Account attribute key
     kSecAttrService -> Name of the service.
     kSecAttrAccessible -> Specifies when data is accessible.
     kSecAttrAccessGroup : Keychain access group name. This should be same to share the data across apps.
     */
    
    [dict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    NSData *encodedKey = [key dataUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:encodedKey forKey:(__bridge id)kSecAttrGeneric];
    [dict setObject:encodedKey forKey:(__bridge id)kSecAttrAccount];
    [dict setObject:self.service forKey:(__bridge id)kSecAttrService];
    [dict setObject:(__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    
    //This is for sharing data across apps
    if(self.group != nil)
        [dict setObject:self.group forKey:(__bridge id)kSecAttrAccessGroup];
    
    return  dict;
    
}

- (BOOL)setObject:(NSData *)data forKey:(NSString *)key
{
    NSMutableDictionary * dict =[self prepareDict:key];
    [dict setObject:data forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dict, NULL);
    if(errSecSuccess != status) {
        NSLog(@"Unable add item with key =%@ error:%@", key, @(status));
    }
    return (errSecSuccess == status);
}

- (NSData *)objectForKey:(NSString *)key
{
    NSMutableDictionary *dict = [self prepareDict:key];
    [dict setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [dict setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)dict,&result);
    
    if( status != errSecSuccess) {
        NSLog(@"Unable to fetch item for key %@ with error:%@", key, @(status));
        return nil;
    }
    
    return (__bridge NSData *)result;
}

- (BOOL)updateObject:(NSData *)data forKey:(NSString *)key
{
    NSMutableDictionary * dictKey =[self prepareDict:key];
    
    NSMutableDictionary * dictUpdate =[[NSMutableDictionary alloc] init];
    [dictUpdate setObject:data forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)dictKey, (__bridge CFDictionaryRef)dictUpdate);
    if(errSecSuccess != status) {
        NSLog(@"Unable add update with key =%@ error:%@", key, @(status));
    }
    return (errSecSuccess == status);
    
    return YES;
}

- (BOOL)removeObjectForKey:(NSString *)key
{
    NSMutableDictionary *dict = [self prepareDict:key];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)dict);
    if( status != errSecSuccess) {
        NSLog(@"Unable to remove item for key %@ with error:%@", key, @(status));
        return NO;
    }
    return  YES;
}


@end
