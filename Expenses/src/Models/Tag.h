//
//  Tag.h
//  Expenses
//
//  Created by Borja Arias Drake on 12/10/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>


@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * name;

@property (nonatomic, copy) NSString * iconImageName;

@property (nonatomic, strong) UIColor *color;

@end
