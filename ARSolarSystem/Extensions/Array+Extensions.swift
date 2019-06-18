//
//  Array+Extensions.swift
//  ARSolarSystem
//
//  Created by Vicentiu Petreaca on 18/06/2019.
//  Copyright © 2019 Vicentiu Petreaca. All rights reserved.
//

import SceneKit

extension Array where Element == SCNNode {
    subscript(_ idx: PlanetIndex) -> Element {
        return self[idx.rawValue]
    }
}
