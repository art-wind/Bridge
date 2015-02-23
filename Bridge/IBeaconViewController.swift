//
//  IBeaconViewController.swift
//  Bridge
//
//  Created by 许Bill on 15-2-20.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
class IBeaconViewController: UIViewController,CBPeripheralManagerDelegate {
    
    
    var beaconRegion:CLBeaconRegion?
   var peripheralManager:CBPeripheralManager?
    
    @IBAction func pressToTransmit() {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initTheBeacons()
        // Do any additional setup after loading the view.
    }
    func initTheBeacons()
    {
        let st = "FA85FB34-C32A-4132-ACCC-C88EB1288CCF"
        let uuid:NSUUID = NSUUID(UUIDBytes: st)
        beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 1, minor: 2, identifier: "Bridge App")
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        if peripheral.state == CBPeripheralManagerState.PoweredOn {
            println("BroadCAast Normal")
        }else{
            self.peripheralManager?.stopAdvertising()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
