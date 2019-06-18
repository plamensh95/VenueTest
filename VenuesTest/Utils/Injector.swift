//
//  Injector.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 14.06.19.
//  Copyright © 2019 Plamen SH. All rights reserved.
//

class Injector {
    
    class func injectRepositoryDependency() -> Repository {
        return Repository()
    }
    
    class func injectRemoteRepositoryDependency() -> RemoteRepository {
        return RemoteRepository()
    }
    
    class func injectAPIClientDependency() -> APIClient {
        return APIClient()
    }
    
    class func injectAPIRequestBuilderDependency() -> APIRequestBuilder {
        return APIRequestBuilder()
    }
    
    class func injectAPIResponseParserDependency() -> APIResponseParser {
        return APIResponseParser()
    }
}
