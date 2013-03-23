//
//  KSInspectableStackOverflowCommunicator.h
//  browse-overflow
//
//  Created by Mauricio Hanika on 18.03.13.
//  Copyright (c) 2013 Mauricio Hanika. All rights reserved.
//

#import "KSStackOverflowCommunicator.h"

@interface KSInspectableStackOverflowCommunicator : KSStackOverflowCommunicator

- (NSURL *) URLToFetch;
- (NSURLConnection *) currentURLConnection;


@end
