//
//  BSPieGraphControllerProtocol.swift
//  Expenses
//
//  Created by Borja Arias Drake on 05/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

protocol BSPieGraphControllerProtocol
{
    func sortedTagsByPercentage(fromSections tags: [Tag], sections : [AnyObject]?) -> [AnyObject]?
    func categories(forMonth month: NSNumber?, year : Int) -> [AnyObject]?
    func expensesByCategory(forMonth month: NSNumber?, year : Int) -> [AnyObject]?
}
