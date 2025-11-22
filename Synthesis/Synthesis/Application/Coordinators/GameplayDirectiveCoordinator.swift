//
//  GameplayDirectiveCoordinator.swift
//  Synthesis - Application Coordinator
//
//  Coordinator managing gameplay session flow and navigation.
//  Handles game initiation, progression, and conclusion.
//

import UIKit

protocol GameplayDirectiveCoordinatorDelegate: AnyObject {
    func gameplayDidConclude(with chronicle: TriumphChronicle?)
}

class GameplayDirectiveCoordinator: CoordinatorProtocol {

    // MARK: - Properties

    let navigationController: UINavigationController
    var childCoordinators: [CoordinatorProtocol] = []

    private let difficultyEchelon: DifficultyEchelon
    weak var delegate: GameplayDirectiveCoordinatorDelegate?

    // MARK: - Initialization

    init(
        navigationController: UINavigationController,
        difficultyEchelon: DifficultyEchelon
    ) {
        self.navigationController = navigationController
        self.difficultyEchelon = difficultyEchelon
    }

    // MARK: - CoordinatorProtocol

    func inaugurate() {
        let viewModel = GameplayOrchestratorViewModel(
            difficultyEchelon: difficultyEchelon,
            coordinator: self
        )

        let viewController = GameplayAuditoriumViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen

        navigationController.present(viewController, animated: true)
    }

    // MARK: - Navigation

    func concludeGameplaySession(finalChronicle: TriumphChronicle?) {
        navigationController.dismiss(animated: true) { [weak self] in
            self?.delegate?.gameplayDidConclude(with: finalChronicle)
            self?.conclude()
        }
    }
}
