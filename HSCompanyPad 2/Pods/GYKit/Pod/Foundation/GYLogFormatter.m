#import "GYLogFormatter.h"

@interface GYLogFormatter ()

@property (nonatomic, strong) NSDateFormatter* threadUnsafeDateFormatter; // for date/time formatting

@end

@implementation GYLogFormatter

- (id)init
{
    if (self = [super init]) {
        _threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
        [_threadUnsafeDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [_threadUnsafeDateFormatter setDateFormat:@"HH:mm:ss.SSS"];
    }

    return self;
}

- (NSString*)formatLogMessage:(DDLogMessage*)logMessage
{
    NSString* dateAndTime = [self.threadUnsafeDateFormatter stringFromDate:(logMessage->timestamp)];

    NSString* logLevel = nil;
    switch (logMessage->logFlag) {
    case LOG_FLAG_ERROR:
        logLevel = @"HS_E";
        break;
    case LOG_FLAG_WARN:
        logLevel = @"HS_W";
        break;
    case LOG_FLAG_INFO:
        logLevel = @"HS_I";
        break;
    case LOG_FLAG_DEBUG:
        logLevel = @"HS_D";
        break;
    case LOG_FLAG_VERBOSE:
        logLevel = @"HS_V";
        break;
    default:
        logLevel = @"?";
        break;
    }

    NSString* formattedLog = [NSString stringWithFormat:@"%@ |%@|    [%@ %@] #%d: %@",
                                       dateAndTime,
                                       logLevel,
                                       logMessage.fileName,
                                       logMessage.methodName,
                                       logMessage->lineNumber,
                                       logMessage->logMsg];

    return formattedLog;
}

@end
