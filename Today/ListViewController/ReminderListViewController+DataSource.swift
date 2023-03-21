//[5] 보기 컨트롤러 구성
//[6] 셀 배경색 변경
//[7] 미리 알림 완료 상태 표시
//[8] 모델 식별 가능하게 만들기
//[9] 사용자 정의 버튼 동작 만들기
//[10] 타겟-액션 쌍 연결
//[11] 스냅샷 업데이트

import UIKit

//미리 알림 목록에 대한 데이터 소스 역할을 하는 모든 동작이 포함되어 있음.
extension ReminderListViewController {
    //[5] 유형 별칭 정의함. -> 미리 알림 데이터에 대한 비교 및 가느안 데이터 소스 및 스냅샷을 정의
    //[2] diffable 데이터 소스에 대한 별칭을 추가함.  + [8] 데이터 소스 및 스냅샷 유형 별칭의 항목 식별자 유형으로 변경함. String -> Reminder.ID
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    //[3] diff 가능한 데이터 소스 스냅샷에 대한 유형 별칭 추가함. + [8] 데이터 소스 및 스냅샷 유형 별칭의 항목 식별자 유형으로 변경함. String -> Reminder.ID
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>
    
    //[11] 미리 알림 목록 보기 컨트롤러의 메서드에서 이전 단계에서 만든 메서드로 스냅샷 코드를 추출하는 함수.
    func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(reminders.map { $0.id })
        dataSource.apply(snapshot)
    }
    
    //[5] 셀, 인덱스 경로 및 .cellRegistration Handlerid + [8] 매개변수 목록에서 식별자 유형으로 변경함. String -> Reminder.ID
    func cellRegistrationHandler(
        cell:
            UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID
    ) {
        //셀 등록 클로저에서 내용을 추출하고 새 메서드 삽입 + [8] reminders 샘플 데이터 대신 새 배열에서 미리 알림을 검색함. Reminder.sampleData[indexPath.item] -> reminders[indexPath.item] + [8] 새 메서드를 사용하여 제공된 id, reminders[indexPath.item] -> reminder(withId: id)
        let reminder = reminder(withId: id)
        var contentConfiguaration = cell.defaultContentConfiguration()
        contentConfiguaration.text = reminder.title
        contentConfiguaration.secondaryText = reminder.dueDate.dayAndTimeText                               //미리 알림 기한을 콘텐츠 구성의 보조 텍스트에 할당함.
        contentConfiguaration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)  //보조 텍스트 글꼴을 .caption1로 설정
        cell.contentConfiguration  = contentConfiguaration
        
        //[6] 셀 등록 처리기에서 새 단추 구성 메서드를 호출하여 미리 알림을 전달하고 결과를 doneButtonConfiguration 변수에 할당함.
        var doneButtonConfiguration = doneButtonConfiguration(for: reminder)
        //[6] 완료버튼 구성의 속성에 할당함. ( UIColor = todayListCellBackground)
        doneButtonConfiguration.tintColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
        //[6] 셀 배열을 만들고 셀 accessories 속성에 할당함.
        cell.accessories = [
            .customView(configuration: doneButtonConfiguration), .disclosureIndicator(displayed: .always)
        ]
        
        //배경 설정값을 지정된 변수에 담음.
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        //배경 설정의 속성에 색상을 할당함. ( UIColor = todayListCellBackground)
        backgroundConfiguration.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        cell.backgroundConfiguration = backgroundConfiguration
    }
    //[8] 미리 알림 식별자를 수락하고 미리 알림 배열에서 해당 미리 알림을 반환하는 이름이 지정된 메서드를 만듦.
    func reminder(withId id: Reminder.ID) -> Reminder {
        let index = reminders.indexOfReminder(withId: id)
        return reminders[index]
    }
    //[8] 미리 알림을 수락하고 해당 배열 요소를 미리 알림 내용으로 업데이트하는 함수.
    func updateReminder(_ reminder: Reminder) {
        let index = reminders.indexOfReminder(withId: reminder.id)
        reminders[index] = reminder
    }
    //[9] 모델에서 미리 알림을 가져와 사용하는 함수. + 버튼을 눌렀을 때 호출됨.
    func completeReminder(withId id: Reminder.ID) {
        //.reminder(withId:)를 호출하여 미리 알림을 가져옴.
        var reminder = reminder(withId: id)
        //미리 알림의 속성을 전환함.
        reminder.isComplete.toggle()
        //모델에서 미리 알림을 업데이트 시 .updateReminder(_:)를 호출해야 함.
        updateReminder(reminder)
        //[11]
        updateSnapshot()
    }
    
    
    //[6] 미리 알림을 수락
    private func doneButtonConfiguration(for reminder: Reminder)
    -> UICellAccessory.CustomViewConfiguration
    {
        //삼항 조건 연산자로 상수에 할당함.
        let symbolName = reminder.isComplete ? "circle.fill" : "circle"
        //텍스트 스타일을 사용하여 새 이미지를 만들고, 결과를 .title1상수에 할당함.
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        //심볼 구성을 사용하여 새 이미지를 만들고 그 결과를 image상수에 할당함.
        let image = UIImage(systemName: symbolName, withConfiguration:  symbolConfiguration)
        //새 버튼을 만들고 button상수에 할당함. + [10] 새 클래스를 사용하도록 할당을 변경함.(UIButton()->ReminderDoneButton())
        let button = ReminderDoneButton()

        //[10] 를 호출하여 버튼의 이벤트를 액션 메서드에 연결함.
        button.addTarget(self, action: #selector(didPressDoneButton(_:)), for: .touchUpInside)
        //[10] 미리 알림의 식별자를 버튼의 id속성에 할당함.
        button.id = reminder.id
        
        //버튼 .normal상태에 대한 이미지를 할당함.
        button.setImage(image, for: .normal)
        
        //버튼을 사용하여 사용자 지정보기 구성을 만들고, 결과를 반환함.
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
    }
    
}
