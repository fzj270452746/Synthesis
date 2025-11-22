//
//  FeedbackViewController.swift
//  Synthesis
//
//  Created by Hades on 11/18/25.
//

import UIKit

class PatronageVoiceCollector: UIViewController {

    private let environmentalBackdropCanvas = UIImageView()
    private let purposeDeclaration = UILabel()
    private let narrativeCompositionField = UITextView()
    private let transmissionPillar = LuminousActionPillar(title: "Submit Feedback", variant: .paramount)
    private let withdrawalPillar = UIButton()
    private let instructionalGhostText = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        constructCollectionInterface()
        delineateLayoutBoundaries()
        establishInteractionProtocols()
    }

    private func constructCollectionInterface() {
        // Background
        environmentalBackdropCanvas.image = UIImage(named: "backgruiou")
        environmentalBackdropCanvas.contentMode = .scaleAspectFill
        environmentalBackdropCanvas.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(environmentalBackdropCanvas)

        // Close button
        withdrawalPillar.setTitle("✕", for: .normal)
        withdrawalPillar.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        withdrawalPillar.setTitleColor(.white, for: .normal)
        withdrawalPillar.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        withdrawalPillar.layer.cornerRadius = 20
        withdrawalPillar.translatesAutoresizingMaskIntoConstraints = false
        withdrawalPillar.addTarget(self, action: #selector(withdrawalPercussionDetected), for: .touchUpInside)
        view.addSubview(withdrawalPillar)

        // Title
        purposeDeclaration.text = "Feedback"
        purposeDeclaration.font = UIFont.boldSystemFont(ofSize: 28)
        purposeDeclaration.textColor = .white
        purposeDeclaration.textAlignment = .center
        purposeDeclaration.layer.shadowColor = UIColor.black.cgColor
        purposeDeclaration.layer.shadowOffset = CGSize(width: 0, height: 2)
        purposeDeclaration.layer.shadowRadius = 4
        purposeDeclaration.layer.shadowOpacity = 0.8
        purposeDeclaration.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(purposeDeclaration)

        // Feedback text view
        narrativeCompositionField.font = UIFont.systemFont(ofSize: 16)
        narrativeCompositionField.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        narrativeCompositionField.layer.cornerRadius = 12
        narrativeCompositionField.layer.borderWidth = 2
        narrativeCompositionField.layer.borderColor = UIColor(white: 0.7, alpha: 1.0).cgColor
        narrativeCompositionField.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        narrativeCompositionField.translatesAutoresizingMaskIntoConstraints = false
        narrativeCompositionField.delegate = self
        view.addSubview(narrativeCompositionField)

        // Placeholder
        instructionalGhostText.text = "Enter your feedback here..."
        instructionalGhostText.font = UIFont.systemFont(ofSize: 16)
        instructionalGhostText.textColor = UIColor.lightGray
        instructionalGhostText.translatesAutoresizingMaskIntoConstraints = false
        narrativeCompositionField.addSubview(instructionalGhostText)

        // Submit button
        transmissionPillar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(transmissionPillar)
    }

    private func delineateLayoutBoundaries() {
        NSLayoutConstraint.activate([
            environmentalBackdropCanvas.topAnchor.constraint(equalTo: view.topAnchor),
            environmentalBackdropCanvas.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            environmentalBackdropCanvas.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            environmentalBackdropCanvas.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            withdrawalPillar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            withdrawalPillar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            withdrawalPillar.widthAnchor.constraint(equalToConstant: 40),
            withdrawalPillar.heightAnchor.constraint(equalToConstant: 40),

            purposeDeclaration.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            purposeDeclaration.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            purposeDeclaration.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            narrativeCompositionField.topAnchor.constraint(equalTo: purposeDeclaration.bottomAnchor, constant: 32),
            narrativeCompositionField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            narrativeCompositionField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            narrativeCompositionField.heightAnchor.constraint(equalToConstant: 200),

            instructionalGhostText.topAnchor.constraint(equalTo: narrativeCompositionField.topAnchor, constant: 12),
            instructionalGhostText.leadingAnchor.constraint(equalTo: narrativeCompositionField.leadingAnchor, constant: 16),

            transmissionPillar.topAnchor.constraint(equalTo: narrativeCompositionField.bottomAnchor, constant: 32),
            transmissionPillar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            transmissionPillar.widthAnchor.constraint(equalToConstant: 280)
        ])
    }

    private func establishInteractionProtocols() {
        transmissionPillar.addTarget(self, action: #selector(transmissionPillarPercussed), for: .touchUpInside)
    }

    @objc private func transmissionPillarPercussed() {
        let feedbackText = narrativeCompositionField.text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !feedbackText.isEmpty else {
            OpulentInquiryPanel.renderInquisitivePanel(
                title: "Empty Feedback",
                message: "Please enter your feedback before submitting.",
                actions: [("OK", .paramount, {})]
            )
            return
        }

        let feedbackEntry = ObservationTestimony(narrativeSubstance: feedbackText, inscriptionMoment: Date())
        ArchivedRepositoryKeeper.sovereignExemplar.archiveObservationTestimony(feedbackEntry)

        OpulentInquiryPanel.renderInquisitivePanel(
            title: "Thank You!",
            message: "Your feedback has been submitted.",
            actions: [
                ("OK", .paramount, { [weak self] in
                    self?.dismiss(animated: true)
                })
            ]
        )
    }

    @objc private func withdrawalPercussionDetected() {
        dismiss(animated: true)
    }
}

// MARK: - UITextViewDelegate

extension PatronageVoiceCollector: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        instructionalGhostText.isHidden = !textView.text.isEmpty
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        instructionalGhostText.isHidden = true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        instructionalGhostText.isHidden = !textView.text.isEmpty
    }
}
