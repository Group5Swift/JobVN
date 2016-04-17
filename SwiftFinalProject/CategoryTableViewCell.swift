//
//  CategoryTableViewCell.swift
//  SwiftFinalProject
//
//  Created by Dam Vu Duy on 4/10/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import UIKit

enum CheckCellState {
    case Uncheck
    case Checked
    case Collapsed
}

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var indicateLabel: UIImageView!
    
    var cellMode: CheckCellState = .Collapsed {
        didSet {
            switch cellMode {
                case .Uncheck:
                    indicateLabel.image = UIImage(named: "uncheck")
                    break
                case .Checked:
                    indicateLabel.image = UIImage(named: "checked")
                    break
                case .Collapsed:
                    indicateLabel.image = UIImage(named: "expand")
                    break
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
