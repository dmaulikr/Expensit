//
//  BSYearlySummaryGraphLineController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 05/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

@objc class BSYearlySummaryGraphLineController: NSObject, BSCoreDataControllerProtocol, BSGraphLineControllerProtocol
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
        let request = self.coreDataController.requestToGetYears()
        
        do {
            let output = try self.coreDataController.results(for: request)
            return output as! [NSDictionary]
        }
        catch {
            return []
        }
    }
    
    func graphSurplusResults(for section: String) -> [AnyObject] {
        let request = self.coreDataController.graphYearlySurplusFetchRequest()
        do {
            let output = try self.coreDataController.results(for: request)
            return output
        }
        catch {
            return []
        }        
    }
    
    func graphExpensesResults(for section: String) -> [AnyObject] {
        let request = self.coreDataController.graphYearlyExpensesFetchRequest()
        do {
            let output = try self.coreDataController.results(for: request)
            return output
        }
        catch {
            return []
        }
    }

    
}
