//
//  BSExpensesSummaryPieGraphPresenter.swift
//  Expenses
//
//  Created by Borja Arias Drake on 11/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

class BSExpensesSummaryPieGraphPresenter : NSObject, BSPieGraphPresenterProtocol
{
    let pieGraphController : BSPieGraphControllerProtocol
    let month : NSNumber?
    let year : NSNumber
    
    init(pieGraphController: BSPieGraphControllerProtocol, month: NSNumber?, year: NSNumber)
    {
        self.pieGraphController = pieGraphController
        self.month = month
        self.year = year
        super.init()
    }
    
    func categories() -> [AnyObject]? {
        let sections = self.sections()
        let categories = self.pieGraphController.categories(forMonth: self.month, year: self.year) as! [Tag]
        return self.pieGraphController.sortedTagsByPercentage(fromSections: categories, sections:sections)
    }
    
    func sections() -> [AnyObject]? {
        return self.pieGraphController.expensesByCategory(forMonth: self.month, year: self.year)
    }
}
