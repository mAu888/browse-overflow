//
//  KSNonNetworkedStackOverflowCommunicator.h
//  browse-overflow
//
//  Created by Mauricio Hanika on 21.03.13.
//  Copyright (c) 2013 Mauricio Hanika. All rights reserved.
//

#import "KSStackOverflowCommunicator.h"

@interface KSNonNetworkedStackOverflowCommunicator : KSStackOverflowCommunicator

@property (nonatomic, strong) NSData *receivedData;

@end
