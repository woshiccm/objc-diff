#import "OCDifference.h"

@implementation OCDifference

- (instancetype)initWithType:(OCDifferenceType)type name:(NSString *)name path:(NSString *)path lineNumber:(NSUInteger)lineNumber columnNumber:(NSUInteger)columnNumber USR:(NSString *)USR modifications:(NSArray *)modifications {
    if (!(self = [super init]))
        return nil;

    _type = type;
    _name = [name copy];
    _path = [path copy];
    _lineNumber = lineNumber;
    _columnNumber = columnNumber;
    _USR = USR;
    _modifications = [modifications copy];

    return self;
}

+ (instancetype)differenceWithType:(OCDifferenceType)type name:(NSString *)name path:(NSString *)path lineNumber:(NSUInteger)lineNumber columnNumber:(NSUInteger)columnNumber {
    return [[self alloc] initWithType:type name:name path:path lineNumber:lineNumber columnNumber:columnNumber USR:nil modifications:nil];
}

+ (instancetype)differenceWithType:(OCDifferenceType)type name:(NSString *)name path:(NSString *)path lineNumber:(NSUInteger)lineNumber columnNumber:(NSUInteger)columnNumber USR:(NSString *)USR {
    return [[self alloc] initWithType:type name:name path:path lineNumber:lineNumber columnNumber:columnNumber USR:USR modifications:nil];
}

+ (instancetype)modificationDifferenceWithName:(NSString *)name path:(NSString *)path lineNumber:(NSUInteger)lineNumber columnNumber:(NSUInteger)columnNumber modifications:(NSArray *)modifications {
    return [[self alloc] initWithType:OCDifferenceTypeModification name:name path:path lineNumber:lineNumber columnNumber:columnNumber USR:nil modifications:modifications];
}

+ (instancetype)modificationDifferenceWithName:(NSString *)name path:(NSString *)path lineNumber:(NSUInteger)lineNumber columnNumber:(NSUInteger)columnNumber USR:(NSString *)USR modifications:(NSArray *)modifications {
    return [[self alloc] initWithType:OCDifferenceTypeModification name:name path:path lineNumber:lineNumber columnNumber:columnNumber USR:USR modifications:modifications];
}

- (NSDictionary *)toDictionary {
    NSString *type = @"";
    switch (self.type) {
        case OCDifferenceTypeAddition:
            type = @"additon";
            break;
        case OCDifferenceTypeRemoval:
            type = @"removal";
            break;
        case OCDifferenceTypeModification:
            type = @"modification";
            break;
    }
    return @{@"type" : type,
             @"name" : self.name ?: @"",
             @"path" : self.path ?: @"",
             @"line" : [NSNumber numberWithUnsignedInteger:self.lineNumber] ?: 0,
             @"column" : [NSNumber numberWithUnsignedInteger:self.columnNumber] ?: 0,
             @"usr" : self.USR ?: @"",
    };
}

- (NSString *)description {
    NSMutableString *result = [NSMutableString stringWithString:@""];
    switch (self.type) {
        case OCDifferenceTypeAddition:
            [result appendString:@"additon"];
            break;
        case OCDifferenceTypeRemoval:
            [result appendString:@"removal"];
            break;
        case OCDifferenceTypeModification:
            [result appendString:@"modification"];
            break;
    }
    [result appendString:@","];
    [result appendString:self.name ?: @""];
    [result appendString:@","];
    [result appendString:self.USR ?: @""];
    [result appendString:@","];
    if (self.path) {
        [result appendFormat:@"%@,%tu,%tu", self.path, self.lineNumber, self.columnNumber];
    }
    return result;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[OCDifference class]])
        return NO;

    OCDifference *other = object;

    return
    other.type == self.type &&
    (other.name == self.name || [other.name isEqual:self.name]) &&
    (other.path == self.path || [other.path isEqual:self.path]) &&
    other.lineNumber == self.lineNumber &&
    other.columnNumber == self.columnNumber &&
    (other.modifications == self.modifications || [other.modifications isEqual:self.modifications]);
}

- (NSUInteger)hash {
    return self.type ^ [self.name hash] ^ [self.path hash] ^ self.lineNumber ^ self.columnNumber ^ [self.modifications hash];
}

@end
