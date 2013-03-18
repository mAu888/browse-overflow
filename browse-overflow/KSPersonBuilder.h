//
//  KSPersonBuilder.h
//  browse-overflow
//
//  Created by Mauricio Hanika on 18.03.13.
//  Copyright (c) 2013 Mauricio Hanika. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KSPerson;

@interface KSPersonBuilder : NSObject

+ (KSPerson *) personFromDictionary:(NSDictionary *)dictionary;

@end
