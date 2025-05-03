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
    
//    private lazy var refreshControl: UIRefreshControl = {
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(reloadPage), for: .valueChanged)
//        return refreshControl
//    }()
    
    private lazy var titleLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Olsun-da hər istəyə uyğun xidmət üçün tərəfdaş tap!",
            labelColor: .black,
            labelFont: .montserratMedium,
            labelSize: 18,
            numOfLines: 2
        )
        label.accessibilityIdentifier = "partnersTitleLabel"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var typeMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Xidmət növü", for: .normal)
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
        button.setTitle("Məkan", for: .normal)
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
    
    private lazy var partnersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(PartnerCell.self, forCellWithReuseIdentifier: PartnerCell.identifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
    
    private var partners: [Partner] = []
    private var allPartners: [Partner] = []
    
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
        
        Logger.debug("id: \(KeychainHelper.getString(key: .userID) ?? "")")
        
        partners = [
            Partner(
                name: "Javahir Design",
                description: "İncə zövqlə gəlinliklər hazırlayan bir atelyedir. loren ipsum loren ipsum loren ipsum loren ipsumloren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum lorSON",
                coverImage: UIImage(named: "javahirCover")!,
                category: .weddingClothes,
                gallery: [UIImage(named: "javahirCover")!, UIImage(named: "javahir1")!, UIImage(named: "javahir2")!],
                logo: UIImage(named: "javahirLogo")!,
                contact: [Contact(name: .instagram, link: ""), Contact(name: .whatsapp, link: "")],
                location: .baku
            ),
            Partner(
                name: "Turqay Zeynallı",
                description: "Toy və Tədbir Fotoqrafı. Hər anın təbii gözəlliyi loren ipsum. loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum",
                coverImage: UIImage(named: "turqayCover")!,
                category: .photographer,
                gallery: [UIImage(named: "turqay1")!, UIImage(named: "turqay2")!, UIImage(named: "turqay3")!],
                logo: UIImage(named: "turqayLogo")!,
                contact: [Contact(name: .instagram, link: ""), Contact(name: .whatsapp, link: "")],
                location: .baku
            ),
            Partner(
                name: "Elatus",
                description: "Kişi, qadın və uşaq geyimlərinin onun ölçülerf loren ipsum loren ipsum loren ipsum loren ipsumloren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum loren ipsum",
                coverImage: UIImage(named: "elatusCover")!,
                category: .weddingClothes,
                gallery: [UIImage(named: "elatus1")!, UIImage(named: "elatus2")!],
                logo: UIImage(named: "elatusLogo")!,
                contact: [Contact(name: .instagram, link: ""), Contact(name: .whatsapp, link: "")],
                location: .baku
            )
        ]
        allPartners = partners
    }
    
    override func configureView() {

        configureNavigationBar()
        
        view.backgroundColor = .white
        view.addSubViews(loadingView, titleLabel, typeMenuButton, locationMenuButton, partnersCollectionView)
        view.bringSubviewToFront(loadingView)
        
        typeDropdown.options = ServiceType.allCases.map { $0.rawValue }
        typeDropdown.onSelect = { [weak self] selected in
            let title = selected ?? "Xidmət növü"
            self?.typeMenuButton.setTitle(title, for: .normal)

            self?.selectedType = ServiceType(rawValue: selected ?? "")
            self?.filterPartners()
            self?.hideDropdown(self?.typeMenuButton ?? UIButton())
        }

        
        typeDropdown.translatesAutoresizingMaskIntoConstraints = false
        typeDropdown.isHidden = true
        view.addSubview(typeDropdown)
        
        typeDropdown.anchorSize(.init(width: 0, height: ServiceType.allCases.count * 44))
        NSLayoutConstraint.activate([
            typeDropdown.topAnchor.constraint(equalTo: typeMenuButton.bottomAnchor, constant: 4),
            typeDropdown.leadingAnchor.constraint(equalTo: typeMenuButton.leadingAnchor),
            typeDropdown.widthAnchor.constraint(equalTo: typeMenuButton.widthAnchor, constant: 60),
        ])
        
        
        locationDropdown.options = ServiceLocation.allCases.map { $0.rawValue }
        locationDropdown.onSelect = { [weak self] selected in
            let title = selected ?? "Məkan"
            self?.locationMenuButton.setTitle(title, for: .normal)

            self?.selectedLocation = ServiceLocation(rawValue: selected ?? "")
            self?.filterPartners()
            self?.hideDropdown(self?.locationMenuButton ?? UIButton())
        }
        locationDropdown.translatesAutoresizingMaskIntoConstraints = false
        locationDropdown.isHidden = true
        view.addSubview(locationDropdown)
        
        locationDropdown.anchorSize(.init(width: 0, height: ServiceLocation.allCases.count * 44))
        NSLayoutConstraint.activate([
            locationDropdown.topAnchor.constraint(equalTo: locationMenuButton.bottomAnchor, constant: 4),
            locationDropdown.trailingAnchor.constraint(equalTo:  view.trailingAnchor, constant: -20),
            locationDropdown.widthAnchor.constraint(equalTo: locationMenuButton.widthAnchor, constant: 60),
        ])
     }
    
    private func filterPartners() {
        partners = allPartners.filter { partner in
            let typeMatches = selectedType == nil || partner.category == selectedType
            let locationMatches = selectedLocation == nil || partner.location == selectedLocation
            return typeMatches && locationMatches
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
            trailing: view.trailingAnchor,
            padding: .init(top: 20, left: 24, bottom: 0, right: -24)
        )
        
        typeMenuButton.anchor(
            top: titleLabel.bottomAnchor,
            leading: view.leadingAnchor,
            padding: .init(top: 20, left: 20, bottom: 0, right: 0)
        )
        typeMenuButton.anchorSize(.init(width: view.frame.width/2 - 24, height: DeviceSizeClass.current == .compact ? 36 : 44))
        
        locationMenuButton.anchor(
            top: titleLabel.bottomAnchor,
            leading: view.centerXAnchor,
            padding: .init(top: 20, left: 44, bottom: 0, right: 0)
        )
        locationMenuButton.anchorSize(.init(width: view.frame.width/2 - 88, height: DeviceSizeClass.current == .compact ? 36 : 44))
        
        partnersCollectionView.anchor(
            top: typeMenuButton.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 0)
        )
    }
    
    fileprivate func configureNavigationBar() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.tintColor = .primaryHighlight
        navigationItem.configureNavigationBar(text: "Tərəfdaşlar")
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
//                    self.refreshControl.endRefreshing()
                    self.partnersCollectionView.reloadData()
                case .error(let error):
                    self.showMessage(title: "Error", message: error)
                }
            }
        }
    }
}

extension PartnersViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return partners.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PartnerCell.identifier, for: indexPath) as! PartnerCell
            cell.configure(with: partners[indexPath.item])
            return cell
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = (collectionView.frame.width - 48) / 2
            return CGSize(width: width, height: width)
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.showPartnerDetailVC(partner: partners[indexPath.item])
    }
}
