//
//  GameRecordsViewController.swift
//  Synthesis
//
//  Created by Hades on 11/18/25.
//

import UIKit

class ChronicleArchivesExhibitor: UIViewController {

    private let ambientBackgroundRenderer = UIImageView()
    private let exhibitorProclamation = UILabel()
    private let chronicleManifestationGrid = UITableView()
    private let egressPillar = UIButton()
    private let obliterationPillar = LuminousActionPillar(title: "Clear All Records", variant: .cataclysmic)

    private var triumphChronicleCollection: [VictoryChronicleNode] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        establishExhibitionLayout()
        delineateLayoutBoundaries()
        procureArchivedVictories()
        establishInteractionProtocols()
    }

    private func establishExhibitionLayout() {
        // Background
        ambientBackgroundRenderer.image = UIImage(named: "backgruiou")
        ambientBackgroundRenderer.contentMode = .scaleAspectFill
        ambientBackgroundRenderer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ambientBackgroundRenderer)

        // Close button
        egressPillar.setTitle("✕", for: .normal)
        egressPillar.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        egressPillar.setTitleColor(.white, for: .normal)
        egressPillar.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        egressPillar.layer.cornerRadius = 20
        egressPillar.translatesAutoresizingMaskIntoConstraints = false
        egressPillar.addTarget(self, action: #selector(egressPercussionDetected), for: .touchUpInside)
        view.addSubview(egressPillar)

        // Title
        exhibitorProclamation.text = "Game Records"
        exhibitorProclamation.font = UIFont.boldSystemFont(ofSize: 28)
        exhibitorProclamation.textColor = .white
        exhibitorProclamation.textAlignment = .center
        exhibitorProclamation.layer.shadowColor = UIColor.black.cgColor
        exhibitorProclamation.layer.shadowOffset = CGSize(width: 0, height: 2)
        exhibitorProclamation.layer.shadowRadius = 4
        exhibitorProclamation.layer.shadowOpacity = 0.8
        exhibitorProclamation.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exhibitorProclamation)

        // Table view
        chronicleManifestationGrid.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        chronicleManifestationGrid.layer.cornerRadius = 12
        chronicleManifestationGrid.delegate = self
        chronicleManifestationGrid.dataSource = self
        chronicleManifestationGrid.register(VictoryChronicleTablet.self, forCellReuseIdentifier: "GameRecordCell")
        chronicleManifestationGrid.separatorStyle = .singleLine
        chronicleManifestationGrid.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chronicleManifestationGrid)

        // Clear button
        obliterationPillar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(obliterationPillar)
    }

    private func delineateLayoutBoundaries() {
        NSLayoutConstraint.activate([
            ambientBackgroundRenderer.topAnchor.constraint(equalTo: view.topAnchor),
            ambientBackgroundRenderer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ambientBackgroundRenderer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ambientBackgroundRenderer.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            egressPillar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            egressPillar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            egressPillar.widthAnchor.constraint(equalToConstant: 40),
            egressPillar.heightAnchor.constraint(equalToConstant: 40),

            exhibitorProclamation.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            exhibitorProclamation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            exhibitorProclamation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            chronicleManifestationGrid.topAnchor.constraint(equalTo: exhibitorProclamation.bottomAnchor, constant: 32),
            chronicleManifestationGrid.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chronicleManifestationGrid.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chronicleManifestationGrid.bottomAnchor.constraint(equalTo: obliterationPillar.topAnchor, constant: -20),

            obliterationPillar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            obliterationPillar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            obliterationPillar.widthAnchor.constraint(equalToConstant: 280)
        ])
    }

    private func procureArchivedVictories() {
        triumphChronicleCollection = ArchivedRepositoryKeeper.sovereignExemplar.extractApexChronicles(threshold: 50)
        chronicleManifestationGrid.reloadData()
    }

    private func establishInteractionProtocols() {
        obliterationPillar.addTarget(self, action: #selector(obliterationPillarPercussed), for: .touchUpInside)
    }

    @objc private func obliterationPillarPercussed() {
        OpulentInquiryPanel.renderInquisitivePanel(
            title: "Clear Records",
            message: "Are you sure you want to delete all game records?",
            actions: [
                ("Cancel", .subsidiary, {}),
                ("Clear", .cataclysmic, { [weak self] in
                    ArchivedRepositoryKeeper.sovereignExemplar.purgeEntireChronicleArchive()
                    self?.procureArchivedVictories()
                })
            ]
        )
    }

    @objc private func egressPercussionDetected() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension ChronicleArchivesExhibitor: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if triumphChronicleCollection.isEmpty {
            return 1 // Show empty state
        }
        return triumphChronicleCollection.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameRecordCell", for: indexPath) as? VictoryChronicleTablet else {
            return UITableViewCell()
        }

        if triumphChronicleCollection.isEmpty {
            cell.manifestVacuity()
        } else {
            let record = triumphChronicleCollection[indexPath.row]
            cell.inscribeChronicleData(record, rank: indexPath.row + 1)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return triumphChronicleCollection.isEmpty ? 100 : 80
    }
}

