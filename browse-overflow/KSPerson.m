//
//  KSPerson.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 03.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import "KSPerson.h"

@implementation KSPerson

@synthesize name = _name;
@synthesize avatarURL = _avatarURL;

- (id)initWithName:(NSString *)name avatarLocation:(NSString *)avatarLocation
{
  if ((self = [super init]) == nil)
    return nil;
  
  _name = [name copy];
  _avatarURL = [[NSURL alloc] initWithString:avatarLocation];
  
  return self;
}

@end
