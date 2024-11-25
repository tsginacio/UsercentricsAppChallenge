//
//  CostCalculator.swift
//  UserCentricsStudyCase
//
//  Created by Tiago Inácio on 25/11/2024.
//

import Foundation
import Usercentrics



class CostCalculator {
    let services : [UsercentricsService]
    let rulesManager: RulesManager
    
    init(services: [UsercentricsService]) {
        self.services = services
        self.rulesManager = RulesManager()
    }
    
    func culculateCost(consents: [UsercentricsServiceConsent]) -> [ServiceCost] {
        
        var serviceCosts = [ServiceCost]()
        
        print("---------- Costs by Services ----------")
        
        for consent in consents {
            if(consent.status == false) {
                //service disabled
                continue
            }
            
            //find service with same ServiceID
            guard let service = services.filter ({ $0.templateId == consent.templateId}).first else {
                continue
            }
            
            let dataCollected = service.dataCollectedList
            var cost = calculateBaseCost(for: dataCollected)
            
            // Applying Rules
            cost = rulesManager.applyRules(to: cost, with: dataCollected)
            let serviceCost = ServiceCost(name: service.templateId ?? "" , cost: cost)
            
            //Print cost by Service
            print("\(service.dataProcessor ?? "Unknow service" ) = \(cost)")
            
            serviceCosts.append(serviceCost)
        }
        print("---------------------------------------")
        
        //TO-DO: SUM Equal services names
        return serviceCosts
        
    }
    
    private func calculateBaseCost(for dataCollected: [String]) -> Double {
        let costTable: [String: Double] = [
            "Configuration of app settings": 1,
            "IP address": 2,
            "User behaviour": 2,
            "User agent": 3,
            "App crashes": -2,
            "Browser information": 3,
            "Credit and debit card number": 4,
            "First name": 6,
            "Geographic location": 7,
            "Date and time of visit": 1,
            "Advertising identifier": 2,
            "Bank details": 5,
            "Purchase activity": 6,
            "Internet service provider": 4,
            "JavaScript support": -1
        ]
        
        return dataCollected.reduce(0) {sum, dataType in
            sum + (costTable[dataType] ?? 0)
        }
    }
}
