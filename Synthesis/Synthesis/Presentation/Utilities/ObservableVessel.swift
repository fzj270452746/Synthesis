//
//  ObservableVessel.swift
//  Synthesis - Presentation Utility
//
//  Lightweight observable pattern implementation for reactive state propagation.
//  Enables subscription-based notification without external dependencies.
//

import Foundation

class ObservableVessel<Payload> {

    // MARK: - Types

    typealias WitnessIdentifier = UUID
    typealias WitnessClosure = (Payload) -> Void

    private struct RegisteredWitness {
        let identifier: WitnessIdentifier
        let closure: WitnessClosure
    }

    // MARK: - Properties

    /// Current payload value
    private(set) var currentPayload: Payload {
        didSet {
            disseminateTransformation(currentPayload)
        }
    }

    /// Registry of subscribed witnesses
    private var witnessRegistry: [RegisteredWitness] = []

    /// Thread-safe access queue
    private let synchronizationQueue = DispatchQueue(
        label: "com.synthesis.observable",
        attributes: .concurrent
    )

    // MARK: - Initialization

    init(initialPayload: Payload) {
        self.currentPayload = initialPayload
    }

    // MARK: - Mutation

    /// Transmutes payload value and notifies witnesses
    func transmute(_ newPayload: Payload) {
        synchronizationQueue.async(flags: .barrier) { [weak self] in
            self?.currentPayload = newPayload
        }
    }

    /// Silently updates payload without notification
    func silentlyTransmute(_ newPayload: Payload) {
        synchronizationQueue.async(flags: .barrier) { [weak self] in
            self?.currentPayload = newPayload
        }
    }

    // MARK: - Subscription

    /// Registers witness for transformation notifications
    @discardableResult
    func registerWitness(
        immediate: Bool = true,
        closure: @escaping WitnessClosure
    ) -> WitnessIdentifier {
        let identifier = UUID()
        let witness = RegisteredWitness(identifier: identifier, closure: closure)

        synchronizationQueue.async(flags: .barrier) { [weak self] in
            self?.witnessRegistry.append(witness)
        }

        if immediate {
            closure(currentPayload)
        }

        return identifier
    }

    /// Deregisters witness by identifier
    func deregisterWitness(identifier: WitnessIdentifier) {
        synchronizationQueue.async(flags: .barrier) { [weak self] in
            self?.witnessRegistry.removeAll { $0.identifier == identifier }
        }
    }

    /// Obliterates all registered witnesses
    func obliterateAllWitnesses() {
        synchronizationQueue.async(flags: .barrier) { [weak self] in
            self?.witnessRegistry.removeAll()
        }
    }

    // MARK: - Notification

    /// Disseminates transformation to all witnesses
    private func disseminateTransformation(_ payload: Payload) {
        synchronizationQueue.async { [weak self] in
            guard let witnesses = self?.witnessRegistry else { return }

            DispatchQueue.main.async {
                witnesses.forEach { witness in
                    witness.closure(payload)
                }
            }
        }
    }

    // MARK: - Mapping

    /// Creates derived observable by transforming payload
    func mapToDerivative<DerivedPayload>(
        transform: @escaping (Payload) -> DerivedPayload
    ) -> ObservableVessel<DerivedPayload> {
        let derivative = ObservableVessel<DerivedPayload>(
            initialPayload: transform(currentPayload)
        )

        registerWitness { payload in
            derivative.transmute(transform(payload))
        }

        return derivative
    }

    // MARK: - Combining

    /// Combines two observables into tuple observable
    func combineWith<OtherPayload>(
        _ other: ObservableVessel<OtherPayload>
    ) -> ObservableVessel<(Payload, OtherPayload)> {
        let combined = ObservableVessel<(Payload, OtherPayload)>(
            initialPayload: (currentPayload, other.currentPayload)
        )

        registerWitness { [weak other] payload in
            guard let otherPayload = other?.currentPayload else { return }
            combined.transmute((payload, otherPayload))
        }

        other.registerWitness { [weak self] otherPayload in
            guard let selfPayload = self?.currentPayload else { return }
            combined.transmute((selfPayload, otherPayload))
        }

        return combined
    }
}

// MARK: - Convenience for Optionals

extension ObservableVessel where Payload: OptionalProtocol {
    var isPresent: Bool {
        return currentPayload.asOptional != nil
    }

    func unwrap() -> Payload.Wrapped? {
        return currentPayload.asOptional
    }
}

protocol OptionalProtocol {
    associatedtype Wrapped
    var asOptional: Wrapped? { get }
}

extension Optional: OptionalProtocol {
    var asOptional: Wrapped? {
        return self
    }
}

// MARK: - CustomStringConvertible

extension ObservableVessel: CustomStringConvertible {
    var description: String {
        return "ObservableVessel(witnesses: \(witnessRegistry.count))"
    }
}
