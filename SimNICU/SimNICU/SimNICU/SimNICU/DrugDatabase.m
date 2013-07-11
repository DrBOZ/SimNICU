//
//  DrugDatabase.m
//  SimNICU
//
//  Created by Conrad Bosman on 05/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "DrugDatabase.h"
#import "DrugCategory.h"
#import "Druginfo.h"
#import "Drug.h"

@implementation DrugDatabase

- (id)init
{
    self = [super init];
    if (self)
    {
        // populate database
        
        self.drugCategories = [[NSMutableArray alloc] initWithCapacity:20];
        
        DrugCategory *drugCategory;
        Drug *drug;
        NSMutableArray *drugInfoSections;
        DrugInfo *drugInfoSection;
      
#pragma mark - UK Drugs
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Drugs";
        
        // create array
        NSMutableArray *drugs = [[NSMutableArray alloc] initWithCapacity:10];
        
        drug = [[Drug alloc] init];
        drug.name = @"Abidec";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Aciclovir";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Adenosine";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Adrenaline";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Alprostadil";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Amoxycillin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Amphotericin B (liposomal)";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Ampicillin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Atracurium";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Atropine";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"BCG";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Benzylpenicillin";
        
        drugInfoSections = [[NSMutableArray alloc] initWithCapacity:10];
        
        // section 0
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:0];
        drugInfoSection.header = @"Pharmacology";
        drugInfoSection.heightForRow = [NSNumber numberWithInt:100.0f];
        drugInfoSection.htmlFile = @"benzylpenicillinPharmacology";
        [drugInfoSections addObject:drugInfoSection];
        
        // section 1
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:1];
        drugInfoSection.header = @"Indications";
        drugInfoSection.heightForRow = [NSNumber numberWithInt:80.0f];
        drugInfoSection.htmlFile = @"benzylpenicillinIndications";
        [drugInfoSections addObject:drugInfoSection];
        
        // section 2
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:2];
        drugInfoSection.header = @"Presentation";
        drugInfoSection.heightForRow = [NSNumber numberWithInt:40.0f];
        drugInfoSection.htmlFile = @"benzylpenicillinPresentation";
        [drugInfoSections addObject:drugInfoSection];
        drug.info = drugInfoSections;
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Breast milk fortifier";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Caffeine";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Calcium chloride";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Calcium gluconate";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Captopril";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Caspofungin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Cefotaxime";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Ceftazidime";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Cefuroxime";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Chloral hydrate";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Ciprofloxacin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Co-amoxyclav (Augmentin)";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Daktarin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Dalivit";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Dexamethasone";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Diamorphine";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Digoxin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Dobutamine";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Dopamine";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Domperidone";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Erythropoetin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Fentanyl";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Flucloxacillin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Fluconazole";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Flucytosine";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Folic acid";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Ganciclovir";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Gaviscon";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Gentamicin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Glucagon";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Hydrocortisone";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Ibuprofen";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Immunoglobulin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Indomethacin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Insulin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Lignocaine";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Lorazepam";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Magnesium sulphate";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Meropenem";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Midazolam";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Milrinone";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Morphine";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Naloxone";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Nystatin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Nitrous oxide";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Omeprazole";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Palivizumab";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Pancuronium";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Paracetamol";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Paraldehyde";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Phenobarbitone";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Piperacillin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Potassium acid phosphate";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Potassium chloride";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Pyridoxine";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Ranitidine";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Salbutamol";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Sildenafil";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Sodium benzoate";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Sodium bicarbonate";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Sodium phenylbutyrate";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Sodium chloride";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Sodium valproate";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Sucrose";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Sytron";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Tazocin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Teicoplanin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"THAM";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Thiopentone";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Tobramycin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Trimethoprim";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Thyroxine (levothyroxine)";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Urokinase";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Ursodeoxycholic acid";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Vancomycin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Vecuronium";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Vitamin D";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Vitamin K";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Warfarin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Zidovudine";
        [drugs addObject:drug];
        
        // Add array to drugs
        drugCategory.drugs = drugs;
        
        [self.drugCategories addObject:drugCategory];
        
        /*
#pragma mark - EXAMPLE
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Examples";
        
        // create array
        foods = [[NSMutableArray alloc] initWithCapacity:7];
        
#pragma mark Example
        food = [[Food alloc] init];
        food.name = @"Example (1)";
        food.defaultPortionIndex = [NSNumber numberWithInt:0];
        portions = [[NSMutableArray alloc] initWithCapacity:1];
        // portion 0
        portion = [[Portion alloc] init];
        portion.name = @"Standard Size";
        portion.index = [NSNumber numberWithInt:0];
        portion.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Toast.png"]];
        portion.imageView.frame = CGRectMake(0.0f, 0.0f, 140.0f, (140.0f * (920.0f / 1000.0f)));
        portion.imageView.userInteractionEnabled = YES;
        portion.weight = [NSNumber numberWithInt:13];
        portion.carbs = [NSNumber numberWithInt:7];
        portion.fats = [NSNumber numberWithInt:0];
        portion.protein = [NSNumber numberWithInt:0];
        portion.cals = [NSNumber numberWithInt:50];
        [portions addObject:portion];
        food.portions = portions;
        [foods addObject:food];
        
        [self.drugCategories addObject:drugCategory];
         */
    }
    return self;
}

@end
