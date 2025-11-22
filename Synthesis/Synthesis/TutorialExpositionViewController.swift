//
//  TutorialExpositionViewController.swift
//  Synthesis
//
//  Created by Hades on 11/18/25.
//

import UIKit

class TutorialExpositionViewController: UIViewController {

    private let backgroundImageView = UIImageView()
    private let closeButton = UIButton()
    private let contentScrollView = UIScrollView()
    private let contentContainerView = UIView()

    private let headerTitleLabel = UILabel()
    private let objectiveSectionView = InstructionSectionView()
    private let mechanicsSectionView = InstructionSectionView()
    private let scoringSectionView = InstructionSectionView()
    private let strategySectionView = InstructionSectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUserInterface()
        populateInstructionContent()
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

        // Scroll view
        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        contentScrollView.showsVerticalScrollIndicator = true
        view.addSubview(contentScrollView)

        // Container view
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentScrollView.addSubview(contentContainerView)

        // Header title
        headerTitleLabel.text = "How to Play"
        headerTitleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        headerTitleLabel.textColor = .white
        headerTitleLabel.textAlignment = .center
        headerTitleLabel.layer.shadowColor = UIColor.black.cgColor
        headerTitleLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        headerTitleLabel.layer.shadowRadius = 4
        headerTitleLabel.layer.shadowOpacity = 0.8
        headerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainerView.addSubview(headerTitleLabel)

        // Section views
        objectiveSectionView.translatesAutoresizingMaskIntoConstraints = false
        contentContainerView.addSubview(objectiveSectionView)

        mechanicsSectionView.translatesAutoresizingMaskIntoConstraints = false
        contentContainerView.addSubview(mechanicsSectionView)

        scoringSectionView.translatesAutoresizingMaskIntoConstraints = false
        contentContainerView.addSubview(scoringSectionView)

        strategySectionView.translatesAutoresizingMaskIntoConstraints = false
        contentContainerView.addSubview(strategySectionView)
    }

    private func populateInstructionContent() {
        objectiveSectionView.configureSectionContent(
            heading: "Objective",
            description: "Match 3 or more adjacent tiles of the same value to merge them into higher-value tiles. Create combos and achieve the highest score possible!"
        )

        mechanicsSectionView.configureSectionContent(
            heading: "Game Mechanics",
            description: """
            • Place tiles on the grid by tapping empty cells
            • When 3+ identical tiles connect (horizontally/vertically), they merge
            • Tiles upgrade progressively (筒1→筒2→筒3...→筒9)
            • At maximum difficulty level, tiles are eliminated instead of upgraded
            • Chain reactions occur when merges create new matching groups
            • Game ends when the grid is completely filled
            """
        )

        scoringSectionView.configureSectionContent(
            heading: "Scoring System",
            description: """
            • Base Score: Tile Value × 10 × Number of Merged Tiles
            • Combo Bonus: Each consecutive merge adds +50 points
            • Chain Reactions: Automatic merges multiply your combo
            • Higher difficulty levels yield greater scoring opportunities
            """
        )

        strategySectionView.configureSectionContent(
            heading: "Strategic Tips",
            description: """
            • Plan ahead - consider the next tile preview
            • Build larger connected groups for better merges
            • Create chain reaction opportunities for combo bonuses
            • Manage grid space efficiently to avoid filling up
            • Higher difficulties offer bigger grids and more challenge
            """
        )
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

            contentScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            contentScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentContainerView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentContainerView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            contentContainerView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),

            headerTitleLabel.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: 20),
            headerTitleLabel.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 20),
            headerTitleLabel.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -20),

            objectiveSectionView.topAnchor.constraint(equalTo: headerTitleLabel.bottomAnchor, constant: 24),
            objectiveSectionView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 20),
            objectiveSectionView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -20),

            mechanicsSectionView.topAnchor.constraint(equalTo: objectiveSectionView.bottomAnchor, constant: 20),
            mechanicsSectionView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 20),
            mechanicsSectionView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -20),

            scoringSectionView.topAnchor.constraint(equalTo: mechanicsSectionView.bottomAnchor, constant: 20),
            scoringSectionView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 20),
            scoringSectionView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -20),

            strategySectionView.topAnchor.constraint(equalTo: scoringSectionView.bottomAnchor, constant: 20),
            strategySectionView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 20),
            strategySectionView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -20),
            strategySectionView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor, constant: -20)
        ])
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - Instruction Section View

class InstructionSectionView: UIView {

    private let headingLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let containerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureAppearance() {
        // Container with semi-transparent background
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)

        // Heading label
        headingLabel.font = UIFont.boldSystemFont(ofSize: 22)
        headingLabel.textColor = UIColor(red: 1.0, green: 0.9, blue: 0.4, alpha: 1.0)
        headingLabel.numberOfLines = 0
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(headingLabel)

        // Description label
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            headingLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            headingLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            headingLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }

    func configureSectionContent(heading: String, description: String) {
        headingLabel.text = heading
        descriptionLabel.text = description
    }
}
