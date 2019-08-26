//
//  QuestionViewController.swift
//  PatternsDemo
//
//  Created by SuShi on 2019/8/26.
//  Copyright © 2019 SuShi. All rights reserved.
//

import UIKit

public class QuestionViewController: UIViewController {

    public var questionGroup = QuestionGroup.basicPhrases()
    public var questionIndex = 0
    
    public var correctCount = 0
    public var incorrectCount = 0
    
    public var questionView: QuestionView! {
        guard isViewLoaded else { return nil }
        return (view as! QuestionView)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showQuestion()
    }
    
    private func showQuestion() {
        let question = questionGroup.questions[questionIndex]
        
        questionView.answerLabel.text = question.answer
        questionView.hintLbel.text = question.hint
        questionView.promptLabel.text = question.prompt
        
        questionView.answerLabel.isHidden = true
        questionView.hintLbel.isHidden = true
    }

    @IBAction func toggleAnswerLables(_ sender: Any) {
        questionView.answerLabel.isHidden = !questionView.answerLabel.isHidden
        questionView.hintLbel.isHidden = !questionView.hintLbel.isHidden
    }
    
    @IBAction func handleInCorrect(_ sender: Any) {
        incorrectCount += 1
        questionView.incorrectLabel.text = "\(incorrectCount)"
        showNextQuestion()
    }
    
    @IBAction func handleCorrect(_ sender: Any) {
        correctCount += 1
        questionView.correctLabel.text = "\(correctCount)"
        showNextQuestion()
    }
    
    private func showNextQuestion() {
        questionIndex += 1
        guard questionIndex < questionGroup.questions.count else {
            return
        }
        showQuestion()
    }
}

