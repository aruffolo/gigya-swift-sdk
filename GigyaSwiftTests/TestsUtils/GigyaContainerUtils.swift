//
//  GigyaAppContextMock.swift
//  GigyaSwiftTests
//
//  Created by Shmuel, Sagi on 28/03/2019.
//  Copyright © 2019 Gigya. All rights reserved.
//

import Foundation
@testable import GigyaSwift

class GigyaContainerUtils {
    let container: IOCContainer = IOCContainer()

    init() {
        registerDependencie()
    }

    func registerDependencie() {
        container.register(service: GigyaConfig.self, isSingleton: true) { _ in GigyaConfig() }

        container.register(service: IOCNetworkAdapterProtocol.self) { _ in
            return NetworkAdapterMock()
        }

        container.register(service: IOCSocialProviderFactoryProtocol.self) { resolver in
            let sessionService = resolver.resolve(IOCSessionServiceProtocol.self)
            return ProviderFactoryMock(sessionService: sessionService!, config: resolver.resolve(GigyaConfig.self)!)
        }

        container.register(service: IOCApiServiceProtocol.self) { resolver in
            return ApiService(with: resolver.resolve(IOCNetworkAdapterProtocol.self)!)
        }

        container.register(service: IOCGigyaWrapperProtocol.self, isSingleton: true) { _ in
            return GigyaWrapperMock()
        }

        container.register(service: IOCSessionServiceProtocol.self, isSingleton: true) { resolver in
            let gigyaApi = resolver.resolve(IOCGigyaWrapperProtocol.self)
            let accountService = resolver.resolve(IOCAccountServiceProtocol.self)

            return GigyaSessionServiceMock(gigyaApi: gigyaApi!, accountService: accountService!)
        }

        container.register(service: IOCBusinessApiServiceProtocol.self) { resolver in
            let apiService = resolver.resolve(IOCApiServiceProtocol.self)
            let sessionService = resolver.resolve(IOCSessionServiceProtocol.self)
            let accountService = resolver.resolve(IOCAccountServiceProtocol.self)
            let providerFactory = resolver.resolve(IOCSocialProviderFactoryProtocol.self)

            return BusinessApiService(apiService: apiService!,
                                        sessionService: sessionService!,
                                        accountService: accountService!,
                                        providerFactory: providerFactory!)
        }

        container.register(service: IOCAccountServiceProtocol.self, isSingleton: true) { _ in AccountService() }
    }

}
