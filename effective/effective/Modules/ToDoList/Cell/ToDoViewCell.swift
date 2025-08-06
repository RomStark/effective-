//
//  ToDoViewCell.swift
//  effective
//
//  Created by Al Stark on 06.08.2025.
//

import UIKit

protocol ToDoViewCellProtocol: AnyObject {
    func doneTapped(_ cell: ToDoViewCell)
}


final class ToDoViewCell: UITableViewCell {
    static var reuseIdentifier = "MainScreenViewCell"
    weak var delegate: ToDoViewCellProtocol?
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor(hexString: "#F4F4F4")
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "done"), for: .normal)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubviews(
            [titleLabel,
             descriptionLabel,
             dateLabel,
            ]
        )
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = .black
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with vm: TodoViewModel) {
        titleLabel.attributedText = vm.isCompleted ? strikeText(strike: vm.title) : NSMutableAttributedString(string: vm.title)
        
        self.descriptionLabel.text = vm.subtitle
        dateLabel.text = vm.createAt
        updateUI(vm.isCompleted, title: vm.title)
    }
}

private extension ToDoViewCell {
    func strikeText(strike: String) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: strike)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSMakeRange(0, attributeString.length)
        )
        
        return attributeString
    }
    
    func updateUI(_ isComplete: Bool, title: String) {
        checkButton.setImage(
            UIImage(named: isComplete ? "done" : "emptyCheck"),
            for: .normal
        )
        titleLabel.attributedText = isComplete ? strikeText(strike: title) : NSMutableAttributedString(string: title)
    }
}


// MARK: UI
private extension ToDoViewCell {
    private func setupView() {
        setupMainView()
        setupCheckButton()
        setupStackView()
    }
    
    private func setupMainView() {
        contentView.addSubview(mainView)
        
        mainView.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: 12
        ).isActive = true
        mainView.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: 16
        ).isActive = true
        mainView.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor,
            constant: -16
        ).isActive = true
        mainView.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor
        ).isActive = true
    }
    
    private func setupCheckButton() {
        mainView.addSubview(checkButton)
        checkButton.widthAnchor.constraint(
            equalToConstant: 24
        ).isActive = true
        checkButton.heightAnchor.constraint(
            equalTo: checkButton.widthAnchor
        ).isActive = true
        checkButton.leadingAnchor.constraint(
            equalTo: mainView.leadingAnchor, constant: 20
        ).isActive = true
        checkButton.topAnchor.constraint(
            equalTo: mainView.topAnchor,
            constant: 12
        ).isActive = true
        
        checkButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    private func setupStackView() {
        mainView.addSubview(stackView)
        stackView.leadingAnchor.constraint(
            equalTo: checkButton.trailingAnchor,
            constant: 24
        ).isActive = true
        stackView.topAnchor.constraint(
            equalTo: mainView.topAnchor
        ).isActive = true
        stackView.bottomAnchor.constraint(
            equalTo: mainView.bottomAnchor,
            constant: -24
        ).isActive = true
        stackView.trailingAnchor.constraint(
            equalTo: mainView.trailingAnchor,
            constant: -24
        ).isActive = true
    }
    
    @objc private func addButtonTapped() {
        delegate?.doneTapped(self)
    }
}
