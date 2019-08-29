//
//  QuestionGroup.swift
//  PatternsDemo
//
//  Created by SuShi on 2019/8/26.
//  Copyright © 2019 SuShi. All rights reserved.
//

public class QuestionGroup: Codable {
    
    public class Score: Codable {
        
        public var correctCount: Int = 0 {
            didSet { updateRunningPercentage() }
        }
        
        public var incorrectCount: Int = 0 {
            didSet { updateRunningPercentage() }
        }
        
        public lazy var runningPercentage = Observable(calculateRunningPercentage())
        
        public init() { }
        
        /// 添加重置功能
        public func reset() {
            correctCount = 0
            incorrectCount = 0
        }
        
        private func updateRunningPercentage() {
            runningPercentage.value = calculateRunningPercentage()
        }
    
        private func calculateRunningPercentage() -> Double {
            let totolCount = correctCount + incorrectCount
            guard totolCount > 0 else {
                return 0
            }
            return Double(correctCount) / Double(totolCount)
        }
    }
    
    public let questions: [Question]
    public private(set) var score: Score
    public let title: String
    
    public init(questions: [Question],
                score: Score = Score(),
                title: String) {
        self.questions = questions
        self.score = score
        self.title = title
    }
}
