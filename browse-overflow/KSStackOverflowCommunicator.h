//
//  KSStackOverflowCommunicator.h
//  browse-overflow
//
//  Created by Mauricio Hanika on 06.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KSTopic;

@interface KSStackOverflowCommunicator : NSObject

- (void) searchForQuestionsWithTag:(NSString *)tag;

@end
