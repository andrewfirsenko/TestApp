//
//  ViewController.swift
//  TestApp
//
//  Created by Andrew on 19.10.2021.
//

import UIKit

class ViewController: UIViewController {

    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Asset.Color.mainWhite.color10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

}

