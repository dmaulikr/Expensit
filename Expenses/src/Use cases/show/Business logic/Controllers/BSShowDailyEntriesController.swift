//
//  BSShowDailyEntriesController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 21/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation



class BSShowDailyEntriesController: BSAbstractShowEntriesController {
    
    override func fetchRequest() -> NSFetchRequest {
        return self.coreDataController.fetchRequestForDaylySummary()
    }

    override func sectionNameKeyPath() -> String? {
        return "monthYear"
    }

    override func graphSurplusResultsForSection(section: String) -> [AnyObject] {
        let request = self.coreDataController.graphDailySurplusFetchRequestForSectionName(section)
        do {
            let output = try self.coreDataController.resultsForRequest(request)
            return output
        }
        catch {
            return []
        }

    }
    
    override func graphExpensesResultsForSection(section: String) -> [AnyObject] {
        let request = self.coreDataController.graphDailyExpensesFetchRequestForSectionName(section)
        do {
            let output = try self.coreDataController.resultsForRequest(request)
            return output
        }
        catch {
            return []
        }

    }

}