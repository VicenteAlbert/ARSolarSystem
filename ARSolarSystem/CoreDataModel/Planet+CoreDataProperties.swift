//
//  Planet+CoreDataProperties.swift
//  ARSolarSystem
//
//  Created by Vicentiu Petreaca on 19/06/2019.
//  Copyright © 2019 Vicentiu Petreaca. All rights reserved.
//
//

import Foundation
import CoreData


extension Planet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Planet> {
        return NSFetchRequest<Planet>(entityName: "Planet")
    }

    @NSManaged public var details: String
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var url: String
    @NSManaged public var order: Int16

}
