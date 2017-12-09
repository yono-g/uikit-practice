//
//  MyTableViewCell.swift
//  UIKitExample
//
//  Created by yono on 2017/12/09.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    // MARK: - IBOutlet

    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
