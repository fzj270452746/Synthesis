//
//  DifficultySelectionViewController.swift
//  Synthesis
//
//  Created by Hades on 11/18/25.
//

import UIKit

class DifficultySelectionViewController: UIViewController {

    private let backgroundImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let difficultyGridView = UIView()
    private let closeButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUserInterface()
        setupConstraints()
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
        titleLabel.text = "Select Difficulty"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        titleLabel.layer.shadowRadius = 4
        titleLabel.layer.shadowOpacity = 0.8
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Subtitle
        subtitleLabel.text = "Choose the maximum tile value"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitleLabel)

        // Difficulty grid
        difficultyGridView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(difficultyGridView)

        createDifficultyButtons()
    }

    private func createDifficultyButtons() {
        let difficulties = [3, 4, 5, 6, 7, 8, 9]
        let columns = 4
        let buttonSize: CGFloat = 75
        let spacing: CGFloat = 16

        for (index, difficulty) in difficulties.enumerated() {
            let row = index / columns
            let col = index % columns

            let button = AestheticButtonView(title: "\(difficulty)", variant: .primary)
            button.applyCompactStyle()
            button.tag = difficulty
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(difficultyButtonTapped(_:)), for: .touchUpInside)

            difficultyGridView.addSubview(button)

            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: buttonSize),
                button.heightAnchor.constraint(equalToConstant: buttonSize),
                button.leadingAnchor.constraint(equalTo: difficultyGridView.leadingAnchor, constant: CGFloat(col) * (buttonSize + spacing)),
                button.topAnchor.constraint(equalTo: difficultyGridView.topAnchor, constant: CGFloat(row) * (buttonSize + spacing))
            ])
        }
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

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            difficultyGridView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            difficultyGridView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            difficultyGridView.widthAnchor.constraint(equalToConstant: 348),
            difficultyGridView.heightAnchor.constraint(equalToConstant: 166)
        ])
    }

    @objc private func difficultyButtonTapped(_ sender: UIButton) {
        let selectedDifficulty = sender.tag
        let gameVC = GameViewController(maximumValue: selectedDifficulty)
        gameVC.modalPresentationStyle = .fullScreen
        present(gameVC, animated: true)
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}
