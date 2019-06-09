//
//  PlanetWrapper.swift
//  ARSolarSystem
//
//  Created by Vicentiu Petreaca on 09/06/2019.
//  Copyright © 2019 Vicentiu Petreaca. All rights reserved.
//

import ARKit

struct PlanetWrapper {
    let geometry: SCNGeometry
    let diffuse: UIImage
    let specular: UIImage?
    let emission: UIImage?
    let normal: UIImage?
    let position: SCNVector3
    
    var node: SCNNode {
        let planet = SCNNode(geometry: geometry)
        planet.geometry?.firstMaterial?.diffuse.contents = diffuse
        planet.geometry?.firstMaterial?.specular.contents = specular
        planet.geometry?.firstMaterial?.emission.contents = emission
        planet.geometry?.firstMaterial?.normal.contents = normal
        planet.position = position
        return planet
    }
}
