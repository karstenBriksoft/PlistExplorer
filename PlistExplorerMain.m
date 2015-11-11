// Copyright © 2015 JABT Labs Inc.
// Copyright © 2010 Briksoftware.com.
//
// Based on PlistExplorer by Karsten Kusche: https://github.com/karstenBriksoft/PlistExplorer

#import <Cocoa/Cocoa.h>
#import <sysexits.h>

#import "ExploringUnarchiver.h"
#import "Morphic.h"

int main(int argc, char* argv[]) {
	@autoreleasepool {
		NSString* path = nil;
		if (argc > 1) {
			path = [[NSString alloc] initWithUTF8String:argv[1]];
		} else {
			printf("usage: %s <filename>\n", argv[0]);
			return EX_USAGE;
		}

        NSData* data = [NSData dataWithContentsOfFile:path];
        ExploringUnarchiver* unarchiver = [[ExploringUnarchiver alloc] initForReadingWithData:data];
        
        Morphic* rootObject = [unarchiver decodeObjectForKey:@"root"];

        // Do this if you want a full dump of the archive in JSON format
        //[rootObject printJSON];

        // Do this if you only want the non-foundation class names and their keys in YAML format
        NSMutableDictionary* keysByClass = [NSMutableDictionary dictionary];
        [rootObject collectKeysByClass:keysByClass];
        for (NSString* className in keysByClass) {
            printf("%s:\n", className.UTF8String);

            NSSet* keys = keysByClass[className];
            for (NSString* key in keys) {
                printf("    %s\n", key.UTF8String);
            }
        }
	}
	return EX_OK;
}
