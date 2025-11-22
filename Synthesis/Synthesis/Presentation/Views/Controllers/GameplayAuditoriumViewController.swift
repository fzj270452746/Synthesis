//
//  GameplayAuditoriumViewController.swift
//  Synthesis - Presentation Controller
//
//  Main gameplay view controller orchestrating user interaction.
//  Implements MVVM pattern with thin controller philosophy.
//

import UIKit

class GameplayAuditoriumViewController: UIViewController {

    // MARK: - UI Components

    private let arenaCanvas: TessellatedArenaCanvas
    private let scoreDisplayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let comboDisplayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .systemOrange
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let nextFragmentContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let nextFragmentVisage: NumericGlyphVisage = {
        let visage = NumericGlyphVisage()
        visage.translatesAutoresizingMaskIntoConstraints = false
        return visage
    }()

    private let nextFragmentLabel: UILabel = {
        let label = UILabel()
        label.text = "Next"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let terminationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Terminate", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Properties

    private let viewModel: GameplayOrchestratorViewModel
    private var observerTokens: [ObservableVessel<Any>.WitnessIdentifier] = []

    // MARK: - Initialization

    init(viewModel: GameplayOrchestratorViewModel) {
        self.viewModel = viewModel
        self.arenaCanvas = TessellatedArenaCanvas(
            dimensionalCapacity: viewModel.gridDimensions
        )

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented - use init(viewModel:)")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureAppearance()
        configureHierarchy()
        configureConstraints()
        configureActions()
        bindViewModel()
    }

    // MARK: - Configuration

    private func configureAppearance() {
        view.backgroundColor = .systemBackground
        title = "Synthesis"
    }

    private func configureHierarchy() {
        view.addSubview(scoreDisplayLabel)
        view.addSubview(comboDisplayLabel)
        view.addSubview(arenaCanvas)
        view.addSubview(nextFragmentContainer)
        view.addSubview(terminationButton)

        nextFragmentContainer.addSubview(nextFragmentLabel)
        nextFragmentContainer.addSubview(nextFragmentVisage)

        arenaCanvas.translatesAutoresizingMaskIntoConstraints = false
        arenaCanvas.interactionDelegate = self
    }

    private func configureConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            // Score
            scoreDisplayLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            scoreDisplayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Combo
            comboDisplayLabel.topAnchor.constraint(equalTo: scoreDisplayLabel.bottomAnchor, constant: 8),
            comboDisplayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Arena Canvas
            arenaCanvas.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            arenaCanvas.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            arenaCanvas.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            arenaCanvas.heightAnchor.constraint(equalTo: arenaCanvas.widthAnchor),

            // Next Fragment Container
            nextFragmentContainer.topAnchor.constraint(equalTo: arenaCanvas.bottomAnchor, constant: 24),
            nextFragmentContainer.trailingAnchor.constraint(equalTo: arenaCanvas.trailingAnchor),
            nextFragmentContainer.widthAnchor.constraint(equalToConstant: 100),
            nextFragmentContainer.heightAnchor.constraint(equalToConstant: 120),

            // Next Fragment Label
            nextFragmentLabel.topAnchor.constraint(equalTo: nextFragmentContainer.topAnchor, constant: 8),
            nextFragmentLabel.centerXAnchor.constraint(equalTo: nextFragmentContainer.centerXAnchor),

            // Next Fragment Visage
            nextFragmentVisage.topAnchor.constraint(equalTo: nextFragmentLabel.bottomAnchor, constant: 8),
            nextFragmentVisage.leadingAnchor.constraint(equalTo: nextFragmentContainer.leadingAnchor, constant: 16),
            nextFragmentVisage.trailingAnchor.constraint(equalTo: nextFragmentContainer.trailingAnchor, constant: -16),
            nextFragmentVisage.bottomAnchor.constraint(equalTo: nextFragmentContainer.bottomAnchor, constant: -16),

            // Termination Button
            terminationButton.topAnchor.constraint(equalTo: nextFragmentContainer.topAnchor),
            terminationButton.leadingAnchor.constraint(equalTo: arenaCanvas.leadingAnchor),
            terminationButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func configureActions() {
        terminationButton.addTarget(
            self,
            action: #selector(handleTerminationTap),
            for: .touchUpInside
        )
    }

    // MARK: - ViewModel Binding

    private func bindViewModel() {
        // Lattice visualization
        viewModel.latticeVisualizationData.registerWitness { [weak self] gridData in
            self?.arenaCanvas.updatePresentation(with: gridData)
        }

        // Score display
        viewModel.accumulatedMeritDisplay.registerWitness { [weak self] scoreText in
            self?.scoreDisplayLabel.text = "Score: \(scoreText)"
        }

        // Combo display
        viewModel.sequentialAmplifierDisplay.registerWitness { [weak self] comboText in
            self?.comboDisplayLabel.text = "Combo: \(comboText)"
        }

        // Next fragment display
        viewModel.pendingFragmentDisplay.registerWitness { [weak self] fragmentData in
            self?.nextFragmentVisage.presentVisualization(fragmentData)
        }

        // Interaction enabled state
        viewModel.isInteractionEnabled.registerWitness { [weak self] isEnabled in
            self?.arenaCanvas.isUserInteractionEnabled = isEnabled
        }
    }

    // MARK: - Actions

    @objc private func handleTerminationTap() {
        presentTerminationConfirmation()
    }

    private func presentTerminationConfirmation() {
        let alert = UIAlertController(
            title: "Terminate Session",
            message: "Conclude current gameplay session?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Terminate", style: .destructive) { [weak self] _ in
            self?.viewModel.handleTerminationRequest()
        })

        present(alert, animated: true)
    }

    private func presentGameOverDialog() {
        let alert = UIAlertController(
            title: "Terminal Configuration",
            message: "Game Over\n\nFinal Score: \(viewModel.currentScore)\nMax Combo: \(viewModel.currentCombo)x",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Resurrect", style: .default) { [weak self] _ in
            self?.viewModel.handleResurrectionRequest()
        })

        alert.addAction(UIAlertAction(title: "Conclude", style: .cancel) { [weak self] _ in
            self?.viewModel.handleTerminationRequest()
        })

        present(alert, animated: true)
    }
}

// MARK: - TessellatedArenaInteractionDelegate

extension GameplayAuditoriumViewController: TessellatedArenaInteractionDelegate {

    func didSelectAnchorPoint(at coordinate: LatticeCoordinate) {
        viewModel.handleFragmentAnchorage(at: coordinate)

        // Check for game over
        if viewModel.isGameOver {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.presentGameOverDialog()
            }
        }
    }
}
