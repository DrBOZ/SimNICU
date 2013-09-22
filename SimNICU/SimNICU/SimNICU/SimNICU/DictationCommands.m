//
//  DictationCommands.m
//  SimNICU
//
//  Created by Conrad Bosman on 15/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "DictationCommands.h"
#import "CBTableViewRowData.h"

@implementation DictationCommands

+ (NSArray *)returnListOfAppleDictationCommands
{
    CBTableViewRowData *rowData;
    
    NSMutableArray *tableRows = [[NSMutableArray alloc] initWithCapacity:20];
    
    float largeText = 17.0f;
    float smallText = 14.0f;
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"\"numeral 5\"";
    rowData.detailText = @"5";
    rowData.detailTextFontSize = [NSNumber numberWithFloat:largeText];
    
    [tableRows addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"\"percent sign\"";
    rowData.detailText = @"%";
    rowData.detailTextFontSize = [NSNumber numberWithFloat:largeText];
    
    [tableRows addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"\"degree sign\"";
    rowData.detailText = @"\u00B0";
    rowData.detailTextFontSize = [NSNumber numberWithFloat:largeText];
    
    [tableRows addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"\"comma\"";
    rowData.detailText = @",";
    rowData.detailTextFontSize = [NSNumber numberWithFloat:largeText];
    
    [tableRows addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"\"dot\"";
    rowData.detailText = @".";
    rowData.detailTextFontSize = [NSNumber numberWithFloat:largeText];
    
    [tableRows addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"\"open parenthesis\"";
    rowData.detailText = @"(";
    rowData.detailTextFontSize = [NSNumber numberWithFloat:largeText];
    
    [tableRows addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"\"close parenthesis\"";
    rowData.detailText = @")";
    rowData.detailTextFontSize = [NSNumber numberWithFloat:largeText];
    
    [tableRows addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"\"new line\"";
    rowData.detailText = @"new text line";
    rowData.detailTextFontSize = [NSNumber numberWithFloat:smallText];
    
    [tableRows addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"\"no space\"";
    rowData.detailText = @"omit space next word";
    rowData.detailTextFontSize = [NSNumber numberWithFloat:smallText];
    
    [tableRows addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"\"no space on\"";
    rowData.detailText = @"autospacing off";
    rowData.detailTextFontSize = [NSNumber numberWithFloat:smallText];
    
    [tableRows addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"\"no space off\"";
    rowData.detailText = @"autospacing on";
    rowData.detailTextFontSize = [NSNumber numberWithFloat:smallText];
    
    [tableRows addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"\"space bar\"";
    rowData.detailText = @"insert space";
    rowData.detailTextFontSize = [NSNumber numberWithFloat:smallText];
    
    [tableRows addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"\"new paragraph\"";
    rowData.detailText = @"New paragraph";
    rowData.detailTextFontSize = [NSNumber numberWithFloat:smallText];
    
    [tableRows addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"\"caps on\"";
    rowData.detailText = @"Caps lock on";
    rowData.detailTextFontSize = [NSNumber numberWithFloat:smallText];
    
    [tableRows addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"\"caps off\"";
    rowData.detailText = @"Caps lock off";
    rowData.detailTextFontSize = [NSNumber numberWithFloat:smallText];
    
    [tableRows addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"\"no caps\"";
    rowData.detailText = @"All lowercase";
    rowData.detailTextFontSize = [NSNumber numberWithFloat:smallText];
    
    [tableRows addObject:rowData];
    
    return tableRows;
}

@end
