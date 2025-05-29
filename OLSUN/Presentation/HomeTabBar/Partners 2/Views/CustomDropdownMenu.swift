//
//  CustomDropdownMenu.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 02.05.25.
//

import UIKit

final class CustomDropdownMenu: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var options: [String] = []
    var selectedOption: String? {
        didSet { tableView.reloadData() }
    }
    var onSelect: ((String?) -> Void)?
    
    private let tableView = UITableView()
    private let cellIdentifier = "DropdownCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setup() {
        layer.cornerRadius = 8
        backgroundColor = .white
        layer.borderWidth = 1
        clipsToBounds = true
        layer.borderColor = UIColor.lightGray.cgColor
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        tableView.fillSuperview()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.font = UIFont(name: FontKeys.workSansMedium.rawValue, size: DeviceSizeClass.current == .compact ? 14 : 16)
        cell.tintColor = .black
        cell.textLabel?.text = option
        cell.textLabel?.textColor = .black
        
        print(cell.frame.height)
        cell.accessoryType = .none
        cell.backgroundColor = .white
        cell.imageView?.image = nil
        
        if selectedOption == option {
            let checkmark = UIImage(systemName: "checkmark.square")?.withTintColor(.black, renderingMode: .alwaysOriginal)
            cell.imageView?.image = checkmark
        } else {
            cell.imageView?.image = UIImage(systemName: "square")?
                .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tappedOption = options[indexPath.row]
        
        selectedOption = (selectedOption == tappedOption) ? nil : tappedOption
        onSelect?(selectedOption)
        tableView.reloadData()
    }
}
