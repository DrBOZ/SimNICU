//
//  SettingsModel.m
//  SimNICU
//
//  Created by Conrad Bosman on 16/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBTableViewSectionData.h"
#import "CBTableViewRowData.h"
#import "SettingsModel.h"

@implementation SettingsModel

+ (NSArray *)getArrayForTableView
{
    NSMutableArray *tableData = [[NSMutableArray alloc] initWithCapacity:5];
    
    CBTableViewSectionData *sectionData;
    CBTableViewRowData *rowData;
    
    /*
     // section 0
     sectionData = [[CBTableViewSectionData alloc] init];
     sectionData.titleForHeader = @"General";
     sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
     
     rowData = [[CBTableViewRowData alloc] init];
     rowData.text = @"Corrected Age";
     [sectionData.rowData addObject:rowData];
     
     rowData = [[CBTableViewRowData alloc] init];
     rowData.text = @"Fluid Requirements";
     [sectionData.rowData addObject:rowData];
     
     rowData = [[CBTableViewRowData alloc] init];
     rowData.text = @"Intubation";
     [sectionData.rowData addObject:rowData];
     
     rowData = [[CBTableViewRowData alloc] init];
     rowData.text = @"Phototherapy";
     [sectionData.rowData addObject:rowData];
     
     [tableData addObject:sectionData];
     */
    
    // section 0
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = @"Patient List";
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Bay Editor";
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
    // section 1
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = @"Daily Summary";
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Editor";
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"PDF";
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
#if SYNCRONISATION_PREVIEW_MODE
    
    // section 2
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = @"Syncronisation";
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Local";
    rowData.detailText = @"4/9/2013 08:00";
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"iCloud";
    rowData.detailText = @"Off";
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
#endif
    
#if LOCALISATION_PREVIEW_MODE
    
    // section 4
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = @"Localisation";
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Language";
    rowData.detailText = @"UK English";
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Decimal Separator";
    rowData.detailText = @"Point";
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
#endif
    
#if GROWTH_CHART_PREVIEW_MODE
    
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = @"Growth Chart";
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Data Set";
    rowData.detailText = @"UK 90";
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
#endif

    return tableData;
}

@end
