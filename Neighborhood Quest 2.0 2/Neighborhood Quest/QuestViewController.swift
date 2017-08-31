//
//  QuestViewController.swift
//  Neighborhood Quest
//
//  Created by Kyle Kimery on 11/18/16.
//  Copyright © 2016 Kenneth James. All rights reserved.
//

import UIKit
import CoreData


class QuestViewController: UIViewController, UITextFieldDelegate {
    
    var statsArray = [NSManagedObject]()
    
    
    //the timer object is created here
    var timer = NSTimer()
    var timer2 = NSTimer()
    
    @IBOutlet weak var timerButton: ExpButtonView!
    
    @IBOutlet weak var buttonA: PushButtonView!
    @IBOutlet weak var buttonB: PushButtonView!
    @IBOutlet weak var buttonC: PushButtonView!
    
    //a connection to a text view that displays the quiz question, prompts, etc
    //@IBOutlet weak var questTextView: UITextView!
    @IBOutlet weak var questTextView: UITextView!
    
    @IBOutlet weak var displayedTimer: UILabel!
    
    //the text originally displayed in the textview, this can be done differently...
    var text = "Your Quiz has begun!\nYou will have 30 seconds to answer your question.\n\n"
    
    var timeBase = 30.0
    var currentTime = 30.00 - 0.1
    var isCorrect = false
    var isFailed = false
    var correctAnswerIndex = -1
    var isAnswered = false
    
    
    
