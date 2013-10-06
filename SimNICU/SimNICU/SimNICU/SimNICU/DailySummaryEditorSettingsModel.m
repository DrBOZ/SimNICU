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
    sectionData.titleForHeader = @"Text Entry";
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Autocorrection";
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Tool Bar";
    [sectionData.rowData addObject:rowData];
    
    // Nice idea, but difficult to implement...
    /*
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Dynamic Text";
    [sectionData.rowData addObject:rowData];
     */
    
    [tableData addObject:sectionData];
    
    if ([preferences.trackball intValue] == 1)
    {
        // section 1
        sectionData = [[CBTableViewSectionData alloc] init];
        sectionData.titleForHeader = @"Custom Text";
        sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:20];
        
        Preferences *preferences = [Preferences sharedPreferences];
        HandoverSection *section;
        
        for (section in preferences.handoverSections)
        {
            rowData = [[CBTableViewRowData alloc] init];
            rowData.text = section.sectionName;
            [sectionData.rowData addObject:rowData];
        }
        
        [tableData addObject:sectionData];
    }
    
    return tableData;
}

@end
