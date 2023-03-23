//[1] 컬렉션을 목록으로 구성
//[2] 데이터 소스 구성
//[3] 스냅샷 적용
//[5] 보기 컨트롤러 구성
//[8] 모델 식별 가능하게 만들기
//[17] 상세보기 표시
//[35] 뷰 계층 구조의 변경 사항 관찰
//[37] 타겟-액션 쌍 연결
//[39] 미리 알림 삭제
//[41] 목록 스타일로 미리 알림 필터링
//[42] 분할된 컨트롤 표시
//[43] 세분화된 컨트롤에 작업 추가
//[46] 머리글 보기 표시
//[47] 진행 상황을 동적으로 업데이트
//[50] 목록에 그라디언트 레이어 추가
//[56] 사용자에게 오류표시
//[57] 미리 알림 표시

import UIKit

class ReminderListViewController: UICollectionViewController {
//    //[3] diff 가능한 데이터 소스 스냅샷에 대한 유형 별칭 추가함.
//    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
//    //[2] diffable 데이터 소스에 대한 별칭을 추가함.
//    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    
    //[2] 암시적으로 래핑을 해제하는 속성을 추가함.
    var dataSource: DataSource!
    

    //[8] reminders 인스턴스 배열을 저장하는 속성을 추가 및 sampleData로 배열을 초기화함.
    //[57] 빈 배열 추가 Reminder.sampleData -> []
    var reminders: [Reminder] = []
    
    //[41] 속성 추가
    var listStyle: ReminderListStyle = .today
    
    //[41] 지정된 목록 스타일에 대한 미리 알림 컬렉션을 반환하는 계산된 속성을 추가함.
    var filteredReminders: [Reminder] {
        return reminders.filter { listStyle.shouldInclude(date: $0.dueDate) }.sorted {
            //[41] 기한별로 필터링된 미리 알림을 정렬
            $0.dueDate < $1.dueDate
        }
    }
    
    //[42] listStyle의 이름으로 초기화 및 이름이 지정된 속성으로 저장함.
    let listStyleSegumentedControl = UISegmentedControl(items: [
        ReminderListStyle.today.name, ReminderListStyle.future.name, ReminderListStyle.all.name
    ])
    
    //[46]
    var headerView: ProgressHeaderView?
    
    //[47]
    var progress: CGFloat {
        //[47] 각 미리 알림이 나타내는 배열의 비율을 계산하고, 값을 chunkSize 로컬 상수에 저장함
        let chunkSize = 1.0 / CGFloat(filteredReminders.count)
        
        //[47] 미리 알림의 백분율을 계산함
        let progress = filteredReminders.reduce(0.0) {
            let chunk = $1.isComplete ? chunkSize : 0
            return $0 + chunk
        }
        //[47] 진행 상황을 반환함
        return progress
    }
    
    override func viewDidLoad() {
        //View Controller가 View 계층 구조를 메모리에 로드한 후 시스템은 [.viewDidLoad()]를 실행
        super.viewDidLoad()
        
        //[46] collectionView 배경색 설정
        collectionView.backgroundColor = UIColor(red: 0.1, green: 1.0, blue: 0.1, alpha: 0.9)
        
        //[1] 컬렉션 보기 레이아웃에 목록 레이아웃을 할당함.
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout

        //[2] 새 셀 등록을 만듦.
//        let cellRegistration = UICollectionView.CellRegistration {
//            (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: String) in
//            //항목에 해당하는 미리 알림을 검색함.
//            let reminder = Reminder.sampleData[indexPath.item]
//            //셀의 기본 contentConfiguration을 검색함.
//            var contentConfiguartion = cell.defaultContentConfiguration()
//            //contentConfiguartion.text에 할당함.
//            contentConfiguartion.text = reminder.title
//            //contentConfiguration을 셀에 할당함.
//            cell.contentConfiguration = contentConfiguartion
//        }
        //[5] 클로저를 제거 후 새 함수를 핸들러 매개변수로 전달함.
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)


        //[2] 새 데이터 원본을 만듦. + [8] 데이터 소스 이니셜라이저의 유형을 String -> Reminder.ID로 변경
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in
            //셀 등록을 사용하여 셀을 대기열에서 제거하고 반환함.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }

