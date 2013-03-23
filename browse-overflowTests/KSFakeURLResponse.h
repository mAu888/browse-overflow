//
//  KSFakeURLResponse.h
//  browse-overflow
//
//  Created by Mauricio Hanika on 21.03.13.
//  Copyright (c) 2013 Mauricio Hanika. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSFakeURLResponse : NSObject

@property (nonatomic, assign) NSInteger statusCode;

- (id) initWithStatusCode:(NSInteger)statusCode;

@end
