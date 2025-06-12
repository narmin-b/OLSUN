//
//  GalleryCell.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 03.05.25.
//

import UIKit
import AVFoundation
import SkeletonView

class GalleryCell: UICollectionViewCell {
    static let identifier = "GalleryCell"

    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        iv.isSkeletonable = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var playIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "play.circle.fill"))
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isHidden = true
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)
        contentView.addSubview(playIcon)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            playIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            playIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playIcon.widthAnchor.constraint(equalToConstant: 40),
            playIcon.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        contentView.isSkeletonable = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.showAnimatedGradientSkeleton()
    }

    func configureCell(withImageNamed image: UIImage) {
        imageView.image = image
        playIcon.isHidden = true
    }

    func configureCell(withURl mediaPath: String) {
        imageView.loadImage(named: mediaPath) { _ in
            self.playIcon.isHidden = !(mediaPath.hasSuffix(".mp4") || mediaPath.hasSuffix(".mov"))
        }
    }
}
