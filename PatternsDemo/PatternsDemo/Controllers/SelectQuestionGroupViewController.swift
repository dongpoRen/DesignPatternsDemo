//
//  SelectQuestionGroupViewController.swift
//  PatternsDemo
//
//  Created by SuShi on 2019/8/26.
//  Copyright © 2019 SuShi. All rights reserved.
//

import UIKit

public class SelectQuestionViewController: UIViewController {
    
    // MARK: - Properties
    public let questionGroups = QuestionGroup.allGroups()
    public var selectedQuestionGroup: QuestionGroup!
    private let appSettings = AppSettings.shared
    
    /// Outlets
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
}

extension SelectQuestionViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionGroups.count
    }
        
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionGroupCell", for: indexPath) as! QuestionGroupCell
        let group = questionGroups[indexPath.row]
        cell.titleLabel.text = group.title
        return cell
    }
}

extension SelectQuestionViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedQuestionGroup = questionGroups[indexPath.row]
        return indexPath
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? QuestionViewController else { return }
        viewController.delegate = self
        viewController.questionStrategy = appSettings.questionStrategy(for: selectedQuestionGroup)
    }
}

extension SelectQuestionViewController: QuestionViewControllerDelegate {
   
    public func questionViewController(_ viewController: QuestionViewController, didCancel questionStrategy: QuestionStrategy, at questionIndex: Int) {
        navigationController?.popToViewController(self, animated: true)
    }
    
    public func questionViewController(_ viewController: QuestionViewController, didComplete questionStrategy: QuestionStrategy) {
        navigationController?.popToViewController(self, animated: true)
    }
}
