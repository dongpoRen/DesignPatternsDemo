//
//  QuestionGroupBuilder.swift
//  PatternsDemo
//
//  Created by SuShi on 2019/8/30.
//  Copyright © 2019 SuShi. All rights reserved.
//

import Foundation

public class QuestionGroupBuilder {
    public var questions = [QuestionBuilder()]
    public var title = ""
    
    public func addNewQuestion() {
        let question = QuestionBuilder()
        questions.append(question)
    }
    
    public func removeQuestion(at index: Int) {
        questions.remove(at: index)
    }
    
    public func build() throws -> QuestionGroup {
        guard title.count > 0 else { throw Error.missingTitle }
        guard questions.count > 0 else { throw Error.missingQuestions }
        let questions = try self.questions.map { try $0.build() }
        return QuestionGroup(questions: questions, title: title)
    }
    
    public enum Error: String, Swift.Error {
        case missingTitle
        case missingQuestions
    }
}
