//
//  FilterViewController.swift
//  COVID Tracker
//
//  Created by 赤堀雅司 on 8/6/21.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  public var completion: ((State) -> Void)?
  private var states: [State] = [] {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  private let tableView: UITableView = {
    let table = UITableView(frame: .zero, style: .grouped)
    table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    return table
  }()

    override func viewDidLoad() {
        super.viewDidLoad()
      title = "Select State"
      view.addSubview(tableView)
      tableView.delegate = self
      tableView.dataSource = self
      fetchStates()
      navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
    }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
  
  private func fetchStates() {
    APICaller.shared.getStateList{ [weak self] result in
      switch result {
      case .success(let states): self?.states = states
      case .failure(let error): print(error)
      }
    }
  }
  
  @objc func didTapClose() {
      dismiss(animated: true, completion: nil)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return states.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let state = states[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = state.name
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let state = states[indexPath.row]
    completion?(state)
    dismiss(animated: true, completion: nil)
  }
}
