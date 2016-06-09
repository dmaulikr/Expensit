//
//  BSShowMonthlyEntriesController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 21/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation


class BSShowMonthlyEntriesController: BSAbstractShowEntriesController, BSShowMonthlyEntriesControllerProtocol {
    
    override func fetchRequest() -> NSFetchRequest {
        return self.coreDataController.fetchRequestForMonthlySummary()
    }

    override func sectionNameKeyPath() -> String? {
        return "year"
    }
        
    func expensesByCategoryForMonth(month: NSNumber?, year : Int) -> [AnyObject]? {
        return self.coreDataController.expensesByCategoryForMonth(month, inYear:year)
    }
    
    func sortedTagsByPercentageFromSections(tags: [Tag], sections : [AnyObject]?) -> [AnyObject]? {
        return self.coreDataController.sortedTagsByPercentageFromSections(tags, sections:sections)
    }
    
    // make month nil
    func categoriesForMonth(month: NSNumber?, year : Int) -> [AnyObject]? {
        return self.coreDataController.categoriesForMonth(month, inYear: year)
    }

}