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
      
#pragma mark - UK DRUGS
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Drugs";
        
        // create array
        NSMutableArray *drugs = [[NSMutableArray alloc] initWithCapacity:10];
        
#pragma mark Abidec
        drug = [[Drug alloc] init];
        drug.name = @"Abidec";
        [drugs addObject:drug];
        
#pragma mark Aciclovir
        drug = [[Drug alloc] init];
        drug.name = @"Aciclovir";
        [drugs addObject:drug];
        
#pragma mark Adenosine
        drug = [[Drug alloc] init];
        drug.name = @"Adenosine";
        [drugs addObject:drug];
        
#pragma mark Adrenaline
        drug = [[Drug alloc] init];
        drug.name = @"Adrenaline";
        
        drugInfoSections = [[NSMutableArray alloc] initWithCapacity:10];
        
        // section 0
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:0];
        drugInfoSection.header = @"Pharmacology";
        drugInfoSection.heightForRow = [NSNumber numberWithFloat:400.0f];
        drugInfoSection.inset = [NSNumber numberWithFloat:10.0f];
        drugInfoSection.htmlFile = @"adrenalinePharmacology";
        [drugInfoSections addObject:drugInfoSection];
        
        // section 1
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:1];
        drugInfoSection.header = @"Indications";
        drugInfoSection.heightForRow = [NSNumber numberWithFloat:80.0f];
        drugInfoSection.inset = [NSNumber numberWithFloat:10.0f];
        drugInfoSection.htmlFile = @"adrenalineIndications";
        [drugInfoSections addObject:drugInfoSection];
        
        // section 2
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:2];
        drugInfoSection.header = @"Presentation";
        drugInfoSection.heightForRow = [NSNumber numberWithFloat:250.0f];
        drugInfoSection.inset = [NSNumber numberWithFloat:0.0f];
        drugInfoSection.htmlFile = @"adrenalinePresentation";
        [drugInfoSections addObject:drugInfoSection];
        
        // section 3
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:3];
        drugInfoSection.header = @"Dose";
        drugInfoSection.heightForRow = [NSNumber numberWithFloat:650.0f];
        drugInfoSection.inset = [NSNumber numberWithFloat:0.0f];
        drugInfoSection.htmlFile = @"adrenalineDose";
        [drugInfoSections addObject:drugInfoSection];
        
        // section 4
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:4];
        drugInfoSection.header = @"Preparation";
        drugInfoSection.heightForRow = [NSNumber numberWithFloat:1060.0f];
        drugInfoSection.inset = [NSNumber numberWithFloat:10.0f];
        drugInfoSection.htmlFile = @"adrenalinePreparation";
        [drugInfoSections addObject:drugInfoSection];
        
        // section 5
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:5];
        drugInfoSection.header = @"Stability";
        drugInfoSection.heightForRow = [NSNumber numberWithFloat:38.0f];
        drugInfoSection.inset = [NSNumber numberWithFloat:10.0f];
        drugInfoSection.htmlFile = @"adrenalineStability";
        [drugInfoSections addObject:drugInfoSection];
        
        // section 6
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:6];
        drugInfoSection.header = @"Y-site Compatibilities";
        drugInfoSection.heightForRow = [NSNumber numberWithFloat:105.0f];
        drugInfoSection.inset = [NSNumber numberWithFloat:10.0f];
        drugInfoSection.htmlFile = @"adrenalineYSiteCompatibilities";
        [drugInfoSections addObject:drugInfoSection];
        
        // section 7
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:7];
        drugInfoSection.header = @"Y-site Incompatibilities";
        drugInfoSection.heightForRow = [NSNumber numberWithFloat:60.0f];
        drugInfoSection.inset = [NSNumber numberWithFloat:10.0f];
        drugInfoSection.htmlFile = @"adrenalineYSiteIncompatibilities";
        [drugInfoSections addObject:drugInfoSection];
        
        // section 8
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:8];
        drugInfoSection.header = @"Side effects";
        drugInfoSection.heightForRow = [NSNumber numberWithFloat:170.0f];
        drugInfoSection.inset = [NSNumber numberWithFloat:10.0f];
        drugInfoSection.htmlFile = @"adrenalineSideEffects";
        [drugInfoSections addObject:drugInfoSection];
        
        // section 9
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:9];
        drugInfoSection.header = @"Monitoring";
        drugInfoSection.heightForRow = [NSNumber numberWithFloat:165.0f];
        drugInfoSection.inset = [NSNumber numberWithFloat:10.0f];
        drugInfoSection.htmlFile = @"adrenalineMonitoring";
        [drugInfoSections addObject:drugInfoSection];
        
        // section 10
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:10];
        drugInfoSection.header = @"Licence status";
        drugInfoSection.heightForRow = [NSNumber numberWithFloat:80.0f];
        drugInfoSection.inset = [NSNumber numberWithFloat:10.0f];
        drugInfoSection.htmlFile = @"adrenalineLicenceStatus";
        [drugInfoSections addObject:drugInfoSection];
        
        // section 11
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:11];
        drugInfoSection.header = @"References";
        drugInfoSection.heightForRow = [NSNumber numberWithFloat:310.0f];
        drugInfoSection.inset = [NSNumber numberWithFloat:10.0f];
        drugInfoSection.htmlFile = @"adrenalineReferences";
        [drugInfoSections addObject:drugInfoSection];
        
        drug.info = drugInfoSections;
        [drugs addObject:drug];
        
