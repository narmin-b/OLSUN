//
//  Extensions.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 19.03.25.
//

import Foundation
import UIKit
import MapKit

extension Double {
    func convertToString() -> String {
        return String(self)
    }
}

extension Int {
    func convertToString() -> String {
        return String(self)
    }
}

extension UITableView {
    
    func setTableHeaderView(headerView: UIView) {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableHeaderView = headerView
        
        headerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
    func updateHeaderViewFrame() {
        guard let headerView = self.tableHeaderView else { return }
        
        headerView.layoutIfNeeded()
        
        let header = self.tableHeaderView
        self.tableHeaderView = header
    }
    
    func setBottomInset(to value: CGFloat) {
        let edgeInset = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)
        
        self.contentInset = edgeInset
        self.scrollIndicatorInsets = edgeInset
    }
}

extension UITableViewCell {
    
    static var reuseIdentifier: String {
        return NSStringFromClass(self)
    }
    
}
extension UITableView {
    
    public func register<T: UITableViewCell>(cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
}

extension UITableView {
    
    public func dequeue<T: UITableViewCell>(cellClass: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier) as? T
    }
    
    public func dequeue<T: UITableViewCell>(
        cellClass: T.Type,
        forIndexPath indexPath: IndexPath
    ) -> T {
        guard let cell = dequeueReusableCell(
            withIdentifier: cellClass.reuseIdentifier,
            for: indexPath) as? T else {
            fatalError(
                "Error: cell with id: \(cellClass.reuseIdentifier) for indexPath: \(indexPath) is not \(T.self)")
        }
        return cell
    }
    
}

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(cell: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UICollectionReusableView>(header: T.Type) {
        
        register(
            T.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UICollectionReusableView>(footer: T.Type) {
        register(
            T.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: T.reuseIdentifier)
    }
    
}

extension UICollectionView {
    func dequeue<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath
        ) as! T
    }
}

extension UICollectionView {
    func dequeue<T: UICollectionReusableView>(
        header: T.Type,
        for indexPath: IndexPath
    ) -> T {
        return dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath
        ) as! T
    }
    
    func dequeue<T: UICollectionReusableView>(
        footer: T.Type,
        for indexPath: IndexPath
    ) -> T {
        return dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath
        ) as! T
    }
}


extension UIViewController {
    func showMessage(
        title: String = "",
        message: String = "",
        actionTitle: String = "OK"
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIView {
    func addSubViews(_ views: UIView ...) {
        views.forEach({addSubview($0)})
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: UIView ...) {
        
    }
}
extension String {
    var containsWhitespace : Bool {
        return(self.rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
    }
    
    func doesContainUppercase() -> Bool {
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let stringPredicate = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        return  stringPredicate.evaluate(with: self)
    }
    
    func doesContainDigit() -> Bool {
        let numberRegEx = ".*[0-9]+.*"
        let stringPredicate = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        return stringPredicate.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        let pattern = "^[a-zA-Z0-9@#_-]{8,16}$"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self)
    }
    
    func isValidPasswordMask() -> Bool  {
        count >= 8 && count <= 4096
    }
    
    func isValidEmailMask() -> Bool  {
        count > 5
    }
    
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidName() -> Bool {
        count > 2 && !self.containsWhitespace
    }
}

extension UIImageView {
    func loadImageURL(url: String) {
        guard let url = URL(string: url) else {return}
//        self.sd_setImage(with: url)
    }
}

extension UITextField {
    func errorBorderOff() {
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
    }
    
    func errorBorderOn() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.masksToBounds = true
    }
}

extension UIWindow {
    static var current: UIWindow {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return UIWindow()
    }
}


extension UIScreen {
    static var current: UIScreen {
        UIWindow.current.screen
    }
}

extension UIButton {
    func buttonChosen() {
        backgroundColor = .primaryHighlight
        titleLabel?.textColor = .black
    }
    
    func buttonUnchosen() {
        backgroundColor = .accentMain
        titleLabel?.textColor = .white
    }
}

extension UILabel {
    func configureLabel(icon: String, text: String) {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: icon)?.withTintColor(.primaryHighlight)
        imageAttachment.bounds = CGRect(x: 0, y: 0, width: 12, height: 12)
        
        let attributedText = NSMutableAttributedString(string: "")
        attributedText.append(NSAttributedString(attachment: imageAttachment))
        attributedText.append(NSAttributedString(string: " "))
        attributedText.append(NSAttributedString(string: text))
        
        self.attributedText = attributedText
    }
}

extension UINavigationItem {
    func configureNavigationBar(text: String) {
        let navgationView = UIView()
        navgationView.translatesAutoresizingMaskIntoConstraints = false
        let label = UILabel()
        label.text = text
        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont(name: "Nexa-Bold", size: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
       
        navgationView.addSubview(label)
        label.centerXToView(to: navgationView)
        label.centerYToView(to: navgationView)

        self.titleView = navgationView

        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.backBarButtonItem = backButton
    }
}

extension UIImage {
    func resizeImage(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension MKCoordinateRegion {
    static var northCyprus: MKCoordinateRegion {
        let center = CLLocationCoordinate2D(latitude: 35.2, longitude: 33.4)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.8)
        return MKCoordinateRegion(center: center, span: span)
    }
}

extension UIView {
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
    }
}

func printFonts() {
    for family in UIFont.familyNames {
        for font in UIFont.fontNames(forFamilyName: family) {
            print(font)
        }
    }
}
