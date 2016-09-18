//
//  main.m
//  nslogger-CLI
//
//  Created by Niklas Berglund on 17/09/16.
//

#import <Foundation/Foundation.h>
#import "LoggerClient.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        int option = 0;
        
        // default values
        NSString *domain = @"nslogger-CLI";
        int level = 0;
        NSString *message = @"";
        
        while ((option = getopt(argc, argv,"d:l:m:")) != -1) {
            switch (option) {
                case 'd' :
                    domain = [NSString stringWithUTF8String:optarg];
                    break;
                case 'l' :
                    level = atoi(optarg);
                    break;
                case 'm' :
                    message = [NSString stringWithUTF8String:optarg];
                    break;
                default:
                    //print_usage();
                    exit(EXIT_FAILURE);
            }
        }
        
        if ([message isEqualToString:@""]) {
            fprintf(stderr, "Empty message. You must specify a message with: -m \"Your message here\"\n");
            exit(EXIT_FAILURE);
        }
        
        Logger *logger = LoggerGetDefaultLogger();
        LoggerStart(logger);
        LogMessage(domain, level, @"%@", message);
        
        [[NSNotificationCenter defaultCenter] addObserverForName:NSLOGGER_MESSAGE_SENT object:nil queue:[[NSOperationQueue alloc] init] usingBlock:^(NSNotification * _Nonnull note) {
            CFRunLoopStop(CFRunLoopGetCurrent());
        }];
        
        [[NSRunLoop currentRunLoop] run];
    }
    
    return 0;
}
