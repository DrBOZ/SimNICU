//
//  DailySummaryEditorSettingsModel.m
//  SimNICU
//
//  Created by Conrad Bosman on 16/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "DailySummaryEditorSettingsModel.h"
#import "CBTableViewSectionData.h"
#import "CBTableViewRowData.h"
#import "HandoverSection.h"

@implementation DailySummaryEditorSettingsModel

+ (NSMutableArray *)getArrayForTableView
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    NSMutableArray *tableData = [[NSMutableArray alloc] initWithCapacity:3];
    CBTableViewSectionData *sectionData;
    CBTableViewRowData *rowData;
    
    // section 0
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = NSLocalizedString(@"Text Entry", nil);
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = NSLocalizedString(@"Autocorrection", nil);
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = NSLocalizedString(@"Tool Bar", nil);
    [sectionData.rowData addObject:rowData];
    
    // Nice idea, but difficult to implement...
    /*
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Dynamic Text";
    [sectionData.rowData addObject:rowData];
     */
    
    [tableData addObject:sectionData];
    
    // section 1
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = NSLocalizedString(@"Custom Text", @"Text that the user can change");
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:20];
    
    HandoverSection *section;
    
    for (int i = 0; i < preferences.handoverSections.count - 1; i++)
    {
        section = preferences.handoverSections[i];
        
        rowData = [[CBTableViewRowData alloc] init];
        rowData.text = NSLocalizedString(section.sectionName, nil);
        [sectionData.rowData addObject:rowData];
    }
    
//    for (section in preferences.handoverSections)
//    {
//        rowData = [[CBTableViewRowData alloc] init];
//        rowData.text = NSLocalizedString(section.sectionName, nil);
//        [sectionData.rowData addObject:rowData];
//    }
    
    [tableData addObject:sectionData];
    
    return tableData;
}

@end
