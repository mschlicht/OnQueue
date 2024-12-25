//
//  Delegate.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/23/24.
//

import Foundation
import SwiftUI
import CloudKit

final class AppDelegate:NSObject,UIApplicationDelegate{
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}

final class SceneDelegate:NSObject,UIWindowSceneDelegate{
    func windowScene(_ windowScene: UIWindowScene, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {
        let shareStore = QueuesProvider.shared.sharedPersistentStore
        let persistentContainer = QueuesProvider.shared.persistentContainer
        persistentContainer.acceptShareInvitations(from: [cloudKitShareMetadata], into: shareStore, completion: { metas,error in
            if let error = error {
                print("accepteShareInvitation error :\(error)")
            }
        })
    }
}
