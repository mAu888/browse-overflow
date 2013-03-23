//
//  KSNonNetworkedStackOverflowCommunicator.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 21.03.13.
//  Copyright (c) 2013 Mauricio Hanika. All rights reserved.
//

#import "KSNonNetworkedStackOverflowCommunicator.h"

@implementation KSNonNetworkedStackOverflowCommunicator

- (NSData *) receivedData
{
  return _receivedData;
}

- (void) setReceivedData:(NSData *)receivedData
{
  _receivedData = receivedData;
}

@end
