//
//  ViewController.swift
//  ARSolarSystem
//
//  Created by Vicentiu Petreaca on 09/06/2019.
//  Copyright © 2019 Vicentiu Petreaca. All rights reserved.
//

import UIKit
import ARKit
class MainViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        AVCaptureDevice.requestAccess(for: .video) {
            if $0 {
                self.sceneView.session.run(self.configuration)
                self.sceneView.autoenablesDefaultLighting = true
                self.addPlanets()
            }
        }
    }
    
    func addPlanets() {
        let sun = SCNNode(geometry: SCNSphere(radius: 0.35))
        let earthParent = SCNNode()
        let venusParent = SCNNode()
        let moonParent = SCNNode()
        
        sun.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Sun diffuse")
        sun.position = SCNVector3(0,0,-1)
        earthParent.position = SCNVector3(0,0,-1)
        venusParent.position = SCNVector3(0,0,-1)
        moonParent.position = SCNVector3(1.2 ,0 , 0)
        
        sceneView.scene.rootNode.addChildNode(sun)
        sceneView.scene.rootNode.addChildNode(earthParent)
        sceneView.scene.rootNode.addChildNode(venusParent)
        
        
        let earthWrapper = PlanetWrapper(geometry: SCNSphere(radius: 0.2),
                                         diffuse: #imageLiteral(resourceName: "Earth day"),
                                         specular: #imageLiteral(resourceName: "Earth Specular"),
                                         emission: #imageLiteral(resourceName: "Earth Emission"),
                                         normal: #imageLiteral(resourceName: "Earth Normal"),
                                         position: SCNVector3(1.2 ,0 , 0))
        let venusWrapper = PlanetWrapper(geometry: SCNSphere(radius: 0.1),
                                         diffuse: #imageLiteral(resourceName: "Venus Surface"),
                                         specular: nil,
                                         emission: #imageLiteral(resourceName: "Venus Atmosphere"),
                                         normal: nil,
                                         position: SCNVector3(0.7, 0, 0))
        let moonWrapper = PlanetWrapper(geometry: SCNSphere(radius: 0.05),
                                        diffuse: #imageLiteral(resourceName: "moon Diffuse"),
                                        specular: nil,
                                        emission: nil,
                                        normal: nil,
                                        position: SCNVector3(0,0,-0.3))
        
        let earthNode = earthWrapper.node
        let venusNode = venusWrapper.node
        let moonNode = moonWrapper.node
        
        let sunAction = rotation(time: 8)
        let earthParentRotation = rotation(time: 14)
        let venusParentRotation = rotation(time: 10)
        let earthRotation = rotation(time: 8)
        let moonRotation = rotation(time: 5)
        let venusRotation = rotation(time: 8)
        
        
        earthNode.runAction(earthRotation)
        venusNode.runAction(venusRotation)
        earthParent.runAction(earthParentRotation)
        venusParent.runAction(venusParentRotation)
        moonParent.runAction(moonRotation)
        
        sun.runAction(sunAction)
        earthParent.addChildNode(earthNode)
        earthParent.addChildNode(moonParent)
        venusParent.addChildNode(venusNode)
        earthNode.addChildNode(moonNode)
        moonParent.addChildNode(moonNode)
    }
    
    private func rotation(time: TimeInterval) -> SCNAction {
        let rotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: time)
        return SCNAction.repeatForever(rotation)
    }
}
