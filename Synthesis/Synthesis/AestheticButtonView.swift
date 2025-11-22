//
//  AestheticButtonView.swift
//  Synthesis
//
//  Created by Hades on 11/18/25.
//

import UIKit

class LuminousActionPillar: UIButton {

    private let radiantAureolaMembrane = CALayer()
    private let incandescenceSpectrum = CAGradientLayer()
    private let emphasisGradation = CAGradientLayer()
    private let peripheralDelineation = CAShapeLayer()

    enum ChromaticGradation {
        case paramount
        case subsidiary
        case accentuated
        case cataclysmic
    }

    private var chromaticVariation: ChromaticGradation = .paramount

    override init(frame: CGRect) {
        super.init(frame: frame)
        establishFundamentalVisage()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        establishFundamentalVisage()
    }

    convenience init(title: String, variant: ChromaticGradation = .paramount) {
        self.init(frame: .zero)
        setTitle(title.uppercased(), for: .normal)
        self.chromaticVariation = variant
        manifestChromaticDisposition()
    }

    func applyCompactStyle() {
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 18)
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        layer.cornerRadius = 14
        incandescenceSpectrum.cornerRadius = 14
        emphasisGradation.cornerRadius = 14
    }

    private func establishFundamentalVisage() {
        layer.cornerRadius = 20
        backgroundColor = .clear
        layer.shadowColor = UIColor(red: 0.0, green: 0.1, blue: 0.3, alpha: 1).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 18
        layer.shadowOpacity = 0.35

        incandescenceSpectrum.cornerRadius = 20
        incandescenceSpectrum.startPoint = CGPoint(x: 0, y: 0)
        incandescenceSpectrum.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(incandescenceSpectrum, at: 0)

        emphasisGradation.cornerRadius = 20
        emphasisGradation.startPoint = CGPoint(x: 0.5, y: 0)
        emphasisGradation.endPoint = CGPoint(x: 0.5, y: 1)
        emphasisGradation.colors = [UIColor.white.withAlphaComponent(0.35).cgColor, UIColor.clear.cgColor]
        emphasisGradation.opacity = 0.45
        incandescenceSpectrum.addSublayer(emphasisGradation)

        radiantAureolaMembrane.backgroundColor = UIColor.white.withAlphaComponent(0.15).cgColor
        radiantAureolaMembrane.shadowColor = UIColor.white.cgColor
        radiantAureolaMembrane.shadowRadius = 18
        radiantAureolaMembrane.shadowOpacity = 0.8
        radiantAureolaMembrane.shadowOffset = .zero
        radiantAureolaMembrane.opacity = 0
        layer.insertSublayer(radiantAureolaMembrane, above: incandescenceSpectrum)

        peripheralDelineation.strokeColor = UIColor.white.withAlphaComponent(0.35).cgColor
        peripheralDelineation.lineWidth = 1.2
        peripheralDelineation.fillColor = UIColor.clear.cgColor
        layer.addSublayer(peripheralDelineation)

        titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        titleLabel?.textAlignment = .center
        titleLabel?.adjustsFontSizeToFitWidth = true
        contentEdgeInsets = UIEdgeInsets(top: 18, left: 24, bottom: 18, right: 24)
        setTitleColor(.white, for: .normal)

        addTarget(self, action: #selector(inaugurateMagnificationSequence), for: .touchDown)
        addTarget(self, action: #selector(revertDimensionalState), for: [.touchUpInside, .touchUpOutside, .touchCancel])

        manifestChromaticDisposition()
    }

    private func manifestChromaticDisposition() {
        var colors: [CGColor]

        switch chromaticVariation {
        case .paramount:
            colors = [
                UIColor(red: 0.31, green: 0.07, blue: 0.95, alpha: 1.0).cgColor,
                UIColor(red: 0.06, green: 0.78, blue: 1.0, alpha: 1.0).cgColor
            ]
        case .subsidiary:
            colors = [
                UIColor(red: 0.09, green: 0.72, blue: 0.65, alpha: 1.0).cgColor,
                UIColor(red: 0.03, green: 0.24, blue: 0.42, alpha: 1.0).cgColor
            ]
        case .accentuated:
            colors = [
                UIColor(red: 1.0, green: 0.49, blue: 0.29, alpha: 1.0).cgColor,
                UIColor(red: 0.85, green: 0.11, blue: 0.56, alpha: 1.0).cgColor
            ]
        case .cataclysmic:
            colors = [
                UIColor(red: 0.94, green: 0.14, blue: 0.29, alpha: 1.0).cgColor,
                UIColor(red: 0.5, green: 0.02, blue: 0.12, alpha: 1.0).cgColor
            ]
        }

        incandescenceSpectrum.colors = colors
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        incandescenceSpectrum.frame = bounds
        emphasisGradation.frame = bounds
        radiantAureolaMembrane.frame = bounds
        radiantAureolaMembrane.cornerRadius = layer.cornerRadius
        peripheralDelineation.path = UIBezierPath(roundedRect: bounds.insetBy(dx: 1, dy: 1), cornerRadius: layer.cornerRadius).cgPath
    }

    @objc private func inaugurateMagnificationSequence() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            self.radiantAureolaMembrane.opacity = 1
        }
    }

    @objc private func revertDimensionalState() {
        UIView.animate(withDuration: 0.15) {
            self.transform = .identity
            self.radiantAureolaMembrane.opacity = 0
        }
    }
}
