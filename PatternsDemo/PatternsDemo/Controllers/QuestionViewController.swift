//
//  QuestionViewController.swift
//  PatternsDemo
//
//  Created by SuShi on 2019/8/26.
//  Copyright © 2019 SuShi. All rights reserved.
//

import UIKit

public protocol QuestionViewControllerDelegate: class {
    
    func questionViewController(_ viewController: QuestionViewController, didCancel questionStrategy: QuestionStrategy, at questionIndex: Int)
 
    func questionViewController(_ viewController: QuestionViewController, didComplete questionStrategy: QuestionStrategy)
}

public class QuestionViewController: UIViewController {

    public var questionIndex = 0
    public var correctCount = 0
    public var incorrectCount = 0
    
    public weak var delegate: QuestionViewControllerDelegate?
    
    public var questionStrategy: QuestionStrategy! {
        didSet {
            navigationItem.title = questionStrategy.title
        }
    }
    
    public var questionView: QuestionView! {
        guard isViewLoaded else { return nil }
        return (view as! QuestionView)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCancelButton()
        showQuestion()
    }
    
    private func setupCancelButton() {
        let action = #selector(handleCancelPressed(sender:))
        let item = UIBarButtonItem(image: UIImage(named: "ic_menu"), style: .plain, target: self, action: action)
        navigationItem.leftBarButtonItem = item
    }
    
    @objc private func handleCancelPressed(sender: UIBarButtonItem) {
        delegate?.questionViewController(self, didCancel: questionStrategy, at: questionIndex)
    }
    
    private func showQuestion() {
        let question = questionStrategy.currentQuestion()
        
        questionView.answerLabel.text = question.answer
        questionView.hintLbel.text = question.hint
        questionView.promptLabel.text = question.prompt
        
        questionView.answerLabel.isHidden = true
        questionView.hintLbel.isHidden = true
        
        questionIndexItem.title = questionStrategy.questionIndexTitle()
    }

    @IBAction func toggleAnswerLables(_ sender: Any) {
        questionView.answerLabel.isHidden = !questionView.answerLabel.isHidden
        questionView.hintLbel.isHidden = !questionView.hintLbel.isHidden
    }
    
    @IBAction func handleInCorrect(_ sender: Any) {
        let question = questionStrategy.currentQuestion()
        questionStrategy.markQuestionIncorrect(question)
        questionView.incorrectLabel.text = String(questionStrategy.incorrectCount)
        showNextQuestion()
    }
    
    @IBAction func handleCorrect(_ sender: Any) {
        let question = questionStrategy.currentQuestion()
        questionStrategy.markQuestionCorrect(question)
        questionView.correctLabel.text = String(questionStrategy.correctCount)
        showNextQuestion()
    }
    
    private func showNextQuestion() {
        guard questionStrategy.advanceToNextQuestion() else {
            delegate?.questionViewController(self, didComplete: questionStrategy)
            return
        }
        showQuestion()
    }
    
    private lazy var questionIndexItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        item.tintColor = .black
        navigationItem.rightBarButtonItem = item
        return item
    }()
}

