//
//  BSExpensesSummaryPieGraphController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 11/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

class BSExpensesSummaryPieGraphController : BSAbstractShowEntriesController, BSPieGraphControllerProtocol {
 
    func sortedTagsByPercentage(fromSections tags: [Tag], sections : [AnyObject]?) -> [AnyObject]? {
        return self.coreDataController.sortedTagsByPercentage(fromSections: tags, sections:sections)
    }
    
    // make month nil
    func categories(forMonth month: NSNumber?, year : Int) -> [AnyObject]? {
        return self.coreDataController.categories(forMonth: month, inYear: year)
    }
    
    func expensesByCategory(forMonth month: NSNumber?, year : Int) -> [AnyObject]? {
        return self.coreDataController.expensesByCategory(forMonth: month, inYear:year)
    }

}
