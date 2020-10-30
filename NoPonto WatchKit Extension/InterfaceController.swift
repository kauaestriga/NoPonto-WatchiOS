//
//  InterfaceController.swift
//  NoPonto WatchKit Extension
//
//  Created by Usuário Convidado on 29/10/20.
//  Copyright © 2020 Kauã Estriga. All rights reserved.
//

import WatchKit

class InterfaceController: WKInterfaceController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var timer: WKInterfaceTimer!
    @IBOutlet weak var buttonTimer: WKInterfaceButton!
    @IBOutlet weak var labelWeight: WKInterfaceLabel!
    @IBOutlet weak var groupText: WKInterfaceGroup!
    @IBOutlet weak var groupImage: WKInterfaceGroup!
    @IBOutlet weak var labelCook: WKInterfaceLabel!
    @IBOutlet weak var sliderCook: WKInterfaceSlider!
    @IBOutlet weak var labelTemperture: WKInterfaceLabel!
    @IBOutlet weak var pickerWeight: WKInterfacePicker!
    @IBOutlet weak var pickerTemperture: WKInterfacePicker!
    
    // MARK - Properties
    var kg: Double = 0.1
    var meatTemperature = MeatTemperature.rare
    var increment = 0.1
    var timerRunning = false
    var maxKg: Double = 2.0
    
    // MARK: - Super Methods
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        groupImage.setHidden(true)
        setupPickers()
        updateConfiguration()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: Methods
    func setupPickers() {
        //Picker de quantidade
        var weihtItems: [WKPickerItem] = []
        for weight in stride(from: 0.1, through: maxKg, by: increment) {
            let item = WKPickerItem()
            item.title = String(format: "%.1f", weight)
            weihtItems.append(item)
        }
        pickerWeight.setItems(weihtItems)
        pickerWeight.setSelectedItemIndex(0)
        
        //Picker de temperatura
        var temperatureItems: [WKPickerItem] = []
        for imageIndex in 1...4 {
            let item = WKPickerItem()
            item.contentImage = WKImage(imageName: "temp-\(imageIndex)")
            temperatureItems.append(item)
        }
        pickerTemperture.setItems(temperatureItems)
        
    }
    
    func updateConfiguration() {
        labelTemperture.setText(meatTemperature.stringValue)
        labelCook.setText(meatTemperature.stringValue)
        pickerTemperture.setSelectedItemIndex(meatTemperature.rawValue)
        labelWeight.setText("Total: \(String(format: "%.1f", kg)) kg")
        let index = Int(kg * 10 - 1)
        pickerWeight.setSelectedItemIndex(index)
        sliderCook.setValue(Float(meatTemperature.rawValue))
    }
    
    // MARK: - IBActions
    @IBAction func minus() {
        if kg > 0.1 {
            kg -= increment
            updateConfiguration()
        }
    }
    
    @IBAction func plus() {
        if kg < maxKg {
            kg += increment
            updateConfiguration()
        }
    }
    
    @IBAction func toggleTimer() {
        if timerRunning {
            timer.stop()
            buttonTimer.setTitle("Iniciar Timer")
        } else {
            let time = meatTemperature.cookTimeForKg(kg)
            timer.setDate(Date(timeIntervalSinceNow: time))
            timer.start()
            buttonTimer.setTitle("Parar Timer")
        }
        timerRunning.toggle()
    }
    
    @IBAction func onSliderChange(_ value: Float) {
        if let newMeatTemperature = MeatTemperature(rawValue: Int(value)) {
            meatTemperature = newMeatTemperature
            updateConfiguration()
        }
    }
    
    @IBAction func onWeightPickerChange(_ value: Int) {
        kg = Double(value + 1) * increment
        updateConfiguration()
    }
    
    @IBAction func onTemperaturePickerChange(_ value: Int) {
        if let newMeatTemperature = MeatTemperature(rawValue: Int(value)) {
            meatTemperature = newMeatTemperature
            updateConfiguration()
        }
    }
    
    @IBAction func onModeChange(_ value: Bool) {
        groupImage.setHidden(!value)
        groupText.setHidden(value)
    }
    
}
