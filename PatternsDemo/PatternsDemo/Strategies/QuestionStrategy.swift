//
//  QuestionStrategy.swift
//  PatternsDemo
//
//  Created by SuShi on 2019/8/27.
//  Copyright © 2019 SuShi. All rights reserved.
//

public protocol QuestionStrategy: class {
    
    var title: String { get }
    var correctCount: Int { get }
    var incorrectCount: Int { get }
    
    func advanceToNextQuestion() -> Bool
    func currentQuestion() -> Question
    
    func markQuestionCorrect(_ question: Question)
    func markQuestionIncorrect(_ question: Question)
    
    func questionIndexTitle() -> String
}
