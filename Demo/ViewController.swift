//
//  ViewController.swift
//  Demo
//
//  Created by Astghik Hakopian on 20.03.21.
//


import SpriteKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bubblesView: BubblesView! {
        didSet {
            magnetic.bubblesDelegate = self
            magnetic.removeNodeOnLongPress = true
            magnetic.backgroundColor = #colorLiteral(red: 0.05171684921, green: 0.06983882934, blue: 0.07370931655, alpha: 1)
            #if DEBUG
//            magneticView.showsFPS = true
//            magneticView.showsDrawCount = true
//            magneticView.showsQuadCount = true
//            magneticView.showsPhysics = true
            #endif
        }
    }
    
    var magnetic: Bubbles {
        return bubblesView.bubbles
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        for interest in interestsDatasource {
            let node = Node(text: interest.title, image: interest.image, color: interest.color, radius: 60)
            
            node.scaleToFitContent = false
            node.color = .white // interest.color
            node.selectedColor = .white //interest.color
            node.fillTexture = node.texture
            node.selectedBorderColor = UIColor.electricBlue
            magnetic.addChild(node)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func add(_ sender: UIControl?) {
        let name = UIImage.names.randomItem()
        let color = UIColor.colors.randomItem()
        let node = Node(text: name.capitalized, image: UIImage(named: name), color: color, radius: 60)
        node.scaleToFitContent = false
        node.selectedColor = UIColor.clear
        magnetic.addChild(node)
    }
    
    @IBAction func reset(_ sender: UIControl?) {
        bubblesView.bubbles.reset()
    }
    
}

// MARK: - MagneticDelegate

extension ViewController: BubblesDelegate {
    
    func bubbles(_ bubbles: Bubbles, didSelect node: Node) {
        print("didSelect -> \(node)")
    }
    
    func bubbles(_ bubbles: Bubbles, didDeselect node: Node) {
        print("didDeselect -> \(node)")
    }
    
    func bubbles(_ bubbles: Bubbles, didRemove node: Node) {
        print("didRemove -> \(node)")
    }
    
}

// MARK: - ImageNode
class ImageNode: Node {
    override var image: UIImage? {
        didSet {
            texture = image.map { SKTexture(image: $0) }
        }
    }
    override func selectedAnimation() {}
    override func deselectedAnimation() {}
}



//

struct InterestModel {
    let title: String
    let image: UIImage?
    let color: UIColor
}


// datasource

let interestsDatasource = [
    InterestModel(title: "Health", image: UIImage(named: "health"), color: #colorLiteral(red: 0.835385561, green: 0.3871763945, blue: 0.4830617309, alpha: 1)),
    InterestModel(title: "Finance", image: UIImage(named: "finance"), color: #colorLiteral(red: 0.5854968429, green: 0.5575082898, blue: 0.4862399697, alpha: 1)),
    InterestModel(title: "Managment", image: UIImage(named: "managment"), color: #colorLiteral(red: 0.6310946345, green: 0.5455613136, blue: 0.8611627817, alpha: 1)),
    InterestModel(title: "Cleaning", image: UIImage(named: "cleaning"), color: #colorLiteral(red: 0.6542317271, green: 0.5466202497, blue: 0.3871933222, alpha: 1)),
    InterestModel(title: "Quitting", image: UIImage(named: "quitting"), color: #colorLiteral(red: 0.3652980924, green: 0.7204908729, blue: 0.7613945603, alpha: 1)),
    InterestModel(title: "Routine", image: UIImage(named: "routine"), color: #colorLiteral(red: 0.2079172432, green: 0.2755297422, blue: 0.5574368834, alpha: 1)),
    InterestModel(title: "Drink water", image: UIImage(named: "water"), color: #colorLiteral(red: 0.2518230975, green: 0.5693916678, blue: 0.8232086897, alpha: 1))
]
