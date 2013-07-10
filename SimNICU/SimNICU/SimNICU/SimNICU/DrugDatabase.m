//
//  DrugDatabase.m
//  SimNICU
//
//  Created by Conrad Bosman on 05/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "DrugDatabase.h"
#import "DrugCategory.h"
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
        // Portion *portion;
        // NSMutableArray *portions;
      
#pragma mark - ALL DRUGS
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Drugs";
        
        // create array
        NSMutableArray *drugs = [[NSMutableArray alloc] initWithCapacity:10];
        
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
        drug.name = @"Benzylpenicillin";
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
        drug.name = @"Daktarin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Dexamethasone";
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
        drug.name = @"Gentamicin";
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
        drug.name = @"Meropenem";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Midazolam";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Milrinone";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Nystatin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Pancuronium";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Paracetamol";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Phenobarbitone";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Piperacillin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Potassium chloride";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Pyridoxine";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Magnesium";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Morphine";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Naloxone";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Nitrous oxide";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Nystatin";
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
        drug.name = @"Sodium bicarbonate";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Sodium chloride";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Sucrose";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Teicoplanin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Thiopentone";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Trimethoprim";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Thyroxine (levothyroxine)";
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
        drug.name = @"Vitamin K";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Vitamins (Multivitamins)";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Zidovudine";
        [drugs addObject:drug];
        
        // Add array to drugs
        drugCategory.drugs = drugs;
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - FAVOURITES
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Favourites";
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - ANALGESIA
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Analgesia";
        
        // create array
        drugs = [[NSMutableArray alloc] initWithCapacity:10];
        
        drug = [[Drug alloc] init];
        drug.name = @"Paracetamol";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Morphine";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Sucrose";
        [drugs addObject:drug];
        
        // Add array to drugs
        drugCategory.drugs = drugs;
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - ANTIBIOTIC
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Antibiotics & Sepsis";
        
        // create array
        drugs = [[NSMutableArray alloc] initWithCapacity:10];
        
        drug = [[Drug alloc] init];
        drug.name = @"Benzylpenicillin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Flucloxacillin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Gentamicin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Meropenem";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Piperacillin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Teicoplanin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Vancomycin";
        [drugs addObject:drug];
        
        // Add array to drugs
        drugCategory.drugs = drugs;
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - ANTICONVULSIVE
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Anticonvulsive";
        
        // create array
        drugs = [[NSMutableArray alloc] initWithCapacity:10];
        
        drug = [[Drug alloc] init];
        drug.name = @"Lignocaine";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Lorazepam";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Midazolam";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Phenobarbitone";
        [drugs addObject:drug];
        
        // Add array to drugs
        drugCategory.drugs = drugs;
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - ANTIVIRAL
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Antiviral";
        
        // create array
        drugs = [[NSMutableArray alloc] initWithCapacity:10];
        
        drug = [[Drug alloc] init];
        drug.name = @"Aciclovir";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Ganciclovir";
        [drugs addObject:drug];
        
        // Add array to drugs
        drugCategory.drugs = drugs;
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - ANTIEPILEPTICS
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Antiepileptics";
        
        // create array
        drugs = [[NSMutableArray alloc] initWithCapacity:10];
        
        drug = [[Drug alloc] init];
        drug.name = @"Lignocaine";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Midazolam";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Phenobarbitone";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Thiopentone";
        [drugs addObject:drug];
        
        // Add array to drugs
        drugCategory.drugs = drugs;
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - ANTIFUNGAL
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Antifungal";
        
        // create array
        drugs = [[NSMutableArray alloc] initWithCapacity:10];
        
        drug = [[Drug alloc] init];
        drug.name = @"Amphotericin B";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Daktarin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Nystatin";
        [drugs addObject:drug];
        
        // Add array to drugs
        drugCategory.drugs = drugs;
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - CARDIAC
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Cardiac";
        
        // create array
        drugs = [[NSMutableArray alloc] initWithCapacity:10];
        
        drug = [[Drug alloc] init];
        drug.name = @"Adenosine";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Alprostadil";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Atropine";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Captopril";
        [drugs addObject:drug];
        
        // Add array to drugs
        drugCategory.drugs = drugs;
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - ELECTROLYTES
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Electrolytes";
        
        // create array
        drugs = [[NSMutableArray alloc] initWithCapacity:10];
        
        drug = [[Drug alloc] init];
        drug.name = @"Sodium Chloride";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Potassium Chloride";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Calcium Chloride";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Magnesium";
        [drugs addObject:drug];
        
        // Add array to drugs
        drugCategory.drugs = drugs;
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - GALACTAGOGUES
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Galactagogues";
        
        // create array
        drugs = [[NSMutableArray alloc] initWithCapacity:10];
        
        drug = [[Drug alloc] init];
        drug.name = @"Domperidone";
        [drugs addObject:drug];
        
        // Add array to drugs
        drugCategory.drugs = drugs;
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - GASTRO
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Gastrointestinal";
        
        // create array
        drugs = [[NSMutableArray alloc] initWithCapacity:10];
        
        drug = [[Drug alloc] init];
        drug.name = @"Domperidone";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Ursodeoxycholic acid";
        [drugs addObject:drug];
        
        // Add array to drugs
        drugCategory.drugs = drugs;
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - HIV
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"HIV";
        
        // create array
        drugs = [[NSMutableArray alloc] initWithCapacity:10];
        
        drug = [[Drug alloc] init];
        drug.name = @"Zidovudine";
        [drugs addObject:drug];
        
        // Add array to drugs
        drugCategory.drugs = drugs;
        
        [self.drugCategories addObject:drugCategory];
   
