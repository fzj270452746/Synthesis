//
//  FeedbackViewController.swift
//  Synthesis
//
//  Created by Hades on 11/18/25.
//

import UIKit

class FeedbackViewController: UIViewController {

    private let backgroundImageView = UIImageView()
    private let titleLabel = UILabel()
    private let feedbackTextView = UITextView()
    private let submitButton = AestheticButtonView(title: "Submit Feedback", variant: .primary)
    private let closeButton = UIButton()
    private let placeholderLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUserInterface()
        setupConstraints()
        configureButtonActions()
    }

    private func configureUserInterface() {
        // Background
        backgroundImageView.image = UIImage(named: "backgruiou")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)

        // Close button
        closeButton.setTitle("✕", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        closeButton.layer.cornerRadius = 20
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)

        // Title
        titleLabel.text = "Feedback"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        titleLabel.layer.shadowRadius = 4
        titleLabel.layer.shadowOpacity = 0.8
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Feedback text view
        feedbackTextView.font = UIFont.systemFont(ofSize: 16)
        feedbackTextView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        feedbackTextView.layer.cornerRadius = 12
        feedbackTextView.layer.borderWidth = 2
        feedbackTextView.layer.borderColor = UIColor(white: 0.7, alpha: 1.0).cgColor
        feedbackTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        feedbackTextView.translatesAutoresizingMaskIntoConstraints = false
        feedbackTextView.delegate = self
        view.addSubview(feedbackTextView)

        // Placeholder
        placeholderLabel.text = "Enter your feedback here..."
        placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        feedbackTextView.addSubview(placeholderLabel)

        // Submit button
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(submitButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40),

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            feedbackTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            feedbackTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            feedbackTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            feedbackTextView.heightAnchor.constraint(equalToConstant: 200),

            placeholderLabel.topAnchor.constraint(equalTo: feedbackTextView.topAnchor, constant: 12),
            placeholderLabel.leadingAnchor.constraint(equalTo: feedbackTextView.leadingAnchor, constant: 16),

            submitButton.topAnchor.constraint(equalTo: feedbackTextView.bottomAnchor, constant: 32),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 280)
        ])
    }

    private func configureButtonActions() {
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }

    @objc private func submitButtonTapped() {
        let feedbackText = feedbackTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !feedbackText.isEmpty else {
            ElegantDialogView.displayAlert(
                title: "Empty Feedback",
                message: "Please enter your feedback before submitting.",
                actions: [("OK", .primary, {})]
            )
            return
        }

        let feedbackEntry = FeedbackEntry(feedbackContent: feedbackText, submissionDate: Date())
        PersistentStorageManager.sharedInstance.saveFeedbackEntry(feedbackEntry)

        ElegantDialogView.displayAlert(
            title: "Thank You!",
            message: "Your feedback has been submitted.",
            actions: [
                ("OK", .primary, { [weak self] in
                    self?.dismiss(animated: true)
                })
            ]
        )
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - UITextViewDelegate

extension FeedbackViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
