//
//  SelectionView.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 30.08.25.
//

import UIKit

protocol SelectionViewDelegate: AnyObject {
    func selectionView(_ selectionView: SelectionView, didSelect option: String)
}

final class SelectionView: UIView {
    
    private let stackView = UIStackView()
    private var buttons: [UIButton] = []
    private var options: [String]
    
    weak var delegate: SelectionViewDelegate?
    
    private var selectedIndex: Int? {
        didSet {
            updateButtonStyles()
        }
    }
    
    init(options: [String]) {
        self.options = options
        super.init(frame: .zero)
        setupView()
        createButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func createButtons() {
        options.forEach { option in
            let button = UIButton(type: .system)
            button.setTitle(option, for: .normal)
            button.setTitleColor(.neutral400, for: .normal)
            button.titleLabel?.font = UIFont(name: "RobotoSerif-Medium", size: 15)
            
            button.layer.cornerRadius = 8
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.neutraln200.cgColor
            
            button.addTarget(self, action: #selector(optionTapped(_:)), for: .touchUpInside)
            
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
    }
    
    @objc private func optionTapped(_ sender: UIButton) {
        guard let index = buttons.firstIndex(of: sender) else { return }
        selectedIndex = index
        delegate?.selectionView(self, didSelect: options[index])
    }
    
    private func updateButtonStyles() {
        for (index, button) in buttons.enumerated() {
            if index == selectedIndex {
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = .violet600
                button.layer.borderColor = UIColor.violet600.cgColor
            } else {
                button.setTitleColor(.neutral400, for: .normal)
                button.backgroundColor = .clear
                button.layer.borderColor = UIColor.neutraln200.cgColor
            }
        }
    }
    
    func getSelectedOption() -> String? {
        guard let index = selectedIndex else { return nil }
        return options[index]
    }
}
