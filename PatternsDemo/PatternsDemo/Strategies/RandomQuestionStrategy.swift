//
//  RandomQuestionStrategy.swift
//  PatternsDemo
//
//  Created by SuShi on 2019/8/27.
//  Copyright © 2019 SuShi. All rights reserved.
//
import GameplayKit.GKRandomSource

public class RandomQuestionStrategy: QuestionStrategy {
    
    public var correctCount: Int = 0
    public var incorrectCount: Int = 0
    
    private var questionIndex: Int = 0
    private var questionGroup: QuestionGroup
    private var questions: [Question]
    
    public init(questionGroup: QuestionGroup) {
        self.questionGroup = questionGroup
        
        let random = GKRandomSource.sharedRandom()
        questions = random.arrayByShufflingObjects(in: questionGroup.questions) as! [Question]
    }
    
    public var title: String {
        return questionGroup.title
    }
    
    public func advanceToNextQuestion() -> Bool {
        guard questionIndex + 1 < questions.count else {
            return false
        }
        questionIndex += 1
        return true
    }
    
    public func currentQuestion() -> Question {
        return questions[questionIndex]
    }
    
    public func markQuestionCorrect(_ question: Question) {
        correctCount += 1
    }
    
    public func markQuestionIncorrect(_ question: Question) {
        incorrectCount += 1
    }
    
    public func questionIndexTitle() -> String {
        return "\(questionIndex + 1)/\(questions.count)"
    }
    
    
}
