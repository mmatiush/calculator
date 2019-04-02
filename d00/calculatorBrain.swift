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
    private var accumulator: Int?

    
    private enum Operation {
        case constant(Int)
        case unaryOperation((Int) -> Int)
        case binaryOperation((Int,Int) -> Int)
//        case binaryOperationWithOverflow((Int) -> (Int, Bool))
        case equals()
    }

    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Int,Int) -> Int
//        let functionWithOverflow: (Int) -> (Int,Bool)
        let firstOperand: Int
        var divisionByZeroWarning: Bool
        
        func perform(with secondOperand: Int) -> Int {
            return function(firstOperand, secondOperand)
        }
//        func performOperationWithOverflow(with secondOperand: Int) -> (value: Int, overflow: Bool) {
//            return self.function(secondOperand)
//        }

    }
    
    private var operations: Dictionary<String,Operation> = [
//        "π"     : Operation.constant(Double.pi),
//        "e"     : Operation.constant(M_E),
//        "√"     : Operation.unaryOperation(sqrt),
//        "cos"   : Operation.unaryOperation(cos),
        "AC"    : Operation.constant(0),
        "±"     : Operation.unaryOperation({ -$0 }),
        "×"     : Operation.binaryOperation( * ),
        "÷"     : Operation.binaryOperation( / ),
        "-"     : Operation.binaryOperation( - ),
        "+"     : Operation.binaryOperation( + ),
//        "++"     : Operation.binaryOperation1(addingReportingOverflow),
        "="     : Operation.equals(),
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
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!, divisionByZeroWarning: symbol == "÷")
                    accumulator = nil
                }
//            case .binaryOperationWithOverflow(let function):
//                if accumulator != nil {
//                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!, divisionByZeroWarning: symbol == "÷")
//                    accumulator = nil
//                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            if pendingBinaryOperation!.divisionByZeroWarning && accumulator == 0 {
                print("Zero division")
            } else {
                accumulator =  pendingBinaryOperation!.perform(with: accumulator!)
            }
            pendingBinaryOperation = nil
        }
    }
    
    // We want the method to mutate the propery, therefore we use the keyword mutating
    mutating func setOperand(_ operand: Int) {
         accumulator = operand
    }
    
    var result: Int?  {
        get {
            return accumulator
        }
    }
}


