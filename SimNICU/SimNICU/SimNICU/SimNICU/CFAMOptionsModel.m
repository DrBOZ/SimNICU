//
//  CFAMOptionsModel.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 18/11/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBTableViewSectionData.h"
#import "CBTableViewRowData.h"
#import "CFAMOptionsModel.h"

@implementation CFAMOptionsModel

+ (NSArray *)getArrayForTableView
{
    NSMutableArray *tableData = [[NSMutableArray alloc] initWithCapacity:5];
    
    CBTableViewSectionData *sectionData;
    CBTableViewRowData *rowData;
    
    // General Information section
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = NSLocalizedString(@"General Information", nil);
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = NSLocalizedString(@"Terms and Abbreviations", nil);
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = NSLocalizedString(@"Indications", nil);
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
    // Setup section
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = NSLocalizedString(@"Setup", nil);
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = NSLocalizedString(@"Electrode placement", nil);
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = NSLocalizedString(@"Monitor setup", nil);
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
    // Interpretation section
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = NSLocalizedString(@"Interpretation", nil);
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = NSLocalizedString(@"Guide", nil);
    [sectionData.rowData addObject:rowData];
    
//    rowData = [[CBTableViewRowData alloc] init];
//    rowData.text = NSLocalizedString(@"Examples", nil);
//    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
#if SYNCRONISATION_PREVIEW_MODE
    
    // Syncronisation section
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
    
    // Localisation section
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
    
    // Growth chart section
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
