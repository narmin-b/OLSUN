//
//  Extensions.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 19.03.25.
//

import Foundation
import UIKit
import MapKit
import SDWebImage
import SVGKit
import SkeletonView
import AVFoundation

private var fullTextKey: UInt8 = 0
private var attributedFullTextKey: UInt8 = 0

func whatsapp() {
    let message = "Salam! Mən OLSUN tətbiqindən çıxdım."
    let phoneNumber = "994504577132"
    
    if let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
       let url = URL(string: "whatsapp://send?phone=\(phoneNumber)&text=\(encodedMessage)"),
       UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
        Logger.debug("WhatsApp not available")
    }
}

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
        actionTitle: String = "OK",
        completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: actionTitle, style: .default) { _ in
            completion?()
        })
        
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
        let pattern = "^[a-zA-Z0-9]{8,16}$"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self)
    }
    
    func isValidName() -> Bool {
        let nameRegex = "^[A-Za-zÀ-ÿƏəĞğİıŞşÇçÖöÜü]+([\\s'-][A-Za-zÀ-ÿƏəĞğİıŞşÇçÖöÜü]+)*$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return namePredicate.evaluate(with: self)
    }
    
    func isValidAge(format: String = "yyyy-MM-dd") -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let birthDate = dateFormatter.date(from: self) else {
            return false
        }
        
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        if let age = ageComponents.year {
            return age >= 10
        }
        return false
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
    
    func toDisplayDateFormat(from inputFormat: String = "yyyy-MM-dd", to outputFormat: String = "dd.MM.yyyy") -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = inputFormatter.date(from: self) {
            return outputFormatter.string(from: date)
        } else {
            return self
        }
    }
    
    func toAPIDateFormat() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd.MM.yyyy"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = inputFormatter.date(from: self) {
            return outputFormatter.string(from: date)
        } else {
            return self
        }
    }
}

//extension UIImageView {
//    func loadImage(named imageName: String, completion: ((UIImage?) -> Void)? = nil) {
//        let baseURL = "https://olsun.in"
//        guard let url = URL(string: baseURL + imageName) else {
//            completion?(nil)
//            return
//        }
//        
//        isSkeletonable = true
//        showAnimatedGradientSkeleton()
//
//        if url.pathExtension.lowercased().contains("mp4") || url.pathExtension.lowercased().contains("mov") {
//            DispatchQueue.global().async {
//                let asset = AVAsset(url: url)
//                let imageGenerator = AVAssetImageGenerator(asset: asset)
//                imageGenerator.appliesPreferredTrackTransform = true
//                
//                let time = CMTime(seconds: 1, preferredTimescale: 600)
//                var actualTime = CMTime.zero
//                
//                do {
//                    let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: &actualTime)
//                    let thumbnail = UIImage(cgImage: cgImage)
//                    
//                    DispatchQueue.main.async {
//                        self.hideSkeleton()
//                        self.image = thumbnail
//                        completion?(thumbnail)
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        self.hideSkeleton()
//                        completion?(nil)
//                    }
//                }
//            }
//        } else {
//            URLSession.shared.dataTask(with: url) { data, _, error in
//                DispatchQueue.main.async {
//                    self.hideSkeleton()
//                    guard let data = data, error == nil,
//                          let image = UIImage(data: data) else {
//                        completion?(nil)
//                        return
//                    }
//                    self.image = image
//                    completion?(image)
//                }
//            }.resume()
//        }
//    }
//}

extension UIImageView {
    func loadImage(named imageName: String, completion: ((UIImage?) -> Void)? = nil) {
        let baseURL = "https://olsun.in"
        guard let url = URL(string: baseURL + imageName) else {
            self.hideSkeleton()
            completion?(nil)
            return
        }

        isSkeletonable = true
        showAnimatedGradientSkeleton()

        // Handle video thumbnails
        if url.pathExtension.lowercased() == "mp4" || url.pathExtension.lowercased() == "mov" {
            let asset = AVAsset(url: url)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            let time = CMTime(seconds: 1, preferredTimescale: 600)

            generator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { [weak self] _, cgImage, _, result, error in
                DispatchQueue.main.async {
                    guard let self = self else { return }

                    if let cgImage = cgImage, result == .succeeded {
                        let image = UIImage(cgImage: cgImage)
                        UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve) {
                            self.image = image
                        }
                        self.hideSkeleton()
                        completion?(image)
                    } else {
                        print("Failed to generate video thumbnail: \(error?.localizedDescription ?? "Unknown error")")

                        // Optional fallback image for videos
                        self.image = UIImage(named: "video-placeholder") // Add a default placeholder in Assets
                        self.hideSkeleton()
                        completion?(nil)
                    }
                }
            }
        } else {
            URLSession.shared.dataTask(with: url) { data, _, error in
                DispatchQueue.main.async {
                    guard let data = data, error == nil, let image = UIImage(data: data) else {
                        self.hideSkeleton()
                        completion?(nil)
                        return
                    }

                    UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve) {
                        self.image = image
                    }
                    self.hideSkeleton()
                    completion?(image)
                }
            }.resume()
        }
    }
}

