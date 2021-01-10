//
//  PlistExplorer.h
//  PlistExplorer
//
//  Created by Karsten Kusche on 13.01.10.
//  Copyright 2010 Briksoftware.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PlistExplorer : NSObject

- (NSDictionary*)crackFile:(NSString*)aFile;
- (NSDictionary*)blobOfUnarchiver:(NSKeyedUnarchiver*)unarchiver;

@end
