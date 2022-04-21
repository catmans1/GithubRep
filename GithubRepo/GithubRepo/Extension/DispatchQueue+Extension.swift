//
//  DispatchQueue+Extension.swift
//  GithubRepo
//
//  Created by HungLe on 4/21/22.
//

import Dispatch

private var throttleWorkItems = [AnyHashable: DispatchWorkItem]()
private var nilContext: AnyHashable = arc4random()

public extension DispatchQueue {

    func throttle(deadline: DispatchTime, context: AnyHashable? = nil, action: @escaping () -> Void) {
        let worker = DispatchWorkItem {
            defer { throttleWorkItems.removeValue(forKey: context ?? nilContext) }
            action()
        }

        asyncAfter(deadline: deadline, execute: worker)

        throttleWorkItems[context ?? nilContext]?.cancel()
        throttleWorkItems[context ?? nilContext] = worker
    }
}

