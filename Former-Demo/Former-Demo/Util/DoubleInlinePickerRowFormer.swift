//
//  InlinePickerRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/2/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

public protocol DoubleInlinePickerFormableRow: FormableRow {
    
    func formTitleLabel() -> UILabel?
    func formDisplayLabels() -> [UILabel]?
}

open class DoubleInlinePickerRowFormer<T: UITableViewCell, S>
: BaseRowFormer<T>, Formable, ConfigurableInlineForm where T: DoubleInlinePickerFormableRow {
    
    // MARK: Public
    
    public typealias InlineCellType = DoubleFormPickerCell
    
    public let inlineRowFormer: RowFormer
    override open var canBecomeEditing: Bool {
        return enabled
    }
    
    open var pickerItems: [[InlinePickerItem<S>]] = [[], []]
    open var selectedRow: [Int] = [0, 0]
    open var component: Int = 0
    open var titleDisabledColor: UIColor? = .lightGray
    open var displayDisabledColor: UIColor? = .lightGray
    open var titleEditingColor: UIColor?
    open var displayEditingColor: UIColor?
    
    required public init(
        instantiateType: Former.InstantiateType = .Class,
        cellSetup: ((T) -> Void)?) {
            inlineRowFormer = DoublePickerRowFormer<InlineCellType, S>(instantiateType: .Class)
            super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    @discardableResult
    public final func onValueChanged(_ handler: @escaping ((InlinePickerItem<S>, Int) -> Void)) -> Self {
        onValueChanged = handler
        return self
    }
    
    open override func update() {
        super.update()
        
        let titleLabel = cell.formTitleLabel()
        let displayLabels = cell.formDisplayLabels()
        let displayLabel = displayLabels?[component]
        let pickerItem = pickerItems[component][selectedRow[component]]

        if pickerItems.isEmpty {
            displayLabel?.text = ""
        } else {
            displayLabel?.text = pickerItem.title
            _ = pickerItem.displayTitle.map { displayLabel?.attributedText = $0 }
        }
        
        if enabled {
            if isEditing {
                if titleColor == nil { titleColor = titleLabel?.textColor }
                _ = titleEditingColor.map { titleLabel?.textColor = $0 }
                
                if pickerItem.displayTitle == nil {
                    if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .black }
                    _ = displayEditingColor.map { displayLabel?.textColor = $0 }
                }
            } else {
                _ = titleColor.map { titleLabel?.textColor = $0 }
                _ = displayTextColor.map { displayLabel?.textColor = $0 }
                titleColor = nil
                displayTextColor = nil
            }
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            titleLabel?.textColor = titleDisabledColor
            if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .black }
            displayLabel?.textColor = displayDisabledColor
        }
        
        let inlineRowFormer = self.inlineRowFormer as! DoublePickerRowFormer<InlineCellType, S>
        inlineRowFormer.configure {
            $0.pickerItems = pickerItems
            $0.selectedRow = selectedRow
            $0.component = component
            $0.enabled = enabled
        }.onValueChanged(valueChanged).update()
    }

//    public override func cellSelected(indexPath: IndexPath) {
//        former?.deselect(animated: true)
//    }
    
    public func editingDidBegin() {
        if enabled {
            let titleLabel = cell.formTitleLabel()
            let displayLabels = cell.formDisplayLabels()
            let displayLabel = displayLabels?[component]
            let pickerItem = pickerItems[component][selectedRow[component]]

            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            _ = titleEditingColor.map { titleLabel?.textColor = $0 }
            
            if pickerItem.displayTitle == nil {
                if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .black }
                _ = displayEditingColor.map { displayLabel?.textColor = $0 }
            }
            isEditing = true
        }
    }
    
    public func editingDidEnd() {
        isEditing = false
        let titleLabel = cell.formTitleLabel()
        let displayLabels = cell.formDisplayLabels()
        let displayLabel = displayLabels?[component]
        let pickerItem = pickerItems[component][selectedRow[component]]

        if enabled {
            _ = titleColor.map { titleLabel?.textColor = $0 }
            titleColor = nil
            
            if pickerItem.displayTitle == nil {
                _ = displayTextColor.map { displayLabel?.textColor = $0 }
            }
            displayTextColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .black }
            titleLabel?.textColor = titleDisabledColor
            displayLabel?.textColor = displayDisabledColor
        }
    }
    
    // MARK: Private
    
    private final var onValueChanged: ((InlinePickerItem<S>, Int) -> Void)?
    private final var titleColor: UIColor?
    private final var displayTextColor: UIColor?
    
    private func valueChanged(pickerItem: PickerItem<S>, component: Int) {
        if enabled {
            let inlineRowFormer = self.inlineRowFormer as! DoublePickerRowFormer<InlineCellType, S>

            let inlinePickerItem = pickerItem as! InlinePickerItem
            let displayLabels = cell.formDisplayLabels()
            let displayLabel = displayLabels?[component]
            
            selectedRow = inlineRowFormer.selectedRow
            displayLabel?.text = inlinePickerItem.title
            if let displayTitle = inlinePickerItem.displayTitle {
                displayLabel?.attributedText = displayTitle
            } else {
                if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .black }
                _ = displayEditingColor.map { displayLabel?.textColor = $0 }
            }
            onValueChanged?(inlinePickerItem, component)
        }
    }
}
