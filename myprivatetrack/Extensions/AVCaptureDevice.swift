/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit
import Photos

extension AVCaptureDevice {
    
    static func askCameraAuthorization(callback: @escaping (Result<Void, Error>) -> Void){
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case .authorized:
            callback(.success(()))
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video){ granted in
                if granted{
                    callback(.success(()))
                }
                else{
                    callback(.failure(AuthorizationError.rejected))
                }
            }
            break
        default:
            callback(.failure(AuthorizationError.rejected))
            break
        }
    }
    
    static func askAudioAuthorization(callback: @escaping (Result<Void, Error>) -> Void){
        switch AVCaptureDevice.authorizationStatus(for: .audio){
        case .authorized:
            callback(.success(()))
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio){ granted in
                if granted{
                    callback(.success(()))
                }
                else{
                    callback(.failure(AuthorizationError.rejected))
                }
            }
            break
        default:
            callback(.failure(AuthorizationError.rejected))
            break
        }
    }
    
    static func askVideoAuthorization(callback: @escaping (Result<Void, Error>) -> Void){
        askCameraAuthorization(){ result  in
            switch result{
            case .success(()):
                askAudioAuthorization(){ _ in
                    callback(.success(()))
                }
                return
            case .failure:
                callback(.failure(AuthorizationError.rejected))
                return
            }
        }
    }
    
}


extension AVCaptureDevice.DiscoverySession {
    
    var uniqueDevicePositionsCount: Int {
        
        var uniqueDevicePositions = [AVCaptureDevice.Position]()
        
        for device in devices where !uniqueDevicePositions.contains(device.position) {
            uniqueDevicePositions.append(device.position)
        }
        
        return uniqueDevicePositions.count
    }
    
}
