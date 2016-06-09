//
//  BSGraphLineControllerProtocol.swift
//  Expenses
//
//  Created by Borja Arias Drake on 05/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

protocol BSGraphLineControllerProtocol
{
    func abscissaValues() -> [NSDictionary]
    func graphSurplusResultsForSection(section: String) -> [AnyObject]
    func graphExpensesResultsForSection(section: String) -> [AnyObject]
}