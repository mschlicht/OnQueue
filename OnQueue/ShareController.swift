//
//  ShareController.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/23/24.
//

import CloudKit
import Foundation
import SwiftUI
import UIKit

struct CloudSharingView: UIViewControllerRepresentable {
    let share: CKShare
    let container: CKContainer
    let queue:Queue

    func makeCoordinator() -> CloudSharingCoordinator {
        CloudSharingCoordinator.shared
    }

    func makeUIViewController(context: Context) -> UICloudSharingController {
        share[CKShare.SystemFieldKey.title] = queue.title
        let controller = UICloudSharingController(share: share, container: container)
        controller.modalPresentationStyle = .formSheet
        controller.delegate = context.coordinator
        context.coordinator.queue = queue
        return controller
    }

    func updateUIViewController(_ uiViewController: UICloudSharingController, context: Context) {

    }
}

class CloudSharingCoordinator:NSObject,UICloudSharingControllerDelegate{
    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
        print("failed to save share\(error)")
    }

    func itemTitle(for csc: UICloudSharingController) -> String? {
        queue?.title
    }

    func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController){
        
    }

    func cloudSharingControllerDidStopSharing(_ csc: UICloudSharingController){

        guard let queue = queue else {return}
        if !stack.isOwner(object: queue) {
            do {
                try delete(queue)
            } catch {
                print(error)
            }
        }
        else {
            // 应该处理掉ckshare,目前不起作用。已提交feedback，希望官方提供正式的恢复方式。
            // 目前我的处理思路是，先对停止共享的托管对象（例如note）在本地进行Deep Copy（包含所有关系数据）
            // 然后调用purgeObjectsAndRecordsInZone删除网络上的共享自定义Zone
        }
    }
    static let shared = CloudSharingCoordinator()
    let stack = QueuesProvider.shared
    var queue:Queue?
    
    private func delete(_ queue: Queue) throws {
        let context = QueuesProvider.shared.viewContext
        let existingQueue = try context.existingObject(with: queue.objectID)
        context.delete(existingQueue)
        try context.save()
    }
}
