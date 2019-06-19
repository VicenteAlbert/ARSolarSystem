//
//  PlanetModel.swift
//  ARSolarSystem
//
//  Created by Vicentiu Petreaca on 18/06/2019.
//  Copyright © 2019 Vicentiu Petreaca. All rights reserved.
//

import CoreData

struct PlanetModel: Decodable {
    let id: String, name: String, details: String, url: String, order: Int
}

extension PlanetModel {
    init(from dbObject: Planet) {
        self.id = dbObject.id
        self.name = dbObject.name
        self.details = dbObject.details
        self.url = dbObject.url
        self.order = Int(dbObject.order)
    }
}
