//
//  NoResultsViewController.swift
//  UIKitExample
//
//  Created by yono on 2018/06/23.
//

import UIKit

class NoResultsViewController: UIViewController {
    
    @IBOutlet var noResultsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var titles: [String] = [
        "foo",
        "bar",
        "baz"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = noResultsView
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didTapDeleteButton(_ sender: UIBarButtonItem) {
        titles.removeAll()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension NoResultsViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension NoResultsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView?.isHidden = titles.count > 0
        
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoResultsCell", for: indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
}
