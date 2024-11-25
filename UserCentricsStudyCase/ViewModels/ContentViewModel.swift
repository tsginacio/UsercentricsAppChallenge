//
//  ContentViewModel.swift
//  UserCentricsStudyCase
//
//  Created by Tiago Inácio on 25/11/2024.
//

import Foundation
import Combine
import Usercentrics

class ContentViewModel: ObservableObject {
    @Published var totalCost: Double? = nil
    @Published var serviceCosts: [ServiceCost] = []
    @Published var alreadyCollectConsent: Bool = false
    @Published var loading: Bool = true

    private let consentManager: ConsentManager
    
    init(consentManager: ConsentManager = .shared) {
        self.consentManager = consentManager
        fetchConsentStatus()
    }

    func fetchConsentStatus() {
        loading = true
        consentManager.consentBannerStatus { consents in
            guard let consents = consents else {
                self.alreadyCollectConsent = false
                self.loading = false
                return
            }
            self.alreadyCollectConsent = true
            self.calculateCosts(for: consents)
            self.loading = false
        }
    }

    func showConsentBanner() {
        loading = true
        consentManager.showConsentBanner { consents in
            guard let consents = consents else { return }
            self.alreadyCollectConsent = true
            self.calculateCosts(for: consents)
            self.loading = false
        }
    }

    private func calculateCosts(for consents: [UsercentricsServiceConsent]) {
        let services = consentManager.getCMPDataServices()
        
        let calculator = CostCalculator(services: services)
        self.serviceCosts = calculator.culculateCost(consents: consents)
        
        self.totalCost = serviceCosts.reduce(0) { $0 + $1.cost }
        
        print("---------------------------------------")
        print("Total Consent Cost: \(self.totalCost ?? 0.00)")
        print("---------------------------------------")
    }
}

