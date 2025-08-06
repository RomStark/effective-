//
//  ToDoListViewController.swift
//  effective
//
//  Created by Al Stark on 06.08.2025.
//

import UIKit

protocol TodoListViewProtocol: AnyObject {
    func displayTodos(_ viewModels: [TodoViewModel])
}

final class TodoListViewController: UIViewController {
    private let bottomBar = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
    private let countLabel = UILabel()
    private let addButton = UIButton(type: .system)
    
    private var titleLabel = UILabel()
    
    private let presenter: TodoListPresenterProtocol
    
    private var todos: [TodoViewModel] = []
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    
    init(presenter: TodoListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupTitleLabel()
        setupSearchBar()
        setupBottomBar()
        setupTableView()
        presenter.loadTodos()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.loadTodos()
    }
    
    private func setupBottomBar() {
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBar)
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.contentView.addSubview(container)
        
        countLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        countLabel.textColor = .white
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(countLabel)
        
        let image = UIImage(systemName: "square.and.pencil")
        addButton.setImage(image, for: .normal)
        addButton.tintColor = .systemYellow
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        container.addSubview(addButton)
        
        let barHeight: CGFloat = 120
        NSLayoutConstraint.activate([
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: barHeight),
            bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            container.centerXAnchor.constraint(equalTo: bottomBar.contentView.centerXAnchor),
            container.topAnchor.constraint(equalTo: bottomBar.contentView.topAnchor, constant: 20),
            container.centerYAnchor.constraint(equalTo: bottomBar.contentView.centerYAnchor),
            
            countLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            countLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            addButton.leadingAnchor.constraint(equalTo: countLabel.trailingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            addButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 28),
            addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor)
        ])
        updateCountLabel()
    }
    
    private func updateCountLabel() {
        countLabel.text = "\(todos.count) задач"
    }
    
    private func setupSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.placeholder = "Поиск задач"
        searchBar.backgroundColor = .black
        searchBar.barTintColor = .black
        searchBar.searchTextField.textColor = .white
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        
        titleLabel.text = "Лента"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 44)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor
        ).isActive = true
        titleLabel.leadingAnchor.constraint(
            equalTo: view.leadingAnchor, constant: 20
        ).isActive = true
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .black
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor)
        ])
        tableView.register(
            ToDoViewCell.self,
            forCellReuseIdentifier: ToDoViewCell.reuseIdentifier
        )
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc private func didTapAdd() {
        presenter.didTapAddNew()
    }
}

extension TodoListViewController: TodoListViewProtocol {
    func displayTodos(_ viewModels: [TodoViewModel]) {
        self.todos = viewModels
        tableView.reloadData()
        updateCountLabel()
    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBar(_ sb: UISearchBar, textDidChange text: String) {
        presenter.search(text)
    }
}

extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count
    }
    
    func tableView(_ tv: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCell(
            withIdentifier: ToDoViewCell.reuseIdentifier,
            for: indexPath
        ) as! ToDoViewCell
        let vm = todos[indexPath.row]
        cell.configure(with: vm)
        cell.delegate = self
        return cell
    }
}

extension TodoListViewController: ToDoViewCellProtocol {
    func doneTapped(_ cell: ToDoViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter.toggleCompleted(at: indexPath.row)
    }
}


extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tv: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectTodo(at: indexPath.row)
        tv.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        
        let identifier = NSIndexPath(row: indexPath.row, section: indexPath.section)
        return UIContextMenuConfiguration(
            identifier: identifier,
            previewProvider: nil
        ) { _ in
            let edit = UIAction(
                title: "Редактировать",
                image: UIImage(systemName: "pencil")
            ) { _ in
                self.presenter.didSelectTodo(at: indexPath.row)
            }
            
            let delete = UIAction(
                title: "Удалить",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { _ in
                self.presenter.deleteTodo(at: indexPath.row)
            }
            
            let share = UIAction(
                title: "Поделиться",
                image: UIImage(systemName: "square.and.arrow.up")
            ) { _ in
                let vm = self.todos[indexPath.row]
                let items: [Any] = [vm.title, vm.subtitle]
                let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self.present(ac, animated: true)
            }
            
            return UIMenu(title: "", children: [edit, delete, share])
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuInteraction interaction: UIContextMenuInteraction,
        willDisplayForMenuWith configuration: UIContextMenuConfiguration,
        animator: UIContextMenuInteractionAnimating?
    ) {
        guard
            let id = configuration.identifier as? NSIndexPath
        else { return }
        
        let index = IndexPath(row: id.row, section: id.section)
        if let cell = tableView.cellForRow(at: index) {
            cell.setHighlighted(true, animated: false)
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuInteraction interaction: UIContextMenuInteraction,
        willEndForMenuWith configuration: UIContextMenuConfiguration,
        animator: UIContextMenuInteractionAnimating?
    ) {
        guard let id = configuration.identifier as? NSIndexPath else {
            return
        }
        
        let index = IndexPath(row: id.row, section: id.section)
        if let cell = tableView.cellForRow(at: index) {
            cell.setHighlighted(false, animated: true)
        }
    }
}
