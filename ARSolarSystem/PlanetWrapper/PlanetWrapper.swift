//
//  PlanetWrapper.swift
//  ARSolarSystem
//
//  Created by Vicentiu Petreaca on 09/06/2019.
//  Copyright © 2019 Vicentiu Petreaca. All rights reserved.
//

import ARKit

class PlanetWrapper: SCNNode {
    private let underlyingModel: PlanetModel

    var id: String {
        return underlyingModel.id
    }

    init(geometry: SCNGeometry,
         diffuse: UIImage,
         specular: UIImage? = nil,
         emission: UIImage? = nil,
         normal: UIImage? = nil,
         position: SCNVector3,
         model: PlanetModel) {
        self.underlyingModel = model
        super.init()
        self.geometry = geometry
        self.position = position
        self.geometry?.firstMaterial?.diffuse.contents = diffuse
        self.geometry?.firstMaterial?.specular.contents = specular
        self.geometry?.firstMaterial?.emission.contents = emission
        self.geometry?.firstMaterial?.normal.contents = normal
        self.name = model.name
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
