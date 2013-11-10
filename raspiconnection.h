//
//  raspiconnection.h
//  hackPrincton
//
//  Created by Robert mannuzza on 11/9/13.
//  Copyright (c) 2013 Robert mannuzza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface raspiconnection : NSObject <NSStreamDelegate>{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}
@property (strong,nonatomic) NSArray *values;
- (void)initNetworkCommunication;
- (void)sendback;
- (void) messageReceived:(NSString *)message;
- (void)sendMessage:(NSString *)msg;

@end