// MARK: - VictoryChronicleTablet

class VictoryChronicleTablet: UITableViewCell {

    private let hierarchicalDesignation = UILabel()
    private let triumphQuantity = UILabel()
    private let adversityIndicator = UILabel()
    private let sequenceAmplifier = UILabel()
    private let temporalStamp = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        establishTabletGeometry()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func establishTabletGeometry() {
        backgroundColor = .clear
        selectionStyle = .none

        hierarchicalDesignation.font = UIFont.boldSystemFont(ofSize: 20)
        hierarchicalDesignation.textColor = UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0)
        hierarchicalDesignation.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hierarchicalDesignation)

        triumphQuantity.font = UIFont.boldSystemFont(ofSize: 18)
        triumphQuantity.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0)
        triumphQuantity.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(triumphQuantity)

        adversityIndicator.font = UIFont.systemFont(ofSize: 14)
        adversityIndicator.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.5, alpha: 1.0)
        adversityIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(adversityIndicator)

        sequenceAmplifier.font = UIFont.systemFont(ofSize: 14)
        sequenceAmplifier.textColor = UIColor(red: 0.9, green: 0.5, blue: 0.2, alpha: 1.0)
        sequenceAmplifier.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(sequenceAmplifier)

        temporalStamp.font = UIFont.systemFont(ofSize: 12)
        temporalStamp.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.6, alpha: 1.0)
        temporalStamp.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(temporalStamp)

        NSLayoutConstraint.activate([
            hierarchicalDesignation.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            hierarchicalDesignation.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            hierarchicalDesignation.widthAnchor.constraint(equalToConstant: 40),

            triumphQuantity.leadingAnchor.constraint(equalTo: hierarchicalDesignation.trailingAnchor, constant: 12),
            triumphQuantity.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),

            adversityIndicator.leadingAnchor.constraint(equalTo: triumphQuantity.leadingAnchor),
            adversityIndicator.topAnchor.constraint(equalTo: triumphQuantity.bottomAnchor, constant: 4),

            sequenceAmplifier.leadingAnchor.constraint(equalTo: adversityIndicator.trailingAnchor, constant: 12),
            sequenceAmplifier.centerYAnchor.constraint(equalTo: adversityIndicator.centerYAnchor),

            temporalStamp.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            temporalStamp.topAnchor.constraint(equalTo: triumphQuantity.topAnchor)
        ])
    }

    func inscribeChronicleData(_ record: VictoryChronicleNode, rank: Int) {
        hierarchicalDesignation.text = "#\(rank)"
        triumphQuantity.text = "\(record.triumphantTally) pts"
        adversityIndicator.text = "Difficulty: \(record.adversityGradient)"
        sequenceAmplifier.text = "Combo ×\(record.consecutiveSequencePinnacle)"
        temporalStamp.text = record.beautifiedTemporalDescriptor

        hierarchicalDesignation.isHidden = false
        triumphQuantity.isHidden = false
        adversityIndicator.isHidden = false
        sequenceAmplifier.isHidden = false
        temporalStamp.isHidden = false
    }

    func manifestVacuity() {
        triumphQuantity.text = "No records yet"
        triumphQuantity.textAlignment = .center
        triumphQuantity.isHidden = false

        hierarchicalDesignation.isHidden = true
        adversityIndicator.isHidden = true
        sequenceAmplifier.isHidden = true
        temporalStamp.isHidden = true
    }
}
