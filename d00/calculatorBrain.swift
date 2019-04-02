//
//  calculatorBrain.swift
//  d00
//
//  Created by Maksym MATIUSHCHENKO on 4/1/19.
//  Copyright © 2019 Maksym MATIUSHCHENKO. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    // Private var can be accessed only from the struct
    private var accumulator: Double?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals()
    }

    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    private var operations: Dictionary<String,Operation > = [
        "π"     : Operation.constant(Double.pi),
        "e"     : Operation.constant(M_E),
        "√"     : Operation.unaryOperation(sqrt),
        "cos"   : Operation.unaryOperation(cos),
        "±"     : Operation.unaryOperation({ -$0 }),
        "×"     : Operation.binaryOperation( * ),
        "÷"     : Operation.binaryOperation( / ),
        "+"     : Operation.binaryOperation( + ),
        "-"     : Operation.binaryOperation( - ),
        "="     : Operation.equals()
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil{
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator =  pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    // We want the method to mutate the propery, therefore we use the keyword mutating
    mutating func setOperand(_ operand: Double) {
         accumulator = operand
    }
    
    var result: Double?  {
        get {
            return accumulator
        }
    }
    
}

