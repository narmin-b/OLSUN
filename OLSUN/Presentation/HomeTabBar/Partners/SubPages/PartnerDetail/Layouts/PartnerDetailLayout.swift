//
//  PartnerDetailLayout.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 03.05.25.
//

import UIKit

final class PartnerDetailLayout {
    
    // MARK: - Section 0: Header with Logo + Description
    func headerSection() -> NSCollectionLayoutSection {
           let itemSize = NSCollectionLayoutSize(
               widthDimension: .fractionalWidth(1),
               heightDimension: .estimated(10)
           )
           let item = NSCollectionLayoutItem(layoutSize: itemSize)
           
           let groupSize = NSCollectionLayoutSize(
               widthDimension: .fractionalWidth(1),
               heightDimension: .estimated(560)
           )
           let group = NSCollectionLayoutGroup.vertical(
               layoutSize: groupSize,
               subitems: [item]
           )
           
           let section = NSCollectionLayoutSection(group: group)
           section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 8, trailing: 16)
           return section
       }

    // MARK: - Section 1: Gallery with Images
    func gallerySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.305),
            heightDimension: .fractionalWidth(0.3)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(120)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16)
        
        section.boundarySupplementaryItems = [
            .init(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading
            )
        ]

        return section
    }

    // MARK: - Section 2: Contact Icons
    func contactSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(44),
            heightDimension: .absolute(44)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .absolute(88)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(16)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 24, trailing: 16)
        
        section.boundarySupplementaryItems = [
            .init(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading
            )
        ]

        return section
    }
}
