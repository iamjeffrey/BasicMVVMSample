//
//  MainModel.swift
//  UsedGood
//
//  Created by Seonghwan on 2022/02/13.
//

import Foundation

struct MainModel {
    func setAlert(errorMessage: [String]) -> Alert {
            let title = errorMessage.isEmpty ? "Success": "Failed"
            let message = errorMessage.isEmpty ? nil : errorMessage.joined(separator: "\n")
        return (title: title, message: message)
    }
}

