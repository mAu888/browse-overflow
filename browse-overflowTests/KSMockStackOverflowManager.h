//
//  KSMockStackOverflowManager.h
//  browse-overflow
//
//  Created by Mauricio Hanika on 21.03.13.
//  Copyright (c) 2013 Mauricio Hanika. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSStackOverflowCommunicator.h"

@interface KSMockStackOverflowManager : NSObject <KSStackOverflowCommunicatorDelegate>

- (NSUInteger) topicFailureErrorCode;
- (NSString *) topicSearchString;
- (NSUInteger) questionBodyFailureErrorCode;
- (NSString *) questionBodyString;
- (NSUInteger) answersFailureErrorCode;
- (NSString *) answersString;

@end
