// Copyright © 2015 JABT Labs Inc.
// Copyright © 2010 Briksoftware.com.
//
// Based on PlistExplorer by Karsten Kusche: https://github.com/karstenBriksoft/PlistExplorer

#import "Morphic.h"
#import "ExploringUnarchiver.h"

@implementation NSObject (JSON)

- (void)printJSON {
    printf("\"%s\"", self.class.description.UTF8String);
}

@end

@implementation NSArray (JSON)

- (void)printJSON {
    printf("[");
    for (NSInteger i = 0; i < self.count; i += 1) {
        NSObject* object = self[i];
        [object printJSON];
        if (i < self.count - 1)
            printf(", ");
    }
    printf("]");
}

@end

@implementation NSDictionary (JSON)

- (void)printJSON {
    NSArray* keys = [self.allKeys sortedArrayUsingSelector:@selector(compare:)];
    if (keys.count == 1 && [keys.firstObject isEqual:@"array_do"]) {
        NSArray* array = self[@"array_do"];
        [array printJSON];
        return;
    }

    printf("{");
    for (NSInteger i = 0; i < keys.count; i += 1) {
        NSString* key = keys[i];
        [key printJSON];
        printf(": ");

        NSObject* object = self[key];
        [object printJSON];
        if (i < keys.count - 1)
            printf(", ");
    }
    printf("}");
}

@end

@implementation NSData (JSON)

- (void)printJSON {
    printf("\"data of size %i\"", (int)self.length);
}

@end

@implementation NSString (JSON)

- (void)printJSON {
    NSMutableString *s = [NSMutableString stringWithString:self];
    [s replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    printf("\"%s\"", s.UTF8String);
}

@end


@implementation Morphic

- (id)initWithCoder:(ExploringUnarchiver*)unarchiver {
	self = [self init];
    self.objects = [NSMutableDictionary dictionary];

	NSArray* keys = unarchiver.keys;
    for (NSString* key in keys) {
        self.objects[key] = [unarchiver decodeObjectForKey:key];
    }

	return self;
}

- (void)printJSON {
    NSMutableDictionary* dict = [self.objects mutableCopy];
    dict[@"_class"] = [self.class description];
    [dict printJSON];
}

- (void)collectKeysByClass:(NSMutableDictionary*)keysByClass {
    NSString* className = [self.class description];
    NSMutableSet* keys = keysByClass[className];
    if (keys) {
        [keys addObjectsFromArray:self.objects.allKeys];
    } else {
        keys = [NSMutableSet setWithArray:self.objects.allKeys];
        keysByClass[className] = keys;
    }

    for (NSString* key in self.objects) {
        NSObject* object = self.objects[key];
        [self collectKeysOfObject:object byClass:keysByClass];
    }
}

- (void)collectKeysOfObject:(NSObject*)object byClass:(NSMutableDictionary *)keysByClass {
    if ([object isKindOfClass:[Morphic class]]) {
        Morphic* morphic = (Morphic*)object;
        [morphic collectKeysByClass:keysByClass];
    } else if ([object isKindOfClass:[NSArray class]]) {
        NSArray* array = (NSArray*)object;
        for (NSObject* object in array) {
            [self collectKeysOfObject:object byClass:keysByClass];
        }
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dict = (NSDictionary*)object;
        for (NSObject* key in dict) {
            NSObject* object = dict[key];
            [self collectKeysOfObject:object byClass:keysByClass];
        }
    }
}

@end
