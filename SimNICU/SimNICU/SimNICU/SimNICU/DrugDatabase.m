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
        drugCategory.name = @"All Drugs";
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - FAVOURITES
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Favourites";
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - ANALGESICS
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Analgesics";
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark ANTIBIOTICS
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Antibiotics";
        
        // create array
        NSMutableArray *drugs = [[NSMutableArray alloc] initWithCapacity:10];
        
        drug = [[Drug alloc] init];
        drug.name = @"Benzylpenicillin";
        [drugs addObject:drug];
        
        drug = [[Drug alloc] init];
        drug.name = @"Gentamicin";
        [drugs addObject:drug];
        
        // Add array to drugs
        drugCategory.drugs = drugs;
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - ANTIVIRALS
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Antivirals";
        
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
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - CREAMS & LOTIONS
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Creams & Lotions";
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - DIURETICS
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Diuretics";
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - ELECTROLYTES
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Electrolytes";
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - GALACTAGOGUES
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Galactagogues";
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - HIV
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"HIV";
        
        [self.drugCategories addObject:drugCategory];
   
#pragma mark - IMMUNOGLOBULINS
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Immunoglobulins";
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - INOTROPES
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Inotropes";
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - MUSCLE RELAXANTS
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Muscle Relaxants";
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - NUTRITIONAL SUPPLEMENTS
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Nutritional Supplements";
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - PDA
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"PDA Prophylaxis";
        
        [self.drugCategories addObject:drugCategory];
        
#pragma mark - SURFACTANTS
        
        drugCategory = [[DrugCategory alloc] init];
        drugCategory.name = @"Surfactants";
        
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
