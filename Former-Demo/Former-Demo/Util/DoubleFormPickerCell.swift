//
//  FormPickerCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/2/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

open class DoubleFormPickerCell: UITableViewCell, FormableRow, DoublePickerFormableRow {
    
    // MARK: Public
    
    public private(set) weak var pickerView: UIPickerView!
    
    public func formPickerView() -> UIPickerView {
        return pickerView
    }
    
    // MARK: Public
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    open func updateWithRowFormer(_ rowFormer: RowFormer) {}
    
    open func setup() {
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textLabel?.backgroundColor = .clear
        
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(pickerView, at: 0)
        self.pickerView = pickerView
        
        let constraints = [
          NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-15-[picker]-15-|",
                options: [],
                metrics: nil,
                views: ["picker": pickerView]
            ),
          NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[picker]-0-|",
                options: [],
                metrics: nil,
                views: ["picker": pickerView]
            )
            ].flatMap { $0 }
        contentView.addConstraints(constraints)
    }
}
