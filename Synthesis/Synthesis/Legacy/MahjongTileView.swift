//
//  EmbellishedGlyphCanvas.swift
//  Synthesis
//
//  Created by Hades on 11/18/25.
//

import UIKit

class EmbellishedGlyphCanvas: UIView {

    private let iconographicRenderer = UIImageView()
    private let iridescenceMembrane = CAGradientLayer()
    var encapsulatedFragment: CeramicGlyphFragment?

    override init(frame: CGRect) {
        super.init(frame: frame)
        establishPristineAesthetic()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        establishPristineAesthetic()
    }

    private func establishPristineAesthetic() {
        backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        layer.cornerRadius = 8
        layer.borderWidth = 2
        layer.borderColor = UIColor(white: 0.8, alpha: 1.0).cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.2

        iconographicRenderer.contentMode = .scaleAspectFit
        iconographicRenderer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconographicRenderer)

        NSLayoutConstraint.activate([
            iconographicRenderer.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            iconographicRenderer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            iconographicRenderer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            iconographicRenderer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }

    func inscribeFragmentVisualization(with fragment: CeramicGlyphFragment) {
        self.encapsulatedFragment = fragment
        iconographicRenderer.image = UIImage(named: fragment.emblematicAssetDesignation)
    }

    func obliterateFragmentPresentation() {
        self.encapsulatedFragment = nil
        iconographicRenderer.image = nil
    }

    func choreographMaterializationSequence() {
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut) {
            self.alpha = 1
            self.transform = .identity
        }
    }

    func executeCoalescenceChoreography(epilogue: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.alpha = 0.5
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.alpha = 0
            }) { _ in
                self.transform = .identity
                self.alpha = 1  // Restore alpha to make the empty tile visible and clickable
                epilogue()
            }
        }
    }

    func orchestrateTranscendenceAnimation(epilogue: @escaping () -> Void) {
        UIView.animate(withDuration: 0.15, animations: {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { _ in
                UIView.animate(withDuration: 0.2) {
                    self.transform = .identity
                    epilogue()
                }
            }
        }
    }

    func manifestRhythmicPulsation() {
        let undulationSequence = CABasicAnimation(keyPath: "transform.scale")
        undulationSequence.duration = 0.6
        undulationSequence.fromValue = 1.0
        undulationSequence.toValue = 1.1
        undulationSequence.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        undulationSequence.autoreverses = true
        undulationSequence.repeatCount = .infinity
        layer.add(undulationSequence, forKey: "rhythmicOscillation")
    }

    func extinguishRhythmicPulsation() {
        layer.removeAnimation(forKey: "rhythmicOscillation")
    }
}
