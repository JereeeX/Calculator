//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Jeremy.Xu on 2016-11-05.
//  Copyright © 2016 Yi Hsu. All rights reserved.
//

import Foundation


func factorial(_ op: Double) -> Double{

    return op == 0 ? 1 : op * factorial(op - 1)
}

class CalculatorBrain{
    private var accumulator = 0.0
    
    var description = ""
    
    var isPartialResults = false
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    var operations: Dictionary<String, Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "sin": Operation.UnaryOperation(sin),
        "tan": Operation.UnaryOperation(tan),
        "x²": Operation.UnaryOperation( { $0*$0 } ),
        "x³": Operation.UnaryOperation( { $0*$0*$0 } ),
        "x!": Operation.UnaryOperation( factorial ),
        "+": Operation.BinaryOperation( { $0 + $1 } ),
        "-": Operation.BinaryOperation( { $0 - $1 } ),
        "×": Operation.BinaryOperation( { $0 * $1 } ),
        "÷": Operation.BinaryOperation( { $0 / $1 } ),
        "=": Operation.Equals,
        "c": Operation.Cancel
    ]
    
    enum Operation{
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case Cancel
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let constValue):
                accumulator = constValue
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingOperation()
            case .Cancel:
                accumulator = 0.0
                pending = nil
            }
            
        }
        
    }
    
    private func executePendingOperation() {
        if pending != nil{
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    
    
    var result: Double {
        get{
            return accumulator
        }
    }
}
