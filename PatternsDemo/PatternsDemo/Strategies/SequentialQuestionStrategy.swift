//
//  SequentialQuestionStrategy.swift
//  PatternsDemo
//
//  Created by SuShi on 2019/8/27.
//  Copyright © 2019 SuShi. All rights reserved.
//

public class SequentialQuestionStrategy: QuestionStrategy {
  
    public var correctCount: Int = 0
    public var incorrectCount: Int = 0
    private var questionIndex: Int = 0
    private var questionGroup: QuestionGroup
    
    public init(questionGroup: QuestionGroup) {
        self.questionGroup = questionGroup
    }
    
    public var title: String {
        return questionGroup.title
    }
 
    public func currentQuestion() -> Question {
        return questionGroup.questions[questionIndex]
    }
    
    public func markQuestionCorrect(_ question: Question) {
        correctCount += 1
    }
    
    public func markQuestionIncorrect(_ question: Question) {
        incorrectCount += 1
    }
    
    public func questionIndexTitle() -> String {
        return "\(questionIndex + 1)/\(questionGroup.questions.count)"
    }
    
    public func advanceToNextQuestion() -> Bool {
        guard questionIndex + 1 < questionGroup.questions.count else {
            return false
        }
        questionIndex += 1
        return true
    }
}
