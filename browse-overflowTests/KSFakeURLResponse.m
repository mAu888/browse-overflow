//
//  KSFakeURLResponse.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 21.03.13.
//  Copyright (c) 2013 Mauricio Hanika. All rights reserved.
//

#import "KSFakeURLResponse.h"

@implementation KSFakeURLResponse

- (id) initWithStatusCode:(NSInteger)statusCode
{
  if ((self = [super init]) == nil)
    return nil;
  
  _statusCode = statusCode;
  
  return self;
}

@end