    //This is an action tied to a "start" type button, this must be connected to the GUI!!!!!!
    @IBAction func beginQuest(sender: AnyObject) {
        questTextView.text = text
        getNewQuestion()
        timer = NSTimer.scheduledTimerWithTimeInterval(timeBase, target: self, selector:#selector(QuestViewController.outOfTime), userInfo: nil, repeats: false)
        timer2 = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector:#selector(QuestViewController.updateTime), userInfo: nil, repeats: true)
        let range = NSMakeRange(questTextView.text.characters.count - 1, 0)
        questTextView.scrollRangeToVisible(range)
    }
    
    
    
    //This is the function called every 1 second by timer2, it updates the displayed time remaining
    func updateTime() {
        if !isFailed {
            currentTime = currentTime - 0.1
            if currentTime <= 0.0 {
                displayedTimer.text = "0.0"
            }else {
                displayedTimer.text = String(Double(round(1000*currentTime)/1000))
            }
            timerButton.timeGone = currentTime
            timerButton.type = "timer"
            timerButton.setNeedsDisplay()
        }else{
            timer2.invalidate()
        }
        
    }
    
    
    //This function is called by timer if the question isn't answered successfully by the time limit
    func outOfTime() {
        if !isAnswered {
            questTextView.text = "Out of time! Question failed!!"
            let range = NSMakeRange(questTextView.text.characters.count - 1, 0)
            questTextView.scrollRangeToVisible(range)
            isFailed = true
            isAnswered = true
            updateButtonColors()
        }
    }
    
    
    
    
    
    //This is the function called by the start button, which generates random questions...
    
    /*
     This function is in it's most basic form right now. It only creates math questions. It can be expanded upon later to create
     questions for other categories, but that is rather time consuming, but not particularly difficult programming-wise.
     For at least alpha, this function should probaly remain math-only.
     */
    
    func getNewQuestion() {
        
        statsArray[0].setValue(String(Int(statsArray[0].valueForKey("numQuizzes") as! String)! + 1), forKey: "numQuizzes")
        
        do {
            try statsArray[0].managedObjectContext?.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
        

        
        //the category of the questions is a randomly generated integer
        let questionCategory = Int(arc4random_uniform(0))+1
        
        //the question and answer are stored in an array, the 0th position is the question and the 1st is the answer, the other 2 indexes are dummy answers
        var question = []
        
        
        if questionCategory == 1{       //Math category
            
            questTextView.text = questTextView.text + "Your randomly assigned topic is: Math!"
            question = createMathQuestion()
            askQuestion(question[0] as! String)
            generateAnswerChoices(question as! Array<String>)
            
        } else if questionCategory == 2{
            questTextView.text = questTextView.text + "Your randomly assigned topic is: Language!"
            
        }else if questionCategory == 3 {
            questTextView.text = questTextView.text + "Your randomly assigned topic is: Sports!"
            
        }else {
            questTextView.text = questTextView.text + "Your randomly assigned topic is: Botany!"
        }
    }
    
    
    func askQuestion(question: String) {
        questTextView.text = questTextView.text + "\nYour question is: " + question
        
    }
    
    
    //This function randomly assigns the answer and the fake answers to either A, B, or C
    func generateAnswerChoices(answers: Array<String>){
        correctAnswerIndex = Int(arc4random_uniform(3))
        var answerChoices = ["A","B","C"]
        var dummy1Index = correctAnswerIndex
        while dummy1Index == correctAnswerIndex {
            dummy1Index = Int(arc4random_uniform(3))
        }
        var dummy2Index = dummy1Index
        while dummy2Index == dummy1Index || dummy2Index == correctAnswerIndex {
            dummy2Index = Int(arc4random_uniform(3))
        }
        answerChoices[correctAnswerIndex] = answers[1]
        answerChoices[dummy1Index] = answers[2]
        answerChoices[dummy2Index] = answers[3]
        
        questTextView.text = questTextView.text + "\nChoice A: " + answerChoices[0] + "\nChoice B: " + answerChoices[1] + "\nChoice C: " + answerChoices[2]
        
    }
    
    
    //This function determines whether or not the button pressed corresponds to the correct answer
    func checkAnswer(answerChoice: Int){
        timer.invalidate()
        timer2.invalidate()
        if isAnswered {
            questTextView.text = questTextView.text + "\nYou have already answered."
        }else if answerChoice == correctAnswerIndex {
            isAnswered = true
            questTextView.text = questTextView.text + "\nCorrect!"
            success()
            
        }else {
            isAnswered = true
            isFailed = true
            questTextView.text = questTextView.text + "\nIncorrect!"
        }
        let range = NSMakeRange(questTextView.text.characters.count - 1, 0)
        questTextView.scrollRangeToVisible(range)
        updateButtonColors()
    }
    
    func updateButtonColors(){
        
        if correctAnswerIndex == 0{
            buttonA.colorInt = 2
            buttonA.setNeedsDisplay()
            buttonB.colorInt = 1
            buttonB.setNeedsDisplay()
            buttonC.colorInt = 1
            buttonC.setNeedsDisplay()
        }else if correctAnswerIndex == 1{
            buttonA.colorInt = 1
            buttonA.setNeedsDisplay()
            buttonB.colorInt = 2
            buttonB.setNeedsDisplay()
            buttonC.colorInt = 1
            buttonC.setNeedsDisplay()
        }else {
            buttonA.colorInt = 1
            buttonA.setNeedsDisplay()
            buttonB.colorInt = 1
            buttonB.setNeedsDisplay()
            buttonC.colorInt = 2
            buttonC.setNeedsDisplay()
        }
        statsArray[0].setValue(String((Double(statsArray[0].valueForKey("totalTime") as! String)! + 30.0 - currentTime)), forKey: "totalTime")

        statsArray[0].setValue(String((Double(statsArray[0].valueForKey("totalTime") as! String)!)/Double(statsArray[0].valueForKey("numQuizzes") as! String)!), forKey: "averageTime")

    }
    
    
    
    
    
    //This function generates a random math problem for the user to solve, along with the answer and 2 dummy/fake answer choices
    func createMathQuestion() -> Array<String> {
        
        let firstNum = Int(arc4random_uniform(1000))
        let secondNum = Int(arc4random_uniform(1000))
        let operationNum = Int(arc4random_uniform(4))
        var operationList = ["+", "-", "*", "/"]
        let operation = operationList[operationNum]
        
        let question = String(firstNum) + " " + String(operation) + " " + String(secondNum)
        
        var answer = "0"
        
        if operation == "+"{
            answer = String(Double(firstNum + secondNum))
        } else if operation == "-"{
            answer = String(Double(firstNum - secondNum))
        }else if operation == "*" {
            answer = String(Double(firstNum * secondNum))
        }else{
            let tempX = Double(firstNum) / Double(secondNum)
            let xX = Double(floor(1000*tempX)/1000)
            answer = String(xX)
        }
        
        var dummyAnswer1 = "0"
        var dummyAnswer2 = "0"
        
        if operation != "/" {
            dummyAnswer1 = String(Double(answer)! + Double(arc4random_uniform(70)) - 35)
            dummyAnswer2 = String(Double(answer)! + Double(arc4random_uniform(70)) - 35)
        }else {
            dummyAnswer1 = String(Double(answer)! + Double(arc4random_uniform(10)) - 5)
            dummyAnswer2 = String(Double(answer)! + Double(arc4random_uniform(10)) - 5)
        }
        
        while dummyAnswer1 == answer || dummyAnswer2 == answer {
            dummyAnswer1 = String(Double(answer)! + Double(arc4random_uniform(70)) - 35)
            dummyAnswer2 = String(Double(answer)! + Double(arc4random_uniform(70)) - 35)
        }
        
        return [question,answer,dummyAnswer1,dummyAnswer2]
    }
    
    @IBAction func selectedChoiceA(sender: AnyObject) {
        checkAnswer(0)
        //buttonA.colorInt = 1
        //buttonA.setNeedsDisplay()
    }
    
    @IBAction func selectedChoiceB(sender: AnyObject) {
        checkAnswer(1)
    }
    
    @IBAction func selectedChoiceC(sender: AnyObject) {
        checkAnswer(2)
    }
    
    
    func success() {
        //Here is where core data comes in to level up the player and/or give them items
        
      

        let expRequired = 50 * Int(statsArray[0].valueForKey("level") as! String)!
        var exp = Int(statsArray[0].valueForKey("experience") as! String)! + 25
        questTextView.text = questTextView.text + "\nYou gained 25 experience points!"
        var level = Int(statsArray[0].valueForKey("level") as! String)!
        statsArray[0].setValue(String(Int(statsArray[0].valueForKey("numCorrect") as! String)! + 1), forKey: "numCorrect")
        
        //Check if the player leveled up here
        if exp >= expRequired {
            level = level + 1
            exp = exp - expRequired
            questTextView.text = questTextView.text + "\nLevel Up!!\nYou are now level " + String(level)
            statsArray[0].setValue(String(level), forKey: "level")
        }
        
        statsArray[0].setValue(String(exp), forKey: "experience")

        //save the new level/experience to core data
        do {
            try statsArray[0].managedObjectContext?.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
        
    }
    
    func createData() {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Stats",
                                                        inManagedObjectContext:managedContext)
        
        let person = NSManagedObject(entity: entity!,
                                     insertIntoManagedObjectContext: managedContext)
        
        person.setValue("1", forKey: "level")
        person.setValue("0", forKey: "experience")
        person.setValue("0", forKey: "numQuizzes")
        person.setValue("0", forKey: "numCorrect")
        person.setValue("0", forKey: "averageTime")
        person.setValue("0", forKey: "totalTime")
        
        do {
            try managedContext.save()
            statsArray.append(person)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
    
    
    
    func fetchData() {
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Stats")
        
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            statsArray = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        if statsArray.count == 0{
            createData()
        }
        
        
        let range = NSMakeRange(questTextView.text.characters.count - 1, 0)
        questTextView.scrollRangeToVisible(range)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
}
