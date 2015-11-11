// Copyright © 2015 JABT Labs Inc.
// Copyright © 2010 Briksoftware.com.
//
// Based on PlistExplorer by Karsten Kusche: https://github.com/karstenBriksoft/PlistExplorer

#import <Cocoa/Cocoa.h>


@interface Morphic : NSObject

@property (strong, nonatomic) NSMutableDictionary* objects;

- (void)printJSON;
- (void)collectKeysByClass:(NSMutableDictionary*)keysByClass;

@end
