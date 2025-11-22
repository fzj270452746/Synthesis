//
//  GameRecordsViewController.swift
//  Synthesis
//
//  Created by Hades on 11/18/25.
//

import UIKit

class GameRecordsViewController: UIViewController {

    private let backgroundImageView = UIImageView()
    private let titleLabel = UILabel()
    private let recordsTableView = UITableView()
    private let closeButton = UIButton()
    private let clearButton = AestheticButtonView(title: "Clear All Records", variant: .destructive)

    private var gameRecords: [GameRecordEntry] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUserInterface()
        setupConstraints()
        loadGameRecords()
        configureButtonActions()
    }

    private func configureUserInterface() {
        // Background
        backgroundImageView.image = UIImage(named: "backgruiou")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)

        // Close button
        closeButton.setTitle("✕", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        closeButton.layer.cornerRadius = 20
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)

        // Title
        titleLabel.text = "Game Records"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        titleLabel.layer.shadowRadius = 4
        titleLabel.layer.shadowOpacity = 0.8
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Table view
        recordsTableView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        recordsTableView.layer.cornerRadius = 12
        recordsTableView.delegate = self
        recordsTableView.dataSource = self
        recordsTableView.register(GameRecordTableCell.self, forCellReuseIdentifier: "GameRecordCell")
        recordsTableView.separatorStyle = .singleLine
        recordsTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recordsTableView)

        // Clear button
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clearButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40),

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            recordsTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            recordsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recordsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            recordsTableView.bottomAnchor.constraint(equalTo: clearButton.topAnchor, constant: -20),

            clearButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 280)
        ])
    }

    private func loadGameRecords() {
        gameRecords = PersistentStorageManager.sharedInstance.fetchTopGameRecords(limit: 50)
        recordsTableView.reloadData()
    }

    private func configureButtonActions() {
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
    }

    @objc private func clearButtonTapped() {
        ElegantDialogView.displayAlert(
            title: "Clear Records",
            message: "Are you sure you want to delete all game records?",
            actions: [
                ("Cancel", .secondary, {}),
                ("Clear", .destructive, { [weak self] in
                    PersistentStorageManager.sharedInstance.clearAllGameRecords()
                    self?.loadGameRecords()
                })
            ]
        )
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension GameRecordsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if gameRecords.isEmpty {
            return 1 // Show empty state
        }
        return gameRecords.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameRecordCell", for: indexPath) as? GameRecordTableCell else {
            return UITableViewCell()
        }

        if gameRecords.isEmpty {
            cell.configureEmptyState()
        } else {
            let record = gameRecords[indexPath.row]
            cell.configureWithRecord(record, rank: indexPath.row + 1)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return gameRecords.isEmpty ? 100 : 80
    }
}

// MARK: - GameRecordTableCell

class GameRecordTableCell: UITableViewCell {

    private let rankLabel = UILabel()
    private let scoreLabel = UILabel()
    private let difficultyLabel = UILabel()
    private let comboLabel = UILabel()
    private let dateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCellLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureCellLayout() {
        backgroundColor = .clear
        selectionStyle = .none

        rankLabel.font = UIFont.boldSystemFont(ofSize: 20)
        rankLabel.textColor = UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0)
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rankLabel)

        scoreLabel.font = UIFont.boldSystemFont(ofSize: 18)
        scoreLabel.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(scoreLabel)

        difficultyLabel.font = UIFont.systemFont(ofSize: 14)
        difficultyLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.5, alpha: 1.0)
        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(difficultyLabel)

        comboLabel.font = UIFont.systemFont(ofSize: 14)
        comboLabel.textColor = UIColor(red: 0.9, green: 0.5, blue: 0.2, alpha: 1.0)
        comboLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(comboLabel)

        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.6, alpha: 1.0)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            rankLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rankLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rankLabel.widthAnchor.constraint(equalToConstant: 40),

            scoreLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 12),
            scoreLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),

            difficultyLabel.leadingAnchor.constraint(equalTo: scoreLabel.leadingAnchor),
            difficultyLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 4),

            comboLabel.leadingAnchor.constraint(equalTo: difficultyLabel.trailingAnchor, constant: 12),
            comboLabel.centerYAnchor.constraint(equalTo: difficultyLabel.centerYAnchor),

            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateLabel.topAnchor.constraint(equalTo: scoreLabel.topAnchor)
        ])
    }

    func configureWithRecord(_ record: GameRecordEntry, rank: Int) {
        rankLabel.text = "#\(rank)"
        scoreLabel.text = "\(record.achievedScore) pts"
        difficultyLabel.text = "Difficulty: \(record.selectedDifficulty)"
        comboLabel.text = "Combo ×\(record.maximumCombo)"
        dateLabel.text = record.formattedDate

        rankLabel.isHidden = false
        scoreLabel.isHidden = false
        difficultyLabel.isHidden = false
        comboLabel.isHidden = false
        dateLabel.isHidden = false
    }

    func configureEmptyState() {
        scoreLabel.text = "No records yet"
        scoreLabel.textAlignment = .center
        scoreLabel.isHidden = false

        rankLabel.isHidden = true
        difficultyLabel.isHidden = true
        comboLabel.isHidden = true
        dateLabel.isHidden = true
    }
}
