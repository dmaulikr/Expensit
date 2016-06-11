//
//  BSPieGraphControllerProtocol.swift
//  Expenses
//
//  Created by Borja Arias Drake on 05/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

protocol BSPieGraphControllerProtocol
{
    func sortedTagsByPercentageFromSections(tags: [Tag], sections : [AnyObject]?) -> [AnyObject]?
    func categoriesForMonth(month: NSNumber?, year : Int) -> [AnyObject]?
    func expensesByCategoryForMonth(month: NSNumber?, year : Int) -> [AnyObject]?
}