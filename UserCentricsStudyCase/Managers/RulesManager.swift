//
//  RulesEngine.swift
//  UserCentricsStudyCase
//
//  Created by Tiago Inácio on 25/11/2024.
//

import Foundation

struct RulesManager {
    private let rules: [Rule]
    
    init() {
        self.rules = [
            Rule1(),
            Rule2(),
            Rule3()
        ]
    }
    
    func applyRules(to baseCost: Double, with data: [String]) -> Double {
        var finalCost = baseCost
        for rule in rules {
            if rule.applies(to: data) {
                finalCost = rule.finalCost(finalCost)
            }
        }
        
        return finalCost
    }
}
