//
//  ElegantDialogView.swift
//  Synthesis
//
//  Created by Hades on 11/18/25.
//

import UIKit

class ElegantDialogView: UIView {

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let buttonsStackView = UIStackView()
    private var completionHandlers: [() -> Void] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureInitialLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureInitialLayout() {
        backgroundColor = UIColor.black.withAlphaComponent(0.6)

        // Container setup
        containerView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        containerView.layer.cornerRadius = 24
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 8)
        containerView.layer.shadowRadius = 20
        containerView.layer.shadowOpacity = 0.4
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)

        // Title label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)

        // Message label
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.5, alpha: 1.0)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(messageLabel)

        // Buttons stack view
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 12
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(buttonsStackView)

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 40),
            containerView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -40),
            containerView.widthAnchor.constraint(lessThanOrEqualToConstant: 340),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),

            buttonsStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
            buttonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            buttonsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            buttonsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            buttonsStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }

    func configureContent(title: String, message: String) {
        titleLabel.text = title
        messageLabel.text = message
    }

    func appendActionButton(title: String, variant: AestheticButtonView.ButtonVariant = .primary, handler: @escaping () -> Void) {
        let button = AestheticButtonView(title: title, variant: variant)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        buttonsStackView.addArrangedSubview(button)
        completionHandlers.append(handler)
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        if let index = buttonsStackView.arrangedSubviews.firstIndex(of: sender) {
            dismissWithAnimation {
                self.completionHandlers[index]()
            }
        }
    }

    func presentOnWindow() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        frame = window.bounds
        window.addSubview(self)

        alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.alpha = 1
            self.containerView.transform = .identity
        }
    }

    private func dismissWithAnimation(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.removeFromSuperview()
            completion()
        }
    }

    static func displayAlert(title: String, message: String, actions: [(String, AestheticButtonView.ButtonVariant, () -> Void)]) {
        let dialog = ElegantDialogView()
        dialog.configureContent(title: title, message: message)
        for action in actions {
            dialog.appendActionButton(title: action.0, variant: action.1, handler: action.2)
        }
        dialog.presentOnWindow()
    }
}
