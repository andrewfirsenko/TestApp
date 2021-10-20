//
//  RightDeleteFlowLayout.swift
//  TestApp
//
//  Created by Andrew on 20.10.2021.
//

import UIKit

class DeleteFlowLayout: UICollectionViewFlowLayout {
    
    private var deleteIndexPaths: [IndexPath?] = []
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        deleteIndexPaths = []
        updateItems.forEach { item in
            if case .delete = item.updateAction {
                deleteIndexPaths.append(item.indexPathBeforeUpdate)
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeLayoutTransition()
        deleteIndexPaths.removeAll()
    }
        
    open override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attr = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath) ?? layoutAttributesForItem(at: itemIndexPath) else {
            return nil
        }
        
        if deleteIndexPaths.contains(itemIndexPath) {
            attr.alpha = 0
        }
        
        return attr
    }
    
}
