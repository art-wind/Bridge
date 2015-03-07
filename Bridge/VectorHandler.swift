//
//  VectorHandler.swift
//  Bridge
//
//  Created by 许Bill on 15-3-5.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import Foundation
class VectorHandler {
    let length = Vector().properties.count
    let adjustRate = 0.1
    
    
    func getVector(array:[String])->[Double]{
        let property = Vector.getVectorList()
        var ret = [Double]()
        for i in 0..<length{
            var found = false
            for j in 0..<array.count
            {
                if property[i] == array[j] {
                    ret.append(1.0)
                    found = true
                    break
                }
            }
            if found == false{
                ret.append(0.0)
            }
        }
        return formalize(vectorToBeFormalized: ret)
    }
    func computeSimilarity(user:User,activity:Activity)->Double
    {
        var ret = 0.0
        let vecFromUser = user.vector
        let vecFromActivity = activity.vector!
        
        for i in 0..<length{
            ret += vecFromUser[i] * vecFromActivity[i]
        }
        return ret
    }
    func adjustUserAfterFollowActity(user:User,activity:Activity){
        let vecFromUser = user.vector
        let vecFromActivity = activity.vector!
        println(vecFromUser )
        println(vecFromActivity)
        var difference = vectorMinus(array: vecFromActivity, arrayToMinus: vecFromUser)
        let modifiedDiffer = difference.map { (num) -> Double in
            return num * self.adjustRate
        }
        let adjustedVector = vectorPlus(array: vecFromUser, arrayToPlus: modifiedDiffer)
        
        
        
//        let user = PFUser(withoutDataWithObjectId: objectID)
//        
        let objectID = user.ID
        var query = PFUser.query()
        query.getObjectInBackgroundWithId(objectID) {
            (user: PFObject!, error: NSError!) -> Void in
            if error != nil {
                println(error)
            } else {
                user["vector"] = adjustedVector
                println(adjustedVector)
                user.saveInBackground()
            }
        }
        
        
        user.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                println("User has been saved.")
            }
        }
    }
    func computeModuleValue(vectorToBeModuled:[Double])->Double{
        var ret = 0.0
        for i in vectorToBeModuled {
            ret += pow(i, 2.0)
        }
        return ret
    }
    func formalize(vectorToBeFormalized vector:[Double])->[Double]{
        var ret = [Double]()
        let moduleValue = computeModuleValue(vector)
        if moduleValue == 0 {

            for _ in 0..<length {
                ret.append(0)
            }
            return ret
        }
        else{
            ret = vector.map(){
                return sqrt($0/moduleValue)
            }
            
            return ret
        }
       
    }
    func vectorMinus(array arr1:[Double],arrayToMinus arr2:[Double])->[Double]{
        if arr1.count != arr2.count{
            println("Problem for two vector Minus")
        }
        else{
            var ret = [Double]()
            for i in 0..<length{
                ret.append(arr1[i]-arr2[i])
            }
            return ret
        }
        return [Double]()
    }
    func vectorPlus(array arr1:[Double],arrayToPlus arr2:[Double])->[Double]{
        if arr1.count != arr2.count{
            println("Problem for two vector Plus" )
        }
        else{
            var ret = [Double]()
            for i in 0..<length{
                ret.append(arr1[i]+arr2[i])
            }
            return ret
        }
        return [Double]()
    }
    func vectorMulti(array arr1:[Double],arrayToMulti arr2:[Double])->Double{
        if arr1.count != arr2.count{
            println("Problem for two vector")
        }
        else{
            var ret = 0.0
            for i in 0..<length{
                ret += (arr1[i]*arr2[i])
            }
            return ret
        }
        return 0.0
    }

}