//
//  AppViewModel.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 15/12/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "AppViewModel.h"
#import "Screen.h"

@implementation AppViewModel

+ (NSArray *)getArrayForMainMenu
{
    NSMutableArray *screens = [[NSMutableArray alloc] initWithCapacity:20];
    
    Screen *screen;
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"APGAR scores", nil);
    screen.segueId = @"APGAR";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Blood Products", nil);
    screen.segueId = @"BloodProducts";
    [screens addObject:screen];
    
#if CALCULATOR_PREVIEW_MODE
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Calculator", nil);
    screen.segueId = @"Calculator";
    [screens addObject:screen];
    
#endif
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Cerebral Function Monitoring", nil);
    screen.segueId = @"CFAM";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Cooling", nil);
    screen.segueId = @"Cooling";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Corrected Age", nil);
    screen.segueId = @"Age Calculators";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Cranial Ultrasound", nil);
    screen.segueId = @"CrUSS";
    
    /*
     #if CRUSS_PREVIEW_MODE
     
     screen.detailMenuText = @"New Image Viewer!";
     
     #endif
     */
    
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = @"Curosurf\u00AE";
    screen.segueId = @"Curosurf";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Diaphragmatic Hernia", nil);
    screen.segueId = @"CDH";
    [screens addObject:screen];
    
#if DRUGS_PREVIEW_MODE
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Drugs", nil);
    screen.segueId = @"Drugs";
    [screens addObject:screen];
    
#endif
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Early Care", nil);
    screen.segueId = @"EarlyCare";
    [screens addObject:screen];
    
#if FLUID_BALANCE_PREVIEW_MODE
    
    screen = [Screen new];
    screen.menuText = @"Fluid Balance";
    screen.segueId = @"FluidBalance";
    [screens addObject:screen];
    
#endif
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Fluid Requirements", nil);
    screen.segueId = @"FluidRequirements";
    [screens addObject:screen];
    
#if FEEDS_AND_FLUIDS_PREVIEW_MODE
    
    screen = [Screen new];
    screen.menuText = @"Feeds & Fluids";
    screen.segueId = @"FeedsAndFluids";
    [screens addObject:screen];
    
#endif
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Gastroschisis", nil);
    screen.segueId = @"Gastroschisis";
    [screens addObject:screen];
    
#if GLUCOSE_LOAD_PREVIEW_MODE
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Glucose Load", nil);
    
    screen.detailMenuText = @"Coming soon!";
    screen.segueId = @"GlucoseInfusionRate";
    [screens addObject:screen];
    
#endif
    
    screen = [Screen new];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0)
    {
        screen.menuText = NSLocalizedString(@"High Frequency Oscillation", nil);
    }
    else if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 3.0)
    {
        screen.menuText = @"HFOV";
    }
    screen.segueId = @"HFOV";
    [screens addObject:screen];
    
#if HYPOGLYCAEMIA_PREVIEW_MODE
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Hypoglycaemia Screen", nil);
    screen.segueId = @"Hypo";
    [screens addObject:screen];
    
#endif
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Infusions", nil);
    screen.segueId = @"Infusions";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Intubation", nil);
    screen.segueId = @"Intubation";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Naloxone (Narcan\u00AE)", nil);
    screen.segueId = @"Narcan";
    [screens addObject:screen];
    
    // Outcomes
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Oxygenation Index", nil);
    screen.segueId = @"OI";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Phototherapy", nil);
    screen.segueId = @"Phototherapy";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Plastic Bag (at delivery)", nil);
    screen.segueId = @"Thermoregulation";
    [screens addObject:screen];
    
#if POSTNATAL_WARD_PREVIEW_MODE
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Postnatal Ward", nil);
    screen.segueId = @"PostnatalWard";
    [screens addObject:screen];
    
#endif
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Pulmonary Haemorrhage", nil);
    screen.segueId = @"PulmonaryHaemorrhage";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Resuscitation Drugs", nil);
    screen.segueId = @"Resus";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Retinopathy of Prematurity", nil);
    screen.segueId = @"ROP";
    [screens addObject:screen];
    
    // Sarnat score
    
    /*
     screen = [Screen new];
     screen.menuText = @"Seizures";
     screen.segueId = @"Fits";
     [screens addObject:screen];
     */
    
    // Sodium correction
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Transport Ventilator", nil);
    screen.segueId = @"BabyPac";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"UAC / UVC", nil);
    screen.segueId = @"UACUVC";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Vitamin K", nil);
    screen.segueId = @"VitK";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Weight Conversion", nil);
    screen.segueId = @"WeightConversion";
    [screens addObject:screen];
    
#if DYNAMIC_TEXT_TESTER
    
    screen = [Screen new];
    screen.menuText = @"Dynamic Text Tester";
    screen.segueId = @"DynamicTextTester";
    [screens addObject:screen];
    
#endif
    
    // alphebetise the screens array based on the screen.menuText property values
    NSArray *sortedScreens;
    
    sortedScreens = [screens sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
                     {
                         NSString *first = [(Screen *)a menuText];
                         NSString *second = [(Screen *)b menuText];
                         return [first compare:second];
                     }];
    
    screens = [NSMutableArray arrayWithArray:sortedScreens];
    
    return screens;
}

@end
