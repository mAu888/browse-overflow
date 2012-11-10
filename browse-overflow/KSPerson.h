//
//  KSPerson.h
//  browse-overflow
//
//  Created by Mauricio Hanika on 03.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSPerson : NSObject

- (id) initWithName:(NSString *)name avatarLocation:(NSString *)avatarLocation;

@property (nonatomic) NSString *name;
@property (nonatomic) NSURL *avatarURL;

@end
