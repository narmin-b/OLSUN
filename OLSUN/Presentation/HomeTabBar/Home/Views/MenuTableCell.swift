//
//  MenuTableCell.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 13.04.25.
//

import UIKit
import Macaw

struct MenuItem {
    var iconName: String
    var title: String
    var description: String
}

final class MenuTableCell: UITableViewCell {
    private var svgNode: Node?

    let iconView: MacawView = {
        let view = MacawView()
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Test",
            labelColor: .primaryHighlight,
            labelFont: .workSansBold,
            labelSize: 20,
            numOfLines: 1
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Test",
            labelColor: .gray,
            labelFont: .workSansRegular,
            labelSize: 12,
            numOfLines: 1
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubViews(iconImageView, titleLabel, descriptionLabel)
        backgroundColor = .secondaryHighlight
        layer.cornerRadius = 16
        contentView.clipsToBounds = true
        selectionStyle = .none
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        iconImageView.anchor(
            top: topAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 4, left: 0, bottom: 0, right: -12)
        )
        iconImageView.anchorSize(.init(
            width: DeviceSizeClass.current == .compact ? 60 : 68,
            height: DeviceSizeClass.current == .compact ? 60 : 68
        ))
        
        titleLabel.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            padding: .init(top: 16, left: 24, bottom: 0, right: 0)
        )
        descriptionLabel.anchor(
            top: titleLabel.bottomAnchor,
            leading: leadingAnchor,
            padding: .init(top: 2, left: 24, bottom: 0, right: 0)
        )
    }
    
    func configure(with item: MenuItem) {
        titleLabel.text = item.title
        accessibilityIdentifier = "menuCell_\(item.title)"
        descriptionLabel.text = item.description
        iconImageView.image = UIImage(named: item.iconName)
    }

    private func loadSVG(urlString: String) {
        guard let url = URL(string: urlString) else {
            Logger.debug("❌ Invalid URL: \(urlString)")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }

            if let error = error {
                Logger.debug("❌ SVG download error: \(error)")
                return
            }

            guard let data = data,
                  let svgText = String(data: data, encoding: .utf8) else {
                Logger.debug("❌ Could not decode SVG data")
                return
            }

            Logger.debug("✅ SVG Loaded from URL")
            Logger.debug("\(svgText.prefix(100))")

            do {
                let node = try SVGParser.parse(text: svgText)
                DispatchQueue.main.async {
                    self.svgNode = node
                    self.iconView.node = node
                }
            } catch {
                Logger.debug("❌ SVG Parsing failed: \(error)")
            }
        }.resume()
    }
}
