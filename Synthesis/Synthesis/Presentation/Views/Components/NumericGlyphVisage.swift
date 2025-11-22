//
//  NumericGlyphVisage.swift
//  Synthesis - Presentation Component
//
//  Visual representation of individual numeric glyph token.
//  Displays tile with magnitude and handles visual transformations.
//

import UIKit

class NumericGlyphVisage: UIView {

    // MARK: - UI Components

    private let magnitudeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Properties

    private var currentMagnitude: Int?

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureHierarchy()
        configureConstraints()
    }

    // MARK: - Configuration

    private func configureHierarchy() {
        addSubview(containerView)
        containerView.addSubview(magnitudeLabel)
        backgroundColor = .clear
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),

            magnitudeLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            magnitudeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }

    // MARK: - Presentation

    func presentVisualization(_ data: TileVisualizationData?) {
        guard let data = data else {
            obliteratePresentation()
            return
        }

        currentMagnitude = data.magnitude
        magnitudeLabel.text = "\(data.magnitude)"
        containerView.backgroundColor = data.displayColor

        // Apply shadow for depth
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
    }

    func obliteratePresentation() {
        magnitudeLabel.text = ""
        containerView.backgroundColor = UIColor.systemGray5.withAlphaComponent(0.3)
        containerView.layer.shadowOpacity = 0
        currentMagnitude = nil
    }

    // MARK: - Animations

    func animateAppearance(completion: (() -> Void)? = nil) {
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.3, y: 0.3)

        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.alpha = 1.0
                self.transform = .identity
            },
            completion: { _ in
                completion?()
            }
        )
    }

    func animateMerge(completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.alpha = 0.5
            },
            completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.alpha = 0
                } completion: { _ in
                    completion?()
                }
            }
        )
    }

    func animateUpgrade(newData: TileVisualizationData, completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: 0.15,
            animations: {
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            },
            completion: { _ in
                self.presentVisualization(newData)

                UIView.animate(
                    withDuration: 0.15,
                    animations: {
                        self.transform = .identity
                    },
                    completion: { _ in
                        UIView.animate(withDuration: 0.15, animations: {
                            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                        }, completion: { _ in
                            UIView.animate(withDuration: 0.15, animations: {
                                self.transform = .identity
                            }, completion: { _ in
                                completion?()
                            })
                        })
                    }
                )
            }
        )
    }

    func animatePulse(iterations: Int = 1, completion: (() -> Void)? = nil) {
        var currentIteration = 0

        func pulseOnce() {
            currentIteration += 1

            UIView.animate(
                withDuration: 0.15,
                animations: {
                    self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                },
                completion: { _ in
                    UIView.animate(
                        withDuration: 0.15,
                        animations: {
                            self.transform = .identity
                        },
                        completion: { _ in
                            if currentIteration < iterations {
                                pulseOnce()
                            } else {
                                completion?()
                            }
                        }
                    )
                }
            )
        }

        pulseOnce()
    }
}
