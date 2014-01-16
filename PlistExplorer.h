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
- (NSArray*)keysOfUnarchiver:(NSKeyedUnarchiver*)unarchiver;

@end


@interface NSObject (PlistExplorer)
- (void)logYourself;
- (void) logYourselfLevel:(NSInteger)level recordingVisitedObjects:(NSMutableSet*)visitedObjects;
- (NSString*)gapForLevel:(NSInteger) level;
@end
