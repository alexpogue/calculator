import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var opHistory: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var brain = CalculatorBrain()

    @IBAction func clear() {
        brain = CalculatorBrain()
        userIsInTheMiddleOfTypingANumber = false
        display.text = "0"
        opHistory.text = nil
    }

    @IBAction func appendDigit(sender: UIButton){
        let digit = sender.currentTitle!
        if digit != "." || !userIsInTheMiddleOfTypingANumber || display.text!.rangeOfString(".") == nil {
            if userIsInTheMiddleOfTypingANumber {
                display.text = display.text! + digit
            } else {
                display.text = (digit == ".") ? ("0.") : (digit)
                userIsInTheMiddleOfTypingANumber = true
            }
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            appendHistory(operation)
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        appendHistory(display.text!)
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0 // should be something else, error message?
        }
    }
    
    func appendHistory(thingToAppend: String) {
        if let history = opHistory.text {
            opHistory.text = history + " " + thingToAppend
        } else {
            opHistory.text = thingToAppend
        }
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}