#pragma mark Alprostadil
        drug = [[Drug alloc] init];
        drug.name = @"Alprostadil";
        [drugs addObject:drug];
        
#pragma mark Amoxycillin
        drug = [[Drug alloc] init];
        drug.name = @"Amoxycillin";
        [drugs addObject:drug];
        
#pragma mark Amphotericin B (liposomal)
        drug = [[Drug alloc] init];
        drug.name = @"Amphotericin B (liposomal)";
        [drugs addObject:drug];
        
#pragma mark Ampicillin
        drug = [[Drug alloc] init];
        drug.name = @"Ampicillin";
        [drugs addObject:drug];
        
#pragma mark Atracurium
        drug = [[Drug alloc] init];
        drug.name = @"Atracurium";
        [drugs addObject:drug];
        
#pragma mark Atropine
        drug = [[Drug alloc] init];
        drug.name = @"Atropine";
        [drugs addObject:drug];
        
#pragma mark BCG
        drug = [[Drug alloc] init];
        drug.name = @"BCG";
        [drugs addObject:drug];
        
#pragma mark Benzylpenicillin
        drug = [[Drug alloc] init];
        drug.name = @"Benzylpenicillin";
        
        drugInfoSections = [[NSMutableArray alloc] initWithCapacity:10];
        
        // section 0
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:0];
        drugInfoSection.header = @"Pharmacology";
        drugInfoSection.heightForRow = [NSNumber numberWithFloat:100.0f];
        drugInfoSection.inset = [NSNumber numberWithFloat:10.0f];
        drugInfoSection.htmlFile = @"benzylpenicillinPharmacology";
        [drugInfoSections addObject:drugInfoSection];
        
        // section 1
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:1];
        drugInfoSection.header = @"Indications";
        drugInfoSection.heightForRow = [NSNumber numberWithFloat:80.0f];
        drugInfoSection.inset = [NSNumber numberWithFloat:10.0f];
        drugInfoSection.htmlFile = @"benzylpenicillinIndications";
        [drugInfoSections addObject:drugInfoSection];
        
        // section 2
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:2];
        drugInfoSection.header = @"Presentation";
        drugInfoSection.heightForRow = [NSNumber numberWithFloat:38.0f];
        drugInfoSection.inset = [NSNumber numberWithFloat:10.0f];
        drugInfoSection.htmlFile = @"benzylpenicillinPresentation";
        [drugInfoSections addObject:drugInfoSection];
        
        // section 3
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:3];
        drugInfoSection.header = @"Dose";
        drugInfoSection.heightForRow = [NSNumber numberWithFloat:40.0f];
        drugInfoSection.htmlFile = @"benzylpenicillinDose";
        [drugInfoSections addObject:drugInfoSection];
        
        // section 4
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:4];
        drugInfoSection.header = @"Preparation";
        drugInfoSection.heightForRow = [NSNumber numberWithFloat:310.0f];
        drugInfoSection.inset = [NSNumber numberWithFloat:0.0f];
        drugInfoSection.htmlFile = @"benzylpenicillinPreparation";
        [drugInfoSections addObject:drugInfoSection];
        
        // section 5
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:5];
        drugInfoSection.header = @"Incompatibilities";
        drugInfoSection.heightForRow = [NSNumber numberWithFloat:125.0f];
        drugInfoSection.inset = [NSNumber numberWithFloat:10.0f];
        drugInfoSection.htmlFile = @"benzylpenicillinIncompatibilities";
        [drugInfoSections addObject:drugInfoSection];
        
        // section 6
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:6];
        drugInfoSection.header = @"Contraindications";
        drugInfoSection.heightForRow = [NSNumber numberWithFloat:125.0f];
        drugInfoSection.inset = [NSNumber numberWithFloat:10.0f];
        drugInfoSection.htmlFile = @"benzylpenicillinContraindications";
        [drugInfoSections addObject:drugInfoSection];
        
        // section 7
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:7];
        drugInfoSection.header = @"Side effects";
        drugInfoSection.heightForRow = [NSNumber numberWithFloat:230.0f];
        drugInfoSection.inset = [NSNumber numberWithFloat:10.0f];
        drugInfoSection.htmlFile = @"benzylpenicillinSideEffects";
        [drugInfoSections addObject:drugInfoSection];
        
        // section 8
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:8];
        drugInfoSection.header = @"Monitoring";
        drugInfoSection.heightForRow = [NSNumber numberWithFloat:38.0f];
        drugInfoSection.inset = [NSNumber numberWithFloat:10.0f];
        drugInfoSection.htmlFile = @"benzylpenicillinMonitoring";
        [drugInfoSections addObject:drugInfoSection];
        
        // section 9
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:9];
        drugInfoSection.header = @"Licence status";
        drugInfoSection.heightForRow = [NSNumber numberWithFloat:38.0f];
        drugInfoSection.inset = [NSNumber numberWithFloat:10.0f];
        drugInfoSection.htmlFile = @"benzylpenicillinLicenceStatus";
        [drugInfoSections addObject:drugInfoSection];
        
        // section 10
        drugInfoSection = [[DrugInfo alloc] init];
        drugInfoSection.section = [NSNumber numberWithInt:10];
        drugInfoSection.header = @"References";
        drugInfoSection.heightForRow = [NSNumber numberWithFloat:220.0f];
        drugInfoSection.inset = [NSNumber numberWithFloat:10.0f];
        drugInfoSection.htmlFile = @"benzylpenicillinReferences";
        [drugInfoSections addObject:drugInfoSection];
        
        drug.info = drugInfoSections;
        [drugs addObject:drug];
        
