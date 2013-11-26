//
//  PostnatalWardModel.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 26/11/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "PostnatalWardModel.h"

@implementation PostnatalWardModel

+ (NSArray *)getListOfPostnatalWardProblems
{
    NSMutableArray *problems = [[NSMutableArray alloc] initWithCapacity:50];
    
    NSString *problem;
    
    // populate array of problems, in alphabetical order
    problem = NSLocalizedString(@"Anorectal malformations", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Ambiguous genitalia", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"BCG vaccination", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Blood in the nappy", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Brachial nerve palsies", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Breast swelling / mastitis", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Breast Feeding", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Cardiac arrhythmia", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Cleft lip & palate", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Cyanosis", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Down's Syndrome", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Edward's Syndrome", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Group B Strep (Maternal)", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Grunting", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Heart murmurs", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Hepatitis B", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Hip Problems", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Hydronephrosis", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Hypoglycaemia", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Hypospadias", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Hypothermia", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Hypotonia", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Irritability", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Jaundice", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Jittery", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Limb Abnormalities", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Natal Teeth", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Noisy Breathing", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Offensive Liquor", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Opiate withdrawl / NAS", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Patau's Syndrome", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Polydactyly", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Polyhydraminios", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Preauricular skin tags", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Prolonged rupture of membranes (PROM)", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Pyrexia", nil);
    [problems addObject:problem];
    
    problem = @"Rashes";
    [problems addObject:problem];
    
    problem = @"Red Reflexes";
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Sacral Dimple", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Scalp Swelling", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Single palmar crease", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Sticky eyes", nil);
    [problems addObject:problem];
    
    problem = @"Sticky Umbilicus";
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Tachypnoea", nil);
    [problems addObject:problem];
    
    problem = @"Talipes";
    [problems addObject:problem];
    
    problem = @"Testicular Swelling";
    [problems addObject:problem];
    
    problem = @"Thrombocytopenia";
    [problems addObject:problem];
    
    problem = @"Thyroid Disease (Maternal)";
    [problems addObject:problem];
    
    problem = @"Tongue Tie";
    [problems addObject:problem];
    
    problem = @"Two Vessels in Cord";
    [problems addObject:problem];
    
    problem = @"Undescended Testes";
    [problems addObject:problem];
    
    problem = @"Vitamin K";
    [problems addObject:problem];
    
    problem = @"Vomiting";
    [problems addObject:problem];
    
    problem = @"Weight Loss";
    [problems addObject:problem];
    
    // need to alphabetise
    
    return problems;
}

@end
