//
//  ScrollTabMenuView.swift
//  UIKitExample
//
//  Created by yono on 2018/06/16.
//

import UIKit

protocol ScrollTabMenuViewDelegate {
    func didTapTabMenu(selectedIndex: Int)
}

class ScrollTabMenuView : UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var delegate: ScrollTabMenuViewDelegate?

    var menuItems: [String] = [] {
        didSet {
            render()
        }
    }

    let tabWidth: CGFloat = 100
    var selectedIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }

    private func loadNib() {
        let view = Bundle.main.loadNibNamed("ScrollTabMenu", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    private func render() {
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }

        var originX: CGFloat = 0
        
        for (index, menuItem) in menuItems.enumerated() {
            let button = UIButton()
            button.frame = CGRect(x: originX, y: 0, width: tabWidth, height: scrollView.frame.height)
            button.setTitle(menuItem, for: .normal)
            button.setTitleColor(UIColor.red, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(self.didTapTabMenu(sender:)), for: .touchUpInside)
            
            scrollView.addSubview(button)
            originX += tabWidth
        }
        
        scrollView.contentSize = CGSize(width: originX, height: scrollView.frame.height)
    }
    
    @objc func didTapTabMenu(sender: UIButton) {
        delegate?.didTapTabMenu(selectedIndex: sender.tag)
    }
}
