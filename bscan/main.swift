import Foundation
import Cocoa
import IOBluetooth

var timeout = 20
var address = false
var name = false

class BlueDelegate : IOBluetoothDeviceInquiryDelegate {
    func deviceInquiryDeviceFound(sender: IOBluetoothDeviceInquiry!, device: IOBluetoothDevice!) {
        if (address) {
            print(device.addressString + (name ? " " + device.name : ""))
        } else if (name) {
            print(device.name)
        } else {
            print(device.nameOrAddress)
        }
    }
}


var args = CommandLine.arguments
if args.count > 1 {
    var i = 0
    while i < args.count{
        switch args[i] {
        case "-t": if args.count > i+1 { i = i + 1; let t = args[i]; timeout = Int(t)!}
        case "-a": address = true
        case "-n": name = true
        default:break
        }
        i += 1

    }
}

var delegate = BlueDelegate()
var inquiry = IOBluetoothDeviceInquiry(delegate: delegate)
inquiry?.updateNewDeviceNames = true
if (inquiry?.start() == kIOReturnSuccess) {
    sleep(UInt32(timeout))
    inquiry?.stop()
}
