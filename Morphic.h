//
//  Morphic.h
//  PlistExplorer
//
//  Created by Karsten Kusche on 13.01.10.
//  Copyright 2010 Briksoftware.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/// this class is like an object/class-blueprint of any kind
/// actual classes are created via PlistExplorer, they are then instantiated during decoding and initialized via #initWithCoder:
@interface Morphic : NSObject

@end
