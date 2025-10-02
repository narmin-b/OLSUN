//
//  GalleryCell.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 03.05.25.
//

import UIKit
import AVFoundation
import SkeletonView

protocol GalleryCellDelegate: AnyObject {
    func didTapPrevious(in cell: GalleryCell)
    func didTapNext(in cell: GalleryCell)
}

class GalleryCell: UICollectionViewCell {
    static let identifier = "GalleryCell"

    weak var delegate: GalleryCellDelegate?

    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
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
    
    private lazy var prevButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = UIColor.white.withAlphaComponent(0.8)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        button.layer.cornerRadius = 4 // small rounded corners for rectangle
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.addTarget(self, action: #selector(didTapPrev), for: .touchUpInside)
        return button
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = UIColor.white.withAlphaComponent(0.8)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        button.layer.cornerRadius = 4 // small rounded corners for rectangle
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)
        contentView.addSubview(playIcon)
        contentView.addSubview(prevButton)
        contentView.addSubview(nextButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            playIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            playIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playIcon.widthAnchor.constraint(equalToConstant: 40),
            playIcon.heightAnchor.constraint(equalToConstant: 40),
            
            prevButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            prevButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            prevButton.widthAnchor.constraint(equalToConstant: 44),
            prevButton.heightAnchor.constraint(equalToConstant: 44),
            
            nextButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nextButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            nextButton.widthAnchor.constraint(equalToConstant: 44),
            nextButton.heightAnchor.constraint(equalToConstant: 44),
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
        
        // Reset arrow visibility
        prevButton.isHidden = true
        nextButton.isHidden = true
    }
    
    func configureCell(withURl mediaPath: String) {
        imageView.loadImage(named: mediaPath) { _ in
            self.playIcon.isHidden = !(mediaPath.hasSuffix(".mp4") || mediaPath.hasSuffix(".mov"))
        }
    }
    
    func configureArrows(showPrev: Bool, showNext: Bool) {
        prevButton.isHidden = !showPrev
        nextButton.isHidden = !showNext
    }
    
    @objc private func didTapPrev() {
        delegate?.didTapPrevious(in: self)
    }
    
    @objc private func didTapNext() {
        delegate?.didTapNext(in: self)
    }
}
