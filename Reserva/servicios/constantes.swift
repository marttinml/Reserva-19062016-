//
//  constantes.swift
//  miAT&TWeb
//
//  Created by Ivan Tzicuri De la luz Escalante on 05/02/16.
//  Copyright © 2016 Ivan Tzicuri De la luz Escalante. All rights reserved.
//

import WatchKit


class constantes: NSObject {

    override init() {
        super.init()
        
    }
    
    static let sharedInstance = constantes()
    
    var terminoEmpleados:Bool=false
    var primeravez:Bool=false
}
