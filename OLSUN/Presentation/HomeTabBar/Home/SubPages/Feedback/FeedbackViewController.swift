//
//  FeedbackViewController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 15.07.25.
//

import UIKit

final class FeedbackViewController: UIViewController {
    private let viewModel = FeedbackViewModel()
    private let placeholderText = OlsunStrings.feedbackPlaceholderText.localized
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = OlsunStrings.feedbackVCTitle.localized
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let feedbackTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.layer.cornerRadius = 12
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(OlsunStrings.submitText.localized, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .primaryHighlight
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        return button
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        configureViewModel()
        configurePlaceholder()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(feedbackTextView)
        view.addSubview(submitButton)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            feedbackTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            feedbackTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            feedbackTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            feedbackTextView.heightAnchor.constraint(equalToConstant: 200),
            
            submitButton.topAnchor.constraint(equalTo: feedbackTextView.bottomAnchor, constant: 32),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -64),
            submitButton.heightAnchor.constraint(equalToConstant: 48),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        feedbackTextView.delegate = self
    }
    
    private func configureViewModel() {
        viewModel.requestCallback = { [weak self] state in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    self.loadingIndicator.startAnimating()
                    self.submitButton.isEnabled = false
                case .loaded:
                    self.loadingIndicator.stopAnimating()
                case .success:
                    self.dismiss(animated: true, completion: nil)
                case .error(let message):
                    self.showMessage(title: "Xəta", message: message)
                    self.submitButton.isEnabled = true
                }
            }
        }
    }
    
    private func configurePlaceholder() {
        feedbackTextView.text = placeholderText
        feedbackTextView.textColor = .lightGray
    }
    
    @objc private func submitTapped() {
        let text = feedbackTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, text != placeholderText else {
            showMessage(title: "Xəta", message: "Rəy boş ola bilməz")
            return
        }
        viewModel.sendFeedback(text: text)
    }
}

extension FeedbackViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
    }
}
// ... existing code ...