#pragma mark Breast milk fortifier
        drug = [[Drug alloc] init];
        drug.name = @"Breast milk fortifier";
        [drugs addObject:drug];
        
#pragma mark Caffeine
        drug = [[Drug alloc] init];
        drug.name = @"Caffeine";
        [drugs addObject:drug];
        
#pragma mark Calcium chloride
        drug = [[Drug alloc] init];
        drug.name = @"Calcium chloride";
        [drugs addObject:drug];
        
#pragma mark Calcium gluconate
        drug = [[Drug alloc] init];
        drug.name = @"Calcium gluconate";
        [drugs addObject:drug];
        
#pragma mark Captopril
        drug = [[Drug alloc] init];
        drug.name = @"Captopril";
        [drugs addObject:drug];
        
#pragma mark Caspofungin
        drug = [[Drug alloc] init];
        drug.name = @"Caspofungin";
        [drugs addObject:drug];
        
#pragma mark Cefotaxime
        drug = [[Drug alloc] init];
        drug.name = @"Cefotaxime";
        [drugs addObject:drug];
        
#pragma mark Ceftazidime
        drug = [[Drug alloc] init];
        drug.name = @"Ceftazidime";
        [drugs addObject:drug];
        
#pragma mark Cefuroxime
        drug = [[Drug alloc] init];
        drug.name = @"Cefuroxime";
        [drugs addObject:drug];
        
#pragma mark Chloral hydrate
        drug = [[Drug alloc] init];
        drug.name = @"Chloral hydrate";
        [drugs addObject:drug];
        
#pragma mark Ciprofloxacin
        drug = [[Drug alloc] init];
        drug.name = @"Ciprofloxacin";
        [drugs addObject:drug];
        
#pragma mark Co-amoxyclav (Augmentin)
        drug = [[Drug alloc] init];
        drug.name = @"Co-amoxyclav (Augmentin)";
        [drugs addObject:drug];
        
#pragma mark Daktarin
        drug = [[Drug alloc] init];
        drug.name = @"Daktarin";
        [drugs addObject:drug];
        
#pragma mark Dalivit
        drug = [[Drug alloc] init];
        drug.name = @"Dalivit";
        [drugs addObject:drug];
        
#pragma mark Dexamethasone
        drug = [[Drug alloc] init];
        drug.name = @"Dexamethasone";
        [drugs addObject:drug];
        
#pragma mark Diamorphine
        drug = [[Drug alloc] init];
        drug.name = @"Diamorphine";
        [drugs addObject:drug];
        
