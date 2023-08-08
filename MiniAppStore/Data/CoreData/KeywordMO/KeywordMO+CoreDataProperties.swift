//
//  KeywordMO+CoreDataProperties.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/01.
//
//

import Foundation
import CoreData


extension KeywordMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KeywordMO> {
        return NSFetchRequest<KeywordMO>(entityName: "Keyword")
    }

    @NSManaged public var value: String?

}

extension KeywordMO : Identifiable {

}
