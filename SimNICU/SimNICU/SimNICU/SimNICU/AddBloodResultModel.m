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
    
    rowData = [CBTableViewRowData new];
    rowData.text = @"Previous results";
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
    int tag = 0;
    
    //  FBC
    {
        sectionData = [CBTableViewSectionData new];
        sectionData.titleForHeader = @"Haematology";
        sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:3];
        
        // 01 Haemoglobin
        rowData = [CBTableViewRowData new];
        rowData.text = @"Hb";
        rowData.textField = [UITextField new];
        rowData.textField.tag = tag;
        tag ++;
        [sectionData.rowData addObject:rowData];
        
        // 02 Total white cell count
        rowData = [CBTableViewRowData new];
        rowData.text = @"WCC";
        rowData.textField = [UITextField new];
        rowData.textField.tag = tag;
        tag ++;
        [sectionData.rowData addObject:rowData];
        
        // 02 absolute neutrophil count
        rowData = [CBTableViewRowData new];
        rowData.text = @"aNC";
        rowData.textField = [UITextField new];
        rowData.textField.tag = tag;
        tag ++;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"Platelets";
        rowData.textField = [UITextField new];
        rowData.textField.tag = tag;
        tag ++;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"Reticulocytes";
        rowData.textField = [UITextField new];
        rowData.textField.tag = tag;
        tag ++;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"Nucleated RBC";
        rowData.textField = [UITextField new];
        rowData.textField.tag = tag;
        tag ++;
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
        rowData.textField.tag = tag;
        tag ++;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"APTT";
        rowData.textField = [UITextField new];
        rowData.textField.tag = tag;
        tag ++;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"TT";
        rowData.textField = [UITextField new];
        rowData.textField.tag = tag;
        tag ++;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"Fibrinogen";
        rowData.textField = [UITextField new];
        rowData.textField.tag = tag;
        tag ++;
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
        rowData.textField.tag = tag;
        tag ++;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"K";
        rowData.textField = [UITextField new];
        rowData.textField.tag = tag;
        tag ++;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"Urea";
        rowData.textField = [UITextField new];
        rowData.textField.tag = tag;
        tag ++;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"Creatinine";
        rowData.textField = [UITextField new];
        rowData.textField.tag = tag;
        tag ++;
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
        rowData.textField.tag = tag;
        tag ++;
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
        rowData.textField.tag = tag;
        tag ++;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"ALT";
        rowData.textField = [UITextField new];
        rowData.textField.tag = tag;
        tag ++;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"Bilirubin (indirect)";
        rowData.textField = [UITextField new];
        rowData.textField.tag = tag;
        tag ++;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"gamma GT";
        rowData.textField = [UITextField new];
        rowData.textField.tag = tag;
        tag ++;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"Albumin";
        rowData.textField = [UITextField new];
        rowData.textField.tag = tag;
        tag ++;
        [sectionData.rowData addObject:rowData];
        
        [tableData addObject:sectionData];
    }
    
    // Conjugated bilirubin
    {
        sectionData = [CBTableViewSectionData new];
        sectionData.titleForHeader = nil;
        sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:4];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"Bilirubin (direct)";
        rowData.textField = [UITextField new];
        rowData.textField.tag = tag;
        tag ++;
        [sectionData.rowData addObject:rowData];
        
        [tableData addObject:sectionData];
    }
    
    // Bone profile
    {
        sectionData = [CBTableViewSectionData new];
        sectionData.titleForHeader = nil;
        sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:4];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"Ca";
        rowData.textField = [UITextField new];
        rowData.textField.tag = tag;
        tag ++;
        [sectionData.rowData addObject:rowData];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"Ca (adjusted)";
        rowData.textField = [UITextField new];
        rowData.textField.tag = tag;
        tag ++;
        [sectionData.rowData addObject:rowData];
        
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
        rowData.textField.tag = tag;
        tag ++;
        [sectionData.rowData addObject:rowData];
        
        [tableData addObject:sectionData];
    }
    
    // Ammonia
    {
        sectionData = [CBTableViewSectionData new];
        sectionData.titleForHeader = nil;
        sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:1];
        
        rowData = [CBTableViewRowData new];
        rowData.text = @"Ammonia";
        rowData.textField = [UITextField new];
        rowData.textField.tag = tag;
        tag ++;
        [sectionData.rowData addObject:rowData];
        
        [tableData addObject:sectionData];
    }
    
    return tableData;
}

@end
