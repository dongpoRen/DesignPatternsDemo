//
//  QuestionGroup.swift
//  PatternsDemo
//
//  Created by SuShi on 2019/8/26.
//  Copyright © 2019 SuShi. All rights reserved.
//

public class QuestionGroup: Codable {
    
    public class Score: Codable {
        public var correctCount: Int = 0
        public var incorrectCount: Int = 0
        public init() { }
    }
    
    public let questions: [Question]
    public var score: Score
    public let title: String
    
    public init(questions: [Question],
                score: Score = Score(),
                title: String) {
        self.questions = questions
        self.score = score
        self.title = title
    }
}
