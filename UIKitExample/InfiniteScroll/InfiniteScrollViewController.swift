//
//  InfiniteScrollViewController.swift
//  UIKitExample
//
//  Created by yono on 2017/12/09.
//

import UIKit

class InfiniteScrollViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Property
    
    private let refreshControl = UIRefreshControl()

    private var items = [String]()
    private var isLoading = false
    private var currentPage: Int = 1
    private let firstPage = 1
    private let lastPage = 100

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()

        fetch(firstPage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let tableViewHeight = tableView.contentSize.height
        let offsetY = scrollView.contentOffset.y
        let frameHeight = scrollView.frame.height
        
//        print("tableViewHeight " + String(describing: tableViewHeight))
//        print("offsetY " + String(describing: ))
//        print("frameHeight " + String(describing: frameHeight))

        if offsetY + frameHeight >= tableViewHeight {
            fetch(currentPage + 1)
        }
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        items.removeAll()
        fetch(firstPage)
    }

    // MARK: - PrivateMethod
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl.addTarget(self, action: #selector(InfiniteScrollViewController.refresh(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func fetch(_ page: Int) {
        if isLoading { return }
        isLoading = true
        
        if page > lastPage {
            isLoading = false
            return
        }

        let url = URL(string: "https://qiita.com/api/v2/items?page=\(page)")
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { data, _, error -> Void in
            DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
            self.isLoading = false

            // on error
            if let error = error {
                self.presentAlert(title: "通信エラー", message: error.localizedDescription)
                return
            }

            // on success
            guard let data = data else { return }

            do {
                let decodedJsonObject = try JSONSerialization.jsonObject(with: data, options: [])

                // ok
                if let items = decodedJsonObject as? [[String:Any]] {
                    for item in items {
                        let title = item["title"] as! String
                        self.items.append(title)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                    self.currentPage = page + 1
                }
                // error response received
                else if let errorResponse = decodedJsonObject as? [String:String],
                    let errorMessage = errorResponse["message"] {
                    self.presentAlert(title: "エラー", message: errorMessage)
                }
                // json parse error
                else {
                    self.presentAlert(title: "エラー", message: "Could not parse received data")
                }
            }
            catch let e {
                self.presentAlert(title: "エラー", message: e.localizedDescription)
            }
        }
        task.resume()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension InfiniteScrollViewController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as? MyTableViewCell,
            indexPath.row < items.count else {
            return UITableViewCell()
        }
        
        cell.title.text = items[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate

extension InfiniteScrollViewController : UITableViewDelegate {}
