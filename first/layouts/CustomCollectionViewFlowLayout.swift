//
//  CustomCollectionViewFlowLayout.swift
//  first
//
//  Created by Lecouturier Lucie on 11/10/2023.
//

import UIKit

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
          guard let collectionView = collectionView else { return nil }
          
          let layoutAttributes = super.layoutAttributesForElements(in: rect)
          
          let contentWidth = collectionView.bounds.width
          let centerX = collectionView.contentOffset.x + collectionView.bounds.width * 0.5
          
          for attributes in layoutAttributes ?? [] {
              if attributes.indexPath.item % 2 == 0 {
                  attributes.center.x = centerX + contentWidth / 1.7
              }
          }
          
          return layoutAttributes
      }

    override var itemSize: CGSize {
        set {
            super.itemSize = collectionView!.bounds.size
        }
        get {
            return CGSize(width: collectionView!.bounds.width, height: collectionView!.bounds.height / 4)
        }
    }
}
