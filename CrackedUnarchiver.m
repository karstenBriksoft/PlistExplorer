//
//  CrackedUnarchiver.m
//  PlistExplorer
//
//  Created by Karsten Kusche on 13.01.10.
//  Copyright 2010 Briksoftware.com. All rights reserved.
//

#import "CrackedUnarchiver.h"


@implementation CrackedUnarchiver


- (PlistExplorer *) cracker {
  return cracker;
}

- (void) setCracker: (PlistExplorer *) newValue {
  [cracker autorelease];
  cracker = [newValue retain];
}

@end
