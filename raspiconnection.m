//
//  raspiconnection.m
//  hackPrincton
//
//  Created by Robert mannuzza on 11/9/13.
//  Copyright (c) 2013 Robert mannuzza. All rights reserved.
//

#import "raspiconnection.h"

@implementation raspiconnection
@synthesize values;


-(id)init {
    if ( self = [super init] ) {
        [self initNetworkCommunication];
    }
    return self;
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
	switch (streamEvent) {
            
		case NSStreamEventOpenCompleted:
			NSLog(@"Stream opened");
			break;
            
		case NSStreamEventHasBytesAvailable:
            NSLog(@"bytesAvailable");
            if (theStream == inputStream) {
                
                uint8_t buffer[1024];
                int len;
                
                while ([inputStream hasBytesAvailable]) {
                    
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        [self messageReceived:output];
                        NSLog(@"Json String: %@",output);
                        if (nil != output) {
                            NSLog(@"server said: %@", output);
                            
                            
                        }
                    }
                }
            }
            
            break;

            
		case NSStreamEventErrorOccurred:
                NSLog(@"Can not connect to the host!");
			break;
            
		case NSStreamEventEndEncountered:
                NSLog(@"event end encountered");
			break;
            
		default:
                NSLog(@"Unknown event");
            break;
	}
    
}

- (void)initNetworkCommunication {
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"10.25.95.69", 6673, &readStream, &writeStream);
    inputStream = (NSInputStream *)CFBridgingRelease(readStream);
    outputStream = (NSOutputStream *)CFBridgingRelease(writeStream);

    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
    
}

- (void)sendMessage:(NSString *)msg {
    //[self initNetworkCommunication];
    NSString *response  = [NSString stringWithFormat:@"%@%@",msg,@"\n"];
    NSLog(@"response: %@",response);
	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
	[outputStream write:[data bytes] maxLength:[data length]];
    
}
- (void) messageReceived:(NSString *)message {
    NSLog(@"message reveived");
     NSString *strippedNumber = [message stringByReplacingOccurrencesOfString:@"[" withString:@""];
     
     NSString * strippedNumber2 = [strippedNumber stringByReplacingOccurrencesOfString:@"]" withString:@""];
     
     NSString * strippedNumber3 = [strippedNumber2 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
     
     NSString * strippedNumber4 = [strippedNumber3 stringByReplacingOccurrencesOfString:@" " withString:@""];
     
     NSArray *array = [strippedNumber4 componentsSeparatedByString:@","];
     NSLog(@"Output Array: %@",array);
     values=[NSArray arrayWithArray:array];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getArray" object:[NSArray arrayWithArray:array]];


}

-(void)sendback{
    NSString *response  = @"exit\n";
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    
    NSString *res = [NSString stringWithUTF8String:[data bytes]];
    NSLog(@"Data: %@",res);
}


@end