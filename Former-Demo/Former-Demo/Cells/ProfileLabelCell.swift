//
//  ProfileLabelCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 10/31/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

final class ProfileLabelCell: UITableViewCell, InlineDatePickerFormableRow, DoubleInlinePickerFormableRow {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var displayLeftLabel: UILabel!
    @IBOutlet weak var displayRightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = .formerColor()
        displayLeftLabel.textColor = .formerSubColor()
        displayRightLabel.textColor = .formerSubColor()
    }
    
    func formTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    func formDisplayLabel() -> UILabel? {
        return displayLeftLabel
    }

    func formDisplayLabels() -> [UILabel]? {
        return [displayLeftLabel, displayRightLabel]
    }

    func updateWithRowFormer(_ rowFormer: RowFormer) {}
}
