//
//  BSYearlySummaryGraphLineController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 05/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

@objc class BSYearlySummaryGraphLineController: BSAbstractShowEntriesController, BSGraphLineControllerProtocol
{
    override func abscissaValues() -> [NSDictionary] {
        let request = self.coreDataController.requestToGetYears()
        
        do {
            let output = try self.coreDataController.resultsForRequest(request)
            return output as! [NSDictionary]
        }
        catch {
            return []
        }
    }
    
    override func graphSurplusResultsForSection(section: String) -> [AnyObject] {
        let request = self.coreDataController.graphYearlySurplusFetchRequest()
        do {
            let output = try self.coreDataController.resultsForRequest(request)
            return output
        }
        catch {
            return []
        }        
    }
    
    override func graphExpensesResultsForSection(section: String) -> [AnyObject] {
        let request = self.coreDataController.graphYearlyExpensesFetchRequest()
        do {
            let output = try self.coreDataController.resultsForRequest(request)
            return output
        }
        catch {
            return []
        }
    }

    
}