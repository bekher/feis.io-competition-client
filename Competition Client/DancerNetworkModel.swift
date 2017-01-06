//
//  DancerNetworkModel.swift
//  Competition Client
//
//  Created by Greg Bekher on 1/4/17.
//  Copyright © 2017 Feis.io. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import SwiftyJSON

class DancerNetworkModel : NSObject {
    // TODO: socket.io here


    unowned var parentNetworkModel : MainNetworkModel
    unowned var authorizedUser : Variable<UserCredentials?>{
        return parentNetworkModel.authorizedUser
    }
	unowned var provider : RxMoyaProvider<FeisioAPI> {
        return parentNetworkModel.provider
    }

    init(parentNetworkModel: MainNetworkModel) {
        self.parentNetworkModel = parentNetworkModel
    }

    func getDancers( competition : Competition) -> Observable<[Dancer]> {
        //guard (self.authorizedUser.value != nil) else { return nil }

        return self.provider
            .request(FeisioAPI.dancers(competitionId: competition.id))
            .mapJSON()
            .mapTo(arrayOf: Dancer.self)

    }

}
