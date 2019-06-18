//
//  ViewController.swift
//  ARSolarSystem
//
//  Created by Vicentiu Petreaca on 09/06/2019.
//  Copyright © 2019 Vicentiu Petreaca. All rights reserved.
//

import UIKit
import ARKit

enum PlanetIndex: Int, CaseIterable {
    case mercury = 0, venus, earth, moon, mars, jupiter, saturn, uranus, neptune
}

class MainViewController: UIViewController {
    let configuration = ARWorldTrackingConfiguration()

    @IBOutlet weak var sceneView: ARSCNView!

    @IBAction func tapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let location = sender.location(in: sceneView)
            let hits = sceneView.hitTest(location, options: nil)
            if hits.isEmpty == false,
                let planet = hits.first?.node as? PlanetWrapper {
                print(planet.id, planet.name)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        AVCaptureDevice.requestAccess(for: .video) {
            if $0 {
                self.sceneView.session.run(self.configuration)
                self.sceneView.autoenablesDefaultLighting = true
                self.addPlanets()
            }
        }
    }
    
    func addPlanets() {
        let zPos: Double = -5
        let yPos: Double = -1
        let sun = PlanetWrapper(geometry: SCNSphere(radius: 0.69), diffuse: #imageLiteral(resourceName: "Sun diffuse"), position: SCNVector3(0, yPos, zPos), model: models[0])
        sceneView.scene.rootNode.addChildNode(sun)
        animateIn(node: sun, duration: 0.5)

        let planetDict = PlanetIndex.allCases.reduce(into: [PlanetIndex: (parent: SCNNode, wrapper: PlanetWrapper)]()) {
            switch $1 {
            case .mercury:
                $0[$1] = (SCNNode(), PlanetWrapper(geometry: SCNSphere(radius: 0.24),
                                                  diffuse: #imageLiteral(resourceName: "Mercury Surface"),
                                                  position: SCNVector3(1.25, yPos, zPos),
                                                  model: PlanetModel(id: "0", name: "Mercury")))
            case .venus:
                $0[$1] = (SCNNode(), PlanetWrapper(geometry: SCNSphere(radius: 0.6),
                                                   diffuse: #imageLiteral(resourceName: "Venus Surface"),
                                                   emission: #imageLiteral(resourceName: "Venus Atmosphere"),
                                                   position: SCNVector3(2.5, yPos, zPos),
                                                   model: models[1]))
            case .earth:
                $0[$1] = (SCNNode(), PlanetWrapper(geometry: SCNSphere(radius: 0.63),
                                                   diffuse: #imageLiteral(resourceName: "Earth day"),
                                                   specular: #imageLiteral(resourceName: "Earth Specular"),
                                                   emission: #imageLiteral(resourceName: "Earth Emission"),
                                                   normal: #imageLiteral(resourceName: "Earth Normal"),
                                                   position: SCNVector3(4.75, yPos, zPos),
                                                   model: models[2]))
            case .moon:
                $0[$1] = (SCNNode(), PlanetWrapper(geometry: SCNSphere(radius: 0.25),
                                                   diffuse: #imageLiteral(resourceName: "moon Diffuse"),
                                                   position: SCNVector3(0, 0.25, -1),
                                                   model: models[3]))
            case .mars:
                $0[$1] = (SCNNode(), PlanetWrapper(geometry: SCNSphere(radius: 0.33),
                                                   diffuse: #imageLiteral(resourceName: "Mars Surface"),
                                                   position: SCNVector3(7.2, yPos, zPos),
                                                   model: PlanetModel(id: "0", name: "Mars")))
            case .jupiter:
                $0[$1] = (SCNNode(), PlanetWrapper(geometry: SCNSphere(radius: 0.69),
                                                   diffuse: #imageLiteral(resourceName: "Jupiter Surface"),
                                                   position: SCNVector3(8.6, yPos, zPos),
                                                   model: PlanetModel(id: "3", name: "Jupiter")))
            case .saturn:
                $0[$1] = (SCNNode(), PlanetWrapper(geometry: SCNSphere(radius: 0.6),
                                                   diffuse: #imageLiteral(resourceName: "Saturn Surface"),
                                                   position: SCNVector3(10, yPos, zPos),
                                                   model: PlanetModel(id: "63", name: "Saturn")))
            case .uranus:
                $0[$1] = (SCNNode(), PlanetWrapper(geometry: SCNSphere(radius: 0.25),
                                                   diffuse: #imageLiteral(resourceName: "Uranus Surface"),
                                                   position: SCNVector3(10.5, yPos, zPos),
                                                   model: PlanetModel(id: "323", name: "Uranus")))
            case .neptune:
                $0[$1] = (SCNNode(), PlanetWrapper(geometry: SCNSphere(radius: 0.24),
                                                   diffuse: #imageLiteral(resourceName: "Neptune Surface"),
                                                   position: SCNVector3(11, yPos, zPos),
                                                   model: PlanetModel(id: "36", name: "Neptune")))
            }
        }

        planetDict[.moon]?.parent.position = SCNVector3(1.2, 0, 0)

        planetDict
            .filter { $0.key != .moon }
            .forEach { sceneView.scene.rootNode.addChildNode($0.value.parent) }

        createPlanet(.mercury, from: planetDict, selfRotation: rotation(time: 3), axisRotation: rotation(time: 7))
        createPlanet(.venus, from: planetDict, selfRotation: rotation(time: 4), axisRotation: rotation(time: 7))
        createPlanet(.earth, from: planetDict, selfRotation: rotation(time: 5), axisRotation: rotation(time: 9))
        createPlanet(.moon, from: planetDict, selfRotation: rotation(time: 5), axisRotation: rotation(time: 5))
        createPlanet(.mars, from: planetDict, selfRotation: rotation(time: 6), axisRotation: rotation(time: 11))
        createPlanet(.jupiter, from: planetDict, selfRotation: rotation(time: 7), axisRotation: rotation(time: 13))
        createPlanet(.saturn, from: planetDict, selfRotation: rotation(time: 8), axisRotation: rotation(time: 15))
        createPlanet(.uranus, from: planetDict, selfRotation: rotation(time: 8), axisRotation: rotation(time: 17))
        createPlanet(.neptune, from: planetDict, selfRotation: rotation(time: 8), axisRotation: rotation(time: 19))

        planetDict.forEach { animateIn(node: $0.value.wrapper) }

        let sunRotation = rotation(time: 3)
        sun.runAction(sunRotation)

        planetDict[.earth]?.parent.addChildNode(planetDict[.moon]!.parent)
        planetDict[.earth]?.wrapper.addChildNode(planetDict[.moon]!.wrapper)
    }

    private func createPlanet(
        _ `enum`: PlanetIndex,
        from dict: [PlanetIndex: (parent: SCNNode, wrapper: PlanetWrapper)],
        selfRotation: SCNAction,
        axisRotation: SCNAction) {
        dict[`enum`]?.wrapper.runAction(selfRotation)
        dict[`enum`]?.parent.runAction(axisRotation)
        dict[`enum`]?.parent.addChildNode(dict[`enum`]!.wrapper)
    }

    private func animateIn(node: SCNNode?, duration: Double = 1) {
        node?.opacity = 0
        node?.runAction(.fadeIn(duration: duration))
    }
    
    private func rotation(time: TimeInterval) -> SCNAction {
        let rotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: time * 2)
        return SCNAction.repeatForever(rotation)
    }
}
