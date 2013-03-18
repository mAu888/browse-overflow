//
//  KSStackOverflowCommunicatorTests.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 18.03.13.
//  Copyright (c) 2013 Mauricio Hanika. All rights reserved.
//

#import "KSStackOverflowCommunicatorTests.h"
#import "KSInspectableStackOverflowCommunicator.h"

@implementation KSStackOverflowCommunicatorTests

- (void) testSearchingForQuestionsOnTopicCallsTopicAPI {
  KSInspectableStackOverflowCommunicator *communicator = [[KSInspectableStackOverflowCommunicator alloc] init];
  
  [communicator searchForQuestionsWithTag:@"ios"];
  
  STAssertEqualObjects([[communicator URLToFetch] absoluteString], @"http://api.stackoverflow.com/1.1/search?tagged=ios&pagesize=20", @"Use the search api to find questions for a particular tag");
}

@end
