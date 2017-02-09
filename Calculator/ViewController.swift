//
//  ViewController.swift
//  Calculator
//
//  Created by Jeremy.Xu on 2016-11-05.
//  Copyright © 2016 Yi Hsu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak private var display: UILabel!
    
    @IBOutlet weak private var descriptionOfOperation: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    
    @IBOutlet weak var dotButton: UIButton!
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        //Prevent 
        if digit == "." {
            dotButton.isEnabled = false
        }
        if userIsInTheMiddleOfTyping && display.text! != "0"{
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit

        }
        else {
            display.text = digit
        }
        
        userIsInTheMiddleOfTyping = true
        
    }
    
    private var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping{
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
            dotButton.isEnabled = true
        }
        if let mathmaticalSymbol = sender.currentTitle{
            brain.performOperation(symbol: mathmaticalSymbol)
        }
        displayValue = brain.result
    }
    
}