        //[3] 스냅샷 변수 만듦.
        //var snapshot = Snapshot()
        //[3] 스냅샷에 섹션을 추가함.
        //snapshot.appendSections([0])
        //[3] 미리 알림 제목만 포함하는 새 배열을 만들고 제목을 스냅샷의 항목으로 추가함. (한줄로 코드 줄임)
        //[8] 배열을 사용하여 스냅샷을 구성함.(reminders.idto 대신 속성에 매핑하여 title 식별자 배열을 만듬) Reminder.sampleData.map { $0.title } -> reminders.map { $0.id }
        //var reminderTitles = [String]()
        //for reminder in Reminder.sampleData {
        //    reminderTitles.append(reminder.title)
        //}
        //snapshot.appendItems(reminderTitles)
        //snapshot.appendItems(reminders.map { $0.id })

        //[3] 스냅샷을 데이터 소스에 적용함.
        //dataSource.apply(snapshot)
        
        //[46] headerView를 View로 등록함
        let headerRegistration = UICollectionView.SupplementaryRegistration(
            elementKind: ProgressHeaderView.elementKind, handler: supplementaryRegistrationHandler)
        
        //[46] 새 headerView 등록을 사용하는 데이터 소스에 보충 View 클로저를 추가함.
        dataSource.supplementaryViewProvider = { supplementaryView, elementKind, indexPath in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: indexPath)
        }
        
        //[37] 선택기를 호출하는 추가 버튼에 대한 새 항목을 만듦.
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(didPressAddButton(_:)))
            
        //[37] 버튼에 접근성 레이블을 추가함.
        addButton.accessibilityLabel = NSLocalizedString(
            "Add reminder", comment: "Add button accessibility label")
        
        //[37] navigationItem의 오른쪽 막대 버튼 항목에 버튼을 할당함.
        navigationItem.rightBarButtonItem = addButton
        
        //[42] Control의 선택된 segmentIndex를 listStyle.rawValue로 설정함
        listStyleSegumentedControl.selectedSegmentIndex = listStyle.rawValue
        
        //[43] 세그먼트화된 컨트롤에 대한 대상 개체 및 작업 방법을 구상함.
        listStyleSegumentedControl.addTarget(self, action: #selector(didChangeListStyle(_:)), for: .valueChanged)
        
        //[42] listStyleSegumentedControl을 탐색 항목의 titleView에 할당함.
        navigationItem.titleView = listStyleSegumentedControl
        
        //[37] iOS 16.0이상에서 실행되는 스타일을 설정함
        if #available(iOS 16, *) {
            navigationItem.style = .navigator
        }
        
        //[11]
        updateSnapshot()

        //[3] collectionView에 dataSource를 지정함.
        collectionView.dataSource = dataSource
        
        //[57]
        prepareReminderStore()
    }
    
    //[50] 재정의 및 호출
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshBackground()
    }
    
    //[17] 사용자가 선택한 항목을 탭한 항목이 표지되지 않으므로 false를 반환 및 대신 해당 목록 항목에 대한 세부 정보 보기로 전환하는 함수
    override func collectionView(
        _ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        //이 인덱스 경로와 연결된 미리 알림의 ID(식별자)를 검색하고 id 상수에 할당함.
        //let id = reminders[indexPath.item].id
        //[41] reminders -> filteredReminders 변경
        let id = filteredReminders[indexPath.item].id
        
        //.pushDetailViewForReminder 함수 호출함.
        pushDetailViewForReminder(withId: id)
        return false
    }
    
    //[47]
    override func collectionView(
        _ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView,
        forElementKind elementKind: String, at indexPath: IndexPath
    ) {
        //[47] guard 요소 종류가 progressView인지 확인함
        guard elementKind == ProgressHeaderView.elementKind,
              let progressView = view as? ProgressHeaderView
        else {
            return
        }
        
        //[47] progress의 속성을 업데이트함.
        progressView.progress = progress
    }
    
    //[50]
    func refreshBackground() {
        //[50] collectionView의 속성에 nil 할당함
        collectionView.backgroundView = nil
        
        //[50] UIView backgroundView 상수 추가
        let backgroundView = UIView()
        
        //[50] CAGradientLayer gradientLayer 상수 추가
        let gradientLayer = CAGradientLayer.gradientLayer(for: listStyle, in: collectionView.frame)
        
        //[50] backgroundView의 레이어에 하위 레이어로 추가
        backgroundView.layer.addSublayer(gradientLayer)
        
        //[50] collectionView의 속성에 할당함
        collectionView.backgroundView = backgroundView
    }
    
    
    //[17] 미리 알림 식별자를 허용하는 함수
    func pushDetailViewForReminder(withId id: Reminder.ID) {
        //모델의 미리 알림 배열에서 ID(식별자)와 일치하는 미리 알림을 검색하고 .reminder 상수에 할당함.
        let reminder = reminder(withId: id)
        
        //새 세부 제어기를 만들고 이름이 지정된 .viewControllor 상수에 할당함.
        //[35] 핸들러 추가함.([weak self] reminder in)
        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            //편집된 미리 알림을 반영하도록 사용자 인터페이스를 업데이트함.
            self?.updateReminder(reminder)
            self?.updateSnapshot(reloading: [reminder.id])
        }
        
        //viewController를 navigationController 스택으로 푸시함.(ViewController가 현재 navigationController에 포함되어 있으면 navigationController에 대한 참조가 optional 속성에 저장됨)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //[56]
    func showError(_ error: Error) {
        //[56] 경고 제목 상수
        let alertTitle = NSLocalizedString("Error", comment: "Error alert title")
        //[56] 제목, 오류 및 스타일을 사용하여 경고 컨트롤러 만듦.
        let alert = UIAlertController(
            title: alertTitle, message: error.localizedDescription, preferredStyle: .alert)
        //[56] 작업의 제목
        let actionTitle = NSLocalizedString("OK", comment: "Alert OK button title")
        //[56] 작업 제목과 ViewController를 해제하는 클로저를 사용하여 경고에 액션을 추가함
        alert.addAction(
            UIAlertAction(
                title: actionTitle, style: .default,
                handler: { [weak self] _ in
                    self?.dismiss(animated: true)
        }))
        //[56] 경고 컨트롤러 활성화
        present(alert, animated: true, completion: nil)
    }
    
    //[1] Collect 단위 : Item -> Group -> Section 메커니즘을 가지고 있음.
    private func listLayout() -> UICollectionViewCompositionalLayout {
        //목록 레이아웃에 [섹션] 만들기
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        //[46] headermode 변경하여 header 정의함
        listConfiguration.headerMode = .supplementary
        
        listConfiguration.showsSeparators = false
        
        //[39] listConfiguration 설정(사용자가 셀의 앞쪽 가장 자리를 살짝 밀 때 표시할 작업을 제공하는 속성도 존재)
        listConfiguration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        
        listConfiguration.backgroundColor = .clear

        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    //[39] optional을 반환하는 함수
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        //[39] 데이터 소스에서 항목 식별자를 검색함.
        guard let indexPath = indexPath, let id = dataSource.itemIdentifier(for: indexPath) else {
            return nil
        }
        //[39] 작업의 제목을 만듦.
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action titile")
        
        //[39] 데이터 삭제 시 스타일 설정
        let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) {
            [weak self] _, _, completion in
            //[39] 완료 처리기에서 식별자에 해당하는 미리 알림을 삭제함.
            self?.deleteReminder(withId: id)
            //[39] 스냅샷 업데이트함
            self?.updateSnapshot()
            //[39] 완료 처리기를 호출함
            completion(false)
        }
        //[39] 삭제 작업을 사용하여 새 스와이프 작업 구성 개체를 반환함
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    //[46] 파일 맨 아래에 진행률 headerView, elementKind, indexPath를 허용하는 함수(들어오는 progressView를 headerView 속성에 할당함)
    private func supplementaryRegistrationHandler(
        progressView: ProgressHeaderView, elementKind: String, indexPath: IndexPath
    ) {
        headerView = progressView
    }
}

