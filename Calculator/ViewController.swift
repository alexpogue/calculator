import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var userHasTypedDecimalPoint = false;
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton){
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }

    @IBAction func addDecimalPoint() {
        if userHasTypedDecimalPoint {
            return
        }
        if !userIsInTheMiddleOfTypingANumber {
            display.text = "0"
            userIsInTheMiddleOfTypingANumber = true
        }
        display.text = display.text! + "."
        userHasTypedDecimalPoint = true
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    func multiply(op1: Double, op2: Double) -> Double {
        return op1 * op2
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        userHasTypedDecimalPoint = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0 // should be something else, error message?
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