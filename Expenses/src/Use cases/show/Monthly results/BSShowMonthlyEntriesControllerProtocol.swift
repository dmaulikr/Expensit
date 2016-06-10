//
//  BSShowMonthlyEntriesControllerProtocol.swift
//  Expenses
//
//  Created by Borja Arias Drake on 22/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

@objc protocol BSShowMonthlyEntriesControllerProtocol: BSAbstractShowEntriesControllerProtocol
{
    func expensesByCategoryForMonth(month: NSNumber?, year : Int) -> [AnyObject]?
    func sortedTagsByPercentageFromSections(tags: [Tag], sections : [AnyObject]?) -> [AnyObject]?
    func categoriesForMonth(month: NSNumber?, year : Int) -> [AnyObject]?
}