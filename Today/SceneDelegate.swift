import UIKit
//[1] 컬렉션을 목록으로 구성
//[2] 데이터 소스 구성
//[3] 스냅샷 적용
//[4] 날짜 및 시간 형식 지정
//[5] 보기 컨트롤러 구성
//[6] 셀 배경색 변경
//[7] 미리 알림 완료 상태 표시
//[8] 모델 식별 가능하게 만들기
//[9] 사용자 정의 버튼 동작 만들기
//[10] 타겟-액션 쌍 연결
//[11] 스냅샷 업데이트
//[12] 작업을 액세스 가능하게 만들기
//[13] 알림 보기 만들기
//[14] 행에 대한 열거 생성
//[15] 데이터 소스 설정
//[16] 스냅샷 설정
//[17] 상세보기 표시
//[18] 탐색 모음 스타일 지정
//[19] 편집 모드용 섹션 만들기
//[20] 보기 및 편집 모드 구성
//[21] 편집 버튼 추가
//[22] 편집 모드에서 헤더 표시
//[23] 구성 방법 추출
//[24] 재사용 가능한 레이아웃 기능 만들기
//[25] 텍스트 필드가 있는 사용자 지정 보기 만들기
//[26] 콘텐츠 보기 프로토콜 준수
//[27] 콘텐츠 보기 완료
//[28] 콘텐츠 보기 표시
//[29] 날짜 및 메모에 대한 콘텐츠 보기 만들기
//[30] 작업 알림 추가
//[31] 텍스트 구성을 편집 가능하게 만들기
//[32] 날짜 구성을 편집 가능하게 만들기
//[33] 메모 구성을 편집 가능하게 만들기
//[34] 편집 취소
//[35] 뷰 계층 구조의 변경 사항 관찰
//[36] 미리 알림 추가 및 삭제
//[37] 타겟-액션 쌍 연결
//[38] 모델에 새 미리 알림 추가
//[39] 미리 알림 삭제
//[40] 미리 알림 필터링
//[41] 목록 스타일로 미리 알림 필터링
//[42] 분할된 컨트롤 표시
//[43] 세분화된 컨트롤에 작업 추가
//[44] 관계형 제약 조건 생성
//[45] 진행률 원 모양 사용자 지정
//[46] 머리글 보기 표시
//[47] 진행 상황을 동적으로 업데이트
//[48] 진행률 보기를 액세스 가능하게 만들기
//[49] 그라데이션 배경 만들기
//[50] 목록에 그라디언트 레이어 추가
//[51] 미리 알림을 비동기식으로 가져오기
//[52] 모델 유형 간 변환
//[53] 알림 저장소 만들기
//[54] 모든 알림 읽기
//[55] 미리 알림 데이터에 대한 액세스 요청
//[56] 사용자에게 오류표시
//[57] 미리 알림 표시
//[58] 변경 알림에 응답


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

