//[18] 탐색 모음 스타일 지정

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.
        //[18] 열기기능 및 내비게이션 바 기본 모양의 색상 변경함.
        UINavigationBar.appearance().tintColor = UIColor(red: 0.2, green: 0.2, blue: 0.9, alpha: 1.0)
        //[18] 탐색 모음 기본 모양의 배경색을 변경함.
        UINavigationBar.appearance().backgroundColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 0.6)
        //[18] 새 .UINavigationBarAppearancenavBar 를 만들고 navBarAppearance 상수에 할당
        let navBarAppearance = UINavigationBarAppearance()
        //[18] 인스턴스 함수를 호출하여 현재 테마에 적합한 색상으로 탐색 모음을 구성함.
        navBarAppearance.configureWithOpaqueBackground()
        //[18] 새 모양을 기본 스크롤 가장 자리 모양으로 만듦.
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        print("test");
    }
}
