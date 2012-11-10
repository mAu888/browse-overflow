//
//  KSQuestion.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 03.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import "KSQuestion.h"
#import "KSAnswer.h"

@implementation KSQuestion
{
  NSMutableSet *_answersSet;
}

- (id) init
{
  if ((self = [super init]) == nil)
    return nil;
  
  _answersSet = [[NSMutableSet alloc] init];
  
  return self;
}

- (void) addAnswer:(KSAnswer *)answer
{
  [_answersSet addObject:answer];
}

- (NSArray *) answers
{
  return [[_answersSet allObjects] sortedArrayUsingSelector:@selector(compare:)];
}

@synthesize title = _title;
@synthesize date = _date;
@synthesize score = _score;

@end
