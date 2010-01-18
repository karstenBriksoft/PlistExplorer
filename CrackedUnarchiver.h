//
//  CrackedUnarchiver.h
//  PlistExplorer
//
//  Created by Karsten Kusche on 13.01.10.
//  Copyright 2010 Briksoftware.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PlistExplorer;

@interface CrackedUnarchiver : NSKeyedUnarchiver {
	PlistExplorer* cracker;
}

- (PlistExplorer *) cracker;
- (void) setCracker: (PlistExplorer *) newValue;
@end
