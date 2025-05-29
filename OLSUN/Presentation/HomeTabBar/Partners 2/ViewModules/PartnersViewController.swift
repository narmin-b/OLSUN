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
            labelText: OlsunStrings.partnersSubtitle.localized,
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
                description: "\"Javahir Design\" incə zövqlə gəlinliklər hazırlayan bir atelyedir. Burada hər gəlin öz xəyalındakı libası tapır və xüsusi sifarişlə hazırlanan modellərlə fərqlənir. Keyfiyyət və estetik yanaşma atelyemizin əsas prioritetləridir.",
                coverImage: UIImage(named: "javahirCover")!,
                category: .weddingDresses,
                gallery: [UIImage(named: "javahirCover")!, UIImage(named: "javahir1")!, UIImage(named: "javahir2")!],
                logo: UIImage(named: "javahirLogo")!,
                contact: [Contact(name: .instagram, link: ""), Contact(name: .whatsapp, link: "")],
                location: .baku
            ),
            Partner(
                name: "Turqay Zeynallı",
                description: "Toy və Tədbir Fotoqrafı. Hər anın təbii gözəlliyini və orijinallığını qoruyaraq, xatirələrinizi incə bir yanaşma ilə sənədləşdirir. Çəkilişlərində sadəlik, estetik baxış və duyğunun harmoniyası ön plandadır. Xüsusi günlərinizin ən saf və səmimi anlarını zamansız kadrlarla əbədiləşdirməyi hədəfləyir.",
                coverImage: UIImage(named: "turqayCover")!,
                category: .photographer,
                gallery: [UIImage(named: "turqay1")!, UIImage(named: "turqay2")!, UIImage(named: "turqay3")!],
                logo: UIImage(named: "turqayLogo")!,
                contact: [Contact(name: .instagram, link: ""), Contact(name: .whatsapp, link: "")],
                location: .baku
            ),
            Partner(
                name: "Elatus",
                description: "Kişi, qadın və uşaq geyimlərinin onun ölçülərinə uyğun peşəkar hazırlanması. Geyimlərinin zövqünə və bədən formasına tam uyğunlaşdırılması üçün yüksək keyfiyyətli xidmət təklif olunur. Eləcə də, hazır paltarlarının premium təmiri və estetik yenilənməsi ilə sevimli geyimlərinə yenidən həyat verilir.",
                coverImage: UIImage(named: "elatusCover")!,
                category: .tuxedo,
                gallery: [UIImage(named: "elatus1")!, UIImage(named: "elatus2")!],
                logo: UIImage(named: "elatusLogo")!,
                contact: [Contact(name: .instagram, link: ""), Contact(name: .whatsapp, link: "")],
                location: .baku
            ),
            Partner(
                name: "Nur Xına Təşkili",
                description: "Nur Xına Təşkili Zərifə Xanlarovanın rəhbərliyi ilə xına və nişan mərasimlərini zəriflik və ənənə ilə birləşdirərək unudulmaz anlara çevirir. Hər büdcəyə uyğun dekorlar, peşəkar rəqqasə və davulçular, milli rəqslər, mələklərlə gözqamaşdıran girişlər, zövqlə hazırlanmış xonçalar və nişan/həri süfrələri təqdim olunur. Toy və xına aparıcılığı xidmətləri ilə tədbirlər yüksək səviyyədə təşkil olunur – hər detal incəliklə düşünülərək həyata keçirilir.",
                coverImage: UIImage(named: "nurxinaLogo")!,
                category: .khinaOrg,
                gallery: [UIImage(named: "nurxina1")!, UIImage(named: "nurxina2")!, UIImage(named: "nurxina3")!],
                logo: UIImage(named: "nurxinaLogo")!,
                contact: [Contact(name: .instagram, link: ""), Contact(name: .whatsapp, link: ""), Contact(name: .tiktok, link: "")],
                location: .baku
            ),
            Partner(
                name: "Ayla Xonça evi",
                description: "Xonça Boutique, toy, nişan və xına mərasimləri üçün zövqlə hazırlanmış xonça və səbətləri ilə özəl günlərə fərqlilik qatır. Aksessuarlar, şokolad və stekan bəzəkləri ilə hər şey incəliklə tamamlanır. Eyni zamanda, müxtəlif dizaynlarda xonçaların kirayəsi də mövcuddur – hər zövqə və konseptə uyğun seçim imkanı təqdim edilir.",
                coverImage: UIImage(named: "aylaxoncaLogo")!,
                category: .khonca,
                gallery: [UIImage(named: "aylaxonca1")!, UIImage(named: "aylaxonca2")!, UIImage(named: "aylaxonca3")!],
                logo: UIImage(named: "aylaxoncaLogo")!,
                contact: [Contact(name: .instagram, link: ""), Contact(name: .whatsapp, link: ""), Contact(name: .tiktok, link: "")],
                location: .baku
            ),
            Partner(
                name: "Rəvanənin tortları",
                description: "Hər növ tort və şirniyyat sifarişləri zövqünüzə uyğun şəkildə qəbul olunur. Həm görünüşü ilə göz oxşayan, həm də dadı ilə yadda qalan şirniyyatlar xüsusi günlərinizi daha da şirin edəcək.",
                coverImage: UIImage(named: "revanetortLogo")!,
                category: .sweets,
                gallery: [UIImage(named: "revanetort1")!, UIImage(named: "revanetort2")!, UIImage(named: "revanetort3")!],
                logo: UIImage(named: "revanetortLogo")!,
                contact: [Contact(name: .instagram, link: ""), Contact(name: .whatsapp, link: ""), Contact(name: .tiktok, link: "")],
                location: .baku
            ),
            Partner(
                name: "Romantic Decoration",
                description: "Unudulmaz evlilik təklifləri və romantik anlar üçün zövqlü dekorasiyalarla xidmətinizdədir. Güllər, şamlar, işıqlar və sevgi dolu detallarla hazırlanmış konseptlər xüsusi anlarınızı nağıl kimi yaşadacaq.",
                coverImage: UIImage(named: "romanticdecLogo")!,
                category: .decoration,
                gallery: [UIImage(named: "romanticdec1")!, UIImage(named: "romanticdec2")!, UIImage(named: "romanticdec3")!],
                logo: UIImage(named: "romanticdecLogo")!,
                contact: [Contact(name: .instagram, link: ""), Contact(name: .whatsapp, link: ""), Contact(name: .tiktok, link: "")],
                location: .baku
            ),
            Partner(
                name: "Baku Wedding",
                description: "Zövqlü dizayn, peşəkar planlama və unudulmaz məkan dekorasiyaları ilə toy və xüsusi günlərinizi istədiyiniz kimi həyata keçirir. Hər detalda incəlik, hər tədbirdə fərqlilik – çünki sizin gününüz mükəmməl olmalıdır.",
                coverImage: UIImage(named: "bakuwedLogo")!,
                category: .decoration,
                gallery: [UIImage(named: "bakuwed1")!, UIImage(named: "bakuwed2")!, UIImage(named: "bakuwed3")!],
                logo: UIImage(named: "bakuwedLogo")!,
                contact: [Contact(name: .instagram, link: ""), Contact(name: .whatsapp, link: ""), Contact(name: .tiktok, link: "")],
                location: .baku
            ),
            Partner(
                name: "Könül Xonça",
                description: "Nişan və həri mərasimləriniz üçün zövqlə hazırlanmış xonçalar və 30 nəfərlik tam set kirayəsi ilə xüsusi gününüzü daha da yadda qalan edin.",
                coverImage: UIImage(named: "konulxoncaLogo")!,
                category: .khonca,
                gallery: [UIImage(named: "konulxonca1")!, UIImage(named: "konulxonca2")!, UIImage(named: "konulxonca3")!],
                logo: UIImage(named: "konulxoncaLogo")!,
                contact: [Contact(name: .whatsapp, link: ""), Contact(name: .tiktok, link: "")],
                location: .baku
            ),
            Partner(
                name: "Farid Aghayev",
                description: "Kişi saç kəsimi, saqqal düzəltmə və baxım prosedurları, eləcə də xüsusi günlər üçün saç dizaynı xidmətləri təklif edir. Peşəkar yanaşma və zövqlü toxunuşla hər müştərinin stilini ön plana çıxarır.",
                coverImage: UIImage(named: "faridAghayevLogo")!,
                category: .barber,
                gallery: [],
                logo: UIImage(named: "faridAghayevLogo")!,
                contact: [Contact(name: .instagram, link: ""), Contact(name: .whatsapp, link: ""), Contact(name: .tiktok, link: "")],
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
        
        typeDropdown.options = ServiceType.allCases.map { $0.localizedName }
        typeDropdown.onSelect = { [weak self] selected in
            let title = selected ?? OlsunStrings.serviceTypeText.localized
            self?.typeMenuButton.setTitle(title, for: .normal)

            self?.selectedType = ServiceType.fromLocalizedName(selected ?? "")
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
        
        
        locationDropdown.options = ServiceLocation.allCases.map { $0.localizedName }
        locationDropdown.onSelect = { [weak self] selected in
            let title = selected ?? OlsunStrings.serviceLocText.localized
            self?.locationMenuButton.setTitle(title, for: .normal)

            self?.selectedLocation = ServiceLocation.fromLocalizedName(selected ?? "")
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
//            leading: view.centerXAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 20, left: 0, bottom: 0, right: -20)
        )
        locationMenuButton.anchorSize(.init(width: view.frame.width/2 - (DeviceSizeClass.current == .compact ? 66 : 88), height: DeviceSizeClass.current == .compact ? 36 : 44))
        
        partnersCollectionView.anchor(
            top: typeMenuButton.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 8, left: 0, bottom: 0, right: 0)
        )
    }
    
    fileprivate func configureNavigationBar() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.tintColor = .primaryHighlight
        navigationItem.configureNavigationBar(text: OlsunStrings.partnersText.localized)
        
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
        
        let profileButton = UIBarButtonItem(
            image: UIImage(named: "profile"),
            style: .plain,
            target: self,
            action: #selector(profileTabClicked)
        )
        
        profileButton.tintColor = .primaryHighlight
        
        if UserDefaultsHelper.getString(key: .loginType) == "guest" {
            navigationItem.rightBarButtonItems = []
        } else {
            navigationItem.rightBarButtonItems = [profileButton]
        }
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
    
    @objc private func profileTabClicked() {
        viewModel?.showProfileScreen()
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
