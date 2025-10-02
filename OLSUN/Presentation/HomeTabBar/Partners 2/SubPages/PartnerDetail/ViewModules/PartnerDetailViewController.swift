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
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let tabBarController = self.tabBarController as? TabBarController {
            tabBarController.tabBar.isHidden = false
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
        let backItem = UIBarButtonItem(
            image: UIImage(named: "backButton")?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(didTapBack)
        )
        navigationItem.leftBarButtonItem = backItem
        navigationItem.configureNavigationBar(text: viewModel?.newPartner?.name ?? "Partner")
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
                    print(#function)
//                    self.showMessage(title: "Error", message: error)
                }
            }
        }
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            let layout = PartnerDetailLayout()
            switch sectionIndex {
            case 0: return layout.galleryHeaderSection()
            case 1: return layout.aboutSection()
            case 2: return layout.contactSection()
            default: return nil
            }
        }
    }
    
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension PartnerDetailViewController: UICollectionViewDelegate,
                                       UICollectionViewDataSource,
                                       UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 3 }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return (viewModel?.newPartner?.gallery.count ?? 0)
        case 1:
            return 1
        case 2:
            return viewModel?.newPartner?.contact.count ?? 0
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: GalleryCell.identifier,
                    for: indexPath
                ) as! GalleryCell

                guard let gallery = viewModel?.newPartner?.gallery else { return cell }
                let isFirst = indexPath.item == 0
                let isLast = indexPath.item == gallery.count - 1

                cell.configureCell(withURl: gallery[indexPath.item])
                cell.configureArrows(showPrev: !isFirst, showNext: !isLast)
                cell.delegate = self

                return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            cell.delegate = self
            if let partner = viewModel?.newPartner {
                cell.configureCell(with: partner)
            }
            return cell

        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactCell", for: indexPath) as! ContactCell
            if let contact = viewModel?.newPartner?.contact[indexPath.item] {
                cell.configureCell(with: contact)
            }
            return cell

        default:
            return UICollectionViewCell()
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
            header.configure(with: "Haqqında", icon: "exclamationmark.circle")
        case 2:
            header.configure(with: OlsunStrings.contactText.localized, icon: "headset")
        default:
            return header
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            viewModel?.showPartnerGallery(
                partner: (viewModel?.newPartner)!,
                index: indexPath.row
            )
        }
    }
}

extension PartnerDetailViewController: HeaderCellDelegate, GalleryCellDelegate {
    func didTapPrevious(in cell: GalleryCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let prevIndex = max(indexPath.item - 1, 0)
        let target = IndexPath(item: prevIndex, section: indexPath.section)
        collectionView.scrollToItem(at: target, at: .centeredHorizontally, animated: true)
    }
    
    func didTapNext(in cell: GalleryCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let itemCount = collectionView.numberOfItems(inSection: indexPath.section)
        let nextIndex = min(indexPath.item + 1, itemCount - 1)
        let target = IndexPath(item: nextIndex, section: indexPath.section)
        collectionView.scrollToItem(at: target, at: .centeredHorizontally, animated: true)
    }
    
    func didTapReadMore(in cell: HeaderCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
            cell.toggleDescription()
            self.collectionView.performBatchUpdates(nil)
        }, completion: nil)
    }
}
