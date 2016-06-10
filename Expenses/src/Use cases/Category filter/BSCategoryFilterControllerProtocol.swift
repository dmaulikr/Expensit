//
//  BSCategoryFilterControllerProtocol.swift
//  Expenses
//
//  Created by Borja Arias Drake on 09/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

@objc protocol BSCategoryFilterControllerProtocol {

    func allTags() -> [Tag]
    func allTagsImages() -> [UIImage]
}