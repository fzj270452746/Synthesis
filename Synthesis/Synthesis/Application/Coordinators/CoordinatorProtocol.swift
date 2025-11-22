//
//  CoordinatorProtocol.swift
//  Synthesis - Application Coordinator
//
//  Protocol defining navigation coordinator responsibilities.
//  Enables decoupled navigation flow management.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    /// Navigation controller managed by coordinator
    var navigationController: UINavigationController { get }

    /// Child coordinators for hierarchical coordination
    var childCoordinators: [CoordinatorProtocol] { get set }

    /// Inaugurates coordinator flow
    func inaugurate()

    /// Concludes coordinator and cleans up
    func conclude()
}

// MARK: - Default Implementations

extension CoordinatorProtocol {

    func addChildCoordinator(_ coordinator: CoordinatorProtocol) {
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: CoordinatorProtocol) {
        childCoordinators.removeAll { $0 === coordinator }
    }

    func conclude() {
        childCoordinators.forEach { $0.conclude() }
        childCoordinators.removeAll()
    }
}
