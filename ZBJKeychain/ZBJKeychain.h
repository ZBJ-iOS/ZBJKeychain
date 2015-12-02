//
//  ZBJKeychain.h
//  ZBJKeychain
//
//  Created by 王刚 on 15/12/2.
//  Copyright © 2015年 ZBJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBJKeychain : NSObject

- (id)initWithService:(NSString *) service_ withGroup:(NSString*)group_;

- (BOOL)setObject:(NSData *)data forKey:(NSString *)key;
- (BOOL)updateObject:(NSData *)data forKey:(NSString *)key;
- (BOOL)removeObjectForKey:(NSString*)key;
- (NSData*)objectForKey:(NSString*)key;


@end
