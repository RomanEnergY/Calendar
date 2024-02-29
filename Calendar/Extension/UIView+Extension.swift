//
//  BaseView+Extension.swift
//  Calendar
//
//  Created by ZverikRS on 29.02.2024.
//

import UIKit

// MARK: - extension for blinkAlpha

extension UIView {
    func blinkAlpha(
        withDuration: TimeInterval = .shortTap,
        completion: (() -> Void)? = nil
    ) {
        let alpha: CGFloat = alpha
        let task: TimeWithTask = .init(
            start: { [weak self] in
                self?.alpha = alpha - CGFloat(0.3)
                self?.isUserInteractionEnabled = false
            },
            finish: { [weak self] in
                self?.alpha = alpha
                self?.isUserInteractionEnabled = true
            })
        
        timeWithTask(withDuration: withDuration, task: task, completion: completion)
    }
}

// MARK: - extension for timeWithAction

extension UIView {
    
    // MARK: - private properties
    
    private static var taskFinishKey: String { "task.finish" }
    private static var completionKey: String { "task.completion" }
    
    // MARK: - internal struct
    
    struct TimeWithTask {
        let start: () -> Void
        let finish: () -> Void
    }
    
    // MARK: - public methods
    
    func timeWithTask(
        withDuration: TimeInterval = .shortTap,
        task: TimeWithTask,
        completion: (() -> Void)? = nil
    ) {
        var userInfo: [String: Any] = [:]
        userInfo[Self.taskFinishKey] = task.finish
        if let completion {
            userInfo[Self.completionKey] = completion
        }
        
        task.start()
        let timer = Timer(
            timeInterval: withDuration,
            target: self,
            selector: #selector(timerClickWithAction),
            userInfo: userInfo,
            repeats: false)
        
        // перенос таймера на отдельный runloop
        RunLoop.current.add(timer, forMode: .common)
    }
    
    // MARK: - private methods
    
    @objc private func timerClickWithAction(_ sender: Timer) {
        if let dictionary = sender.userInfo as? [String: Any] {
            if let actionFinish = dictionary[Self.taskFinishKey] as? () -> Void,
               let completion = dictionary[Self.completionKey] as? (() -> Void)? {
                actionFinish()
                completion?()
            }
        }
    }
}
