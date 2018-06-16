//
//  ScrollTabMenuViewController.swift
//  UIKitExample
//
//  Created by yono on 2018/06/16.
//

import UIKit

class ScrollTabMenuViewController: UIViewController {

    @IBOutlet weak var scrollTabMenuView: ScrollTabMenuView!
    @IBOutlet weak var selectedIndex: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollTabMenuView.delegate = self

        scrollTabMenuView.menuItems = ["foo", "bar", "foobar", "baz", "barbaz"]
    }
}

extension ScrollTabMenuViewController : ScrollTabMenuViewDelegate {
    
    func didTapTabMenu(selectedIndex: Int) {
        self.selectedIndex.text = String(selectedIndex)
    }
}
