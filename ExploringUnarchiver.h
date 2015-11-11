// Copyright © 2015 JABT Labs Inc.
// Copyright © 2010 Briksoftware.com.
//
// Based on PlistExplorer by Karsten Kusche: https://github.com/karstenBriksoft/PlistExplorer


#import <Cocoa/Cocoa.h>

@class PlistExplorer;

@interface ExploringUnarchiver : NSKeyedUnarchiver

@property (strong, nonatomic) NSMutableSet *unknownClassNames;
@property (readonly) NSArray* keys;

@end
