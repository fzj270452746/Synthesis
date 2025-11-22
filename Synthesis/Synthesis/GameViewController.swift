//
//  GameViewController.swift
//  Synthesis
//
//  Created by Hades on 11/18/25.
//

import UIKit

class GameViewController: UIViewController {

    private let backgroundImageView = UIImageView()
    private let gameOrchestrator: GameStateOrchestrator
    private let gameBoardView: GameBoardGridView

    private let scoreLabel = UILabel()
    private let comboLabel = UILabel()
    private let nextTileLabel = UILabel()
    private let nextTilePreview = MahjongTileView()
    private let closeButton = UIButton()

    private var isProcessingMove = false
    private var maximumComboAchieved = 0

    init(maximumValue: Int) {
        self.gameOrchestrator = GameStateOrchestrator(maxValue: maximumValue)
        self.gameBoardView = GameBoardGridView(
            rows: gameOrchestrator.gridRowCount,
            columns: gameOrchestrator.gridColumnCount
        )
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUserInterface()
        setupConstraints()
        gameBoardView.interactionDelegate = self
        updateUIElements()
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

        // Score label
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 24)
        scoreLabel.textColor = .white
        scoreLabel.textAlignment = .center
        scoreLabel.layer.shadowColor = UIColor.black.cgColor
        scoreLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        scoreLabel.layer.shadowRadius = 4
        scoreLabel.layer.shadowOpacity = 0.8
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreLabel)

        // Combo label
        comboLabel.font = UIFont.boldSystemFont(ofSize: 20)
        comboLabel.textColor = UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1.0)
        comboLabel.textAlignment = .center
        comboLabel.layer.shadowColor = UIColor.black.cgColor
        comboLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        comboLabel.layer.shadowRadius = 4
        comboLabel.layer.shadowOpacity = 0.8
        comboLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(comboLabel)

        // Game board
        gameBoardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gameBoardView)

        // Next tile label
        nextTileLabel.text = "Next Tile"
        nextTileLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nextTileLabel.textColor = .white
        nextTileLabel.textAlignment = .center
        nextTileLabel.layer.shadowColor = UIColor.black.cgColor
        nextTileLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        nextTileLabel.layer.shadowRadius = 4
        nextTileLabel.layer.shadowOpacity = 0.8
        nextTileLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextTileLabel)

        // Next tile preview
        nextTilePreview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextTilePreview)
    }

    private func setupConstraints() {
        let boardSize: CGFloat = min(view.bounds.width - 40, 400)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40),

            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            comboLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 8),
            comboLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            gameBoardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameBoardView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            gameBoardView.widthAnchor.constraint(equalToConstant: boardSize),
            gameBoardView.heightAnchor.constraint(equalToConstant: boardSize),

            nextTileLabel.topAnchor.constraint(equalTo: gameBoardView.bottomAnchor, constant: 24),
            nextTileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nextTilePreview.topAnchor.constraint(equalTo: nextTileLabel.bottomAnchor, constant: 12),
            nextTilePreview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextTilePreview.widthAnchor.constraint(equalToConstant: 80),
            nextTilePreview.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func updateUIElements() {
        scoreLabel.text = "Score: \(gameOrchestrator.currentScore)"

        if gameOrchestrator.consecutiveComboCount > 1 {
            comboLabel.text = "Combo ×\(gameOrchestrator.consecutiveComboCount)"
            comboLabel.isHidden = false
            animateComboLabel()
        } else {
            comboLabel.isHidden = true
        }

        if let nextTile = gameOrchestrator.nextTileToPlace {
            nextTilePreview.configureTile(with: nextTile)
        }

        maximumComboAchieved = max(maximumComboAchieved, gameOrchestrator.consecutiveComboCount)
    }

    private func animateComboLabel() {
        comboLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .curveEaseOut) {
            self.comboLabel.transform = .identity
        }
    }

    @objc private func closeButtonTapped() {
        ElegantDialogView.displayAlert(
            title: "Exit Game",
            message: "Are you sure you want to exit? Your current score will be saved.",
            actions: [
                ("Cancel", .secondary, {}),
                ("Exit", .destructive, { [weak self] in
                    self?.saveCurrentGameRecord()
                    self?.dismiss(animated: true)
                })
            ]
        )
    }

    private func saveCurrentGameRecord() {
        // Only save if player has scored points
        guard gameOrchestrator.currentScore > 0 else { return }

        let record = GameRecordEntry(
            achievedScore: gameOrchestrator.currentScore,
            selectedDifficulty: gameOrchestrator.maximumTileValue,
            timestampDate: Date(),
            maximumCombo: maximumComboAchieved
        )
        PersistentStorageManager.sharedInstance.saveGameRecord(record)
    }

    private func handleGameOver() {
        let record = GameRecordEntry(
            achievedScore: gameOrchestrator.currentScore,
            selectedDifficulty: gameOrchestrator.maximumTileValue,
            timestampDate: Date(),
            maximumCombo: maximumComboAchieved
        )
        PersistentStorageManager.sharedInstance.saveGameRecord(record)

        ElegantDialogView.displayAlert(
            title: "Game Over",
            message: "Final Score: \(gameOrchestrator.currentScore)\nMax Combo: ×\(maximumComboAchieved)",
            actions: [
                ("Restart Game", .accent, { [weak self] in
                    self?.restartGame()
                }),
                ("Back to Menu", .secondary, { [weak self] in
                    self?.dismiss(animated: true)
                })
            ]
        )
    }

    private func restartGame() {
        // Dismiss current game view
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }

            // Get the presenting view controller and present a new game
            if let presentingVC = self.presentingViewController {
                let newGameVC = GameViewController(maximumValue: self.gameOrchestrator.maximumTileValue)
                newGameVC.modalPresentationStyle = .fullScreen
                presentingVC.present(newGameVC, animated: true)
            }
        }
    }
}

