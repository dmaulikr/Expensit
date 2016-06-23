//
//  BSDailySummaryGraphLineController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 09/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation


@objc class BSDailySummaryGraphLineController: NSObject, BSCoreDataControllerProtocol, BSGraphLineControllerProtocol
{
    var coreDataStackHelper : CoreDataStackHelper
    var coreDataController : BSCoreDataController
    
    /// CoreDataController protocol
    required init(coreDataStackHelper : CoreDataStackHelper, coreDataController : BSCoreDataController)
    {
        self.coreDataStackHelper = coreDataStackHelper
        self.coreDataController = coreDataController
    }

    /// BSGraphLineControllerProtocol
    func abscissaValues() -> [NSDictionary] {
        return []
    }
    
    func graphSurplusResults(for section: String) -> [AnyObject] {
        let request = self.coreDataController.graphDailySurplusFetchRequest(forSectionName: section)
        
        do {
            let output = try self.coreDataController.results(for: request)
            return output
        }
        catch {
            return []
        }
    }
    
    func graphExpensesResults(for section: String) -> [AnyObject] {
        let request = self.coreDataController.graphDailyExpensesFetchRequest(forSectionName: section)
        do {
            let output = try self.coreDataController.results(for: request)
            return output
        }
        catch {
            return []
        }
        
    }
}
