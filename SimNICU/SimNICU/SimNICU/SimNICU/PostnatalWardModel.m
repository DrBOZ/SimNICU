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
    problem = NSLocalizedString(@"Anorectal Malformations", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Ambiguous Genitalia", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"BCG Vaccination", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Blood in the nappy", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Brachial Nerve Palsies", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Breast Swelling / Mastitis", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Breast Feeding", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Cardiac Arrhythmia", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Cleft Lip & Palate", nil);
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
    
    problem = NSLocalizedString(@"Heart Murmurs", nil);
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
    
    problem = NSLocalizedString(@"Opiate Withdrawl / NAS", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Patau's Syndrome", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Polydactyly", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Polyhydraminios", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Preauricular Skin Tags", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Prolonged Rupture of Membranes (PROM)", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Pyrexia", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Rashes", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Red Reflexes", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Sacral Dimple", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Scalp Swelling", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Single Palmar Crease", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Sticky Eyes", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Sticky Umbilicus", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Tachypnoea", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Talipes", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Testicular swelling", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Thrombocytopenia", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Thyroid Disease (Maternal)", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Tongue Tie", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Two Vessels in Cord", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Undescended Testes", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Vitamin K", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Vomiting", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Weight Loss", nil);
    [problems addObject:problem];
    
    // alphebetise the array based on the problem string value
    NSArray *sortedProblems;
    
    sortedProblems = [problems sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
                     {
                         NSString *first = (NSString *)a;
                         NSString *second = (NSString *)b;
                         return [first compare:second];
                     }];
    
    problems = [NSMutableArray arrayWithArray:sortedProblems];
    
    return problems;
}

@end
