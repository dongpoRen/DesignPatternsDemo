//
//  SequentialQuestionStrategy.swift
//  PatternsDemo
//
//  Created by SuShi on 2019/8/27.
//  Copyright © 2019 SuShi. All rights reserved.
//

public class SequentialQuestionStrategy: BaseQuestionStrategy {
  
    public convenience init(questionGroupCaretaker: QuestionGroupCaretaker) {
        let questionGroup = questionGroupCaretaker.selectedQuestionGroup!
        let questions = questionGroup.questions
        self.init(questionGroupCaretaker: questionGroupCaretaker, questions: questions)
    }
 }
