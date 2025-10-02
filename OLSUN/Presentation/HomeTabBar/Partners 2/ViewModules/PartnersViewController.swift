//
//  PartnersViewController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 02.05.25.
//

import UIKit

final class PartnersViewController: BaseViewController {
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
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadPage), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Partnyorlar",
            labelColor: .black,
            labelFont: .robotoSerifMedium,
            labelSize: 24,
            numOfLines: 1
        )
        label.accessibilityIdentifier = "homeTitleLabel"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var typeMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(OlsunStrings.serviceTypeText.localized, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: FontKeys.workSansMedium.rawValue, size: DeviceSizeClass.current == .compact ? 14 : 16)
        button.backgroundColor = .secondaryHighlight
        button.layer.cornerRadius = 8
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: -12, bottom: 12, right: 0)
        button.tintColor = .black
        button.isUserInteractionEnabled = true
        button.addRightImage(image: UIImage(systemName: "chevron.down")!, offset: 12)
        button.addTarget(self, action: #selector(toggleDropdown(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var locationMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(OlsunStrings.serviceLocText.localized, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: FontKeys.workSansMedium.rawValue, size: DeviceSizeClass.current == .compact ? 14 : 16)
        button.backgroundColor = .secondaryHighlight
        button.layer.cornerRadius = 8
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: -12, bottom: 12, right: 0)
        button.tintColor = .black
        button.isUserInteractionEnabled = true
        button.addRightImage(image: UIImage(systemName: "chevron.down")!, offset: 12)
        button.addTarget(self, action: #selector(toggleDropdown(_:)), for: .touchUpInside)
        
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var partnersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.refreshControl = refreshControl
        collectionView.register(PartnerCell.self, forCellWithReuseIdentifier: PartnerCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var filterOptions: [FilterOption] = {
        var options = [FilterOption(title: "Hamısı", isSelected: true)] // Default selected
        options.append(contentsOf: ServiceType.allCases.map {
            FilterOption(title: $0.localizedName, isSelected: false)
        })
        return options
    }()
    
    // MARK: Configurations
    private let viewModel: PartnersViewModel?
    private let typeDropdown = CustomDropdownMenu()
    private let locationDropdown = CustomDropdownMenu()
    private let dropdownOverlay = UIView()
    private var isDropdownVisible = false
    private var activeDropdownButton: UIButton?
    private var selectedType: ServiceType?
    private var selectedLocation: ServiceLocation?
    
    init(viewModel: PartnersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        viewModel?.requestCallback = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        
        viewModel?.getAllVendorList()
        Logger.debug("id: \(KeychainHelper.getString(key: .userID) ?? "")")
    }
    
    override func configureView() {
        
        configureNavigationBar()
        
        view.backgroundColor = .white
        view.addSubViews(loadingView, titleLabel, partnersCollectionView, filterCollectionView)
        view.bringSubviewToFront(loadingView)
    }
    
    private func filterPartners() {
        if filterOptions.first?.isSelected == true {
            viewModel?.protocolList = viewModel?.allProtocolList ?? []
        } else {
            let selectedTitles = filterOptions.filter { $0.isSelected && $0.title != "All" }.map { $0.title }
            let selectedTypes = selectedTitles.compactMap { ServiceType.fromLocalizedName($0) }
            
            viewModel?.protocolList = viewModel?.allProtocolList.filter { partner in
                selectedTypes.contains(partner.category ?? .decoration)
            } ?? []
        }
        partnersCollectionView.reloadData()
    }
    
    @objc private func toggleDropdown(_ button: UIButton) {
        if isDropdownVisible {
            hideDropdown(button)
        } else {
            showDropdown(button)
        }
    }
    
    private func showDropdown(_ button: UIButton) {
        activeDropdownButton = button
        
        dropdownOverlay.frame = view.bounds
        dropdownOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        dropdownOverlay.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideDropdownOverlay))
        dropdownOverlay.addGestureRecognizer(tapGesture)
        
        view.addSubview(dropdownOverlay)
        
        if button == typeMenuButton {
            view.bringSubviewToFront(typeMenuButton)
            view.bringSubviewToFront(typeDropdown)
            typeDropdown.isHidden = false
        } else {
            view.bringSubviewToFront(locationMenuButton)
            view.bringSubviewToFront(locationDropdown)
            locationDropdown.isHidden = false
        }
        
        isDropdownVisible = true
    }
    
    @objc private func hideDropdownOverlay() {
        guard let button = activeDropdownButton else { return }
        hideDropdown(button)
    }
    
    @objc private func hideDropdown(_ button: UIButton) {
        dropdownOverlay.removeFromSuperview()
        if button == typeMenuButton {
            typeDropdown.isHidden = true
        } else {
            locationDropdown.isHidden = true
        }
        isDropdownVisible = false
    }
    
    override func configureConstraint() {
        loadingView.fillSuperviewSafeAreaLayoutGuide()
        
        titleLabel.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            padding: .init(top: 0, left: 16, bottom: 0, right: 0)
        )
       
        partnersCollectionView.anchor(
            top: filterCollectionView.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 8, left: 0, bottom: 0, right: 0)
        )
        
        filterCollectionView.anchor(
            top: titleLabel.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 20, left: 20, bottom: 0, right: -20)
        )
        filterCollectionView.anchorSize(.init(width: 0, height: 36))
    }
    
    fileprivate func configureNavigationBar() {
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
                    self.refreshControl.endRefreshing()
                    self.partnersCollectionView.reloadData()
                case .error(let error):
                    self.showMessage(title: "Error", message: error)
                }
            }
        }
    }
    
    @objc private func profileTabClicked() {
        viewModel?.showProfileScreen()
    }
    
    @objc private func reloadPage() {
        viewModel?.refreshAllVendorList()
    }
    
    @objc private func clearFilters() {
        filterOptions = filterOptions.map { FilterOption(title: $0.title, isSelected: false) }
        filterCollectionView.reloadData()
        filterPartners()
    }
    
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension PartnersViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == partnersCollectionView {
            return viewModel?.protocolList.count ?? 0
        } else {
            return filterOptions.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == partnersCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PartnerCell.identifier, for: indexPath) as! PartnerCell
            if let partner = viewModel?.protocolList[safe: indexPath.item] {
                cell.configureCell(with: partner)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.identifier, for: indexPath) as! FilterCell
            cell.configure(with: filterOptions[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == partnersCollectionView {
            let width = (collectionView.frame.width - 48) / 2
            return CGSize(width: width, height: width - 16)
        } else {
            let title = filterOptions[indexPath.item].title
            let width = (title as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)]).width + 24
            return CGSize(width: width, height: 32)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == partnersCollectionView {
            
            guard
                ((viewModel?.allProtocolList.indices.contains(indexPath.item)) != nil),
                let newPartner = viewModel?.allProtocolList[indexPath.item]
            else {
                print("Index out of range for partners or protocolList at item:", indexPath.item)
                return
            }
            viewModel?.addViewCount(partner: newPartner)
            
            viewModel?.showPartnerDetailVC(newPartner: newPartner)
        } else {
            if indexPath.item == 0 {
                for i in 0..<filterOptions.count {
                    filterOptions[i].isSelected = (i == 0)
                }
            } else {
                filterOptions[0].isSelected = false
                filterOptions[indexPath.item].isSelected.toggle()
                
                if !filterOptions.contains(where: { $0.isSelected }) {
                    filterOptions[0].isSelected = true
                }
            }
            
            collectionView.reloadData()
            filterPartners()
        }
    }
}
