//
//  ViewController.swift
//  TaskList
//
//  Created by Виктория Страдзина on 02.04.2023.
//

import UIKit
import CoreData

class TaskListViewController: UITableViewController {
    
    private let cellID = "task"
    private var taskList: [Task] = []
    
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
        fetchData()
    }
    
    private func addNewTask() {
        showAlert(withTitle: "New task", andMessage: "What do you want to do?")
    }
    
    private func fetchData() {
        let fetchRequest = Task.fetchRequest()
        
        do {
            taskList = try viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
    }
    private func showAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save Task", style: .default) { [weak self]_ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            self?.save(task)
        }
        let cancleAction = UIAlertAction(title: "Cancle", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancleAction)
        alert.addTextField { textField in
            textField.placeholder = "New Task"
        }
        present(alert, animated: true)
    }
    
    private func save (_ taskName: String) {
        let task = Task(context: viewContext)
        task.title = taskName
        taskList.append(task)
        
        let indexPath = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - Setup UI
private extension TaskListViewController {
    func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearense = UINavigationBarAppearance()
        navBarAppearense.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearense.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearense.backgroundColor = UIColor(named: "MilkBlue")
        
        navigationController?.navigationBar.standardAppearance = navBarAppearense
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearense
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: UIAction{ [unowned self] _ in
            addNewTask()
        }
        )
        navigationController?.navigationBar.tintColor = .white
    }
}

// MARK: - UITableViewDataSource
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
}
