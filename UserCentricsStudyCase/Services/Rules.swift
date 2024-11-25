//
//  Rules.swift
//  UserCentricsStudyCase
//
//  Created by Tiago Inácio on 25/11/2024.
//

import Foundation


protocol Rule {
    func applies(to dataCollected: [String]) -> Bool
    func finalCost(_ cost: Double) -> Double
}

// Rule 1: Banking snoopy - If a service declares: Purchase activity, Bank details AND Credit and debit card number. Increase the cost by 10%.
struct Rule1: Rule {
    private let data = ["Purchase activity", "Bank details", "Credit and debit card number"]
    
    func applies(to dataCollected: [String]) -> Bool {
        return data.allSatisfy { dataCollected.contains($0) }
    }
    
    func finalCost(_ cost: Double) -> Double {
        return cost * 1.1 // Increase 10%
    }
}

// Rule 2: Why do you care? - If a service declares "Search terms", "Geographic location", and "IP Address", increase the cost by 27%.
struct Rule2: Rule {
    private let data = ["Search terms", "Geographic location", "IP address"]
    
    func applies(to dataCollected: [String]) -> Bool {
        return data.allSatisfy { dataCollected.contains($0) }
    }
    
    func finalCost(_ cost: Double) -> Double {
        return cost * 1.27 // Increase 27%
    }
}

// Rule 3: The good citizen - If a service declares 4 or fewer "data types", decrease the cost by 10%.
struct Rule3: Rule {
    func applies(to dataCollected: [String]) -> Bool {
        return dataCollected.count <= 4
    }
    
    func finalCost(_ cost: Double) -> Double {
        return cost * 0.9 // Decrease 10%
    }
}
