//  Created by Cameron  Partee on 1/14/20.
//  Copyright © 2020 Cameron Partee. All rights reserved.

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var nodeArray = [SCNNode]()
    
    
    // MARK: Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // feature points and lighting
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin,
        ARSCNDebugOptions.showFeaturePoints]
        sceneView.automaticallyUpdatesLighting = true
        
        // add note
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onClickImageView))
        //let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(actionPinchGesture))
        sceneView.addGestureRecognizer(panGesture)
        //sceneView.addGestureRecognizer(pinchGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // Run the view's session
        sceneView.session.run(configuration)
        
        // add all functions here
        addPlaneAtOrigin()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: ARSCNViewDelegate Functions
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
    
    // MARK: ARVisionBoard Functionality
    
    func addPlaneAtOrigin() {
        let plane = SCNNode(geometry: SCNPlane(width: 0.2, height: 0.2))
        plane.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rings")
        plane.geometry?.firstMaterial?.isDoubleSided = true;
        plane.position = SCNVector3(0,0,0)
        plane.name = "rings"
        sceneView.scene.rootNode.addChildNode(plane)
        nodeArray.append(plane)
    }
    
    // builtin touch listener
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: sceneView)
        let hitList = sceneView.hitTest(location, options: nil)
        
        if let hitObject = hitList.first {
            let _ = hitObject.node
            //print("\(node.name ?? "") was pressed")
            // remove node here
        }
    }
    
    @objc func onClickImageView(recogizer: UIPanGestureRecognizer) {
        let translation = recogizer.translation(in: self.view)
        let hits = sceneView.hitTest(translation, options: nil)
        //print("enter function")
        if !hits.isEmpty{
            //print("hits is not empty")
            let node = hits.first?.node
            print("\(node?.name ?? "") was panned")
            node?.position = SCNVector3(CGFloat((node?.position.x)!) + translation.x,
                                        CGFloat((node?.position.y)!) + translation.y,
                                        CGFloat((node?.position.z)!))
        }
//        if let view = recogizer.view {
//            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
//        }
//        recogizer.setTranslation(CGPoint.zero, in: self.view)
    }
       
       
//    @objc func actionPinchGesture(recognizer: UIPinchGestureRecognizer) {
//           if let view = recognizer.view {
//               view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
//               recognizer.scale = 1
//           }
//       }
       
}

struct PicNode {
    
}
