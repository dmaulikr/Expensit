//
//  BSExpensesSummaryPieGraphController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 11/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

class BSExpensesSummaryPieGraphController : BSAbstractShowEntriesController, BSPieGraphControllerProtocol {
 
    func sortedTagsByPercentageFromSections(tags: [Tag], sections : [AnyObject]?) -> [AnyObject]? {
        return self.coreDataController.sortedTagsByPercentageFromSections(tags, sections:sections)
    }
    
    // make month nil
    func categoriesForMonth(month: NSNumber?, year : Int) -> [AnyObject]? {
        return self.coreDataController.categoriesForMonth(month, inYear: year)
    }
    
    func expensesByCategoryForMonth(month: NSNumber?, year : Int) -> [AnyObject]? {
        return self.coreDataController.expensesByCategoryForMonth(month, inYear:year)
    }

}