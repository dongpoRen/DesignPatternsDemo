//
//  Question.swift
//  PatternsDemo
//
//  Created by SuShi on 2019/8/26.
//  Copyright © 2019 SuShi. All rights reserved.
//

public class Question: Codable {
    public let answer: String
    public let hint: String?
    public let prompt: String
    
    public init(answer: String, hint: String?, prompt: String) {
        self.answer = answer
        self.hint = hint
        self.prompt = prompt
    }
}
