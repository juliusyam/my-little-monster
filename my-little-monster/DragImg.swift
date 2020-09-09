//
//  DragImg.swift
//  my-little-monster
//
//  Created by Julius on 08/09/2020.
//

import Foundation
import UIKit

class DragImg: UIImageView {
    
    var originalPosition: CGPoint!
    var dropTarget: UIView? //UIView does limit what UI Property it is set to, like UIImage or UIButton
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        originalPosition = self.center
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self.superview)
            self.center = CGPoint(x: position.x, y: position.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first, let target = dropTarget {
            let position = touch.location(in: self.superview)
            if target.bounds.contains(position) {
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "onTargetDropped"), object: nil) as Notification)
            }
        }
        
        self.center = originalPosition
    }
}
