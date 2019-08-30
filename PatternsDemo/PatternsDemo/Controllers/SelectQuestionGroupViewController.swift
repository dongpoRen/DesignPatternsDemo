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
    private let appSettings = AppSettings.shared
    private let questionGroupCaretaker = QuestionGroupCaretaker()
    
    public var questionGroups: [QuestionGroup] {
        return questionGroupCaretaker.questionGroups
    }
    public var selectedQuestionGroup: QuestionGroup! {
        get { return questionGroupCaretaker.selectedQuestionGroup }
        set { questionGroupCaretaker.selectedQuestionGroup = newValue }
    }
    
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
        let questionGroup = questionGroups[indexPath.row]
        cell.titleLabel.text = questionGroup.title
        
        questionGroup.score.runningPercentage.addObserver(cell, options: [.initial, .new]) { [weak cell] (percetage, _) in
            
            DispatchQueue.main.async {
                cell?.percentLabel.text = String(format: "%.0f %%", round(percetage * 100))
            }
        }
        
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
        if let viewController = segue.destination as? QuestionViewController {
            viewController.delegate = self
            viewController.questionStrategy = appSettings.questionStrategy(for: questionGroupCaretaker)
        } else if let navigationController = segue.destination as? UINavigationController,
            let viewController = navigationController.topViewController as? CreateQuestionGroupViewController {
            viewController.delegate = self
        }
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

extension SelectQuestionViewController: CreateQuestionGroupViewControllerDelegate {
    
    public func createQuestionGroupViewControllerDidCancel(_ viewController: CreateQuestionGroupViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    public func createQuestionGroupViewController(_ viewController: CreateQuestionGroupViewController, created questionGroup: QuestionGroup) {
        questionGroupCaretaker.questionGroups.append(questionGroup)
        try? questionGroupCaretaker.save()
        
        dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
}
