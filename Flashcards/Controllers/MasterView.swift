//
//  MasterView.swift
//  Flashcards
//
//  Created by Garrett miller on 5/3/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import UIKit

protocol MasterViewDelegate: class {
    func didOpenSelection(_ sender: UIButton)
}

class MasterView: UIView {

    private lazy var safeAreaCover: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Decks"
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.heavy)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var chevButton: UIButton = {
        let chevUpImage = UIImage(systemName: "chevron.up.circle")?
            .withTintColor(.black, renderingMode: .alwaysOriginal)
        let button = UIButton()
        button.setBackgroundImage(chevUpImage, for: .init())
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    weak var delegate: MasterViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemGray3
        chevButton.addTarget(self, action: #selector(openPopup(_:)), for: .touchUpInside)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        chevButton.addTarget(self, action: #selector(openPopup(_:)), for: .touchUpInside)
        setupViews()
    }

    @objc private func openPopup(_ sender: UIButton) {
        guard let delegate = delegate else {
            print("delegate is nil")
            return
        }
        delegate.didOpenSelection(sender)
    }

    private func setupViews() {
        bounds = CGRect(x: CGFloat(0), y: CGFloat(0), width: UIScreen.main.bounds.width, height: CGFloat(50))
        addSubview(titleBar)
        addSubview(titleLabel)
        addSubview(chevButton)
        addSubview(safeAreaCover)

        NSLayoutConstraint.activate([
            safeAreaCover.widthAnchor.constraint(equalTo: widthAnchor),
            safeAreaCover.leadingAnchor.constraint(equalTo: leadingAnchor),
            safeAreaCover.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            safeAreaCover.heightAnchor.constraint(equalToConstant: 50),

            titleBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            titleBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleBar.heightAnchor.constraint(equalToConstant: 50),

            titleLabel.centerXAnchor.constraint(equalTo: titleBar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleBar.centerYAnchor),

            chevButton.trailingAnchor.constraint(equalTo: titleBar.trailingAnchor, constant: -20),
            chevButton.centerYAnchor.constraint(equalTo: titleBar.centerYAnchor),
            chevButton.widthAnchor.constraint(equalToConstant: 30),
            chevButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
