//
//  KSStackOverflowCommunicator.h
//  browse-overflow
//
//  Created by Mauricio Hanika on 06.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KSTopic;
@class KSQuestion;

@interface KSStackOverflowCommunicator : NSObject {
  @protected
  NSURL *_fetchingURL;
}


- (void) searchForQuestionsWithTag:(NSString *)tag;
- (void) fetchBodyForQuestion:(KSQuestion *)question;

@end
