//
//  IBAppDelegate.h
//  Imlee(Bulk)
//
//  Created byDevarshi (kulshreshtha.devarshi@gmail.com) on 8/9/13.
//  Copyright (c) 2013 Devarshi Kulshreshtha. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IBAppDelegate : NSObject <NSApplicationDelegate>
@property (readwrite, retain) NSDictionary *imageTypeSelectedDict;
@property (assign) IBOutlet NSWindow *window;
@property (readwrite, retain) NSArray *imageTypes;
@property (readwrite, retain) __block NSMutableArray *imagePathsForConversion;
@property (weak) IBOutlet NSArrayController *selectedImagesPathsArray;
@end
