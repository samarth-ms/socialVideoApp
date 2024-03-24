//
//  HighlightFeedback.swift
//  TalkShop
//
//  Created by Samarth on 22/03/24.
//

import Foundation
import UIKit

protocol HighlightFeedback: UIView { }

extension HighlightFeedback {
    func scaleDownFeedback(highlighted: Bool, animated: Bool) {
        let animationBlock: () -> Void = {
            let scale: CGFloat = 0.95
            let transform = highlighted ? CGAffineTransform(scaleX: scale, y: scale) : CGAffineTransform.identity
            self.transform = transform
            self.layoutIfNeeded()
        }
        if animated {
            let duration: TimeInterval = highlighted ? 0.1 : 0.25
            let curve: UIView.AnimationOptions = highlighted ? .curveEaseOut : .curveEaseIn
            UIView.animate(withDuration: duration, delay: 0.0, options: curve, animations: animationBlock, completion: nil)
        } else {
            animationBlock()
        }
    }
}
