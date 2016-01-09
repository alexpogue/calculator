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
        opHistory.text = ""
    }

    @IBAction func backspace() {
        if userIsInTheMiddleOfTypingANumber {
            let displayChars = display.text!.characters
            display.text = String(displayChars.dropLast())
            if displayChars.count <= 1 {
                display.text = "0"
                userIsInTheMiddleOfTypingANumber = false
            }
        }
    }

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        let userHasTypedADecimalPoint = userIsInTheMiddleOfTypingANumber && display.text!.containsString(".")
        let userJustTypedALeadingZero = userIsInTheMiddleOfTypingANumber && display.text! == "0"
        if digit == "." && userHasTypedADecimalPoint || digit == "0" && userJustTypedALeadingZero {
            return
        }
        removeEqualsFromHistory()
        if userIsInTheMiddleOfTypingANumber && display.text! != "0" {
            display.text = display.text! + digit
        } else {
            display.text = (digit == ".") ? ("0.") : (digit)
            userIsInTheMiddleOfTypingANumber = true
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
            // in case user presses two operators in a row
            removeEqualsFromHistory()
            appendHistory("=")
        }
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
        opHistory.text = opHistory.text! + " " + thingToAppend
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