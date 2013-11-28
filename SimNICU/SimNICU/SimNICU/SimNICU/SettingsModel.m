//
//  SettingsModel.m
//  Neonatal Intensive Care
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
    
    // Patient List section
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = NSLocalizedString(@"Patient List", nil);
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = NSLocalizedString(@"Bay Editor", nil);
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
    // Daily Summary section
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = NSLocalizedString(@"Daily Summary", nil);
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = NSLocalizedString(@"Sections", nil);
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = NSLocalizedString(@"Editor", @"like word processor");
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = NSLocalizedString(@"PDF", @"a type of document");
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
    // Age Calculators section
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = NSLocalizedString(@"Age Calculators", nil);
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = NSLocalizedString(@"First day of life", nil);
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = NSLocalizedString(@"Correct to age", nil);
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
    /*
    // Fluid Requirements section
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = NSLocalizedString(@"Fluid requirements", nil);
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = NSLocalizedString(@"Daily increments", nil);
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = NSLocalizedString(@"Default electrolytes", nil);
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
    // Infusions section
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = NSLocalizedString(@"Infusions", nil);
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = NSLocalizedString(@"Drugs", nil);
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = NSLocalizedString(@"Infusion strength", nil);
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
    // Intubation section
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = NSLocalizedString(@"Intubation", nil);
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = NSLocalizedString(@"Drugs", nil);
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = NSLocalizedString(@"ETT type", nil);
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
     */
    
#if SYNCRONISATION_PREVIEW_MODE
    
    // Intubation section
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
