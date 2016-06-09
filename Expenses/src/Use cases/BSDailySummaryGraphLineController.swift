//
//  BSDailySummaryGraphLineController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 09/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation


@objc class BSDailySummaryGraphLineController: BSAbstractShowEntriesController, BSGraphLineControllerProtocol
{
    override func abscissaValues() -> [NSDictionary] {
        return []
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