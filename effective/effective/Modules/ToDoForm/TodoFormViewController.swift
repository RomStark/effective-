//
//  TodoFormViewController.swift
//  effective
//
//  Created by Al Stark on 06.08.2025.
//

import UIKit

protocol TodoFormViewProtocol: AnyObject {
    func display(todo: TodoViewModel?)
    func showError(_ text: String)
}

final class TodoFormViewController: UIViewController {
    private let presenter: TodoFormPresenterProtocol
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.boldSystemFont(ofSize: 34)
        tv.textColor = .white
        tv.backgroundColor = .clear
        tv.isScrollEnabled = false
        tv.textContainerInset = .zero
        tv.textContainer.lineFragmentPadding = 0
        return tv
    }()
    private let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = .white
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let descriptionView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .white
        tv.backgroundColor = .clear
        tv.isScrollEnabled = false
        return tv
    }()
    
    init(presenter: TodoFormPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNavigation()
        setupLayout()
        setupTextViewDelegates()
        setupLayout()
        presenter.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent,
           let coord = transitionCoordinator,
           coord.isInteractive {
            cancelTapped()
        }
    }
}

private extension TodoFormViewController {
    func setupNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Назад", style: .plain,
            target: self, action: #selector(cancelTapped)
        )
        navigationController?.navigationBar.tintColor = .systemYellow
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
        let stack = UIStackView(arrangedSubviews: [titleView, dateLabel, descriptionView])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20)
        ])
        
        titleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
    }
}

private extension TodoFormViewController {
    @objc func cancelTapped() {
        presenter.didTapCancel()
        presenter.didTapSave(
            title: titleView.text,
            details: descriptionView.text
        )
    }
    
    private func setupTextViewDelegates() {
        titleView.delegate       = self
        descriptionView.delegate = self
    }
}

extension TodoFormViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        UIView.setAnimationsEnabled(false)
        textView.invalidateIntrinsicContentSize()
        contentView.layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
    }
}

extension TodoFormViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension TodoFormViewController: TodoFormViewProtocol {
    func display(todo: TodoViewModel?) {
        if let vm = todo {
            titleView.text = vm.title
            descriptionView.text = vm.subtitle
            
            dateLabel.text = vm.createAt
        } else {
            titleView.text = ""
            descriptionView.text = ""
        }
    }
    
    func showError(_ text: String) {
        let alert = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        alert.addAction(.init(title: "ОК", style: .default))
        present(alert, animated: true)
    }
}
