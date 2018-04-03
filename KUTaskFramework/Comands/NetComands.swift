//
//  NetComands.swift
//  KUTaskFramework
//
//  Created by Kurushetra on 2/4/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation





//MARK: -------------------------------- NETCOMANDS --------------------------------
struct NetStat:Comand   {
    
    var praser: Prasable
    var type: ComandType = .netStat
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "netstat -an  | grep ESTABLISHED"]
    
    init(praser: Prasable) {
        self.praser = praser
    }
}






struct TcpDumpCom:ComandWithIP {
    
    var type: ComandType = .tcpDump
    var taskPath:String =  "/usr/sbin/tcpdump"
    var taskArgs:[String] = ["-i","en4","-n" ," not (src net 192.168.8.1 and dst net 192.168.8.100) and not  (src net 192.168.8.100 and dst net 192.168.8.1) and not (src net 192.168.8.1 and dst net 239.255.255.250)"]
    var ip:String = ""
    var praser: Prasable
    
    init(withIp: String, praser: Prasable) {
        self.praser = praser
        self.ip = withIp
        //        addIp() //FIXME: Este comando no esta claro
    }
    
    mutating func block(ip:String) {
        let notIpArgs:String = "and not (src net " + ip + " and dst net " + ip + ")"
        self.taskArgs.append(notIpArgs)
    }
}




struct TraceRoute:ComandWithIP {
    
    var praser: Prasable
    var type: ComandType = .traceRoute
    var ip:String = ""
    var taskPath:String =  "/usr/sbin/traceroute"
    var taskArgs:[String] = ["-w 1" , "-m30", "???"]
    
    
    init(withIp: String, praser: Prasable) {
        self.praser = praser
        self.ip = withIp
        addIp()
    }
    
    mutating func addIp() {
        self.taskArgs[2] = self.ip
    }
}




struct NsLookup:ComandWithIP {
    
    var praser: Prasable
    var type: ComandType = .nsLookup
    var ip:String = ""
    var taskPath:String =  "/usr/bin/nslookup"
    var taskArgs:[String] = []
    
    
    init(withIp: String, praser: Prasable) {
        self.praser = praser
        self.ip = withIp
        addIp()
    }
    mutating func addIp() {
        self.taskArgs = [self.ip]
    }
}



struct Whois:ComandWithIP {
    
    var praser: Prasable
    var type: ComandType = .whois
    var ip:String = ""
    var taskPath:String =  "/usr/bin/whois"
    var taskArgs:[String] = []
    
    
    init(withIp: String, praser: Prasable) {
        self.praser = praser
        self.ip = withIp
        addIp()
    }
    mutating func addIp() {
        self.taskArgs = [self.ip]
    }
}



struct MtRoute:ComandIpId {
    
    var praser: Prasable
    var Id: String = ""
    var type: ComandType = .mtRoute
    var ip:String = ""
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo ¿¿¿ | sudo -S  ./mtr -rw -n ??? | awk '{print $2}'"] //FIXME: ruta de mtr no es esta
    
    init(withId: String, withIp: String, praser: Prasable) {
        self.praser = praser
        self.ip = withIp
        self.Id = withId
        addIPAndID()
    }
    
    
    
}
