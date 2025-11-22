//
//  ElegantDialogView.swift
//  Synthesis
//
//  Created by Hades on 11/18/25.
//

import UIKit

class OpulentInquiryPanel: UIView {

    private let encapsulationVessel = UIView()
    private let proclamationInscription = UILabel()
    private let narrativeDescriptor = UILabel()
    private let interactivePillarOrchestration = UIStackView()
    private var culminationCallbacks: [() -> Void] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        architectOrchestrationGeometry()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func architectOrchestrationGeometry() {
        backgroundColor = UIColor.black.withAlphaComponent(0.6)

        // Container setup
        encapsulationVessel.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        encapsulationVessel.layer.cornerRadius = 24
        encapsulationVessel.layer.shadowColor = UIColor.black.cgColor
        encapsulationVessel.layer.shadowOffset = CGSize(width: 0, height: 8)
        encapsulationVessel.layer.shadowRadius = 20
        encapsulationVessel.layer.shadowOpacity = 0.4
        encapsulationVessel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(encapsulationVessel)

        // Title label
        proclamationInscription.font = UIFont.boldSystemFont(ofSize: 24)
        proclamationInscription.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0)
        proclamationInscription.textAlignment = .center
        proclamationInscription.translatesAutoresizingMaskIntoConstraints = false
        encapsulationVessel.addSubview(proclamationInscription)

        // Message label
        narrativeDescriptor.font = UIFont.systemFont(ofSize: 16)
        narrativeDescriptor.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.5, alpha: 1.0)
        narrativeDescriptor.textAlignment = .center
        narrativeDescriptor.numberOfLines = 0
        narrativeDescriptor.translatesAutoresizingMaskIntoConstraints = false
        encapsulationVessel.addSubview(narrativeDescriptor)

        // Buttons stack view
        interactivePillarOrchestration.axis = .vertical
        interactivePillarOrchestration.spacing = 12
        interactivePillarOrchestration.distribution = .fillEqually
        interactivePillarOrchestration.translatesAutoresizingMaskIntoConstraints = false
        encapsulationVessel.addSubview(interactivePillarOrchestration)

        NSLayoutConstraint.activate([
            encapsulationVessel.centerXAnchor.constraint(equalTo: centerXAnchor),
            encapsulationVessel.centerYAnchor.constraint(equalTo: centerYAnchor),
            encapsulationVessel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 40),
            encapsulationVessel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -40),
            encapsulationVessel.widthAnchor.constraint(lessThanOrEqualToConstant: 340),

            proclamationInscription.topAnchor.constraint(equalTo: encapsulationVessel.topAnchor, constant: 32),
            proclamationInscription.leadingAnchor.constraint(equalTo: encapsulationVessel.leadingAnchor, constant: 24),
            proclamationInscription.trailingAnchor.constraint(equalTo: encapsulationVessel.trailingAnchor, constant: -24),

            narrativeDescriptor.topAnchor.constraint(equalTo: proclamationInscription.bottomAnchor, constant: 16),
            narrativeDescriptor.leadingAnchor.constraint(equalTo: encapsulationVessel.leadingAnchor, constant: 24),
            narrativeDescriptor.trailingAnchor.constraint(equalTo: encapsulationVessel.trailingAnchor, constant: -24),

            interactivePillarOrchestration.topAnchor.constraint(equalTo: narrativeDescriptor.bottomAnchor, constant: 24),
            interactivePillarOrchestration.leadingAnchor.constraint(equalTo: encapsulationVessel.leadingAnchor, constant: 24),
            interactivePillarOrchestration.trailingAnchor.constraint(equalTo: encapsulationVessel.trailingAnchor, constant: -24),
            interactivePillarOrchestration.bottomAnchor.constraint(equalTo: encapsulationVessel.bottomAnchor, constant: -24),
            interactivePillarOrchestration.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }

    func inscribeContentSubstance(title: String, message: String) {
        proclamationInscription.text = title
        narrativeDescriptor.text = message
    }

    func annexInteractivePillar(title: String, variant: LuminousActionPillar.ChromaticGradation = .paramount, handler: @escaping () -> Void) {
        let button = LuminousActionPillar(title: title, variant: variant)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(pillarPercussionDetected(_:)), for: .touchUpInside)
        interactivePillarOrchestration.addArrangedSubview(button)
        culminationCallbacks.append(handler)
    }

    @objc private func pillarPercussionDetected(_ sender: UIButton) {
        if let index = interactivePillarOrchestration.arrangedSubviews.firstIndex(of: sender) {
            dissipateWithChoreography {
                self.culminationCallbacks[index]()
            }
        }
    }

    func manifestUponViewport() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        frame = window.bounds
        window.addSubview(self)

        alpha = 0
        encapsulationVessel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.alpha = 1
            self.encapsulationVessel.transform = .identity
        }
    }

    private func dissipateWithChoreography(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            self.encapsulationVessel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.removeFromSuperview()
            completion()
        }
    }

    static func renderInquisitivePanel(title: String, message: String, actions: [(String, LuminousActionPillar.ChromaticGradation, () -> Void)]) {
        let dialog = OpulentInquiryPanel()
        dialog.inscribeContentSubstance(title: title, message: message)
        for action in actions {
            dialog.annexInteractivePillar(title: action.0, variant: action.1, handler: action.2)
        }
        dialog.manifestUponViewport()
    }
}
