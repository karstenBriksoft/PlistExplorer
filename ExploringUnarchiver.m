// Copyright © 2015 JABT Labs Inc.
// Copyright © 2010 Briksoftware.com.
//
// Based on PlistExplorer by Karsten Kusche: https://github.com/karstenBriksoft/PlistExplorer


#import "ExploringUnarchiver.h"
#import "Morphic.h"

#import "objc/objc-class.h"

@interface ExploringUnarchiver (PlistExplorer)

- (id)_blobForCurrentObject;

@end


@implementation ExploringUnarchiver

- (instancetype)initForReadingWithData:(NSData *)data {
    self = [super initForReadingWithData:data];
    self.unknownClassNames = [NSMutableSet set];
    return self;
}

- (NSArray*)keys {
    NSDictionary* blob = [self _blobForCurrentObject];
    return [blob allKeys];
}

- (id)decodeObjectForKey:(NSString *)key {
    @try {
        return [super decodeObjectForKey:key];
    } @catch (NSException* exception) {
        if ([[exception name] isEqual:NSInvalidUnarchiveOperationException]) {
            // too bad the exception doesn't have the class's name in its info dictionary.
            // actually this could probably be swizzled into appkit..
            NSString* className = [self getClassNameFromException: exception];
            [self addMorphicNamed: className];
            [self.unknownClassNames addObject:className];
            return [self decodeObjectForKey:key];
        } else  {
            NSLog(@"unhandled exception: %@",exception);
            exit(1);
        }
    }
}

- (NSString*)getClassNameFromException:(NSException *)exception {
    NSString* reason = [exception reason];
    NSScanner* scanner = [NSScanner scannerWithString:reason];
    NSString* prefix;
    [scanner scanString:@"*** -[ExploringUnarchiver decodeObjectForKey:]: cannot decode object of class (" intoString:&prefix];
    NSString* name;
    [scanner scanUpToString:@")" intoString:&name];
    return name;
}


- (void)addMorphicNamed: (NSString *)className {
    Class newClass = objc_allocateClassPair([Morphic class], [className UTF8String],0);
    objc_registerClassPair(newClass);
}

@end
