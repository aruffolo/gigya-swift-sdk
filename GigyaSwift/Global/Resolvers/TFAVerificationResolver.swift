//
//  TFAVerificationResolver.swift
//  GigyaSwift
//
//  Created by Tal Mirmelshtein on 15/05/2019.
//  Copyright © 2019 Gigya. All rights reserved.
//

import Foundation

public protocol TFAVerificationResolverProtocol {
    
    func startVerificationWithPhone()
    
    func sendPhoneVerificationCode(registeredPhone: TFARegisteredPhone)
    
    func startVerificationWithEmail()
    
    func sendEmailVerificationCode(registeredEmail: TFAEmail)
    
    func startVerificationWithTotp(authorizationCode: String)
}

class TFAVerificationResolver<T: Codable> : TFAResolver<T>, TFAVerificationResolverProtocol {
    
    override init(originalError: NetworkError, regToken: String, businessDelegate: BusinessApiDelegate, completion: @escaping (GigyaLoginResult<T>) -> Void) {
        super.init(originalError: originalError, regToken: regToken, businessDelegate: businessDelegate, completion: completion)
    }
    
    override func forwardInitialInterruption() {
        let loginError = LoginApiError<T>(error: self.originalError, interruption: .pendingTwoFactorVerification(resolver: self))
        self.completion(.failure(loginError))
    }
    
    func startVerificationWithPhone() {
        initTFA(tfaProvider: .gigyaPhone, mode: "verify", arguments: [:])
    }
    
    func sendPhoneVerificationCode(registeredPhone: TFARegisteredPhone) {
        guard let phoneId = registeredPhone.id, let lastMethod = registeredPhone.lastMethod else {
            forwardInitialInterruption()
            return
        }
        sendPhoneVerificationCode(phoneId: phoneId, method: lastMethod)
    }
    
    func startVerificationWithEmail() {
        initTFA(tfaProvider: .email, mode: "verify", arguments: [:])
    }
    
    func sendEmailVerificationCode(registeredEmail: TFAEmail) {
        verifyRegisterdEmail(registeredEmail: registeredEmail)
    }
    
    func startVerificationWithTotp(authorizationCode: String) {
        initTFA(tfaProvider: .totp, mode: "verify", arguments: ["authorizationCode": authorizationCode])
    }
}
