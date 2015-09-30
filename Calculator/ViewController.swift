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

    @IBAction func backspace() {
        if userIsInTheMiddleOfTypingANumber {
            let displayChars = display.text!.characters
            if displayChars.count > 1 {
                display.text = String(displayChars.dropLast())
            } else {
                display.text = "0"
                userIsInTheMiddleOfTypingANumber = false
            }
        }
    }

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        removeEqualsFromHistory()
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
        appendHistory("=")
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        removeEqualsFromHistory()
        appendHistory(display.text!)
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0 // should be something else, error message?
        }
    }

    func removeEqualsFromHistory() {
        opHistory.text = opHistory.text!.stringByReplacingOccurrencesOfString(" =", withString: "")
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