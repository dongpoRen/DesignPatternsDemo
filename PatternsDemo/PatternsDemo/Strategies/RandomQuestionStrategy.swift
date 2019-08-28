//
//  RandomQuestionStrategy.swift
//  PatternsDemo
//
//  Created by SuShi on 2019/8/27.
//  Copyright © 2019 SuShi. All rights reserved.
//
import GameplayKit.GKRandomSource

public class RandomQuestionStrategy: BaseQuestionStrategy {
    
    public convenience init(questionGroupCaretaker: QuestionGroupCaretaker) {
        let questionGroup = questionGroupCaretaker.selectedQuestionGroup!
        let random = GKRandomSource.sharedRandom()
        let questions = random.arrayByShufflingObjects(in: questionGroup.questions) as! [Question]
        self.init(questionGroupCaretaker: questionGroupCaretaker, questions: questions)
    }
}
