//
//  ImageCell.swift
//  TestApp
//
//  Created by Andrew on 19.10.2021.
//

import UIKit
import SDWebImage
import CSwiftLog

class ImageCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private(set) var wasLoad: Bool = false
    
    private lazy var imageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = false
        $0.isSkeletonable = true
        $0.image = nil
        return $0
    }(UIImageView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isSkeletonable = true
        self.contentView.isSkeletonable = true
        self.contentView.backgroundColor = Asset.Color.skeletonFirst.color10
        self.contentView.addSubview(imageView)
    }
    
    // MARK: Load Image
    func loadImage(_ stringUrl: String) {
        imageView.image = nil
        wasLoad = false
        
        imageView.sd_setImage(with: URL(string: stringUrl), completed: { [weak self] img, error, cache, url in
            if let error = error {
                Log.ui.log("Load image: \(error.localizedDescription)", .warning)
                self?.imageView.image = Asset.Image.warningLoadImage.image
            }
            self?.wasLoad = true
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.sd_cancelCurrentImageLoad()
        imageView.image = nil
        wasLoad = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
