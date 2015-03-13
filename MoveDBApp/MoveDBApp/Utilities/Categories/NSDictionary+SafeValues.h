//
//  KM_NSDictionary+SafeValues.h
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 26/06/2013.
//  Copyright (c) 2013 iKode Ltd. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDictionary (NSDictionary_SafeValues)

- (NSString*)safeStringForKey:(id)key;
- (NSNumber*)safeNumberForKey:(id)key;
- (NSArray*)safeArrayForKey:(id)key;
- (NSDictionary*)safeDictionaryForKey:(id)key;
- (UIImage*)safeImageForKey:(id)key;

@end
