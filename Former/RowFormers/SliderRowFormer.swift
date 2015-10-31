//
//  SliderRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/31/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol SliderFormableRow: FormableRow {
        
    func formSlider() -> UISlider
    func formTitleLabel() -> UILabel?
    func formDisplayLabel() -> UILabel?
}

public final class SliderRowFormer<T: UITableViewCell where T: SliderFormableRow>
: CustomRowFormer<T>, ConfigurableForm {
    
    // MARK: Public
    
    public var value: Float = 0
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    public var displayDisabledColor: UIColor? = .lightGrayColor()
    
    required public init(instantiateType: Former.InstantiateType = .Class, cellSetup: (T -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    public override func initialized() {
        super.initialized()
        rowHeight = 88
    }
    
    deinit {
        cell.formSlider().removeTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
    }
    
    public final func onValueChanged(handler: (Float -> Void)) -> Self {
        onValueChanged = handler
        return self
    }
    
    public final func displayTextFromValue(handler: (Float -> String)) -> Self {
        displayTextFromValue = handler
        return self
    }
    
    public final func adjustedValueFromValue(handler: (Float -> Float)) -> Self {
        adjustedValueFromValue = handler
        return self
    }
    
    public override func cellInitialized(cell: T) {
        super.cellInitialized(cell)
        cell.formSlider().addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
    }
    
    public override func update() {
        super.update()
        
        cell.selectionStyle = .None
        let titleLabel = cell.formTitleLabel()
        let displayLabel = cell.formDisplayLabel()
        let slider = cell.formSlider()
        slider.value = adjustedValueFromValue?(value) ?? value
        slider.enabled = enabled
        displayLabel?.text = displayTextFromValue?(value) ?? "\(value)"
        
        if enabled {
            _ = titleColor.map { titleLabel?.textColor = $0 }
            _ = displayColor.map { displayLabel?.textColor = $0 }
            titleColor = nil
            displayColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor }
            if displayColor == nil { displayColor = displayLabel?.textColor }
            titleLabel?.textColor = titleDisabledColor
            displayLabel?.textColor = displayDisabledColor
        }
    }
    
    // MARK: Private
    
    private final var onValueChanged: (Float -> Void)?
    private final var displayTextFromValue: (Float -> String)?
    private final var adjustedValueFromValue: (Float -> Float)?
    private final var titleColor: UIColor?
    private final var displayColor: UIColor?
    
    private dynamic func valueChanged(slider: UISlider) {
        let displayLabel = cell.formDisplayLabel()
        let value = slider.value
        let adjustedValue = adjustedValueFromValue?(value) ?? value
        self.value = adjustedValue
        slider.value = adjustedValue
        displayLabel?.text = displayTextFromValue?(adjustedValue) ?? "\(adjustedValue)"
        onValueChanged?(adjustedValue)
    }
}