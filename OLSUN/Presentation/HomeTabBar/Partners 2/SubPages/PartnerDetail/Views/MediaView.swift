//
//  MediaView.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 07.06.25.
//

import UIKit
import AVFoundation

class MediaView: UIView {
    private let imageView = UIImageView()
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupImageView()
    }

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func loadMedia(from path: String) {
        let baseURL = "https://olsun.in/"
        guard let url = URL(string: baseURL + path) else { return }

        if path.hasSuffix(".mp4") || path.hasSuffix(".mov") {
            // Show video
            imageView.isHidden = true
            playVideo(from: url)
        } else {
            // Show image
            imageView.isHidden = false
            removeVideo()
            imageView.loadImage(named: path)
        }
    }

    private func playVideo(from url: URL) {
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = bounds
        playerLayer?.videoGravity = .resizeAspect
        if let layer = playerLayer {
            self.layer.addSublayer(layer)
        }
        player?.play()
    }

    private func removeVideo() {
        player?.pause()
        player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
}
