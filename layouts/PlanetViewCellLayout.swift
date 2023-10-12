//
//  PlanetViewCellLayout.swift
//  first
//
//  Created by Killian on 12/10/2023.
//

import UIKit

class PlanetsViewControllerLayout: UICollectionViewFlowLayout {
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
           super.prepare(forCollectionViewUpdates: updateItems)
           
       }
       
       override var itemSize: CGSize {
           set {
               super.itemSize = collectionView!.bounds.size
           }
           get {
               return CGSize(width: collectionView!.bounds.width / 2.5, height: collectionView!.bounds.height / 2.5)
           }
       }
    
    override var minimumLineSpacing: CGFloat {
        set {
            super.minimumLineSpacing = collectionView!.bounds.height
        }
        get {
            return CGFloat(floatLiteral: collectionView!.bounds.height / 80)
        }
    }
}
