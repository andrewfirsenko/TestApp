//
//  UIView+Extension.swift
//  TestApp
//
//  Created by Andrew on 20.10.2021.
//

import UIKit

extension UIView {
    
    var safeAreaLayoutGuide10: UILayoutGuide {
        get {
            if #available(iOS 11.0, *) {
                return self.safeAreaLayoutGuide
            } else {
                return self.layoutMarginsGuide
            }
        }
    }
}

