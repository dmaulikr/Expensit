//
//  BSMonthlySummaryGraphLineController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 08/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

@objc class BSMonthlySummaryGraphLineController: BSAbstractShowEntriesController, BSGraphLineControllerProtocol
{
    func abscissaValues() -> [NSDictionary] {
        return []
    }
    
    func graphSurplusResultsForSection(section: String) -> [AnyObject] {
        let request = self.coreDataController.graphMonthlySurplusFetchRequestForSectionName(section)
        
        do {
            let output = try self.coreDataController.resultsForRequest(request)
            return output
        }
        catch {
            return []
        }
    }
    
    func graphExpensesResultsForSection(section: String) -> [AnyObject] {
        let request = self.coreDataController.graphMonthlyExpensesFetchRequestForSectionName(section)
        do {
            let output = try self.coreDataController.resultsForRequest(request)
            return output
        }
        catch {
            return []
        }
        
    }    
}