
import UIKit
import CoreLocation

class SecurityHelper {
    
    enum PermissionType: Int {
        case camera
        case photoLibrary
        case location
        
        static func permissionType(for indexPath: IndexPath) -> PermissionType {
            switch indexPath.row {
            case 0:
                return .camera
            case 1:
                return .photoLibrary
            case 2:
                return .location
            default:
                return .camera
            }
        }
    }
    static func requestPermission(for permissionType: PermissionType, security: SecurityViewController) {
           switch permissionType {
           case .camera:
               security.requestCameraPermission()
           case .photoLibrary:
               security.requestPhotoLibraryPermission()
           case .location:
               security.requestLocationPermission()
           }
       }

       static func resetPermission(for permissionType: PermissionType, security: SecurityViewController) {
           switch permissionType {
           case .camera:
               security.resetCameraPermission()
           case .photoLibrary:
               security.resetPhotoLibraryPermission()
           case .location:
               security.resetLocationPermission()
           }
       }
    
    static func enableToggle(for permissionType: PermissionType, collectionView: UICollectionView) {
          switch permissionType {
          case .camera:
              enableCameraToggle(collectionView)
          case .photoLibrary:
              enablePhotoLibraryToggle(collectionView)
          case .location:
              enableLocationToggle(collectionView)
          }
      }

      public static func enableCameraToggle(_ collectionView: UICollectionView) {
          if let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 1)) as? SecuritySettingCell {
              cell.privacyView.switchControl.isOn = true
          }
      }

      public static func enablePhotoLibraryToggle(_ collectionView: UICollectionView) {
          if let cell = collectionView.cellForItem(at: IndexPath(item: 1, section: 1)) as? SecuritySettingCell {
              cell.privacyView.switchControl.isOn = true
          }
      }

      public static func enableLocationToggle(_ collectionView: UICollectionView) {
          let manager = CLLocationManager()
          manager.delegate = nil
          let locationAuthorizationStatus = manager.authorizationStatus
          let isLocationToggleOn = locationAuthorizationStatus == .authorizedAlways || locationAuthorizationStatus == .authorizedWhenInUse

          if let locationCell = collectionView.cellForItem(at: IndexPath(row: 2, section: 1)) as? SecuritySettingCell {
              locationCell.privacyView.switchControl.isOn = isLocationToggleOn
          }
      }
    
    static func openAppSettings() {
          if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(settingsURL, options: [:]) { _ in }
          }
      }
    
    static func openPhotoLibrarySettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL, options: [:]) { _ in }
        }
    }

    static func openLocationSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL, options: [:]) { _ in }
        }
    }
}
