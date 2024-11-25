//
//  ConsentManager.swift
//  UserCentricsStudyCase
//
//  Created by Tiago Inácio on 25/11/2024.
//

import Foundation
import Usercentrics
import UsercentricsUI
import SwiftUI

class ConsentManager {
    static let shared = ConsentManager()
    
    init(){
        let options = UsercentricsOptions(settingsId: "gChmbFIdL")
        UsercentricsCore.configure(options: options)
    }
    
    //Check if the first banner has already been shown
    func consentBannerStatus(completion: @escaping ([UsercentricsServiceConsent]?) -> Void){
        UsercentricsCore.isReady { [weak self] status in
            guard let _ = self else { return }
            if status.shouldCollectConsent {
                completion(nil)
            } else{
                completion(status.consents)
            }
        } onFailure: { error in
            // Handle non-localized error
            print("Error initializing Usercentrics: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    func showConsentBanner(completion: @escaping ([UsercentricsServiceConsent]?) -> Void) {
        UsercentricsCore.isReady { [weak self] status in
            guard let self = self else { return }
            
            if status.shouldCollectConsent {
                self.collectConsent() { services in
                    completion(services)
                }
            } else{
                self.reviewConsent() { services in
                    completion(services)
                }
            }
        } onFailure: { error in
            // Handle non-localized error
            print("Error initializing Usercentrics: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    private func collectConsent(completion: @escaping ([UsercentricsServiceConsent]?) -> Void) {
        let banner = UsercentricsBanner()
        banner.showFirstLayer(){ userResponse in
            self.processConsent(userResponse: userResponse, completion: completion)
        }
    }
    
    private func reviewConsent(completion: @escaping ([UsercentricsServiceConsent]?) -> Void) {
        let banner = UsercentricsBanner()
        banner.showSecondLayer(){ userResponse in
            self.processConsent(userResponse: userResponse, completion: completion)
        }
    }
    
    private func processConsent(userResponse: UsercentricsConsentUserResponse?, completion: @escaping ([UsercentricsServiceConsent]?) -> Void) {
        
        guard let userResponse = userResponse else {
            // TO-DO: Handle non-response error
            completion(nil)
            return
        }
        
        completion(userResponse.consents)
    }
    
    func getCMPDataServices() -> [UsercentricsService]{
        let cmpData = UsercentricsCore.shared.getCMPData()
        return cmpData.services
    }
    

}
