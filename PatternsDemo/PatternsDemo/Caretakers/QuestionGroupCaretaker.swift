//
//  QuestionGroupCaretaker.swift
//  PatternsDemo
//
//  Created by SuShi on 2019/8/28.
//  Copyright © 2019 SuShi. All rights reserved.
//

import Foundation

public final class QuestionGroupCaretaker {
    
    private let fileName = "QuestionGroupData"
    public var questionGroups: [QuestionGroup] = []
    public var selectedQuestionGroup: QuestionGroup!
    
    public init() {
        loadQuestionGroups()
    }
    
    private func loadQuestionGroups() {
        if let questionGroups =
            try? DiskCaretaker.retrive([QuestionGroup].self,
                                       from: fileName) {
            self.questionGroups = questionGroups
        } else {
            let bundle = Bundle.main
            let url = bundle.url(forResource: fileName, withExtension: "json")!
            self.questionGroups = try! DiskCaretaker.retrive([QuestionGroup].self, from: url)
            try! save()
        }
    }
    
    public func save() throws {
        try DiskCaretaker.save(questionGroups, to: fileName)
    }
}
