//
//  AestheticButtonView.swift
//  Synthesis
//
//  Created by Hades on 11/18/25.
//

import UIKit

class AestheticButtonView: UIButton {

    private let vibrancyEffect = UIVisualEffectView()
    private let luminousGradient = CAGradientLayer()

    enum ButtonVariant {
        case primary
        case secondary
        case accent
        case destructive
    }

    private var buttonVariant: ButtonVariant = .primary

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureInitialAppearance()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureInitialAppearance()
    }

    convenience init(title: String, variant: ButtonVariant = .primary) {
        self.init(frame: .zero)
        setTitle(title, for: .normal)
        self.buttonVariant = variant
        applyVariantStyling()
    }

    func applyCompactStyle() {
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        layer.cornerRadius = 12
        luminousGradient.cornerRadius = 12
    }

    private func configureInitialAppearance() {
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 12
        layer.shadowOpacity = 0.3

        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        contentEdgeInsets = UIEdgeInsets(top: 16, left: 32, bottom: 16, right: 32)

        addTarget(self, action: #selector(executeScaleAnimation), for: .touchDown)
        addTarget(self, action: #selector(restoreScaleAnimation), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    private func applyVariantStyling() {
        luminousGradient.removeFromSuperlayer()
        luminousGradient.frame = bounds
        luminousGradient.cornerRadius = 16

        switch buttonVariant {
        case .primary:
            luminousGradient.colors = [
                UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0).cgColor,
                UIColor(red: 0.1, green: 0.2, blue: 0.6, alpha: 1.0).cgColor
            ]
            setTitleColor(.white, for: .normal)
        case .secondary:
            luminousGradient.colors = [
                UIColor(red: 0.4, green: 0.2, blue: 0.6, alpha: 1.0).cgColor,
                UIColor(red: 0.3, green: 0.1, blue: 0.5, alpha: 1.0).cgColor
            ]
            setTitleColor(.white, for: .normal)
        case .accent:
            luminousGradient.colors = [
                UIColor(red: 0.9, green: 0.5, blue: 0.2, alpha: 1.0).cgColor,
                UIColor(red: 0.8, green: 0.3, blue: 0.1, alpha: 1.0).cgColor
            ]
            setTitleColor(.white, for: .normal)
        case .destructive:
            luminousGradient.colors = [
                UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0).cgColor,
                UIColor(red: 0.7, green: 0.1, blue: 0.1, alpha: 1.0).cgColor
            ]
            setTitleColor(.white, for: .normal)
        }

        luminousGradient.startPoint = CGPoint(x: 0, y: 0)
        luminousGradient.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(luminousGradient, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        luminousGradient.frame = bounds
    }

    @objc private func executeScaleAnimation() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    @objc private func restoreScaleAnimation() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
    }
}
