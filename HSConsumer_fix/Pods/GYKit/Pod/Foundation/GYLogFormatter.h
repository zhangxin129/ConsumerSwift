
#import "DDDispatchQueueLogFormatter.h"
#import "DDTTYLogger.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_OFF;
#endif
@interface GYLogFormatter : DDDispatchQueueLogFormatter <DDLogFormatter>

@end
