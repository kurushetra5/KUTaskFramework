//
//  ComandRuner.swift
//  Prueba-Timer-shellComand-Operations
//
//  Created by Kurushetra on 22/3/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation



public protocol ComandsRunerDelegate {
    func finish(comand:ComandType, withResult result:[String])
}

public enum ComandsRunerError: Error {
    case ComandsRunerFailed(reason: String)
}




public class ComandsRuner {
    
    
    static var timer:Timer!
    static var timer2:Timer!
    public static var comandsRunerId:String!
    
    
    public static var comandsRunerDelegate:ComandsRunerDelegate!
    static var comand1:Comand!
    static var comand2:Comand!
    static var praser:Prasable!
    
    
    public static func setPraser(praser:Any)  throws  {
        
        guard let thePraser =  praser as? Prasable else {
            throw ComandsRunerError.ComandsRunerFailed(reason:"ERROR Class: ComandsRuner Location: public static func setPraser(praser:Any)  throws Reason: The praser introduced do not conform to protocol Prasabl")
        }
        
        self.praser = thePraser
    }
    
    
    
    
    public static func run(comand:String, args:String!, forEver:Bool, completion:@escaping (String) -> Void) { //FIXME: separar en varias func
        
        var ip:String = "0.0.0.0" //TODO: cambiar ???
        var comandForRun:Comand!
        var isOk:Bool = false
        
        if args != nil {
            ip = args
        }
        
        switch comand {
        // ----------------------- FIREWALL -----------------------
        case ComandType.fireWallState.rawValue:
            praser = StatePraser()
            print("fireWallState")
            isOk = true
            comandForRun = FireWallState(withId:comandsRunerId, praser: praser)
            
        case ComandType.fireWallStart.rawValue:
            praser = GenericPraser()
            print("fireWallStart")
            isOk = true
            comandForRun =  FireWallStart(withId: comandsRunerId, praser: praser)
            
        case ComandType.fireWallStop.rawValue:
            praser = GenericPraser()
            print("fireWallStop")
            isOk = true
            comandForRun =  FireWallStop(withId: comandsRunerId, praser: praser)
            
        case ComandType.fireWallBadHosts.rawValue:
            praser = badHostsPraser()
            print("fireWallBadHosts")
            comandForRun = FireWallBadHosts(withId:comandsRunerId, praser: praser)
            isOk = true
            
        case ComandType.addFireWallBadHosts.rawValue:
            praser = GenericPraser()
            print("addFireWallBadHosts")
            comandForRun =  AddFireWallBadHosts(withId: comandsRunerId, withIp:ip, praser: praser)
            isOk = true
            
        case ComandType.deleteFireWallBadHosts.rawValue:
            praser = GenericPraser()
            print("deleteFireWallBadHosts")
            comandForRun =  DeleteFireWallBadHosts(withId:comandsRunerId, withIp:ip, praser: praser)
            isOk = true
            
        case ComandType.blockIp.rawValue:
            praser = GenericPraser()
            print("blockIp")
            comandForRun =  GenericComand(praser: praser, type:.generic, taskPath: "", taskArgs:[""])
            isOk = true
            
            
        // ----------------------- INFO -----------------------
        case ComandType.mtRoute.rawValue:
            praser = GenericPraser()
            print("mtRoute")
            comandForRun =  MtRoute(withId:comandsRunerId, withIp:ip, praser: praser)
            isOk = true
            
        case ComandType.nsLookup .rawValue:
            praser = GenericPraser()
            print("nsLookup")
            comandForRun =  NsLookup(withIp:ip, praser: praser)
            isOk = true
            
        case ComandType.ping.rawValue:
            praser = GenericPraser()
            print("ping")
            comandForRun = GenericComand(praser: praser, type:.generic, taskPath: "", taskArgs:[""])
            isOk = true
            
        case ComandType.traceRoute.rawValue:
            praser = GenericPraser()
            print("traceRoute")
            comandForRun =  TraceRoute(withIp:ip, praser: praser)
            isOk = true
            
        case ComandType.whois.rawValue:
            praser = GenericPraser()
            print("whois")
            comandForRun =  Whois(withIp:ip, praser: praser)
            isOk = true
            
        case ComandType.dig.rawValue:
            praser = GenericPraser()
            print("dig")
            comandForRun =  GenericComand(praser: praser, type:.generic, taskPath: "/usr/bin/dig", taskArgs:[ip])
            isOk = true
            
        case ComandType.history.rawValue:
            praser = GenericPraser()
            print("history")
            comandForRun =  GenericComand(praser: praser, type:.generic, taskPath: "/bin/pwd", taskArgs:["-L"])
            isOk = true
            
        case ComandType.ports_Services.rawValue:
            praser = GenericPraser()
            print("ports_Services")
//            comandForRun =  GenericComandId(withId:  comandsRunerId, praser: praser) //FIXME:no asi
//            isOk = true
            
            
        //  ----------------------- CONECTIONS -----------------------
        case ComandType.netStat.rawValue:
            praser = NetStatPraser()
            print("netStat")
            isOk = true
            comandForRun =  NetStat(praser: praser, type:.netStat, taskPath: "", taskArgs: [""])  //FIXME:no asi
            
        case ComandType.tcpDump.rawValue:
            praser = GenericPraser()
            print("tcpDump")
            isOk = true
            comandForRun =  TcpDumpCom(withIp:ip, praser: praser)
            
            //  ----------------------- CONECTIONS -----------------------
            
        case ComandType.conectionData.rawValue:
            praser = GenericPraser()
            print("conectionData")
            comandForRun = TcpDumpCom(withIp:ip, praser: praser)
            isOk = true
            
            
        //  ----------------------- GENERICS -----------------------
        case ComandType.genericComand.rawValue:
            praser = GenericPraser()
            print("genericComand")
            comandForRun =  GenericComand(praser: praser, type:.generic, taskPath: "", taskArgs:[""])
            isOk = true
            
        case ComandType.generic.rawValue:
            
            if praser != nil {
                print("generic praser OK Set")
                
            }else {
                praser = GenericPraser()
                print("generic praser NOT Set")
            }
            comandForRun =  GenericComand(praser: praser, type:.generic, taskPath: "", taskArgs:[""])
            isOk = true
            
         default:
            print("public static func run(comand:String,... Switch Default")
            isOk = false
            
        }
        
        
        if isOk {
            run(comand:comandForRun  , forEver: forEver) { (result) in
                print(result)
                
                completion(self.praser.prase(comandResult:result) as! String)
            }
        } else {
            print("The comand is not indexed yet ... run(comand")
        }
        
    }
    
    
    
    
    static func run(comand:Comand, forEver:Bool ,completion:@escaping (String) -> Void) {
        
        switch forEver {
        case true:
            
            if timer  == nil {
                comand1 = comand
                 ComandsRuner().timerStart()
            }else if timer != nil {
                comand2 = comand
                timerStart2()
            }
            
        case false:
            run(comand: comand, completion: { (results,comand) in
                print(results)
                print(comand)
                completion(results[0])
                //                 self.comandsRunerDelegate?.finish(comand:comand, withResult:results)
            })
            //            completion("acabado_1")
        }
        
    }
    
    
    
    
    
    
    private static func run(comand:Comand, completion:@escaping ([String],ComandType) -> Void) {
        
        let task = Process()
        task.launchPath = comand.taskPath
        task.arguments = comand.taskArgs
        //        task.arguments = comand.taskArgs
        task.standardOutput = Pipe()
        
        task.terminationHandler = { task in
            guard task.terminationStatus == 0
                else {
                    NSLog("The process fail to operate.")
                    return
            }
            
            guard let data = (task.standardOutput as? Pipe)?.fileHandleForReading.availableData,
                data.count > 0,
                let s = String(data: data, encoding: .utf8)
                else { return }
            
            let dataResult = s.components(separatedBy: "\n")
            
        
            
            DispatchQueue.main.sync {
                completion(dataResult,comand.type)
            }
        }
        task.launch()
    }
    
    
    
    
    
    
    
    
    //MARK: ---------------------- TIMERS ---------------------------
    
    
    
  public   func timerStart() {
        
    ComandsRuner.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        print("timerStart()")
        
    }
    
    static  func timerStart2() {
        
        timer2 = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.timerAction2), userInfo: nil, repeats: true)
        print("timerStart2()")
        
    }
    
    
    
    
    
    
  @objc func timerAction() {
        print("timer Action()")
        
        
        ComandsRuner.run(comand:ComandsRuner.comand1) { (results, comand) in
            ComandsRuner.comandsRunerDelegate?.finish(comand:comand, withResult:results)
        }
        
        
        
    }
    
    
    
    @objc func timerAction2() {
        print("timer Action2()")
        
        ComandsRuner.run(comand:ComandsRuner.comand2) { (results, comand) in
            ComandsRuner.comandsRunerDelegate?.finish(comand:comand, withResult:results)
        }
        
        
    }
    
    
    
}
