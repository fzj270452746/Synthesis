//
//  DifficultySelectionViewController.swift
//  Synthesis
//
//  Created by Hades on 11/18/25.
//

import UIKit

class ChallengeGradientSelector: UIViewController {

    private let scenicBackdropRenderer = UIImageView()
    private let proclamationHeader = UILabel()
    private let expositorySubtext = UILabel()
    private let adversityGradientMatrix = UIView()
    private let dismissalPillar = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        establishSelectorInterface()
        configureSpatialArrangement()
    }

    private func establishSelectorInterface() {
        // Background
        scenicBackdropRenderer.image = UIImage(named: "backgruiou")
        scenicBackdropRenderer.contentMode = .scaleAspectFill
        scenicBackdropRenderer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scenicBackdropRenderer)

        // Close button
        dismissalPillar.setTitle("✕", for: .normal)
        dismissalPillar.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        dismissalPillar.setTitleColor(.white, for: .normal)
        dismissalPillar.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dismissalPillar.layer.cornerRadius = 20
        dismissalPillar.translatesAutoresizingMaskIntoConstraints = false
        dismissalPillar.addTarget(self, action: #selector(dismissalPercussionDetected), for: .touchUpInside)
        view.addSubview(dismissalPillar)

        // Title
        proclamationHeader.text = "Select Difficulty"
        proclamationHeader.font = UIFont.boldSystemFont(ofSize: 28)
        proclamationHeader.textColor = .white
        proclamationHeader.textAlignment = .center
        proclamationHeader.layer.shadowColor = UIColor.black.cgColor
        proclamationHeader.layer.shadowOffset = CGSize(width: 0, height: 2)
        proclamationHeader.layer.shadowRadius = 4
        proclamationHeader.layer.shadowOpacity = 0.8
        proclamationHeader.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(proclamationHeader)

        // Subtitle
        expositorySubtext.text = "Choose the maximum tile value"
        expositorySubtext.font = UIFont.systemFont(ofSize: 16)
        expositorySubtext.textColor = UIColor.white.withAlphaComponent(0.9)
        expositorySubtext.textAlignment = .center
        expositorySubtext.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(expositorySubtext)

        // Difficulty grid
        adversityGradientMatrix.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(adversityGradientMatrix)

        fabricateAdversityPillars()
    }

    private func fabricateAdversityPillars() {
        let difficulties = [3, 4, 5, 6, 7, 8, 9]
        let columns = 4
        let buttonSize: CGFloat = 75
        let spacing: CGFloat = 16

        for (index, difficulty) in difficulties.enumerated() {
            let row = index / columns
            let col = index % columns

            let button = LuminousActionPillar(title: "\(difficulty)", variant: .paramount)
            button.applyCompactStyle()
            button.tag = difficulty
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(adversityPillarPercussed(_:)), for: .touchUpInside)

            adversityGradientMatrix.addSubview(button)

            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: buttonSize),
                button.heightAnchor.constraint(equalToConstant: buttonSize),
                button.leadingAnchor.constraint(equalTo: adversityGradientMatrix.leadingAnchor, constant: CGFloat(col) * (buttonSize + spacing)),
                button.topAnchor.constraint(equalTo: adversityGradientMatrix.topAnchor, constant: CGFloat(row) * (buttonSize + spacing))
            ])
        }
    }

    private func configureSpatialArrangement() {
        NSLayoutConstraint.activate([
            scenicBackdropRenderer.topAnchor.constraint(equalTo: view.topAnchor),
            scenicBackdropRenderer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scenicBackdropRenderer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scenicBackdropRenderer.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            dismissalPillar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            dismissalPillar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dismissalPillar.widthAnchor.constraint(equalToConstant: 40),
            dismissalPillar.heightAnchor.constraint(equalToConstant: 40),

            proclamationHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            proclamationHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            proclamationHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            expositorySubtext.topAnchor.constraint(equalTo: proclamationHeader.bottomAnchor, constant: 12),
            expositorySubtext.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            expositorySubtext.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            adversityGradientMatrix.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            adversityGradientMatrix.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            adversityGradientMatrix.widthAnchor.constraint(equalToConstant: 348),
            adversityGradientMatrix.heightAnchor.constraint(equalToConstant: 166)
        ])
    }

    @objc private func adversityPillarPercussed(_ sender: UIButton) {
        let selectedDifficulty = sender.tag
        let gameVC = ArenaCommandController(maximumValue: selectedDifficulty)
        gameVC.modalPresentationStyle = .fullScreen
        present(gameVC, animated: true)
    }

    @objc private func dismissalPercussionDetected() {
        dismiss(animated: true)
    }
}
