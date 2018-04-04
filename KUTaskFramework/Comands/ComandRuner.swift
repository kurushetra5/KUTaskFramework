//
//  ComandRuner.swift
//  Prueba-Timer-shellComand-Operations
//
//  Created by Kurushetra on 22/3/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation



public protocol ComandsRunerDelegate {
    func finish(comand:String, withResult result:[String])
}

public enum ComandsRunerError: Error {
    case ComandsRunerFailed(reason: String)
}




public class ComandsRuner {
//    
//    public static var comandsRunerId:String!
    public static var comandsRunerDelegate:ComandsRunerDelegate!
    
    
    static var timer:Timer! //TODO: Sobra ? dict de comandos corriendo con id de timer para pararlo
    static var timer2:Timer!  //TODO: Sobra ? dict de comandos corriendo con id de timer para pararlo
    static var comand1:Comand! //TODO: Sobra ? dict de comandos corriendo con id de timer para pararlo
    static var comand2:Comand! //TODO: Sobra ? dict de comandos corriendo con id de timer para pararlo
    static var praser:Prasable! //TODO: Sobra ? lo paso en el ennum
    //    static var forEverComandsRuning:[Comand] = []
    
    
    static var timers:[KUTimer] = []
    
    static var comandToRunForEver:Comand!
    
     //MARK: ---------------------- PUBLIC API ---------------------------
    
    public static func setPraser(praser:Any)  throws  {
        
        guard let thePraser =  praser as? Prasable else {
            throw ComandsRunerError.ComandsRunerFailed(reason:"ERROR Class: ComandsRuner Location: public static func setPraser(praser:Any)  throws Reason: The praser introduced do not conform to protocol Prasabl")
        }
        
        self.praser = thePraser
    }
    
    
    
    public static func runGeneric(comand:String, args:[String], completion:@escaping (PraserResult) -> Void) {
        
        praser =  Prasers.GenericPraser()
        print("Generic")
        let comandForRun:Comand  = GenericComand(name:"generic", praser: praser, taskPath: comand, taskArgs:args)
        
        run(comand:comandForRun  , forEver:false) { (result) in
//            print(result)
            completion(self.praser.prase(comandResult:result) )
        }
        
    }
    
    
    public static func run(comand:Comand, completion:@escaping (PraserResult) -> Void) {
        
 
        
        run(comand:comand  , forEver:false) { (result) in
//            print(result)
            completion( comand.praser.prase(comandResult:result) )  
        }
    }
    
    
    
    public static func runForEver(comand:Comand, completion:@escaping (PraserResult) -> Void) {
        
      run(comand:comand  , forEver:true) { (result) in
            print(result)
            completion(comand.praser.prase(comandResult:result) )
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
  //MARK: ---------------------- PRIVATE API ---------------------------
    
  private  static func run(comand:Comand, forEver:Bool ,completion:@escaping ([String]) -> Void) {
        
        switch forEver {
        case true:
            runTimerTask(comand)
            
//            if timer  == nil {
//                comand1 = comand
//                 ComandsRuner.timerStart()
//            }else if timer != nil {
//                comand2 = comand
//                ComandsRuner.timerStart2()
//            }
            
        case false:
            run(comand: comand, completion: { (results,comand) in
//                print(results)
//                print(comand)
                completion(results)
                
            })
           
        }
        
    }
    
    
    
  static  func runTimerTask(_ comand:Comand) {
    
        comandToRunForEver = comand
    
        // comprobar si existe la tarea por nombre
    for timer in timers  {
        
        if timer.taskType == comand.name {
            print("El Comando ya se esta corriendo ...???")
        } else {
            // crear KUTimer y rellena
            
            let timer:KUTimer = KUTimer(timer:Timer() , id:"TimerID_0001", taskType:comand.name)
            // pone el timer en el array
            timers.append(timer)
            // corre el timer
//            timer.run()
            start(timer:timer, with: comand )
        }
    }
    
    if timers.count == 0 {
        
        let timer:KUTimer = KUTimer(timer:Timer() , id:"TimerID_0001", taskType:comand.name)
        // pone el timer en el array
        timers.append(timer)
        // corre el timer
        //            timer.run()
        start(timer:timer, with: comand )
    }
    
    }
    
 
    
    
private static func run(comand:Comand, completion:@escaping ([String],String) -> Void) {
        
        let task = Process()
        task.launchPath = comand.taskPath
        task.arguments = comand.taskArgs
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
                else {
                return
                }
            
            let dataResult = s.components(separatedBy: "\n")
            
            DispatchQueue.main.sync {
                completion(dataResult,comand.name)
            }
        }
        task.launch()
    }
    
    
    
    
    
    
    
    
    //MARK: ---------------------- TIMERS ---------------------------
    
    public static func stopForEver(comand:String) {
        
        stop(comandName:comand)
    }
    
    
    static  func stop(comandName:String) {
        
        for timer in timers {
            if timer.taskType == comandName {
                timer.timer.invalidate()
                
                if let index = timers.index(where: {$0.taskType == comandName}) {
                    timers.remove(at: index)
                }
            } else {
                print("Timer with Procces not Runing..")
            }
        }
    }
    
    
    static  func start(timer:KUTimer, with comand:Comand ) {
        
        timer.isRunning = true
        timer.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.timerKU), userInfo:["KUComand":comand], repeats: true)
      
    }
    
    
    
    
    
    
    @objc static func timerKU(timer:Timer) {
        
        let timerUserInfo = timer.userInfo as! Dictionary<String, Comand>
        let comandToRun:Comand = timerUserInfo["KUComand"]!
 
        
        ComandsRuner.run(comand:comandToRun) { (results, comand) in
            ComandsRuner.comandsRunerDelegate?.finish(comand:comand, withResult:results)
        }
    }
    
    
    
    
    
    static  func timerStart() {
         timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        print("timerStart()")
    }
    
    
     static func timerStart2() {
        ComandsRuner.timer2 = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.timerAction2), userInfo: nil, repeats: true)
        print("timerStart2()")
    }
    
    
    
    @objc static func timerAction() {
        print("timer Action() ")
        
        ComandsRuner.run(comand:ComandsRuner.comand1) { (results, comand) in
            ComandsRuner.comandsRunerDelegate?.finish(comand:comand, withResult:results)
        }
    }
    
    @objc static func timerAction2() {
        print("timer Action2()")
        
        ComandsRuner.run(comand:ComandsRuner.comand2) { (results, comand) in
            ComandsRuner.comandsRunerDelegate?.finish(comand:comand, withResult:results)
        }
    }
    
    
    
}
