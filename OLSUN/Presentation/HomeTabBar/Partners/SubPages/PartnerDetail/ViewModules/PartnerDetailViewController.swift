//
//  PartnerDetailViewController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 03.05.25.
//

import UIKit

final class PartnerDetailViewController: BaseViewController {
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
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(header: PartnerSectionHeader.self)
        collectionView.register(cell: HeaderCell.self)
        collectionView.register(cell: GalleryCell.self)
        collectionView.register(cell: ContactCell.self)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: Configurations
    private let viewModel: PartnerDetailViewModel?
    private var partners: [Partner] = []
    
    init(viewModel: PartnerDetailViewModel) {
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let tabBarController = self.tabBarController as? TabBarController {
            tabBarController.tabBar.isHidden = false
            tabBarController.customTabBarView.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        
        Logger.debug("id: \(KeychainHelper.getString(key: .userID) ?? "")")
    }
    
    override func configureView() {
        
        configureNavigationBar()
        
        view.backgroundColor = .white
        view.addSubViews(loadingView, collectionView)
        view.bringSubviewToFront(loadingView)
    }
    
    override func configureConstraint() {
        loadingView.fillSuperview()
        
        collectionView.fillSuperviewSafeAreaLayoutGuide()
    }
    
    fileprivate func configureNavigationBar() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.tintColor = .primaryHighlight
        navigationItem.configureNavigationBar(text: viewModel?.partner?.name ?? "Partner")
        
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = .lightGray.withAlphaComponent(0.5)
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        
        navigationController?.navigationBar.addSubview(bottomBorder)
        
        bottomBorder.anchorSize(.init(width: 0, height: 4))
        bottomBorder.anchor(
            leading: navigationController!.navigationBar.leadingAnchor,
            bottom: navigationController!.navigationBar.bottomAnchor,
            trailing: navigationController!.navigationBar.trailingAnchor,
            padding: .init(all: 0)
        )
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
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return PartnerDetailLayout().headerSection()
            case 1:
                return PartnerDetailLayout().gallerySection()
            case 2:
                return PartnerDetailLayout().contactSection()
            default:
                return nil
            }
        }
    }
}

extension PartnerDetailViewController: UICollectionViewDelegate,
                                       UICollectionViewDataSource,
                                       UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel?.partner?.gallery.count ?? 0
        case 2:
            return viewModel?.partner?.contact.count ?? 0
        default:
            return 0
        }
    }
    
    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int { 3 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            cell.delegate = self
            cell.configureCell(with: (viewModel?.partner)!)
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
            let imageName = viewModel?.partner?.gallery[indexPath.item]
            cell.configureCell(withImageNamed: imageName!)
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactCell", for: indexPath) as! ContactCell
            let icon = viewModel?.partner?.contact[indexPath.item]
            cell.configureCell(with: icon!)
            return cell
            
        default:
            fatalError("Unknown section")
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header: PartnerSectionHeader = collectionView.dequeue(header: PartnerSectionHeader.self, for: indexPath)
        
        switch indexPath.section {
        case 1:
            header.configure(with: "Qalereya")
        case 2:
            header.configure(with: "Əlaqə")
        default:
            return header
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            print(indexPath.row)
            viewModel?.showPartnerGallery(
                partner: (viewModel?.partner)!,
                index: indexPath.row
            )
        }
    }
}

extension PartnerDetailViewController: HeaderCellDelegate {
    func didTapReadMore(in cell: HeaderCell) {
            guard let indexPath = collectionView.indexPath(for: cell) else { return }

            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
                cell.toggleDescription()
                self.collectionView.performBatchUpdates(nil)
            }, completion: nil)
        }
}
