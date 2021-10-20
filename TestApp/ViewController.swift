//
//  ViewController.swift
//  TestApp
//
//  Created by Andrew on 19.10.2021.
//

import UIKit
import CSwiftLog

class ViewController: UIViewController {
    
    // MARK: Private property
    private let insetSpacing: CGFloat = 10
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = DeleteFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: insetSpacing, bottom: 0, right: insetSpacing)
//        let widthCell = view.bounds.width - 2 * minLineSpacing
//        flowLayout.itemSize = CGSize(width: widthCell, height: widthCell)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = insetSpacing
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.addSubview(refreshContorl)
        return collectionView
    }()

    private var refreshContorl: UIRefreshControl = {
        $0.tintColor = UIColor.red
        $0.addTarget(self, action: #selector(fetchData(_:)), for: .valueChanged)
        return $0
    }(UIRefreshControl())
    
    private var data: [String] = []
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchData(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: Action methods
    @objc private func fetchData(_ animated: Bool = false) {
        data = ["asdf", "asdf", "asdf", "asdf", "asdf", "asdf"]
        collectionView.reloadData()
        refreshContorl.endRefreshing()
    }
    
    // MARK: Setup methods
    private func setupUI() {
        view.backgroundColor = Asset.Color.mainWhite.color10
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        // Activate Constraint
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide10.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide10.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide10.trailingAnchor),
        ])
    }

}


// MARK: UICollectionView
extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else {
            Log.ui.log("Return default cell", .warning)
            return UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        
        // Add animations here
        let animator = Animator.makeRightAnimation(duration: 0.5, delay: 0)
        animator.animate(cell: cell, in: collectionView) { [weak self] in
            guard
                let self = self,
                let index = collectionView.indexPath(for: cell)
            else {
                return
            }
            self.data.remove(at: index.item)
            collectionView.deleteItems(at: [index])
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthCell = collectionView.bounds.width - 2 * insetSpacing
        return CGSize(width: widthCell, height: widthCell)
    }
}

