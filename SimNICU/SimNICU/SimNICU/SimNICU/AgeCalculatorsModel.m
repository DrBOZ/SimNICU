//
//  AgeCalculatorsModel.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 29/11/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBTableViewSectionData.h"
#import "AgeCalculatorsModel.h"
#import "CBTableViewRowData.h"

@implementation AgeCalculatorsModel

+ (NSArray *)getArrayForTableView
{
    NSMutableArray *tableData = [[NSMutableArray alloc] initWithCapacity:5];
    
    CBTableViewSectionData *sectionData;
    CBTableViewRowData *rowData;
    
    // Chronological Age section
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = NSLocalizedString(@"Chronological Age", nil);
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = NSLocalizedString(@"Exact age", nil);
    rowData.detailText = NSLocalizedString(@"days, hours, minutes", nil);
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = NSLocalizedString(@"Including postmenstrual age", nil);
    rowData.detailText = NSLocalizedString(@"Until 40 weeks gestation", nil);
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
    // Corrected Age section
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = NSLocalizedString(@"Corrected Age", nil);
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = NSLocalizedString(@"Corrected age", nil);
    rowData.detailText = NSLocalizedString(@"After 40 weeks gestation", nil);
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
    /*
    // Gestational Age section
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = NSLocalizedString(@"Gestational Age", nil);
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = NSLocalizedString(@"From LMP", nil);
    // rowData.detailText = NSLocalizedString(@"from LMP", nil);
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = NSLocalizedString(@"From EDD", nil);
    // rowData.detailText = NSLocalizedString(@"from EDD", nil);
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
     
     */
    
    /*
     calculator = [[Calculator alloc] init];
     calculator.text = @"Decimal age";
     calculator.detailText = @"for older growth charts";
     [calculators addObject:calculator];
     */
    
    //    [calculatorGroup addObject:calculators];
    
    return tableData;
}

@end