#pragma mark Digoxin
        drug = [[Drug alloc] init];
        drug.name = @"Digoxin";
        [drugs addObject:drug];

#pragma mark Dobutamine
        drug = [[Drug alloc] init];
        drug.name = @"Dobutamine";
        [drugs addObject:drug];
        
#pragma mark Dopamine
        drug = [[Drug alloc] init];
        drug.name = @"Dopamine";
        [drugs addObject:drug];
    
#pragma mark Domperidone
        drug = [[Drug alloc] init];
        drug.name = @"Domperidone";
        [drugs addObject:drug];
        
#pragma mark Erthyropoetin
        drug = [[Drug alloc] init];
        drug.name = @"Erythropoetin";
        [drugs addObject:drug];
        
#pragma mark Fentanyl
        drug = [[Drug alloc] init];
        drug.name = @"Fentanyl";
        [drugs addObject:drug];
        
#pragma mark Flucloxacillin
        drug = [[Drug alloc] init];
        drug.name = @"Flucloxacillin";
        [drugs addObject:drug];
        
#pragma mark Fluconazole
        drug = [[Drug alloc] init];
        drug.name = @"Fluconazole";
        [drugs addObject:drug];
        
#pragma mark Flucytosine
        drug = [[Drug alloc] init];
        drug.name = @"Flucytosine";
        [drugs addObject:drug];
        
#pragma mark Folic acid
        drug = [[Drug alloc] init];
        drug.name = @"Folic acid";
        [drugs addObject:drug];
        
#pragma mark Ganciclovir
        drug = [[Drug alloc] init];
        drug.name = @"Ganciclovir";
        [drugs addObject:drug];
        
#pragma mark Gaviscon
        drug = [[Drug alloc] init];
        drug.name = @"Gaviscon";
        [drugs addObject:drug];
        
#pragma mark Gentamicin
        drug = [[Drug alloc] init];
        drug.name = @"Gentamicin";
        [drugs addObject:drug];
        
#pragma mark Glucagon
        drug = [[Drug alloc] init];
        drug.name = @"Glucagon";
        [drugs addObject:drug];
        
#pragma mark Hydrocortisone
        drug = [[Drug alloc] init];
        drug.name = @"Hydrocortisone";
        [drugs addObject:drug];
        
#pragma mark Ibuprofen
        drug = [[Drug alloc] init];
        drug.name = @"Ibuprofen";
        [drugs addObject:drug];
        
#pragma mark Immunoglobulin
        drug = [[Drug alloc] init];
        drug.name = @"Immunoglobulin";
        [drugs addObject:drug];
        
#pragma mark Indomethacin
        drug = [[Drug alloc] init];
        drug.name = @"Indomethacin";
        [drugs addObject:drug];
        
#pragma mark Insulin
        drug = [[Drug alloc] init];
        drug.name = @"Insulin";
        [drugs addObject:drug];
        
#pragma mark Lignocaine
        drug = [[Drug alloc] init];
        drug.name = @"Lignocaine";
        [drugs addObject:drug];
        
#pragma mark Lorazepam
        drug = [[Drug alloc] init];
        drug.name = @"Lorazepam";
        [drugs addObject:drug];
        
#pragma mark Magnesium sulphate
        drug = [[Drug alloc] init];
        drug.name = @"Magnesium sulphate";
        [drugs addObject:drug];
        
#pragma mark Meropenem
        drug = [[Drug alloc] init];
        drug.name = @"Meropenem";
        [drugs addObject:drug];
        
#pragma mark Midazolam
        drug = [[Drug alloc] init];
        drug.name = @"Midazolam";
        [drugs addObject:drug];
        
#pragma mark Morphine
        drug = [[Drug alloc] init];
        drug.name = @"Morphine";
        [drugs addObject:drug];
        
#pragma mark Naloxone
        drug = [[Drug alloc] init];
        drug.name = @"Naloxone";
        [drugs addObject:drug];
        
#pragma mark Nystatin
        drug = [[Drug alloc] init];
        drug.name = @"Nystatin";
        [drugs addObject:drug];
        
#pragma mark Nitrous oxide
        drug = [[Drug alloc] init];
        drug.name = @"Nitrous oxide";
        [drugs addObject:drug];
        
#pragma mark Omeprazole
        drug = [[Drug alloc] init];
        drug.name = @"Omeprazole";
        [drugs addObject:drug];
        
#pragma mark Palivizumab
        drug = [[Drug alloc] init];
        drug.name = @"Palivizumab";
        [drugs addObject:drug];
        
