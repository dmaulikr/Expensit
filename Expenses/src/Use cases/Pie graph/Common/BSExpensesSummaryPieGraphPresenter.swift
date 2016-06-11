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
    let year : Int
    
    init(pieGraphController: BSPieGraphControllerProtocol, month: NSNumber?, year: Int)
    {
        self.pieGraphController = pieGraphController
        self.month = month
        self.year = year
        super.init()
    }
    
    func categories() -> [AnyObject]? {
        let sections = self.sections()
        let categories = self.pieGraphController.categoriesForMonth(self.month, year: self.year) as! [Tag]
        return self.pieGraphController.sortedTagsByPercentageFromSections(categories, sections:sections)
    }
    
    func sections() -> [AnyObject]? {
        return self.pieGraphController.expensesByCategoryForMonth(self.month, year: self.year)
    }
}