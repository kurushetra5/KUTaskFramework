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
//    
//    public static var comandsRunerId:String!
    public static var comandsRunerDelegate:ComandsRunerDelegate!
    
    
    static var timer:Timer! //TODO: Sobra ? dict de comandos corriendo con id de timer para pararlo
    static var timer2:Timer!  //TODO: Sobra ? dict de comandos corriendo con id de timer para pararlo
    static var comand1:Comand! //TODO: Sobra ? dict de comandos corriendo con id de timer para pararlo
    static var comand2:Comand! //TODO: Sobra ? dict de comandos corriendo con id de timer para pararlo
    static var praser:Prasable! //TODO: Sobra ? lo paso en el ennum
    //    static var forEverComandsRuning:[Comand] = []
    
    var timers:[KUTimer] = []
    
    
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
        let comandForRun:Comand  = GenericComand(praser: praser, type:.generic, taskPath: comand, taskArgs:args)
        
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
//            print(result)
            completion(comand.praser.prase(comandResult:result) )
        }
    }
    
    
    public static func stopForEver(comand:Comand!) {
        
        if timer  != nil {
            timer.invalidate()
            
        }
    }
    
    
    
    
    
    
    
    
  //MARK: ---------------------- PRIVATE API ---------------------------
    
  private  static func run(comand:Comand, forEver:Bool ,completion:@escaping ([String]) -> Void) {
        
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
//                print(results)
//                print(comand)
                completion(results)
                
            })
           
        }
        
    }
    
    
    
private static func run(comand:Comand, completion:@escaping ([String],ComandType) -> Void) {
        
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
