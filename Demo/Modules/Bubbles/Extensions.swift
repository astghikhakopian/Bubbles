//
//  Extensions.swift
//  Magnetic
//
//  Created by Lasha Efremidze on 3/25/17.
//  Copyright © 2017 efremidze. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
    }
    
    static var red: UIColor {
        return UIColor(red: 255, green: 59, blue: 48)
    }
    
    static var orange: UIColor {
        return UIColor(red: 255, green: 149, blue: 0)
    }
    
    static var yellow: UIColor {
        return UIColor(red: 255, green: 204, blue: 0)
    }
    
    static var green: UIColor {
        return UIColor(red: 76, green: 217, blue: 100)
    }
    
    static var tealBlue: UIColor {
        return UIColor(red: 90, green: 200, blue: 250)
    }
    
    static var blue: UIColor {
        return UIColor(red: 0, green: 122, blue: 255)
    }
    
    static var purple: UIColor {
        return UIColor(red: 88, green: 86, blue: 214)
    }
    
    static var pink: UIColor {
        return UIColor(red: 255, green: 45, blue: 85)
    }

    static var gray: UIColor {
        return UIColor(red: 27, green: 32, blue: 33)
    }
    
    static var electricBlue: UIColor {
        return UIColor(red: 106, green: 178, blue: 246)
    }
    
    static var clear: UIColor {
        return UIColor(red: 256, green: 256, blue: 256, alpha: 0)
    }

    
    static let colors: [UIColor] = [.red, .orange, .yellow, .green, .tealBlue, .blue, .purple, .pink]
    
}

extension UIImage {
    
    static let names: [String] = ["argentina", "bolivia", "brazil", "chile", "costa rica", "cuba", "dominican republic", "ecuador", "el salvador", "haiti", "honduras", "mexico", "nicaragua", "panama", "paraguay", "peru", "venezuela"]
    
}

extension Array {
    
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
    
}




//
import SpriteKit

extension CGFloat {
    static func random(_ lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
    }
}

extension CGPoint {
    func distance(from point: CGPoint) -> CGFloat {
        return hypot(point.x - x, point.y - y)
    }
}

extension UIImage {
    func aspectFill(_ size: CGSize) -> UIImage {
        let aspectWidth = size.width / self.size.width
        let aspectHeight = size.height / self.size.height
        let aspectRatio = max(aspectWidth, aspectHeight)
        
        var newSize = self.size
        newSize.width *= aspectRatio
        newSize.height *= aspectRatio
        return resize(newSize)
    }
    func resize(_ size: CGSize) -> UIImage {
        var rect = CGRect.zero
        rect.size = size
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
