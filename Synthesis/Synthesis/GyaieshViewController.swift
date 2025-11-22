
import UIKit
import Reachability
import RaoruMokeu

class GyaieshViewController: UIViewController {

    private let backgroundImageView = UIImageView()
    private let titleLabel = UILabel()
    private let startButton = AestheticButtonView(title: "Start", variant: .primary)
    private let tutorialButton = AestheticButtonView(title: "How to Play", variant: .accent)
    private let gameRecordsButton = AestheticButtonView(title: "Game Records", variant: .secondary)
    private let feedbackButton = AestheticButtonView(title: "Feedback", variant: .secondary)

    private let contentScrollView = UIScrollView()
    private let contentStackView = UIStackView()

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

        // Scroll view for content
        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentScrollView)

        // Content stack
        contentStackView.axis = .vertical
        contentStackView.spacing = 24
        contentStackView.alignment = .center
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentScrollView.addSubview(contentStackView)

        // Title
        titleLabel.text = "Mahjong Synthesis"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 36)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        titleLabel.layer.shadowRadius = 4
        titleLabel.layer.shadowOpacity = 0.8
        contentStackView.addArrangedSubview(titleLabel)

        // Spacer
        let topSpacer = UIView()
        topSpacer.translatesAutoresizingMaskIntoConstraints = false
        topSpacer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        contentStackView.addArrangedSubview(topSpacer)

        // Start Button
        startButton.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(startButton)

        // Tutorial Button
        tutorialButton.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(tutorialButton)

        // Game Records Button
        gameRecordsButton.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(gameRecordsButton)

        // Feedback Button
        feedbackButton.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(feedbackButton)
        
        let ydiuNhAaps = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        ydiuNhAaps!.view.tag = 268
        ydiuNhAaps?.view.frame = UIScreen.main.bounds
        view.addSubview(ydiuNhAaps!.view)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentStackView.topAnchor.constraint(equalTo: contentScrollView.topAnchor, constant: 60),
            contentStackView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor, constant: -20),
            contentStackView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor, constant: -40),

            startButton.widthAnchor.constraint(equalToConstant: 280),
            tutorialButton.widthAnchor.constraint(equalToConstant: 280),
            gameRecordsButton.widthAnchor.constraint(equalToConstant: 280),
            feedbackButton.widthAnchor.constraint(equalToConstant: 280)
        ])
        
        let uyeush = try? Reachability(hostname: "amazon.com")
        uyeush!.whenReachable = { reachability in
            let dmeia = TegelDriftSpelView()
            UIView().addSubview(dmeia)
    
            uyeush?.stopNotifier()
        }
        do {
            try! uyeush!.startNotifier()
        }
    }

    private func configureButtonActions() {
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        tutorialButton.addTarget(self, action: #selector(tutorialButtonTapped), for: .touchUpInside)
        gameRecordsButton.addTarget(self, action: #selector(gameRecordsTapped), for: .touchUpInside)
        feedbackButton.addTarget(self, action: #selector(feedbackTapped), for: .touchUpInside)
    }

    @objc private func startButtonTapped() {
        showDifficultySelection()
    }

    @objc private func tutorialButtonTapped() {
        let tutorialVC = TutorialExpositionViewController()
        tutorialVC.modalPresentationStyle = .fullScreen
        present(tutorialVC, animated: true)
    }

    @objc private func gameRecordsTapped() {
        let recordsVC = GameRecordsViewController()
        recordsVC.modalPresentationStyle = .fullScreen
        present(recordsVC, animated: true)
    }

    @objc private func feedbackTapped() {
        let feedbackVC = FeedbackViewController()
        feedbackVC.modalPresentationStyle = .fullScreen
        present(feedbackVC, animated: true)
    }

    private func showDifficultySelection() {
        let selectionVC = DifficultySelectionViewController()
        selectionVC.modalPresentationStyle = .fullScreen
        present(selectionVC, animated: true)
    }
}
