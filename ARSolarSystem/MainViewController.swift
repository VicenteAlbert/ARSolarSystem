//
//  ViewController.swift
//  ARSolarSystem
//
//  Created by Vicentiu Petreaca on 09/06/2019.
//  Copyright © 2019 Vicentiu Petreaca. All rights reserved.
//

import UIKit
import ARKit
import CoreData

enum PlanetIndex: Int, CaseIterable {
    case mercury = 0, venus, earth, mars, jupiter, saturn, uranus, neptune, sun, moon
}

class MainViewController: UIViewController {
    private var planets = [PlanetModel]()

    let configuration = ARWorldTrackingConfiguration()

    @IBOutlet weak var sceneView: ARSCNView!

    @IBAction func tapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let location = sender.location(in: sceneView)
            let hits = sceneView.hitTest(location, options: nil)
            if hits.isEmpty == false,
                let planet = hits.first?.node as? PlanetWrapper {
                performSegue(withIdentifier: "showDetails", sender: planet.id)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        AVCaptureDevice.requestAccess(for: .video) {
            if $0 {
                do {
                    if let cdPlanets = try context.fetch(Planet.fetchRequest()) as? [Planet] {
                        self.planets = cdPlanets.map(PlanetModel.init).sorted { $0.order < $1.order }
                    }
                } catch {
                    print("Failed")
                }
                self.sceneView.session.run(self.configuration)
                self.sceneView.autoenablesDefaultLighting = true
                self.addPlanets()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = sender as? String else { return }
        let destinationNav = segue.destination as! UINavigationController
        let detailsVC = destinationNav.viewControllers.first as! DetailsViewController
        detailsVC.planetId = id
    }
    
    private func addPlanets() {
        let zPos: Double = -5
        let yPos: Double = -1
        let sun = PlanetWrapper(geometry: SCNSphere(radius: 0.69), diffuse: #imageLiteral(resourceName: "Sun diffuse"), position: SCNVector3(0, yPos, zPos), model: planets[.sun])
        sun.runAction(rotation(time: 3))
        sceneView.scene.rootNode.addChildNode(sun)
        animateIn(node: sun, duration: 0.5)

        let planetDict = PlanetIndex.allCases.reduce(into: [PlanetIndex: (parent: SCNNode, wrapper: PlanetWrapper)]()) {
            let model = planets[$1]
            switch $1 {
            case .mercury:
                $0[$1] = (SCNNode(), PlanetWrapper(geometry: SCNSphere(radius: 0.24),
                                                  diffuse: #imageLiteral(resourceName: "Mercury Surface"),
                                                  position: SCNVector3(1.25, yPos, zPos),
                                                  model: model))
            case .venus:
                $0[$1] = (SCNNode(), PlanetWrapper(geometry: SCNSphere(radius: 0.6),
                                                   diffuse: #imageLiteral(resourceName: "Venus Surface"),
                                                   emission: #imageLiteral(resourceName: "Venus Atmosphere"),
                                                   position: SCNVector3(2.5, yPos, zPos),
                                                   model: model))
            case .earth:
                $0[$1] = (SCNNode(), PlanetWrapper(geometry: SCNSphere(radius: 0.63),
                                                   diffuse: #imageLiteral(resourceName: "Earth day"),
                                                   specular: #imageLiteral(resourceName: "Earth Specular"),
                                                   emission: #imageLiteral(resourceName: "Earth Emission"),
                                                   normal: #imageLiteral(resourceName: "Earth Normal"),
                                                   position: SCNVector3(4.75, yPos, zPos),
                                                   model: model))
            case .moon:
                $0[$1] = (SCNNode(), PlanetWrapper(geometry: SCNSphere(radius: 0.25),
                                                   diffuse: #imageLiteral(resourceName: "moon Diffuse"),
                                                   position: SCNVector3(0, 0.25, -1),
                                                   model: model))
            case .mars:
                $0[$1] = (SCNNode(), PlanetWrapper(geometry: SCNSphere(radius: 0.33),
                                                   diffuse: #imageLiteral(resourceName: "Mars Surface"),
                                                   position: SCNVector3(7.2, yPos, zPos),
                                                   model: model))
            case .jupiter:
                $0[$1] = (SCNNode(), PlanetWrapper(geometry: SCNSphere(radius: 0.69),
                                                   diffuse: #imageLiteral(resourceName: "Jupiter Surface"),
                                                   position: SCNVector3(8.6, yPos, zPos),
                                                   model: model))
            case .saturn:
                $0[$1] = (SCNNode(), PlanetWrapper(geometry: SCNSphere(radius: 0.6),
                                                   diffuse: #imageLiteral(resourceName: "Saturn Surface"),
                                                   position: SCNVector3(10, yPos, zPos),
                                                   model: model))
            case .uranus:
                $0[$1] = (SCNNode(), PlanetWrapper(geometry: SCNSphere(radius: 0.25),
                                                   diffuse: #imageLiteral(resourceName: "Uranus Surface"),
                                                   position: SCNVector3(10.5, yPos, zPos),
                                                   model: model))
            case .neptune:
                $0[$1] = (SCNNode(), PlanetWrapper(geometry: SCNSphere(radius: 0.24),
                                                   diffuse: #imageLiteral(resourceName: "Neptune Surface"),
                                                   position: SCNVector3(11, yPos, zPos),
                                                   model: model))
            case .sun: break
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

        // Earth specific due to the Moon
        planetDict[.earth]?.parent.addChildNode(planetDict[.moon]!.parent)
        planetDict[.earth]?.wrapper.addChildNode(planetDict[.moon]!.wrapper)

        // Saturn specific
        let ring = SCNTorus(ringRadius: 0.7, pipeRadius: 0.1)
        ring.materials.first?.diffuse.contents = #imageLiteral(resourceName: "Saturn Ring Surface")
        let torusNode = SCNNode(geometry: ring)
        planetDict[.saturn]?.wrapper.addChildNode(torusNode)

        planetDict.forEach { animateIn(node: $0.value.wrapper) }
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
