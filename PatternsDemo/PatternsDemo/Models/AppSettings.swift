//
//  AppSettings.swift
//  PatternsDemo
//
//  Created by SuShi on 2019/8/28.
//  Copyright © 2019 SuShi. All rights reserved.
//

import Foundation

public class AppSettings {
   
    public static let shared = AppSettings()
    private let userDefaults = UserDefaults.standard

    public var questionStrategyType: QuestionStrategyType {
        get {
            let rawValue = userDefaults.integer(forKey: Keys.questionStrategy)
            return QuestionStrategyType(rawValue: rawValue)!
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: Keys.questionStrategy)
        }
    }
    
    public func questionStrategy(for questionGroup: QuestionGroup) -> QuestionStrategy {
        return questionStrategyType.questionStrategy(for: questionGroup)
    }
    
    private init() { }
}

public enum QuestionStrategyType: Int, CaseIterable {
    case random
    case sequential
    
    public func title() -> String {
        switch self {
        case .random:
            return "Random"
        case .sequential:
            return "Sequential"
        }
    }
    
    public func questionStrategy(for questionGroup: QuestionGroup) -> QuestionStrategy {
        switch self {
        case .random:
            return RandomQuestionStrategy(questionGroup: questionGroup)
        case .sequential:
            return SequentialQuestionStrategy(questionGroup: questionGroup)
        }
    }
}

private struct Keys {
    static let questionStrategy = "questionStrategy"
}
