//
//  ViewController.swift
//  TestApp
//
//  Created by Andrew on 19.10.2021.
//

import UIKit
import SkeletonView
import CSwiftLog

class ViewController: UIViewController {
    
    // MARK: Private property
    private let insetSpacing: CGFloat = 10
    private var data: [String] = [] {
        didSet {
            emptyLabel.isHidden = !data.isEmpty
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = DeleteFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: insetSpacing, bottom: 0, right: insetSpacing)
//        let widthCell = view.bounds.width - 2 * minLineSpacing
//        flowLayout.itemSize = CGSize(width: widthCell, height: widthCell)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = insetSpacing
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        collectionView.isSkeletonable = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.addSubview(refreshContorl)
        return collectionView
    }()
    
    private lazy var emptyLabel: UILabel = {
        $0.text = "Тут пока пусто"
        $0.backgroundColor = .clear
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 24)
//        $0.isHidden = true
        return $0
    }(UILabel())

    private var refreshContorl: UIRefreshControl = {
        $0.tintColor = Asset.accentColor.color10
        $0.addTarget(self, action: #selector(actionRefreshControl), for: .valueChanged)
        return $0
    }(UIRefreshControl())
    
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
    @objc private func actionRefreshControl() {
        fetchData(data.isEmpty)
    }
    
    private func fetchData(_ animated: Bool = false) {
        data.removeAll()
        if animated {
            startAnimationSkeleton()
        }
        // Simulate network call delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            guard let self = self else { return }
            
            self.data = [
                "https://picsum.photos/id/237/2000/2000",
                "https://picsum.photos/id/247/2000/2000",
                "https://picsum.photos/id/257/2000/2000",
                "https://picsum.photos/id/267/2000/2000",
                "https://picsum.photos/id/277/2000/2000",
                "https://picsum.photos/id/287/2000/2000",
            ]
            self.stopAnimationSkeleton()
            self.collectionView.reloadData()
            self.refreshContorl.endRefreshing()
        })
        
    }
    
    // MARK: Setup methods
    private func setupUI() {
        view.backgroundColor = Asset.Color.mainWhite.color10
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        [emptyLabel, collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        
        // Activate Constraint
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide10.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide10.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide10.trailingAnchor),
            
            emptyLabel.topAnchor.constraint(equalTo: collectionView.topAnchor),
            emptyLabel.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 16),
            emptyLabel.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -16),
        ])
    }

}


// MARK: UICollectionView
extension ViewController: UICollectionViewDelegateFlowLayout, SkeletonCollectionViewDataSource {
    
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ImageCell, data.count > indexPath.count else {
            return
        }
        cell.loadImage(data[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard
            let cell = collectionView.cellForItem(at: indexPath) as? ImageCell,
            cell.wasLoad
        else {
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
    
    // Skeleton
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        ImageCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
}

// MARK: Skeleton methods
extension ViewController {
    
    private func startAnimationSkeleton() {
        emptyLabel.isHidden = true
        let gradient = SkeletonGradient(baseColor: Asset.Color.skeletonFirst.color10, secondaryColor: .white)
        collectionView.showAnimatedGradientSkeleton(usingGradient: gradient, animation: nil, transition: .none)
    }
    
    private func stopAnimationSkeleton() {
        collectionView.stopSkeletonAnimation()
        collectionView.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
    }
}

