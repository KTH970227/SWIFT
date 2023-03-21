//미리 알림 모델 만들기
//[8] 모델 식별 가능하게 만들기

import Foundation

//[8] 프로토콜 선언 (:Identifiable)
struct Reminder : Identifiable {
    //[8] 기본값 인 String 속성 추가함.
    var id: String = UUID().uuidString
    var title: String
    var dueDate: Date
    var notes: String? = nil
    var isComplete: Bool = false
}

//[8] 미리 알림 배열에 확장을 추가
extension [Reminder] {
    //인수를 받아들이고 반환하는 이름이 지정된 함수를 만듦.
    func indexOfReminder(withId id: Reminder.ID) -> Self.Index {
        //guard 식별자와 일치하는 요소의 첫 번째 인덱스를 index 상수에 할당함.
        guard let index = firstIndex(where: { $0.id == id}) else {
            fatalError()
        }
        //일치하는 인덱스를 반환함.
        return index
    }
}

#if DEBUG //Debug 빌드에서 테스트할 경우 플래그 사용
extension Reminder {
    static var sampleData = [ //샘플 데이터 정적 배열로 정의
        Reminder(
            title: "Submit reimbursement", dueDate: Date().addingTimeInterval(800.0),
            notes: "Don't forget about taxi receipts"),
        Reminder(
            title: "Code review", dueDate: Date().addingTimeInterval(14000.0),
            notes: "Check tech specs in shared folder", isComplete: true),
        Reminder(
            title: "Pick up new contacts", dueDate: Date().addingTimeInterval(24000.0),
            notes: "Optometrist closes at 6:00PM"),
        Reminder(
            title: "Add notes to retrospective", dueDate: Date().addingTimeInterval(3200.0),
            notes: "Collaborate with project manager", isComplete: true),
        Reminder(
            title: "Interview new project manger candidate",
            dueDate: Date().addingTimeInterval(60000.0), notes: "Review protfolio"),
        Reminder(
            title: "Mock up onboarding experience", dueDate: Date().addingTimeInterval(72000.0),
            notes: "Think different"),
        Reminder(
            title: "Review usage analytics", dueDate: Date().addingTimeInterval(83000.0),
            notes: "Discuss trends with management"),
        Reminder(
            title: "Confirm group reservation", dueDate: Date().addingTimeInterval(92500.0),
            notes: "Ask about space heaters"),
        Reminder(
            title: "Add beta testers to TestFlight", dueDate: Date().addingTimeInterval(101000.0),
            notes: "v0.9 out on Friday")
    ]
}

#endif
