//
//  Animator.swift
//  TestApp
//
//  Created by Andrew on 20.10.2021.
//

import UIKit
import CSwiftLog

typealias Animation = (UICollectionViewCell, UICollectionView, @escaping () -> Void) -> Void

final class Animator {
    
    private let animation: Animation

    init(animation: @escaping Animation) {
        self.animation = animation
    }

    func animate(cell: UICollectionViewCell, in collectionView: UICollectionView, completion: @escaping () -> Void = {}) {
        animation(cell, collectionView, completion)
    }
}

// MARK: Factory methods
extension Animator {
    
    static func makeRightAnimation(duration: TimeInterval, delay: Double) -> Animator {
        let animation: Animation = { cell, collectionView, completion in
            UIView.animate(
                withDuration: duration,
                delay: delay,
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: collectionView.bounds.width, y: 0)
                },
                completion: { _ in
                    cell.alpha = 0
                    completion()
                })
        }
        return Animator(animation: animation)
    }
}