#pragma mark - IMMUNOGLOBULINS
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Immunoglobulins";
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - INOTROPES
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Inotropes";
        
        // create array
        drugs = [[NSMutableArray alloc] initWithCapacity:10];
        
        drug = [[Drug alloc] init];
        drug.name = @"Adrenaline";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Dobutamine";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Dopamine";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Calcium gluconate";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Milrinone";
        [drugs addObject:drug];
        
        // Add array to drugs
        drugCategory.drugs = drugs;
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - MUSCLE RELAXANTS
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Muscle Relaxants";
        
        // create array
        drugs = [[NSMutableArray alloc] initWithCapacity:10];
        
        drug = [[Drug alloc] init];
        drug.name = @"Atracurium";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Pancuronium";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Vecuronium";
        [drugs addObject:drug];
        
        // Add array to drugs
        drugCategory.drugs = drugs;
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - NUTRITIONAL SUPPLEMENTS
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Nutritional Supplements";
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - PDA
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Patent ductus arteriosus";
        
        // create array
        drugs = [[NSMutableArray alloc] initWithCapacity:10];
        
        drug = [[Drug alloc] init];
        drug.name = @"Ibuprofen";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Indomethancin";
        [drugs addObject:drug];
        
        // Add array to drugs
        drugCategory.drugs = drugs;
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - SEDATIVES
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Sedatives";
        
        // create array
        drugs = [[NSMutableArray alloc] initWithCapacity:10];
        
        drug = [[Drug alloc] init];
        drug.name = @"Fentanyl";
        [drugs addObject:drug];
        
        // Add array to drugs
        drugCategory.drugs = drugs;
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - SURFACTANT
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Surfactant";
        
        // create array
        drugs = [[NSMutableArray alloc] initWithCapacity:10];
        
        drug = [[Drug alloc] init];
        drug.name = @"Curosurf\u00AE";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Survanta\u00AE";
        [drugs addObject:drug];
        
        // Add array to drugs
        drugCategory.drugs = drugs;
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - VACINES
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Vaccines";
        
        // create array
        drugs = [[NSMutableArray alloc] initWithCapacity:10];
        
        drug = [[Drug alloc] init];
        drug.name = @"Haemophilus influenza (Hib)";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Hepatitis B";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Rotavirus";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Whooping cough";
        [drugs addObject:drug];
        
        // Add array to drugs
        drugCategory.drugs = drugs;
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - VITAMINS
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Vitamins";
        
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
