//
//  Node.swift
//  Magnetic
//
//  Created by Lasha Efremidze on 3/25/17.
//  Copyright © 2017 efremidze. All rights reserved.
//

import SpriteKit

@objcMembers open class Node: SKShapeNode {
    
    public lazy var label: SKMultilineLabelNode = { [unowned self] in
        let label = SKMultilineLabelNode()
        label.fontName = Defaults.fontName
        label.fontSize = Defaults.fontSize
        label.fontColor = Defaults.fontColor
        label.verticalAlignmentMode = .center
        label.width = self.frame.width
        label.separator = " "
        addChild(label)
        return label
    }()
    
    /**
     The text displayed by the node.
     */
    open var text: String? {
        get { return label.text }
        set {
            label.text = newValue
            resize()
        }
    }
    
    /**
     The image displayed by the node.
     */
    open var image: UIImage? {
        didSet {
            texture = SKTexture(image: image!.setInsets(UIEdgeInsets(top: 25, left: 45, bottom: 65, right: 45), backgroundColor:#colorLiteral(red: 0.1064376906, green: 0.1246982589, blue: 0.1285673678, alpha: 1))!)
            selectedTexture = SKTexture(image: image!.setInsets(UIEdgeInsets(top: 35, left: 55, bottom: 75, right: 55), backgroundColor:#colorLiteral(red: 0.113633208, green: 0.1695540249, blue: 0.2476284504, alpha: 1))!)
        }
    }
    
    
    /**
     The color of the node.
     
     Also blends the color with the image.
     */
    open var color: UIColor = Defaults.color {
        didSet {
            self.fillColor = color
        }
    }
    
    open var texture: SKTexture?
    open var selectedTexture: SKTexture?
    
    /**
     The selection state of the node.
     */
    open var isSelected: Bool = false {
        didSet {
            guard isSelected != oldValue else { return }
            if isSelected {
                selectedAnimation()
            } else {
                deselectedAnimation()
            }
        }
    }
    
    /**
     Controls whether the node should auto resize to fit its content
     */
    open var scaleToFitContent: Bool = Defaults.scaleToFitContent {
        didSet {
            resize()
        }
    }
    
    /**
     Additional padding to be applied on resize
     */
    open var padding: CGFloat = Defaults.padding {
        didSet {
            resize()
        }
    }
    
    /**
     The scale of the selected animation
     */
    open var selectedScale: CGFloat = 4 / 3
    
    /**
     The scale of the deselected animation
     */
    open var deselectedScale: CGFloat = 1
    
    /**
     The original color of the node before animation
     */
    private var originalColor: UIColor = Defaults.color
    
    /**
     The color of the seleted node
     */
    open var selectedColor: UIColor?
    
    /**
     The text color of the seleted node
     */
    open var selectedFontColor: UIColor?
    
    /**
     The original text color of the node before animation
     */
    private var originalFontColor: UIColor = Defaults.fontColor
    
    /**
     The color of the seleted node
     */
    open var selectedBorderColor: UIColor?
    
    /**
     The duration of the selected/deselected animations
     */
    open var animationDuration: TimeInterval = 0.2
    
    /**
     The name of the label's font
     */
    open var fontName: String {
        get { label.fontName ?? Defaults.fontName }
        set {
            label.fontName = newValue
            resize()
        }
    }
    
    /**
     The size of the label's font
     */
    open var fontSize: CGFloat {
        get { label.fontSize }
        set {
            label.fontSize = newValue
            resize()
        }
    }
    
    /**
     The color of the label's font
     */
    open var fontColor: UIColor {
        get { label.fontColor ?? Defaults.fontColor }
        set { label.fontColor = newValue }
    }
    
    /**
     The margin scale of the node
     */
    open var marginScale: CGFloat = Defaults.marginScale {
        didSet {
            guard let path = path else { return }
            regeneratePhysicsBody(withPath: path)
        }
    }
    
    open private(set) var radius: CGFloat?
    
    /**
     Set of default values
     */
    struct Defaults {
        static let fontName = "System"//"Avenir-Black"
        static let fontColor = UIColor.white
        static let fontSize = CGFloat(17)
        static let color = UIColor.clear
        static let marginScale = CGFloat(1.01)
        static let scaleToFitContent = false // backwards compatability
        static let padding = CGFloat(20)
    }
    
    /**
     Creates a node with a custom path.
     
     - Parameters:
     - text: The text of the node.
     - image: The image of the node.
     - color: The color of the node.
     - path: The path of the node.
     - marginScale: The margin scale of the node.
     
     - Returns: A new node.
     */
    public init(text: String? = nil, image: UIImage? = nil, color: UIColor, path: CGPath, marginScale: CGFloat = 1.01) {
        super.init()
        self.path = path
        regeneratePhysicsBody(withPath: path)
        self.color = color
        self.strokeColor = .clear
        self.lineWidth = 2
        _ = self.text
        configure(text: text, image: image, color: color)
    }
    
    /**
     Creates a node with a circular path.
     
     - Parameters:
     - text: The text of the node.
     - image: The image of the node.
     - color: The color of the node.
     - radius: The radius of the node.
     - marginScale: The margin scale of the node.
     
     - Returns: A new node.
     */
    public convenience init(text: String? = nil, image: UIImage? = nil, color: UIColor, radius: CGFloat, marginScale: CGFloat = 1.01) {
        let path = SKShapeNode(circleOfRadius: radius).path!
        self.init(text: text, image: image, color: color, path: path, marginScale: marginScale)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configure(text: String?, image: UIImage?, color: UIColor) {
        self.text = text
        self.image = image
        self.color = color
    }
    
    override open func removeFromParent() {
        removedAnimation() {
            super.removeFromParent()
        }
    }
    
    /**
     Resizes the node to fit its current content
     */
    public func resize() {
        guard scaleToFitContent, let text = text, let font = UIFont(name: fontName, size: fontSize) else { return }
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: fontAttributes)
        let radius = size.width / 2 + CGFloat(padding)
        update(radius: radius, withLabelWidth: size.width)
    }
    
    /**
     Updates the radius of the node and sets the label width to a given width or the radius
     
     - Parameters:
     - radius: The new radius
     - withLabelWidth: A custom width for the text label
     */
    public func update(radius: CGFloat, withLabelWidth width: CGFloat? = nil) {
        guard let path = SKShapeNode(circleOfRadius: radius).path else { return }
        self.path = path
        self.label.width = width ?? radius
        self.radius = radius
        regeneratePhysicsBody(withPath: path)
    }
    
    /**
     Regenerates the physics body with a given path after the path has changed .i.e. after resize
     */
    public func regeneratePhysicsBody(withPath path: CGPath) {
        self.physicsBody = {
            var transform = CGAffineTransform.identity.scaledBy(x: marginScale, y: marginScale)
            let body = SKPhysicsBody(polygonFrom: path.copy(using: &transform)!)
            body.allowsRotation = false
            body.friction = 0
            body.linearDamping = 3
            return body
        }()
    }
    
    /**
     The animation to execute when the node is selected.
     */
    open func selectedAnimation() {
        self.originalFontColor = fontColor
        self.originalColor = fillColor
        
        let scaleAction = SKAction.scale(to: selectedScale, duration: animationDuration)
        
        if let selectedFontColor = selectedFontColor {
            label.run(.colorTransition(from: originalFontColor, to: selectedFontColor))
        }
        
        if let selectedColor = selectedColor {
            run(.group([
                scaleAction,
                .colorTransition(from: originalColor, to: selectedColor, duration: animationDuration)
            ]))
        } else {
            run(scaleAction)
        }
        
        //        if let texture = texture {
        //            fillTexture = texture
        //        }
        
        if let selectedTexture = selectedTexture {
            fillTexture = selectedTexture
        }
        
        if let selectedBorderColor = selectedBorderColor {
            strokeColor = selectedBorderColor
        }
        fontSize = 14
    }
    
    /**
     The animation to execute when the node is deselected.
     */
    open func deselectedAnimation() {
        let scaleAction = SKAction.scale(to: deselectedScale, duration: animationDuration)
        
        if let selectedColor = selectedColor {
            run(.group([
                scaleAction,
                .colorTransition(from: selectedColor, to: originalColor, duration: animationDuration)
            ]))
        } else {
            run(scaleAction)
        }
        
        if let selectedFontColor = selectedFontColor {
            label.run(.colorTransition(from: selectedFontColor, to: originalFontColor, duration: animationDuration))
        }
        
        if let texture = texture {
            fillTexture = texture
        }
        
        self.strokeColor = UIColor.clear
        // self.fillTexture = nil
        
        fontSize = 17
    }
    
    /**
     The animation to execute when the node is removed.
     
     - important: You must call the completion block.
     
     - parameter completion: The block to execute when the animation is complete. You must call this handler and should do so as soon as possible.
     */
    open func removedAnimation(completion: @escaping () -> Void) {
        run(.group([.fadeOut(withDuration: animationDuration), .scale(to: 0, duration: animationDuration)]), completion: completion)
    }
    
}


extension UIImage {
    func setInsets(_ insets: UIEdgeInsets, backgroundColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        backgroundColor.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 150, height: 150))
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
    
}