#pragma mark Pancuronium
        drug = [[Drug alloc] init];
        drug.name = @"Pancuronium";
        [drugs addObject:drug];
        
#pragma mark Paracetamol
        drug = [[Drug alloc] init];
        drug.name = @"Paracetamol";
        [drugs addObject:drug];
        
#pragma mark Paraldehyde
        drug = [[Drug alloc] init];
        drug.name = @"Paraldehyde";
        [drugs addObject:drug];
        
#pragma mark Phenobarbitone
        drug = [[Drug alloc] init];
        drug.name = @"Phenobarbitone";
        [drugs addObject:drug];
        
#pragma mark Potassium acid phosphate
        drug = [[Drug alloc] init];
        drug.name = @"Potassium acid phosphate";
        [drugs addObject:drug];
        
#pragma mark Potassium chloride
        drug = [[Drug alloc] init];
        drug.name = @"Potassium chloride";
        [drugs addObject:drug];
        
#pragma mark Pyridoxine
        drug = [[Drug alloc] init];
        drug.name = @"Pyridoxine";
        [drugs addObject:drug];
        
#pragma mark Ranitidine
        drug = [[Drug alloc] init];
        drug.name = @"Ranitidine";
        [drugs addObject:drug];
        
#pragma mark Salbutamol
        drug = [[Drug alloc] init];
        drug.name = @"Salbutamol";
        [drugs addObject:drug];
        
#pragma mark Sildenafil
        drug = [[Drug alloc] init];
        drug.name = @"Sildenafil";
        [drugs addObject:drug];
        
#pragma mark Sodium benzoate
        drug = [[Drug alloc] init];
        drug.name = @"Sodium benzoate";
        [drugs addObject:drug];
        
#pragma mark Sodium bicarbonate
        drug = [[Drug alloc] init];
        drug.name = @"Sodium bicarbonate";
        [drugs addObject:drug];
        
#pragma mark Sodium phenylbutyrate
        drug = [[Drug alloc] init];
        drug.name = @"Sodium phenylbutyrate";
        [drugs addObject:drug];
        
#pragma mark Sodium chloride
        drug = [[Drug alloc] init];
        drug.name = @"Sodium chloride";
        [drugs addObject:drug];
        
#pragma mark Sodium valproate
        drug = [[Drug alloc] init];
        drug.name = @"Sodium valproate";
        [drugs addObject:drug];
        
#pragma mark Sucrose
        drug = [[Drug alloc] init];
        drug.name = @"Sucrose";
        [drugs addObject:drug];
        
#pragma mark Sytron
        drug = [[Drug alloc] init];
        drug.name = @"Sytron";
        [drugs addObject:drug];
        
#pragma mark Tazocin
        drug = [[Drug alloc] init];
        drug.name = @"Tazocin";
        [drugs addObject:drug];
        
#pragma mark Teicoplanin
        drug = [[Drug alloc] init];
        drug.name = @"Teicoplanin";
        [drugs addObject:drug];
        
#pragma mark THAM
        drug = [[Drug alloc] init];
        drug.name = @"THAM";
        [drugs addObject:drug];
        
#pragma mark Thiopentone
        drug = [[Drug alloc] init];
        drug.name = @"Thiopentone";
        [drugs addObject:drug];
        
#pragma mark Tobramycin
        drug = [[Drug alloc] init];
        drug.name = @"Tobramycin";
        [drugs addObject:drug];
        
#pragma mark Trimethoprim
        drug = [[Drug alloc] init];
        drug.name = @"Trimethoprim";
        [drugs addObject:drug];
        
#pragma mark Thyroxine
        drug = [[Drug alloc] init];
        drug.name = @"Thyroxine (levothyroxine)";
        [drugs addObject:drug];
        
#pragma mark Ursodeoxycholic acid
        drug = [[Drug alloc] init];
        drug.name = @"Ursodeoxycholic acid";
        [drugs addObject:drug];
        
#pragma mark Vancomycin
        drug = [[Drug alloc] init];
        drug.name = @"Vancomycin";
        [drugs addObject:drug];
        
#pragma mark Vecuronium
        drug = [[Drug alloc] init];
        drug.name = @"Vecuronium";
        [drugs addObject:drug];
        
#pragma mark Vitamin D
        drug = [[Drug alloc] init];
        drug.name = @"Vitamin D";
        [drugs addObject:drug];
        
#pragma mark Vitamin K
        drug = [[Drug alloc] init];
        drug.name = @"Vitamin K";
        [drugs addObject:drug];
        
#pragma mark Zidovudine
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
