//
//  FireWallComands.swift
//  KUTaskFramework
//
//  Created by Kurushetra on 2/4/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation






//MARK: -------------------------------- FIREWALL --------------------------------
struct FireWallStart:ComandWithID  {
    
     var name: String
    var praser: Prasable
    var Id: String = ""
//    var type: ComandType = .fireWallStart
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo ¿¿¿ | sudo -S pfctl -e -f  /etc/pf.conf"]
    
    init(withId: String, name:String, praser: Prasable) {
        self.name = name
        self.praser = praser
        self.Id = withId
        addId()
    }
    
}


struct FireWallStop:ComandWithID  {
    
    var name: String
    var praser: Prasable
    var Id: String = ""
//    var type: ComandType = .fireWallStop
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo ¿¿¿ | sudo -S  pfctl -d"]
    
    init(withId: String, name:String, praser: Prasable) {
        self.name = name
        self.praser = praser
        self.Id = withId
        addId()
    }
    
}



struct FireWallState:ComandWithID  {
    
    var name: String
    var praser: Prasable = Prasers.StatePraser() //TODO: mirarhaver si funciona ???
    var Id: String = ""
//    var type: ComandType = .fireWallState
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo ¿¿¿ | sudo -S pfctl  -s info | grep Status"]
    
    init(withId: String, name:String, praser: Prasable) {
        self.name = name
//        self.type = .fireWallState
         self.praser = praser
        self.Id = withId
        addId()
    }
    
}



struct FireWallBadHosts:ComandWithID  {
    
    var name: String
    var praser: Prasable
    var Id: String = ""
//    var type: ComandType = .fireWallBadHosts
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo ¿¿¿ | sudo -S pfctl -t badhosts -T show"]
    
    init(withId: String, name:String, praser: Prasable) {
        self.name = name
        self.praser = praser
        self.Id = withId
        addId()
    }
}


struct AddFireWallBadHosts:ComandIpId   {
    
    var name: String
    var praser: Prasable
    var Id: String = ""
//    var type: ComandType = .addFireWallBadHosts
    var ip:String = ""
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo ¿¿¿ | sudo -S pfctl  -t badhosts -T add ???"]
    
    init(withId: String, withIp: String, name:String, praser: Prasable) {
        self.name = name
        self.praser = praser
        self.ip = withIp
        self.Id = withId
        addIPAndID()
    }
}



struct DeleteFireWallBadHosts:ComandIpId  {
    
    var name: String
    var praser: Prasable
    var Id: String = ""
//    var type: ComandType = .deleteFireWallBadHosts
    var ip:String = ""
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo ¿¿¿ | sudo -S pfctl  -t badhosts -T delete ???"]
    
    
    init(withId: String, withIp: String, name:String,  praser: Prasable) {
        self.name = name
        self.praser = praser
        self.ip = withIp
        self.Id = withId
        addIPAndID()
    }
    
}