extension UIImage {
    static func thumbnailForVideo(at url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true

        let time = CMTime(seconds: 1, preferredTimescale: 60)
        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("Failed to generate thumbnail: \(error)")
            return nil
        }
    }
}

extension UITextField {
    func borderOn(with color: UIColor, width: CGFloat = 1) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.masksToBounds = true
    }
    
    func borderOff() {
        self.layer.borderWidth = 0
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

extension UILabel {
    var fullText: String? {
        get { return objc_getAssociatedObject(self, &fullTextKey) as? String }
        set { objc_setAssociatedObject(self, &fullTextKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    var attributedFullText: NSAttributedString? {
        get { return objc_getAssociatedObject(self, &attributedFullTextKey) as? NSAttributedString }
        set { objc_setAssociatedObject(self, &attributedFullTextKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    
    func setTextWithTrailing(
        trailingText: String,
        moreText: String,
        moreTextFont: UIFont,
        moreTextColor: UIColor
    ) {
        guard let fullAttributedText = self.attributedFullText else { return }
        guard let labelFont = self.font else { return }

        let fullText = fullAttributedText.string
        let labelWidth = self.frame.width
        let maxLines = self.numberOfLines
        let lineHeight = labelFont.lineHeight
        let maxHeight = CGFloat(maxLines) * lineHeight
        let constraintSize = CGSize(width: labelWidth, height: .greatestFiniteMagnitude)

        // Compose trailing attributed string
        let trailingAttr = NSMutableAttributedString(string: trailingText, attributes: [.font: labelFont])
        trailingAttr.append(NSAttributedString(string: moreText, attributes: [
            .font: moreTextFont,
            .foregroundColor: moreTextColor
        ]))

        // Binary search to find optimal cut-off point
        var low = 0
        var high = fullText.count
        var bestFit = ""

        while low < high {
            let mid = (low + high) / 2
            let testStr = String(fullText.prefix(mid))
            let testAttr = NSMutableAttributedString(string: testStr, attributes: [.font: labelFont])
            testAttr.append(trailingAttr)

            let rect = testAttr.boundingRect(
                with: constraintSize,
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                context: nil
            )

            if rect.height <= maxHeight {
                bestFit = testStr
                low = mid + 1
            } else {
                high = mid
            }
        }

        // Apply final text
        let finalAttrText = NSMutableAttributedString(string: bestFit, attributes: [.font: labelFont])
        finalAttrText.append(trailingAttr)
        self.attributedText = finalAttrText
    }
    
    func removeTrailingText() {
        self.text = self.fullText
    }
    
    private var visibleTextLength: Int {
        guard let attributedText = self.attributedFullText else { return 0 }

        let textStorage = NSTextStorage(attributedString: attributedText)
        let textContainer = NSTextContainer(size: CGSize(width: self.bounds.width, height: .greatestFiniteMagnitude))
        textContainer.lineBreakMode = self.lineBreakMode
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineFragmentPadding = 0

        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        layoutManager.glyphRange(for: textContainer) // force layout
        let range = layoutManager.characterRange(forGlyphRange: layoutManager.glyphRange(for: textContainer), actualGlyphRange: nil)

        return range.length
    }
}

private extension NSRange {
    func toOptional() -> NSRange? {
        return self.location != NSNotFound ? self : nil
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
        label.font = UIFont(name: "Montserrat-Bold", size: 28)
        label.textColor = .black
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

extension UIView {
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
    }
    
    func pinToEdges(of view: UIView) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}

func printFonts() {
    for family in UIFont.familyNames {
        for font in UIFont.fontNames(forFamilyName: family) {
            Logger.debug("\(font)")
        }
    }
}

extension UIButton {
    func addRightImage(image: UIImage, offset: CGFloat) {
        self.setImage(image, for: .normal)
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.imageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        self.imageView?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -offset).isActive = true
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while let r = responder {
            if let vc = r as? UIViewController {
                return vc
            }
            responder = r.next
        }
        return nil
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
