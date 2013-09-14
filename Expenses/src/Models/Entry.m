//
//  Entry.m
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "Entry.h"
#import "DateTimeHelper.h"


@implementation Entry

@dynamic day, month, year;
@dynamic date;
@dynamic value;
@dynamic desc;
@dynamic monthYear, dayMonthYear, yearMonthDay;

- (NSString*) dayAndMonth
{
    return [NSString stringWithFormat:@"%d/%d", [self.day intValue], [self.month intValue]];
}



#pragma mark - Validation

-(BOOL)validateValue:(id *)ioValue error:(NSError **)outError {
    
    NSDecimalNumber *amount = (NSDecimalNumber *)(*ioValue);
    BOOL valid = (([amount compare:@0] != NSOrderedSame) && (![amount isEqualToNumber:[NSDecimalNumber notANumber]]));

    
    NSString *errorStr = NSLocalizedStringFromTable(
                                                    @"Amount can't be zero", @"Entry",
                                                    @"validation: zero amount error");
    NSDictionary *userInfoDict = @{ NSLocalizedDescriptionKey : errorStr };
    NSError *error = [[NSError alloc] initWithDomain:@"EntryErrorDomain"
                                                code:1
                                            userInfo:userInfoDict];
    *outError = error;
    
    return valid;
}

@end
