//
//  PartnerGalleryViewController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 03.05.25.
//

import UIKit
import AVKit

final class PartnerGalleryViewController: BaseViewController, UIScrollViewDelegate {

    // MARK: - UI Elements

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.contentMode = .scaleAspectFit
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .black
        view.minimumZoomScale = 1
        view.maximumZoomScale = 6
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var playerViewController: AVPlayerViewController?

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "xmark")
        let size = DeviceSizeClass.current == .compact ? 24: 32
        
        let resizedImage = image?.resizeImage(to: CGSize(width: size, height: size))?.withRenderingMode(.alwaysTemplate)
        button.setImage(resizedImage, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var countLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "",
            labelColor: .white,
            labelFont: .montserratMedium,
            labelSize: 24,
            numOfLines: 1
        )
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Configurations

    private let viewModel: PartnerGalleryViewModel?

    init(viewModel: PartnerGalleryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        viewModel?.requestCallback = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarController = self.tabBarController as? TabBarController {
            tabBarController.tabBar.isHidden = true
            tabBarController.customTabBarView.isHidden = true
        }
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = self.tabBarController as? TabBarController {
            tabBarController.tabBar.isHidden = false
            tabBarController.customTabBarView.isHidden = false
        }
        navigationController?.navigationBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        loadImage()
        setUpGesture()
    }

    override func configureView() {
        view.backgroundColor = .black
        view.addSubViews(scrollView, countLabel, closeButton)
        scrollView.addSubview(imageView)
    }

    override func configureConstraint() {
        let pad = DeviceSizeClass.current == .compact ? 8 : 16
        let size = DeviceSizeClass.current == .compact ? 24: 32
        
        closeButton.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            padding: .init(all: CGFloat(pad))
        )
        closeButton.anchorSize(.init(width: size, height: size))

        scrollView.anchorSize(
            .init(
                width: (view.frame.height*0.9)*9/16,
                height: (view.frame.height*0.9)
            )
        )
        scrollView.centerXToSuperview()
        scrollView.centerYToSuperview()
        scrollView.anchor(
            top: closeButton.bottomAnchor,
            bottom: countLabel.topAnchor,
            padding: .init(all: 8)
        )
        scrollView.centerYToSuperview()

        imageView.anchor(
            top: scrollView.topAnchor,
            leading: scrollView.leadingAnchor,
            bottom: scrollView.bottomAnchor,
            trailing: scrollView.trailingAnchor
        )
        imageView.centerYToView(to: scrollView)
        imageView.centerXToView(to: scrollView)

        countLabel.anchor(
            bottom: view.bottomAnchor,
            padding: .init(all: 24)
        )
        countLabel.centerXToSuperview()
    }

    private func configureViewModel() {
        viewModel?.requestCallback = { [weak self] state in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch state {
                case .loading: break
                case .loaded: break
                case .success: break
                case .error(let error): self.showMessage(title: "Error", message: error)
                }
            }
        }
    }

    @objc private func closeButtonTapped() {
        viewModel?.popBackController()
    }

    private func loadImage(animated: Bool = false, direction: UISwipeGestureRecognizer.Direction? = nil) {
        guard let viewModel = viewModel else { return }
        let media = viewModel.limitedGallery[viewModel.selectedIndex]
        countLabel.text = "\(viewModel.selectedIndex + 1)/\(viewModel.limitedGallery.count)"

        if let controller = playerViewController {
            controller.player?.pause()
            controller.player = nil
            controller.willMove(toParent: nil)
            controller.view.removeFromSuperview()
            controller.removeFromParent()
            playerViewController = nil
        }

        if media.isVideo {
            imageView.isHidden = true
            guard let videoURL = URL(string: media.urlWithBase) else { return }
            let player = AVPlayer(url: videoURL)
            let controller = AVPlayerViewController()
            controller.player = player
            controller.showsPlaybackControls = true

            addChild(controller)
            scrollView.addSubview(controller.view)
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                controller.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                controller.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                controller.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
                controller.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                controller.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                controller.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            ])
            controller.didMove(toParent: self)
            player.play()
            playerViewController = controller

        } else {
            imageView.isHidden = false
            imageView.loadImage(named: media.url)
        }
    }

    private func setUpGesture() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTapOnScrollView))
        singleTapGesture.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(singleTapGesture)

        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapOnScrollView))
        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)

        singleTapGesture.require(toFail: doubleTapGesture)

        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeFrom))
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeFrom))
        rightSwipe.direction = .right
        leftSwipe.direction = .left
        scrollView.addGestureRecognizer(rightSwipe)
        scrollView.addGestureRecognizer(leftSwipe)
    }

    @objc private func handleSwipeFrom(recognizer: UISwipeGestureRecognizer) {
        guard let viewModel = viewModel else { return }
        let count = viewModel.limitedGallery.count
        guard count > 0 else { return }

        var index = viewModel.selectedIndex
        switch recognizer.direction {
        case .right: index -= 1
        case .left: index += 1
        default: break
        }

        index = (index < 0) ? (count - 1) : (index % count)
        viewModel.selectedIndex = index
        loadImage(animated: true, direction: recognizer.direction)
    }

    @objc private func handleSingleTapOnScrollView() {
        let hidden = closeButton.isHidden
        closeButton.isHidden = !hidden
        countLabel.isHidden = !hidden
    }

    @objc private func handleDoubleTapOnScrollView(recognizer: UITapGestureRecognizer) {
        guard playerViewController == nil else { return }
        if scrollView.zoomScale == 1 {
            let zoomRect = zoomRectForScale(scale: scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view))
            scrollView.zoom(to: zoomRect, animated: true)
            closeButton.isHidden = true
            countLabel.isHidden = true
        } else {
            scrollView.setZoomScale(1, animated: true)
            closeButton.isHidden = false
            countLabel.isHidden = false
        }
    }

    private func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        let newCenter = imageView.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return playerViewController == nil ? imageView : nil
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard playerViewController == nil else { return }
        if scrollView.zoomScale > 1 {
            if let image = imageView.image {
                let ratioW = imageView.frame.width / image.size.width
                let ratioH = imageView.frame.height / image.size.height
                let ratio = min(ratioW, ratioH)
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                let left = max(0, (scrollView.frame.width - newWidth) * 0.5)
                let top = max(0, (scrollView.frame.height - newHeight) * 0.5)
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
}
