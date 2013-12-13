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

+ (NSArray *)getArrayForTableViewInBloodResultOrder:(NSString *)bloodResultOrder
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
    
    // the tag is used to identify the UITextField position in the UITableView in
    // AddBloodResultsTableViewController to scroll to that position when entering a value
    int tag = 0;
    
    if ([bloodResultOrder isEqualToString:@"Haematology First"])
    {
        //  FBC
        {
            sectionData = [CBTableViewSectionData new];
            sectionData.titleForHeader = @"Haematology";
            sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:3];
            
            // 01 Haemoglobin
            rowData = [CBTableViewRowData new];
            rowData.text = @"Hb";
            rowData.reference = @"Haemoglobin value";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            // 02 Total white cell count
            rowData = [CBTableViewRowData new];
            rowData.text = @"WCC";
            rowData.reference = @"Total White Cell Count value";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            // 02 absolute neutrophil count
            rowData = [CBTableViewRowData new];
            rowData.text = @"aNC";
            rowData.reference = @"Absolute neutrophil count value";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"Platelets";
            rowData.reference = @"Platelet value";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"Reticulocytes";
            rowData.reference = @"Reticulocytes value";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"Nucleated RBC";
            rowData.reference = @"Nucleated Red Blood Cells value";
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
            rowData.reference = @"Prothrombin Time value";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"APTT";
            rowData.reference = @"Activated Partial Thromboplatin Time value";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"TT";
            rowData.reference = @"Thrombin Time value";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"Fibrinogen";
            rowData.reference = @"Fibrinogen value";
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
            rowData.reference = @"Sodium value (serum)";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"K";
            rowData.reference = @"Potassium value (serum)";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"Urea";
            rowData.reference = @"Urea value (serum)";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"Creatinine";
            rowData.reference = @"Creatinine value (serum)";
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
            rowData.reference = @"C Reactive Protein value";
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
            rowData.reference = @"Alkaline phosphatase value (serum)";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"ALT";
            rowData.reference = @"Alanine Transaminase value (serum)";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"Bilirubin (indirect)";
            rowData.reference = @"Unconjugated Bilirubin value (serum)";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"gamma GT";
            rowData.reference = @"gamma GT value (serum)";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"Albumin";
            rowData.reference = @"Albumin value (serum)";
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
            rowData.reference = @"Conjugated Bilirubin value (serum)";
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
            rowData.reference = @"Calcium value (serum)";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"Ca (adjusted)";
            rowData.reference = @"Adjusted Calcium value (serum)";
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
            rowData.reference = @"Magnesium value (serum)";
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
            rowData.reference = @"Ammonia value (serum)";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            [tableData addObject:sectionData];
        }
    }
    else
    {
        // U&Es
        {
            sectionData = [CBTableViewSectionData new];
            sectionData.titleForHeader = @"Biochemistry";
            sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:4];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"Na";
            rowData.reference = @"Sodium value (serum)";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"K";
            rowData.reference = @"Potassium value (serum)";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"Urea";
            rowData.reference = @"Urea value (serum)";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"Creatinine";
            rowData.reference = @"Creatinine value (serum)";
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
            rowData.reference = @"C Reactive Protein value";
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
            rowData.reference = @"Alkaline phosphatase value (serum)";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"ALT";
            rowData.reference = @"Alanine Transaminase value (serum)";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"Bilirubin (indirect)";
            rowData.reference = @"Unconjugated Bilirubin value (serum)";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"gamma GT";
            rowData.reference = @"gamma GT value (serum)";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"Albumin";
            rowData.reference = @"Albumin value (serum)";
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
            rowData.reference = @"Conjugated Bilirubin value (serum)";
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
            rowData.reference = @"Calcium value (serum)";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"Ca (adjusted)";
            rowData.reference = @"Adjusted Calcium value (serum)";
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
            rowData.reference = @"Magnesium value (serum)";
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
            rowData.reference = @"Ammonia value (serum)";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            [tableData addObject:sectionData];
        }
        
        //  FBC
        {
            sectionData = [CBTableViewSectionData new];
            sectionData.titleForHeader = @"Haematology";
            sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:3];
            
            // 01 Haemoglobin
            rowData = [CBTableViewRowData new];
            rowData.text = @"Hb";
            rowData.reference = @"Haemoglobin value";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            // 02 Total white cell count
            rowData = [CBTableViewRowData new];
            rowData.text = @"WCC";
            rowData.reference = @"Total White Cell Count value";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            // 02 absolute neutrophil count
            rowData = [CBTableViewRowData new];
            rowData.text = @"aNC";
            rowData.reference = @"Absolute neutrophil count value";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"Platelets";
            rowData.reference = @"Platelet value";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"Reticulocytes";
            rowData.reference = @"Reticulocytes value";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"Nucleated RBC";
            rowData.reference = @"Nucleated Red Blood Cells value";
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
            rowData.reference = @"Prothrombin Time value";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"APTT";
            rowData.reference = @"Activated Partial Thromboplatin Time value";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"TT";
            rowData.reference = @"Thrombin Time value";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            rowData = [CBTableViewRowData new];
            rowData.text = @"Fibrinogen";
            rowData.reference = @"Fibrinogen value";
            rowData.textField = [UITextField new];
            rowData.textField.tag = tag;
            tag ++;
            [sectionData.rowData addObject:rowData];
            
            [tableData addObject:sectionData];
        }
    }
    
    return tableData;
}

@end
