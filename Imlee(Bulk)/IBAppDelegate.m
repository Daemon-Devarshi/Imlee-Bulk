//
//  IBAppDelegate.m
//  Imlee(Bulk)
//
//  Created byDevarshi (kulshreshtha.devarshi@gmail.com) on 8/9/13.
//  Copyright (c) 2013 Devarshi Kulshreshtha. All rights reserved.
//

#import "IBAppDelegate.h"
@interface IBAppDelegate ()
@property (weak) IBOutlet NSTableView *selectedImagesPathsTable;

@end

@implementation IBAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    _imagePathsForConversion = [[NSMutableArray alloc] initWithCapacity:1];
    [self setupImageTypesArray];
}

- (void)setupImageTypesArray
{
    NSDictionary *pngTypeDict  = @{@"imageTypeName": @"png",@"imageTypeValue" :[NSNumber numberWithInt:NSPNGFileType]};
    NSDictionary *gifTypeDict  = @{@"imageTypeName": @"gif",@"imageTypeValue" :[NSNumber numberWithInt:NSGIFFileType]}; 
    NSDictionary *bmpTypeDict  = @{@"imageTypeName": @"bmp",@"imageTypeValue" :[NSNumber numberWithInt:NSBMPFileType]}; 
    NSDictionary *jpgTypeDict = @{@"imageTypeName": @"jpg",@"imageTypeValue" :[NSNumber numberWithInt:NSJPEGFileType]}; 
    NSDictionary *jpegTypeDict = @{@"imageTypeName": @"jpeg",@"imageTypeValue" :[NSNumber numberWithInt:NSJPEGFileType]}; 
    NSDictionary *tiffTypeDict = @{@"imageTypeName": @"tiff",@"imageTypeValue" :[NSNumber numberWithInt:NSTIFFFileType]};
    
    NSArray *selectedImagesPathsArrayArray = @[pngTypeDict,gifTypeDict,bmpTypeDict,jpgTypeDict,jpegTypeDict,tiffTypeDict];
    self.imageTypes = selectedImagesPathsArrayArray;
}

- (void)addImages
{
    // first open selection panel
    
    // initializing and configuring open panel
    NSOpenPanel *selectImagesForConversion = [NSOpenPanel openPanel];
    [selectImagesForConversion setCanChooseFiles:YES];
    [selectImagesForConversion setCanChooseDirectories:NO];
    [selectImagesForConversion setAllowsMultipleSelection:YES];
    [selectImagesForConversion setTitle:@"Select Images"];
    [selectImagesForConversion setPrompt:@"Choose"];
    [selectImagesForConversion setAllowedFileTypes:[self.imageTypes valueForKey:@"imageTypeName"]];
    
    [selectImagesForConversion beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        
        if (result == NSFileHandlingPanelOKButton)
        {
            // ok button selected
            // FIXME: though below commented line is correct, it is not working as expected
            // hence alternate approach is used
            // [self.imagePathsForConversion addObjectsFromArray:[selectImagesForConversion URLs]];
            
            // check for duplicate records
            
            // framing mutable array out of selected urls
            NSMutableArray *selectedPaths = [[NSMutableArray alloc] initWithArray:[selectImagesForConversion URLs]];
            
            // framing predicate
            NSPredicate *duplicateCheckPredicate = [NSPredicate predicateWithFormat:@"NOT SELF IN %@",[self.selectedImagesPathsArray arrangedObjects]];
            
            // filtered array after dupliate entries being removed
            NSArray *filteredArray = [selectedPaths filteredArrayUsingPredicate:duplicateCheckPredicate];
            
            // adding filtered urls
            [self.selectedImagesPathsArray addObjects:filteredArray];
            
            [self.selectedImagesPathsTable deselectAll:nil];
            
        }
    }];
}

- (void)convertImages
{
    NSString *imageNewExtension = [self.imageTypeSelectedDict objectForKey:@"imageTypeName"];
    NSUInteger imageRepresentationType = [[self.imageTypeSelectedDict objectForKey:@"imageTypeValue"] intValue];
    
    size_t count = [[self.selectedImagesPathsArray arrangedObjects] count];
    
    dispatch_apply(count, dispatch_get_global_queue(0, 0), ^(size_t i) {
        NSURL *imageURL = [[self.selectedImagesPathsArray arrangedObjects] objectAtIndex:i];
        
        NSImage *imageToBeConeverted = [[NSImage alloc] initWithContentsOfURL:imageURL];
        NSBitmapImageRep *bits = [[imageToBeConeverted representations] objectAtIndex:0];
        
        NSData *data = [bits representationUsingType:imageRepresentationType properties:nil];
        
        //changing name of file
        NSString *imagePathWithoutExtension = [[imageURL path] stringByDeletingPathExtension];
        NSString *imagePathWithNewExtension = [[NSString alloc] initWithFormat:@"%@.%@",imagePathWithoutExtension,imageNewExtension];
        
        [data writeToFile:imagePathWithNewExtension atomically:NO];
        
    });
    
    // refresh data structures
    [self.selectedImagesPathsArray removeObjects:[self.selectedImagesPathsArray arrangedObjects]];
    self.imageTypeSelectedDict = nil;
}
@end
