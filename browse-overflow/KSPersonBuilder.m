//
//  KSPersonBuilder.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 18.03.13.
//  Copyright (c) 2013 Mauricio Hanika. All rights reserved.
//

#import "KSPersonBuilder.h"
#import "KSPerson.h"

@implementation KSPersonBuilder

+ (KSPerson *) personFromDictionary:(NSDictionary *)dictionary {
  KSPerson *person = [[KSPerson alloc] init];
  
  person.name = dictionary[@"display_name"];
  person.avatarURL = [NSURL URLWithString:dictionary[@"profile_image"]];
  
  return person;
}

@end
