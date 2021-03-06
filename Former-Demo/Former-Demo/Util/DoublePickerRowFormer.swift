//
//  PickerRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/2/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

public protocol DoublePickerFormableRow: FormableRow {
    
    func formPickerView() -> UIPickerView
}

open class DoublePickerRowFormer<T: UITableViewCell, S>
: BaseRowFormer<T>, Formable where T: DoublePickerFormableRow {
    
    // MARK: Public
    
    open var pickerItems: [[PickerItem<S>]] = [[], []]
    open var selectedRow: [Int] = [0, 0]
    open var component: Int = 0

    public required init(instantiateType: Former.InstantiateType = .Class, cellSetup: ((T) -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    deinit {
        let picker = cell.formPickerView()
        picker.delegate = nil
        picker.dataSource = nil
    }
    
    @discardableResult
    public final func onValueChanged(_ handler: @escaping ((PickerItem<S>, Int) -> Void)) -> Self {
        onValueChanged = handler
        return self
    }
    
    open override func initialized() {
        super.initialized()
        rowHeight = 216
    }
    
    open override func cellInitialized(_ cell: T) {
        let picker = cell.formPickerView()
        picker.delegate = observer
        picker.dataSource = observer
    }
    
    open override func update() {
        super.update()
        
        cell.selectionStyle = .none
        let picker = cell.formPickerView()
        picker.selectRow(selectedRow[component], inComponent: component, animated: false)
        picker.isUserInteractionEnabled = enabled
        picker.layer.opacity = enabled ? 1 : 0.5
    }
    
    // MARK: Private
    
    fileprivate final var onValueChanged: ((PickerItem<S>, Int) -> Void)?
    
    private lazy var observer: Observer<T, S> = Observer<T, S>(pickerRowFormer: self)
}

private class Observer<T: UITableViewCell, S>
: NSObject, UIPickerViewDelegate, UIPickerViewDataSource where T: DoublePickerFormableRow {
    
    fileprivate weak var pickerRowFormer: DoublePickerRowFormer<T, S>?
    
    init(pickerRowFormer: DoublePickerRowFormer<T, S>) {
        self.pickerRowFormer = pickerRowFormer
    }
    
    fileprivate dynamic func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let pickerRowFormer = pickerRowFormer else { return }
        if pickerRowFormer.enabled {
            pickerRowFormer.component = component
            pickerRowFormer.selectedRow[component] = row
            let pickerItem = pickerRowFormer.pickerItems[component][row]
            pickerRowFormer.onValueChanged?(pickerItem, component)
        }
    }
    
    fileprivate dynamic func numberOfComponents(in: UIPickerView) -> Int {
        return 2
    }
    
    fileprivate dynamic func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let pickerRowFormer = pickerRowFormer else { return 0 }
        return pickerRowFormer.pickerItems[component].count
    }
    
    fileprivate dynamic func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let pickerRowFormer = pickerRowFormer else { return nil }
        return pickerRowFormer.pickerItems[component][row].title
    }
}
