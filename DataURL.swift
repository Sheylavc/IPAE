//
//  DataURL.swift
//  diagnostico-empresarial
//
//  Created by ucweb on 30/09/16.
//  Copyright © 2016 ipae. All rights reserved.
//

import UIKit

class DataURL: NSObject {
    
    struct GlobalVariables {
        
        // ULR BASE
        static var UrlBase : String! = "http://diagnostico.ipae.pe/"
        
        
        // Iniciar Test
        static var getAllData : String! = UrlBase + "api-rest/getAllData-v1"
        static var startTest : String! = UrlBase + "api-rest/starTest-v1"
        static var saveRespuestas : String! = UrlBase + "api-rest/saveRespuestas-v1"
        
        static var saveFormulario : String! = UrlBase + "api-rest/saveFormulario-v1"
        static var saveSugerencia : String! = UrlBase + "api-rest/saveSugerencia-v1"
        
        static var getAreas : String! = UrlBase + "api-rest/getAreas-v1"
        static var getTerminos : String! = UrlBase + "api-rest/getTerminos-v1"
        static var updatePregunta : String! = UrlBase + "api-rest/updatePregunta-v1"
        
        static var updateToken : String! = UrlBase + "api-rest/updateToken-v1"
        
    }
    
    
}

/*class Singleton {
    class var token :Singleton{
        struct Static {
            static let instance: Singleton = Singleton()
        }
        return Static.instance
    }
}*/
