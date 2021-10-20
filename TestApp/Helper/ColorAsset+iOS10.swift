//
//  DefaultColorHelper.swift
//  TestApp
//
//  Created by Andrew on 19.10.2021.
//

import UIKit

extension ColorAsset {
    
    static var defaultColor10: Color = UIColor.black
    
    var color10: Color {
        get {
            if #available(iOS 11, *) {
                return self.color
            } else {
                return _defaultColors[name] ?? ColorAsset.defaultColor10
            }
        }
    }
    
    
}
