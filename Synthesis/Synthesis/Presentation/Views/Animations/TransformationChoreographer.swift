//
//  TransformationChoreographer.swift
//  Synthesis - Presentation Animation
//
//  Builder pattern implementation for composing complex view animations.
//  Provides fluent API for animation sequences.
//

import UIKit

class TransformationChoreographer {

    // MARK: - Types

    enum TransformationType {
        case fadeIn
        case fadeOut
        case scale(from: CGFloat, to: CGFloat)
        case pulse
        case slideUp(distance: CGFloat)
        case slideDown(distance: CGFloat)
        case rotate(angle: CGFloat)
        case spring
        case shake
        case pop
    }

    private struct TransformationStep {
        let transformation: TransformationType
        let duration: TimeInterval
        let delay: TimeInterval
        let options: UIView.AnimationOptions
    }

    // MARK: - Properties

    private var transformationSequence: [TransformationStep] = []
    private var completionRitual: (() -> Void)?
    private var intermediateRituals: [() -> Void] = []

    // MARK: - Initialization

    private init() {}

    static func orchestrate() -> TransformationChoreographer {
        return TransformationChoreographer()
    }

    // MARK: - Builder Methods

    @discardableResult
    func incorporateTransformation(
        _ transformation: TransformationType,
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0.0,
        options: UIView.AnimationOptions = [.curveEaseInOut]
    ) -> TransformationChoreographer {
        let step = TransformationStep(
            transformation: transformation,
            duration: duration,
            delay: delay,
            options: options
        )
        transformationSequence.append(step)
        return self
    }

    @discardableResult
    func withCompletionRitual(_ ritual: @escaping () -> Void) -> TransformationChoreographer {
        self.completionRitual = ritual
        return self
    }

    @discardableResult
    func withIntermediateRitual(_ ritual: @escaping () -> Void) -> TransformationChoreographer {
        self.intermediateRituals.append(ritual)
        return self
    }

    // MARK: - Performance Execution

    func commencePerformance(on view: UIView) {
        guard !transformationSequence.isEmpty else {
            completionRitual?()
            return
        }

        executeSequentialTransformations(on: view, startingAt: 0)
    }

    private func executeSequentialTransformations(
        on view: UIView,
        startingAt index: Int
    ) {
        guard index < transformationSequence.count else {
            completionRitual?()
            return
        }

        let step = transformationSequence[index]

        // Execute intermediate ritual if available
        if index < intermediateRituals.count {
            intermediateRituals[index]()
        }

        UIView.animate(
            withDuration: step.duration,
            delay: step.delay,
            options: step.options,
            animations: {
                self.applyTransformation(step.transformation, to: view)
            },
            completion: { _ in
                self.executeSequentialTransformations(on: view, startingAt: index + 1)
            }
        )
    }

    private func applyTransformation(_ transformation: TransformationType, to view: UIView) {
        switch transformation {
        case .fadeIn:
            view.alpha = 1.0

        case .fadeOut:
            view.alpha = 0.0

        case .scale(let from, let to):
            if view.transform == .identity {
                view.transform = CGAffineTransform(scaleX: from, y: from)
            }
            view.transform = CGAffineTransform(scaleX: to, y: to)

        case .pulse:
            view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)

        case .slideUp(let distance):
            view.transform = CGAffineTransform(translationX: 0, y: -distance)

        case .slideDown(let distance):
            view.transform = CGAffineTransform(translationX: 0, y: distance)

        case .rotate(let angle):
            view.transform = CGAffineTransform(rotationAngle: angle)

        case .spring:
            view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

        case .shake:
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.timingFunction = CAMediaTimingFunction(name: .linear)
            animation.duration = 0.6
            animation.values = [-10, 10, -8, 8, -5, 5, 0]
            view.layer.add(animation, forKey: "shake")

        case .pop:
            view.transform = .identity
        }
    }

    // MARK: - Parallel Execution

    func commenceParallelPerformance(on views: [UIView]) {
        for view in views {
            commencePerformance(on: view)
        }
    }
}

// MARK: - Convenience Factory Methods

extension TransformationChoreographer {

    static func fadeInAnimation(duration: TimeInterval = 0.3) -> TransformationChoreographer {
        return TransformationChoreographer.orchestrate()
            .incorporateTransformation(.fadeIn, duration: duration)
    }

    static func fadeOutAnimation(duration: TimeInterval = 0.3) -> TransformationChoreographer {
        return TransformationChoreographer.orchestrate()
            .incorporateTransformation(.fadeOut, duration: duration)
    }

    static func scaleAnimation(from: CGFloat = 0.8, to: CGFloat = 1.0, duration: TimeInterval = 0.3) -> TransformationChoreographer {
        return TransformationChoreographer.orchestrate()
            .incorporateTransformation(.scale(from: from, to: to), duration: duration)
    }

    static func pulseAnimation(iterations: Int = 1) -> TransformationChoreographer {
        let choreographer = TransformationChoreographer.orchestrate()

        for _ in 0..<iterations {
            choreographer
                .incorporateTransformation(.pulse, duration: 0.15)
                .incorporateTransformation(.pop, duration: 0.15)
        }

        return choreographer
    }

    static func mergeAnimation() -> TransformationChoreographer {
        return TransformationChoreographer.orchestrate()
            .incorporateTransformation(.scale(from: 1.0, to: 1.3), duration: 0.2)
            .incorporateTransformation(.fadeOut, duration: 0.2)
    }

    static func appearanceAnimation() -> TransformationChoreographer {
        return TransformationChoreographer.orchestrate()
            .incorporateTransformation(.scale(from: 0.3, to: 1.0), duration: 0.4, options: [.curveEaseOut])
            .incorporateTransformation(.fadeIn, duration: 0.3)
    }

    static func upgradeAnimation() -> TransformationChoreographer {
        return TransformationChoreographer.orchestrate()
            .incorporateTransformation(.pulse, duration: 0.15)
            .incorporateTransformation(.pop, duration: 0.15)
            .incorporateTransformation(.pulse, duration: 0.15)
            .incorporateTransformation(.pop, duration: 0.15)
    }
}
