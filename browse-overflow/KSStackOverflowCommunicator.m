//
//  KSStackOverflowCommunicator.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 06.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import "KSStackOverflowCommunicator.h"

@implementation KSStackOverflowCommunicator

- (void) searchForQuestionsWithTag:(NSString *)tag
{
  _fetchingURL = [NSURL URLWithString:@"http://api.stackoverflow.com/1.1/search?tagged=ios&pagesize=20"];
}

- (void) fetchBodyForQuestion:(KSQuestion *)question
{
}

@end
