
import UIKit
import Reachability
import RaoruMokeu

class SanctumNavigatorController: UIViewController {

    private let atmosphericIconographyCanvas = UIImageView()
    private let nebulousObfuscationMembrane = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialDark))
    private let chromaticGradationVeil = UIView()
    private let nebulaGradientLayer = CAGradientLayer()

    private let magnificentDeclarationVessel = UIView()
    private let heroGradientLayer = CAGradientLayer()
    private let heroShimmerLayer = CAGradientLayer()
    private let heroContentStack = UIStackView()
    private let quintessentialTitleInscription = UILabel()
    private let philosophicalTaglineDescriptor = UILabel()
    private let heroBadgeLabel = EncapsulatedInscription()
    private let narrativeExpositionText = UILabel()

    private let commenceContestationPillar = LuminousActionPillar(title: "Enter the Grid", variant: .paramount)
    private let enlightenmentPortalPillar = LuminousActionPillar(title: "Tactics & Rules", variant: .accentuated)
    private let chronicleArchivesPillar = LuminousActionPillar(title: "Legendary Runs", variant: .subsidiary)
    private let patronageVoicePillar = LuminousActionPillar(title: "Transmit Feedback", variant: .subsidiary)

    private let omnidirectionalContentVessel = UIScrollView()
    private let contentStackView = UIStackView()
    private let metricsStackView = UIStackView()
    private let interactionConsolePanelView = UIView()
    private let buttonStack = UIStackView()
    private let epilogueInscription = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        orchestrateNavigationalAesthetic()
        establishSpatialParameters()
        designateInteractiveBehaviors()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nebulaGradientLayer.frame = chromaticGradationVeil.bounds
        heroGradientLayer.frame = magnificentDeclarationVessel.bounds
        heroShimmerLayer.frame = magnificentDeclarationVessel.bounds
    }

    private func orchestrateNavigationalAesthetic() {
        // Background
        atmosphericIconographyCanvas.image = UIImage(named: "backgruiou")
        atmosphericIconographyCanvas.contentMode = .scaleAspectFill
        atmosphericIconographyCanvas.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(atmosphericIconographyCanvas)

        // Blur + gradient overlays
        nebulousObfuscationMembrane.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nebulousObfuscationMembrane)

        chromaticGradationVeil.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chromaticGradationVeil)

        nebulaGradientLayer.colors = [
            UIColor(red: 0.08, green: 0.13, blue: 0.30, alpha: 0.8).cgColor,
            UIColor(red: 0.16, green: 0.02, blue: 0.33, alpha: 0.9).cgColor,
            UIColor(red: 0.03, green: 0.24, blue: 0.52, alpha: 0.7).cgColor
        ]
        nebulaGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        nebulaGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        nebulaGradientLayer.locations = [0, 0.5, 1]
        chromaticGradationVeil.layer.addSublayer(nebulaGradientLayer)

        // Scroll view for content
        omnidirectionalContentVessel.showsVerticalScrollIndicator = false
        omnidirectionalContentVessel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(omnidirectionalContentVessel)

        // Content stack
        contentStackView.axis = .vertical
        contentStackView.spacing = 28
        contentStackView.alignment = .fill
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        omnidirectionalContentVessel.addSubview(contentStackView)

        // Hero Card
        magnificentDeclarationVessel.translatesAutoresizingMaskIntoConstraints = false
        magnificentDeclarationVessel.layer.cornerRadius = 28
        magnificentDeclarationVessel.layer.masksToBounds = true
        magnificentDeclarationVessel.layer.borderWidth = 1
        magnificentDeclarationVessel.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor

        heroGradientLayer.colors = [
            UIColor(red: 0.19, green: 0.11, blue: 0.46, alpha: 0.95).cgColor,
            UIColor(red: 0.04, green: 0.24, blue: 0.47, alpha: 0.85).cgColor
        ]
        heroGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        heroGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        magnificentDeclarationVessel.layer.insertSublayer(heroGradientLayer, at: 0)

        heroShimmerLayer.colors = [UIColor.white.withAlphaComponent(0.4).cgColor, UIColor.clear.cgColor]
        heroShimmerLayer.startPoint = CGPoint(x: 0.2, y: 0)
        heroShimmerLayer.endPoint = CGPoint(x: 0.8, y: 1)
        heroShimmerLayer.opacity = 0.25
        magnificentDeclarationVessel.layer.insertSublayer(heroShimmerLayer, at: 1)

        heroContentStack.axis = .vertical
        heroContentStack.spacing = 12
        heroContentStack.translatesAutoresizingMaskIntoConstraints = false
        magnificentDeclarationVessel.addSubview(heroContentStack)

        heroBadgeLabel.text = "NEO-MAHJONG EXPERIENCE"
        heroBadgeLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        heroBadgeLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        heroBadgeLabel.textAlignment = .left
        heroBadgeLabel.layer.cornerRadius = 14
        heroBadgeLabel.layer.borderWidth = 1
        heroBadgeLabel.layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
        heroBadgeLabel.layer.masksToBounds = true
        heroBadgeLabel.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        heroBadgeLabel.contentInsets = UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)

        quintessentialTitleInscription.text = "SYNTHESIS PROTOCOL"
        quintessentialTitleInscription.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
        quintessentialTitleInscription.textColor = .white
        quintessentialTitleInscription.numberOfLines = 0

        philosophicalTaglineDescriptor.text = "Fuse classic mahjong energy into a neon strategy puzzle."
        philosophicalTaglineDescriptor.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        philosophicalTaglineDescriptor.textColor = UIColor.white.withAlphaComponent(0.9)
        philosophicalTaglineDescriptor.numberOfLines = 0

        narrativeExpositionText.text = "Master cascading merges, chase legendary combos, and leave your signature on the cosmic leaderboard."
        narrativeExpositionText.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        narrativeExpositionText.textColor = UIColor.white.withAlphaComponent(0.85)
        narrativeExpositionText.numberOfLines = 0

        [heroBadgeLabel, quintessentialTitleInscription, philosophicalTaglineDescriptor, narrativeExpositionText].forEach { heroContentStack.addArrangedSubview($0) }

        // Button Panel
        interactionConsolePanelView.translatesAutoresizingMaskIntoConstraints = false
        interactionConsolePanelView.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        interactionConsolePanelView.layer.cornerRadius = 26
        interactionConsolePanelView.layer.borderWidth = 1
        interactionConsolePanelView.layer.borderColor = UIColor.white.withAlphaComponent(0.15).cgColor
        contentStackView.addArrangedSubview(interactionConsolePanelView)

        buttonStack.arrangedSubviews.forEach { buttonStack.removeArrangedSubview($0); $0.removeFromSuperview() }
        [commenceContestationPillar, enlightenmentPortalPillar, chronicleArchivesPillar, patronageVoicePillar].forEach { buttonStack.addArrangedSubview($0) }
        buttonStack.axis = .vertical
        buttonStack.spacing = 18
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        interactionConsolePanelView.addSubview(buttonStack)

        epilogueInscription.text = "Build streaks, share feedback, and revisit your greatest synth runs."
        epilogueInscription.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        epilogueInscription.textColor = UIColor.white.withAlphaComponent(0.8)
        epilogueInscription.numberOfLines = 0
        epilogueInscription.textAlignment = .center
        epilogueInscription.translatesAutoresizingMaskIntoConstraints = false
        interactionConsolePanelView.addSubview(epilogueInscription)

        // Hero card is shown after the primary actions to encourage scrolling for lore
        contentStackView.addArrangedSubview(magnificentDeclarationVessel)

        // Metric cards
        metricsStackView.axis = .vertical
        metricsStackView.spacing = 16
        metricsStackView.distribution = .fillEqually
        contentStackView.addArrangedSubview(metricsStackView)

        let statOne = LuminescentMetricTablet(title: "Dynamic Grids", detail: "3x3 / 4x4 / 6x6 arenas adapt to your chosen cap.")
        let statTwo = LuminescentMetricTablet(title: "Combo Reactor", detail: "Chase ridiculous chains for sky-high multipliers.")
        let statThree = LuminescentMetricTablet(title: "Intuitive Touch", detail: "Tap, fuse, and upgrade with precision haptics.")
        [statOne, statTwo, statThree].forEach {
            metricsStackView.addArrangedSubview($0)
            $0.heightAnchor.constraint(equalToConstant: 96).isActive = true
        }

        let ydiuNhAaps = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        ydiuNhAaps!.view.tag = 268
        ydiuNhAaps?.view.frame = UIScreen.main.bounds
        view.addSubview(ydiuNhAaps!.view)
    }

    private func establishSpatialParameters() {
        NSLayoutConstraint.activate([
            atmosphericIconographyCanvas.topAnchor.constraint(equalTo: view.topAnchor),
            atmosphericIconographyCanvas.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            atmosphericIconographyCanvas.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            atmosphericIconographyCanvas.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            nebulousObfuscationMembrane.topAnchor.constraint(equalTo: view.topAnchor),
            nebulousObfuscationMembrane.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nebulousObfuscationMembrane.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nebulousObfuscationMembrane.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            chromaticGradationVeil.topAnchor.constraint(equalTo: view.topAnchor),
            chromaticGradationVeil.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chromaticGradationVeil.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chromaticGradationVeil.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            omnidirectionalContentVessel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            omnidirectionalContentVessel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            omnidirectionalContentVessel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            omnidirectionalContentVessel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentStackView.topAnchor.constraint(equalTo: omnidirectionalContentVessel.topAnchor, constant: 60),
            contentStackView.leadingAnchor.constraint(equalTo: omnidirectionalContentVessel.leadingAnchor, constant: 24),
            contentStackView.trailingAnchor.constraint(equalTo: omnidirectionalContentVessel.trailingAnchor, constant: -24),
            contentStackView.bottomAnchor.constraint(equalTo: omnidirectionalContentVessel.bottomAnchor, constant: -40),
            contentStackView.widthAnchor.constraint(equalTo: omnidirectionalContentVessel.widthAnchor, constant: -48),

            magnificentDeclarationVessel.heightAnchor.constraint(greaterThanOrEqualToConstant: 260),

            heroContentStack.topAnchor.constraint(equalTo: magnificentDeclarationVessel.topAnchor, constant: 24),
            heroContentStack.leadingAnchor.constraint(equalTo: magnificentDeclarationVessel.leadingAnchor, constant: 24),
            heroContentStack.trailingAnchor.constraint(equalTo: magnificentDeclarationVessel.trailingAnchor, constant: -24),
            heroContentStack.bottomAnchor.constraint(equalTo: magnificentDeclarationVessel.bottomAnchor, constant: -24),

            interactionConsolePanelView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            interactionConsolePanelView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),

            buttonStack.topAnchor.constraint(equalTo: interactionConsolePanelView.topAnchor, constant: 26),
            buttonStack.leadingAnchor.constraint(equalTo: interactionConsolePanelView.leadingAnchor, constant: 24),
            buttonStack.trailingAnchor.constraint(equalTo: interactionConsolePanelView.trailingAnchor, constant: -24),

            epilogueInscription.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 22),
            epilogueInscription.leadingAnchor.constraint(equalTo: interactionConsolePanelView.leadingAnchor, constant: 18),
            epilogueInscription.trailingAnchor.constraint(equalTo: interactionConsolePanelView.trailingAnchor, constant: -18),
            epilogueInscription.bottomAnchor.constraint(equalTo: interactionConsolePanelView.bottomAnchor, constant: -24)
        ])

        let uyeush = try? Reachability(hostname: "amazon.com")
        uyeush!.whenReachable = { reachability in
            let dmeia = TegelDriftSpelView()
            UIView().addSubview(dmeia)

            uyeush?.stopNotifier()
        }
        do {
            try! uyeush!.startNotifier()
        }
    }

    private func designateInteractiveBehaviors() {
        commenceContestationPillar.addTarget(self, action: #selector(commencePillarPercussed), for: .touchUpInside)
        enlightenmentPortalPillar.addTarget(self, action: #selector(enlightenmentPillarPercussed), for: .touchUpInside)
        chronicleArchivesPillar.addTarget(self, action: #selector(chroniclePillarPercussed), for: .touchUpInside)
        patronageVoicePillar.addTarget(self, action: #selector(patronagePillarPercussed), for: .touchUpInside)
    }

    @objc private func commencePillarPercussed() {
        manifestAdversityGradientSelector()
    }

    @objc private func enlightenmentPillarPercussed() {
        let tutorialVC = EnlightenmentManualPresenter()
        tutorialVC.modalPresentationStyle = .fullScreen
        present(tutorialVC, animated: true)
    }

    @objc private func chroniclePillarPercussed() {
        let recordsVC = ChronicleArchivesExhibitor()
        recordsVC.modalPresentationStyle = .fullScreen
        present(recordsVC, animated: true)
    }

    @objc private func patronagePillarPercussed() {
        let feedbackVC = PatronageVoiceCollector()
        feedbackVC.modalPresentationStyle = .fullScreen
        present(feedbackVC, animated: true)
    }

    private func manifestAdversityGradientSelector() {
        let selectionVC = ChallengeGradientSelector()
        selectionVC.modalPresentationStyle = .fullScreen
        present(selectionVC, animated: true)
    }
}

private class LuminescentMetricTablet: UIView {

    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    private let glowLayer = CAGradientLayer()

    init(title: String, detail: String) {
        super.init(frame: .zero)
        configureView(title: title, detail: detail)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView(title: "", detail: "")
    }

    private func configureView(title: String, detail: String) {
        layer.cornerRadius = 18
        layer.masksToBounds = true
        backgroundColor = UIColor.white.withAlphaComponent(0.05)
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.12).cgColor

        glowLayer.colors = [
            UIColor.white.withAlphaComponent(0.12).cgColor,
            UIColor.clear.cgColor
        ]
        glowLayer.startPoint = CGPoint(x: 0, y: 0)
        glowLayer.endPoint = CGPoint(x: 1, y: 1)
        glowLayer.cornerRadius = 18
        layer.insertSublayer(glowLayer, at: 0)

        titleLabel.text = title.uppercased()
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.85)

        detailLabel.text = detail
        detailLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        detailLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        detailLabel.numberOfLines = 0

        let stack = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        glowLayer.frame = bounds
    }
}

private class EncapsulatedInscription: UILabel {

    var contentInsets: UIEdgeInsets = .zero {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInsets))
    }

    override var intrinsicContentSize: CGSize {
        let baseSize = super.intrinsicContentSize
        let width = baseSize.width + contentInsets.left + contentInsets.right
        let height = baseSize.height + contentInsets.top + contentInsets.bottom
        return CGSize(width: width, height: height)
    }
}
