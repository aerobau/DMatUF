//
//  Reachability.swift
//  DMatUF
//
//  Created by Ian MacCallum on 12/28/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation

extension Reachability {
    class func connectedToInternet() -> Bool {
        let reachability = Reachability.reachabilityForInternetConnection()
        reachability.startNotifier()
        
        let networkStatus = reachability.currentReachabilityStatus()
        

        
        switch networkStatus {
        case .NotReachable: return false
        default: return true
        }
    }
}
