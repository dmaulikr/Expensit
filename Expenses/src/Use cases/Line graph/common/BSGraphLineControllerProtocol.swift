//
//  BSGraphLineControllerProtocol.swift
//  Expenses
//
//  Created by Borja Arias Drake on 05/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

@objc public protocol BSGraphLineControllerProtocol
{
    func abscissaValues() -> [NSDictionary]
    func graphSurplusResults(for section: String) -> [AnyObject]
    func graphExpensesResults(for section: String) -> [AnyObject]
}
