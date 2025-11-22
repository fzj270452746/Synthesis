//
//  MahjongTileView.swift
//  Synthesis
//
//  Created by Hades on 11/18/25.
//

import UIKit

class MahjongTileView: UIView {

    private let tileImageView = UIImageView()
    private let shimmerLayer = CAGradientLayer()
    var tileEntity: MahjongTileEntity?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureInitialAppearance()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureInitialAppearance()
    }

    private func configureInitialAppearance() {
        backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        layer.cornerRadius = 8
        layer.borderWidth = 2
        layer.borderColor = UIColor(white: 0.8, alpha: 1.0).cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.2

        tileImageView.contentMode = .scaleAspectFit
        tileImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tileImageView)

        NSLayoutConstraint.activate([
            tileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            tileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            tileImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            tileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }

    func configureTile(with entity: MahjongTileEntity) {
        self.tileEntity = entity
        tileImageView.image = UIImage(named: entity.assetImageName)
    }

    func clearTile() {
        self.tileEntity = nil
        tileImageView.image = nil
    }

    func animateAppearance() {
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut) {
            self.alpha = 1
            self.transform = .identity
        }
    }

    func animateMerge(completion: @escaping () -> Void) {
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
                completion()
            }
        }
    }

    func animateUpgrade(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.15, animations: {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { _ in
                UIView.animate(withDuration: 0.2) {
                    self.transform = .identity
                    completion()
                }
            }
        }
    }

    func applyPulseEffect() {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 0.6
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        layer.add(pulseAnimation, forKey: "pulseEffect")
    }

    func removePulseEffect() {
        layer.removeAnimation(forKey: "pulseEffect")
    }
}
