//
//  AddBloodResultModel.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 06/12/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBTableViewSectionData.h"
#import "AddBloodResultModel.h"
#import "CBTableViewRowData.h"

@implementation AddBloodResultModel

+ (NSArray *)getArrayForTableView
{
    NSMutableArray *tableData = [[NSMutableArray alloc] initWithCapacity:5];
    
    CBTableViewSectionData *sectionData;
    CBTableViewRowData *rowData;
    
    // DO NOT LOCALISE!
    
    // Patient List section
    sectionData = [CBTableViewSectionData new];
    sectionData.titleForHeader = nil;
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:1];
    
    rowData = [CBTableViewRowData new];
    rowData.text = @"Date and Time";
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
    //  FBC
    {
        sectionData = [CBTableViewSectionData new];
        sectionData.titleForHeader = @"Haematology";
        sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:3];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"Hb";
        rowData.textField = [UITextField new];
        rowData.textField.tag = 0;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"WCC";
        rowData.textField = [UITextField new];
        rowData.textField.tag = 1;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"Platelets";
        rowData.textField = [UITextField new];
        rowData.textField.tag = 2;
        [sectionData.rowData addObject:rowData];
        
        [tableData addObject:sectionData];
    }
    
    //  Clotting
    {
        sectionData = [CBTableViewSectionData new];
        sectionData.titleForHeader = nil;
        sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:4];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"PT";
        rowData.textField = [UITextField new];
        rowData.textField.tag = 3;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"APTT";
        rowData.textField = [UITextField new];
        rowData.textField.tag = 4;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"TT";
        rowData.textField = [UITextField new];
        rowData.textField.tag = 5;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"Fibrinogen";
        rowData.textField = [UITextField new];
        rowData.textField.tag = 6;
        [sectionData.rowData addObject:rowData];
        
        [tableData addObject:sectionData];
    }
    
    // U&Es
    {
        sectionData = [CBTableViewSectionData new];
        sectionData.titleForHeader = @"Biochemistry";
        sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:4];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"Na";
        rowData.textField = [UITextField new];
        rowData.textField.tag = 7;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"K";
        rowData.textField = [UITextField new];
        rowData.textField.tag = 8;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"Urea";
        rowData.textField = [UITextField new];
        rowData.textField.tag = 9;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"Creatinine";
        rowData.textField = [UITextField new];
        rowData.textField.tag = 10;
        [sectionData.rowData addObject:rowData];
        
        [tableData addObject:sectionData];
    }
    
    // LFTs
    {
        sectionData = [CBTableViewSectionData new];
        sectionData.titleForHeader = nil;
        sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:5];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"Alk Phos";
        rowData.textField = [UITextField new];
        rowData.textField.tag = 11;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"ALT";
        rowData.textField = [UITextField new];
        rowData.textField.tag = 12;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"SBR";
        rowData.textField = [UITextField new];
        rowData.textField.tag = 13;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"gamma GT";
        rowData.textField = [UITextField new];
        rowData.textField.tag = 14;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"Albumin";
        rowData.textField = [UITextField new];
        rowData.textField.tag = 15;
        [sectionData.rowData addObject:rowData];
        
        [tableData addObject:sectionData];
    }
    
    // Bone profile
    {
        sectionData = [CBTableViewSectionData new];
        sectionData.titleForHeader = nil;
        sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:4];
        
//        rowData = [CBTableViewRowData new];
//        rowData.text = NSLocalizedString(@"Alk Phos", @"Alkaline phosphatase");
//        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"Ca";
        rowData.textField = [UITextField new];
        rowData.textField.tag = 16;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"Ca (adjusted)";
        rowData.textField = [UITextField new];
        rowData.textField.tag = 17;
        [sectionData.rowData addObject:rowData];
        
//        rowData = [CBTableViewRowData new];
//        rowData.text = NSLocalizedString(@"Albumin", nil);
//        [sectionData.rowData addObject:rowData];
        
        [tableData addObject:sectionData];
    }
    
    // Mg
    {
        sectionData = [CBTableViewSectionData new];
        sectionData.titleForHeader = nil;
        sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:1];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"Mg";
        rowData.textField = [UITextField new];
        rowData.textField.tag = 18;
        [sectionData.rowData addObject:rowData];
        
        [tableData addObject:sectionData];
    }
    
    // CRP
    {
        sectionData = [CBTableViewSectionData new];
        sectionData.titleForHeader = nil;
        sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:1];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"CRP";
        rowData.textField = [UITextField new];
        rowData.textField.tag = 19;
        [sectionData.rowData addObject:rowData];
        
        [tableData addObject:sectionData];
    }
    
    return tableData;
}

@end
