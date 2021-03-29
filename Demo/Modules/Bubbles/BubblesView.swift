//
//  BubblesView.swift
//  Demo
//
//  Created by Astghik Hakopian on 20.03.21.
//

import SpriteKit

public class BubblesView: SKView {
    
    @objc public lazy var bubbles: Bubbles = { [unowned self] in
        let scene = Bubbles(size: self.bounds.size)
        self.presentScene(scene)
        return scene
    }()
    
    
    // MARK: - Init
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    func commonInit() {
        _ = bubbles
    }
    
    
    // MARK: - Lifecycle Methods
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        bubbles.size = bounds.size
    }
}
