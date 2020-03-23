//
//  LoginFlow.swift
//  GigyaNss
//
//  Created by Shmuel, Sagi on 25/02/2020.
//  Copyright © 2020 Gigya. All rights reserved.
//
import Gigya
import Flutter

class LoginFlow<T: GigyaAccountProtocol>: NssFlow {
    var busnessApi: BusinessApiDelegate

    init(busnessApi: BusinessApiDelegate) {
        self.busnessApi = busnessApi
    }
    
    override func next(method: ApiChannelEvent, params: [String: Any]?, response: @escaping FlutterResult) {
        super.next(method: method, params: params, response: response)
        
        switch method {
        case .submit:
            guard let params = params?["params"] as? [String: Any] else {
                return
            }

            let loginId = params["loginID"] as? String ?? ""
            let password = params["password"] as? String ?? ""
            let paramss = params["params"] as? [String: Any] ?? [:]

            busnessApi.callLogin(dataType: T.self, loginId: loginId, password: password, params: paramss) { (result) in
                switch result {
                case .success(let data):
                    let resultData = ["errorCode": 0, "errorMessage": "", "callId": "", "statusCode": 200] as [String : Any]

                    response(resultData)
                case .failure(let error):
                    switch error.error {
                    case .gigyaError(let data):
                        response(FlutterError(code: "\(data.errorCode)", message: data.errorMessage, details: data.toDictionary().asJson))
                    default:
                        response(FlutterError(code: "500", message: "", details: nil))
                    }
                }
            }
        default:
            break
        }
    }
}
