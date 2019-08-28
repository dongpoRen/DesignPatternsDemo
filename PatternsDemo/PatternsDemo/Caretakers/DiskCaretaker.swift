//
//  DiskCaretaker.swift
//  PatternsDemo
//
//  Created by SuShi on 2019/8/28.
//  Copyright © 2019 SuShi. All rights reserved.
//

import Foundation

public final class DiskCaretaker {
    public static let decoder = JSONDecoder()
    public static let encoder = JSONEncoder()
    
    public static func save<T: Codable>(_ object: T, to fileName: String) throws {
        do {
            let url = createDoucumentURL(withFileName: fileName)
            let data = try encoder.encode(object)
            try data.write(to: url, options: .atomic)
        } catch (let error) {
            print("Saved failed: Object: `\(object)`," + "Error: `\(error)`")
            throw error
        }
    }
    
    public static func retrive<T: Codable>(
        _ type: T.Type, from fileName: String) throws -> T {
        let url = createDoucumentURL(withFileName: fileName)
        return try retrive(T.self, from: url)
    }
    
    public static func retrive<T: Codable>(
        _ type: T.Type, from url: URL) throws -> T {
        do {
            let data = try Data(contentsOf: url)
            return try decoder.decode(T.self, from: data)
        } catch (let error) {
            print("Retrive failed: URL: `\(url)`, Error: `\(error)`")
            throw error
        }
    }
    
    public static func createDoucumentURL(
        withFileName fileName: String) -> URL {
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return url.appendingPathComponent(fileName).appendingPathExtension("json")
    }
}
