//
//  KSAnswer.h
//  browse-overflow
//
//  Created by Mauricio Hanika on 03.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KSPerson;

@interface KSAnswer : NSObject

- (NSComparisonResult) compare:(KSAnswer *)otherAnswer;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) KSPerson *person;
@property (nonatomic, assign) int score;
@property (nonatomic, assign, getter = isAccepted) BOOL accepted;

@end
