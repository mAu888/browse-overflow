//
//  KSPersonTests.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 03.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import "KSPersonTests.h"
#import "KSPerson.h"

@implementation KSPersonTests
{
  KSPerson *_person;
  
  NSString *_sharedName;
  NSString *_sharedAvatarLocation;
}

#pragma mark - Set up & tear down

- (void) setUp
{
  _sharedName = @"Graham Lee";
  _sharedAvatarLocation = @"http://example.com/avatar.png";
  
  _person = [[KSPerson alloc] initWithName:_sharedName avatarLocation:_sharedAvatarLocation];
}

- (void) tearDown
{
  _sharedName = nil;
  _sharedAvatarLocation = nil;
  
  _person = nil;
}

#pragma mark - The tests

- (void) testThatPersonHasTheRightName
{
  STAssertEqualObjects(_person.name, _sharedName, @"expecting a person to provide its name");
}

- (void) testThatPersonHasAnAvatarURL
{
  NSURL *url = _person.avatarURL;
  STAssertEqualObjects([url absoluteString], _sharedAvatarLocation, @"The person's avatar should be represented by a url");
}

@end