// MARK: - GameBoardInteractionDelegate

extension GameViewController: GameBoardInteractionDelegate {

    func didSelectGridPosition(_ position: GridPositionCoordinate) {
        guard !isProcessingMove else { return }
        guard gameOrchestrator.canPlaceTile(at: position) else { return }

        isProcessingMove = true

        // Place tile
        guard gameOrchestrator.placeTile(at: position) else {
            isProcessingMove = false
            return
        }

        // Update UI
        if let tile = gameOrchestrator.gridMatrix[position.rowIndex][position.columnIndex] {
            gameBoardView.updateTile(at: position, with: tile)
        }

        // Process merge
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.processMergeSequence(startingAt: position)
        }
    }

    private func processMergeSequence(startingAt position: GridPositionCoordinate) {
        let mergeResult = gameOrchestrator.processMergeOperation(at: position)

        if mergeResult.mergedPositions.isEmpty {
            // No merge occurred
            completeMove()
            return
        }

        // Determine positions to clear (exclude upgrade position if exists)
        var positionsToClear = mergeResult.mergedPositions
        if let upgradePos = mergeResult.newTilePosition {
            positionsToClear.removeAll { $0 == upgradePos }
        }

        // Animate merge for positions that will be cleared
        if !positionsToClear.isEmpty {
            gameBoardView.animateMerge(at: positionsToClear) { [weak self] in
                guard let self = self else { return }
                self.handleUpgradeOrComplete(mergeResult: mergeResult)
            }
        } else {
            // No positions to clear, just handle upgrade
            handleUpgradeOrComplete(mergeResult: mergeResult)
        }
    }

    private func handleUpgradeOrComplete(mergeResult: MergeResultData) {
        // If there's an upgraded tile, show it with animation
        if let newPosition = mergeResult.newTilePosition,
           let newTile = gameOrchestrator.gridMatrix[newPosition.rowIndex][newPosition.columnIndex] {
            gameBoardView.animateUpgrade(at: newPosition, with: newTile) {
                self.updateUIElements()
                self.checkForChainReaction()
            }
        } else {
            // Pure elimination, no upgrade - just update UI
            updateUIElements()
            checkForChainReaction()
        }
    }

    private func checkForChainReaction() {
        if let chainPosition = gameOrchestrator.checkForChainReaction() {
            // Chain reaction detected
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.processMergeSequence(startingAt: chainPosition)
            }
        } else {
            // No more chains
            completeMove()
        }
    }

    private func completeMove() {
        gameOrchestrator.generateNextTile()
        updateUIElements()

        if gameOrchestrator.isGridFull() {
            handleGameOver()
        }

        isProcessingMove = false
    }
}
