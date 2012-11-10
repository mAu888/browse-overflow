//
//  KSAnswer.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 03.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import "KSAnswer.h"
#import "KSPerson.h"

@implementation KSAnswer

@synthesize text = _text;
@synthesize person = _person;
@synthesize score = _score;
@synthesize accepted = _accepted;

- (NSComparisonResult) compare:(KSAnswer *)otherAnswer
{
  if (_accepted && ! [otherAnswer isAccepted])
    return NSOrderedAscending;
  else if (! _accepted && [otherAnswer isAccepted])
    return NSOrderedDescending;
  
  if (_score > [otherAnswer score])
    return NSOrderedAscending;
  else if (_score < [otherAnswer score])
    return NSOrderedDescending;
  else
    return NSOrderedSame;
}

@end
