//
//  PartnerGalleryViewController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 03.05.25.
//

import UIKit

final class PartnerGalleryViewController: BaseViewController, UIScrollViewDelegate {
    // MARK: UI Elements
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.tintColor = .black
        view.hidesWhenStopped = true
        view.backgroundColor = .white.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.contentMode = .scaleAspectFit
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
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
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate)
        let resizedImage = image?.resizeImage(to: CGSize(width: 32, height: 32))
        button.setImage(resizedImage, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var countLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "",
            labelColor: .black,
            labelFont: .montserratMedium,
            labelSize: 24,
            numOfLines: 1
        )
        label.accessibilityIdentifier = "planningTitleLabel"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Configurations
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
        
        Logger.debug("id: \(KeychainHelper.getString(key: .userID) ?? "")")
    }
    
    override func configureView() {
        view.backgroundColor = .white
        view.addSubViews(loadingView, scrollView, countLabel, closeButton)
        scrollView.addSubview(imageView)
        view.bringSubviewToFront(loadingView)
    }
    
    override func configureConstraint() {
        loadingView.fillSuperview()
        
        closeButton.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            padding: .init(all: 16)
        )
        
        scrollView.fillSuperviewSafeAreaLayoutGuide()
        imageView.anchor(
            top: scrollView.topAnchor,
            leading: scrollView.leadingAnchor,
            bottom: scrollView.bottomAnchor,
            trailing: scrollView.trailingAnchor,
            padding: .init(all: 0)
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
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    self.loadingView.startAnimating()
                case .loaded:
                    self.loadingView.stopAnimating()
                case .success:
                    print(#function)
                case .error(let error):
                    self.showMessage(title: "Error", message: error)
                }
            }
        }
    }
    
    @objc fileprivate func closeButtonTapped() {
        viewModel?.popBackController()
    }
    
    fileprivate func loadImage(animated: Bool = false, direction: UISwipeGestureRecognizer.Direction? = nil) {
        guard let viewModel = viewModel,
              let image = viewModel.partner?.gallery[viewModel.selectedIndex] else { return }

        countLabel.text = "\(viewModel.selectedIndex + 1)/\(viewModel.partner?.gallery.count ?? 0)"

        if animated, let direction = direction {
            let offset = imageView.frame.width
            let translationX: CGFloat = direction == .left ? offset : -offset
            
            let incomingImageView = UIImageView(frame: imageView.frame)
            incomingImageView.image = image
            incomingImageView.contentMode = .scaleAspectFit
            incomingImageView.clipsToBounds = true
            incomingImageView.isUserInteractionEnabled = true
            incomingImageView.transform = CGAffineTransform(translationX: translationX, y: 0)
            scrollView.addSubview(incomingImageView)

            UIView.animate(withDuration: 0.3, animations: {
                incomingImageView.transform = .identity
                self.imageView.transform = CGAffineTransform(translationX: -translationX, y: 0)
                self.imageView.alpha = 0.5
            }, completion: { _ in
                self.imageView.image = image
                self.imageView.transform = .identity
                self.imageView.alpha = 1
                incomingImageView.removeFromSuperview()
            })
        } else {
            imageView.image = image
        }
    }
    
    fileprivate func setUpGesture() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTapOnScrollView(recognizer:)))
        singleTapGesture.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(singleTapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapOnScrollView(recognizer:)))
        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)
        
        singleTapGesture.require(toFail: doubleTapGesture)
        
        let rightSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeFrom(recognizer:)))
        let leftSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeFrom(recognizer:)))
        
        rightSwipe.direction = .right
        leftSwipe.direction = .left

        scrollView.addGestureRecognizer(rightSwipe)
        scrollView.addGestureRecognizer(leftSwipe)
    }
    
    @objc fileprivate func handleSwipeFrom(recognizer: UISwipeGestureRecognizer) {
        guard let viewModel = viewModel,
              let count = viewModel.partner?.gallery.count else { return }

        var index = viewModel.selectedIndex

        switch recognizer.direction {
        case .right:
            index -= 1
        case .left:
            index += 1
        default:
            break
        }

        index = (index < 0) ? (count - 1) : (index % count)
        viewModel.selectedIndex = index
        loadImage(animated: true, direction: recognizer.direction)
    }
    
    @objc fileprivate func handleSingleTapOnScrollView(recognizer: UITapGestureRecognizer) {
        if closeButton.isHidden {
            closeButton.isHidden = false
            countLabel.isHidden = false
        } else {
            closeButton.isHidden = true
            countLabel.isHidden = true
        }
    }
    
    @objc fileprivate func handleDoubleTapOnScrollView(recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
            closeButton.isHidden = true
            countLabel.isHidden = true
        } else {
            scrollView.setZoomScale(1, animated: true)
            closeButton.isHidden = false
            countLabel.isHidden = false
        }
    }
    
    fileprivate func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        
        let newCenter = imageView.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        
        return zoomRect
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imageView.image {
                let ratioW = imageView.frame.width / image.size.width
                let ratioH = imageView.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                
                let left = 0.5 * (newWidth * scrollView.zoomScale > imageView.frame.width ? (newWidth - imageView.frame.width) : (scrollView.frame.width - scrollView.contentSize.width))
                
                let top = 0.5 * (newHeight * scrollView.zoomScale > imageView.frame.height ? (newHeight - imageView.frame.height) : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = UIEdgeInsets.zero
        }
    }
}
