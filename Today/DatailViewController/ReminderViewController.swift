//[13] 알림 보기 만들기
//[14] 행에 대한 열거 생성
//[15] 데이터 소스 설정
//[16] 스냅샷 설정
//[18] 탐색 모음 스타일 지정
//[19] 편집 모드용 섹션 만들기
//[20] 보기 및 편집 모드 구성
//[21] 편집 버튼 추가
//[22] 편집 모드에서 헤더 표시
//[23] 구성 방법 추출
//[28] 콘텐츠 보기 표시
//[29] 날짜 및 메모에 대한 콘텐츠 보기 만들기
//[30] 작업 알림 추가
//[34] 편집 취소
//[35] 뷰 계층 구조의 변경 사항 관찰
//[36] 미리 알림 추가 및 삭제

import UIKit

class ReminderViewController: UICollectionViewController {
    //[15] 유형 별칭을 만듦. + [19] 별칭 변경 Int -> Section
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    //[16] 유형 별칭 변경  + [19] 별칭 변경 Int -> Section
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    //[13] 변수 속성 추가함.
    //var reminder: Reminder
    //[35] 핸들러를 호출하는 미리 알림에 관찰자를 추가함.
    var reminder: Reminder {
        didSet {
            onChange(reminder)
        }
    }
        
    //[30] 속성 추가
    var workingReminder: Reminder
    //[36] 특성 추가 및 초기값 설정
    var isAddingNewReminder = false
    //[35] 속성 추가
    var onChange: (Reminder) -> Void
    //[15] 속성 추가
    private var dataSource: DataSource!
    
    //[13] 이니셜라이저를 만듦(미리 알림을 수락하고 속성을 초기화함)
    //[35] @escaping 매개변수를 추가함. (onChange: @escaping (Reminder) -> Void)
    init(reminder: Reminder, onChange: @escaping (Reminder) -> Void) {
        self.reminder = reminder
        //[30] 알림 매개변수 초기 내용을 속성에 복사함.
        self.workingReminder = reminder
        //[35]
        self.onChange = onChange
        //UICollectionLayoutListConfiguration를 사용하여 목록 구성을 만들고 결과를 listConfiguration변수에 할당
        var listConfiguration = UICollectionLayoutListConfiguration(appearance:  .insetGrouped)
        //목록 구성에서 구분 기호를 비활성화 및 목록 셀 사이의 줄을 제거함.
        listConfiguration.showsSeparators = false
        //[22] 목록 구성의 headerMode를 설정
        listConfiguration.headerMode = .firstItemInSection
        //목록 구성을 사용하여 구성 목록 레이아웃을 만들고 결과를 listLayout 상수에 할당함.(목록 구성 레이아웃: 목록에 필요한 레이아웃 정보만 포함)
        let listLayout = UICollectionViewCompositionalLayout.list(using:  listConfiguration)
        //새 목록 레이아웃을 전달하여 수퍼클래스의 init를 호출함.
        super.init(collectionViewLayout:  listLayout)
    }
    
    //[13] 필요한 실패할 수 있는 이니셜라이즈 생성함(결과는 성공 or nil초기화 실패 시 초기화된 개체를 포함함)
    //미리 알림 보기 컨트롤러를 만들기 때문에 앱은 이 이니셜라이저를 사용하지 않음.
    required init?(coder: NSCoder) {
        fatalError("Always inialize ReminderViewController using init(reminder:)")
    }
    
    //[15] viewDidLoad 재정의
    override func viewDidLoad() {
        super.viewDidLoad()
        //핸들러를 사용하여 새 셀 등록을 만들고 결과를 .cellRegistration 상수에 할당함.
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        //재사용 가능한 셀을 대기열에서 빼는 새 데이터 소를 만든 후 결과를 .dataSource에 할당함.
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        //[18] .navigator앱이 iOS 16.0이상에서 실행될 때 탐색 모음의 스타일을 설정함.
        if #available(iOS 16, *) {
            navigationItem.style = .navigator
        }
        
        //[18] 탐색 제목을 변경함.
        navigationItem.title = NSLocalizedString("Reminder", comment: "Reminder view controller title")
        //[21] 탐색 항목의 속성에 할당함.
        navigationItem.rightBarButtonItem = editButtonItem
        
        
        //[16] 스냅샷 업데이트 진행함.
        //[20] 리펙토리 updateSnapshot() -> updateSnapshotForViewing()
        updateSnapshotForViewing()
    }
    
    //[21] 재정의 및 슈퍼클래스의 구현을 호출함.
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            //updateSnapshotForEditing()
            //[30]
            prepareForEditing()
        } else {
            //updateSnapshotForViewing()
            //[30]
            //prepareForViewing()
            //[36] 편집모드 종료 시 호출
            if isAddingNewReminder {
                onChange(workingReminder)
            } else {
                prepareForViewing()
            }
        }
    }
    
    //[15] 셀, 인덱스 경로 및 행을 허용하는 메서드를 만듦.
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        //[20] 인덱스 경로에서 섹션을 검색함.
        let section = section(for: indexPath)
        //[20] 다른 섹션 및 행 조합에 대해 셀을 구성하려면 튜플을 사용하여 switch문을 추가함.
        switch (section, row) {
        //[22] 헤더 행과 일치하는 사례를 추가하고 헤더 행의 관련 값을 title상수에 저장함.
        case (_, .header(let title)):
            //var contentConfiguration = cell.defaultContentConfiguration()   //[22] 셀의 기본 구성을 검색하고 변수에 저장함.
            //contentConfiguration.text = title                               //[22] title 콘텐츠 구성의 속성을 할당함.
            //cell.contentConfiguration = contentConfiguration                //[22] 셀의 속성에 새 구성을 할당함.
            //[23] 새 함수 호출함. + row -> title로 변경
            cell.contentConfiguration = headerConfiguration(for: cell, with: title)
            
        //섹션 .view의 모든 행과 일치하는 사례를 추가함.
        case (.view, _):
            //셀의 기본 구성을 .contentConfiguration 변수에 할당함.
            //var contentConfiguration = cell.defaultContentConfiguration()
            //행의 적합한 텍스트 및 글꼴을 구성함.
            //contentConfiguration.text = text(for: row)
            //contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
            //이전 섹션에서 정의한 행의 image 계산된 변수를 구성 및 image 속성에 할당함.
            //contentConfiguration.image = row.image
            //셀 속성에 구성을 할당함.
            //cell.contentConfiguration = contentConfiguration
            
            //[23] defaultConfiguration에서 case에 대한 기존 코드를 새 함수에 대한 호출로 변경함.
            cell.contentConfiguration = defaultConfiguration(for: cell, at: row)
            
        //[28] case 추가
        case (.title, .editableText(let title)):
            cell.contentConfiguration = titleConfiguration(for: cell, with: title) //[28] 셀 구성에 새 제목 구성을 할당함.
            
        //[29] 새 구성 방법을 호출하는 날짜 및 메모에 대한 사례를 추가하고 해당 출력을 관련 목록 셀 구성에 할당함.
        case (.date, .editableDate(let date)):
            cell.contentConfiguration = dateConfiguration(for: cell, with: date)
        case (.notes, .editableText(let notes)):
            cell.contentConfiguration = notesConfiguration(for: cell, with: notes)
            
        default: //예기치 않은 행이나 섹션을 일치시키려고 시도하는 경우 호출됨.
            fatalError("Unexpected combination of section and row.")
        }

        //셀의 속성에 할당함.
        cell.tintColor = UIColor(red: 0.3, green: 0.8, blue: 0.3, alpha: 0.5) //목록 세부정보 아이콘 색상
    }
    
    
    //[14] 해당의 행과 관련된 텍스트를 반환하는 이름이 지정된 함수 + ReminderViewController+CellConfiguration.swift로 이동
    //func text(for row: Row) -> String? {
    //    switch row {
    //    case .date: return reminder.dueDate.dayText
    //    case .notes: return reminder.notes
    //    case .time: return reminder.dueDate.formatted(date: .omitted, time: .shortened)
    //    case .title: return reminder.title
    //    //[22] default 추가
    //   default: return nil
    //    }
    //}
    
    //[34]
    @objc func didCancelEdit() {
        //[34] reminder에 할당함
        workingReminder = reminder
        //[34] ViewController의 함수를 전달하여 편집 모드를 종료함.
        setEditing(false, animated: true)
    }
    
    //[30]
    private func prepareForEditing() {
        //[34] 취소 버튼을 왼쪽 탐색 모음 버튼 항목으로 할당함.(사용자가 취소 버튼을 누를 때 트리거할 작업을 선택함)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel, target: self, action: #selector(didCancelEdit))
        updateSnapshotForEditing()
    }
    
    //[20] 함수를 만들고 새 스냅샷을 초기화함.
    private func updateSnapshotForEditing() {
        var snapshot = Snapshot()
        //스냅샷에 섹션 .title, .date, .notes 추가함.
        snapshot.appendSections([.title, .date, .notes])
        //[28] editableText의 섹션 항목 추가
        snapshot.appendItems([.header(Section.title.name), .editableText(reminder.title)], toSection: .title)
        
        //[22] 각 섹션에 헤더 항목을 추가
        //snapshot.appendItems([.header(Section.title.name)], toSection:  .title)
        //snapshot.appendItems([.header(Section.date.name)], toSection:  .date)
        //snapshot.appendItems([.header(Section.notes.name)], toSection:  .notes)
        
        //[29] 알림 날짜 및 메모에 대한 항목을 추가
        snapshot.appendItems([.header(Section.date.name), .editableDate(reminder.dueDate)], toSection: .date)
        snapshot.appendItems([.header(Section.notes.name), .editableText(reminder.notes)], toSection: .notes)
        
        //스냅샷을 데이터 소스에 적용함.
        dataSource.apply(snapshot)
    }
    
    //[30]
    private func prepareForViewing() {
        //[34] 왼쪽 막대 버튼 항목을 제거함
        navigationItem.leftBarButtonItem = nil
        
        //[30] 미리 알림을 업데이트함
        if workingReminder != reminder {
            reminder = workingReminder
        }
        updateSnapshotForViewing()
    }
    
    //[16] 스냅샷 업데이트 함수 + [20] 리펙토리 함수명 변경: updateSnapshot -> updateSnapshotForViewing
    private func updateSnapshotForViewing() {
        //새 스냅샷을 만들고 snapshot 변수에 할당함.
        var snapshot = Snapshot()
        //첫 번째이자 유일한 섹션을 스냅샷에 추가함. + [19] 섹션 .updateSnapshot().view을 추가하는 방법을 변경 0 -> .view
        snapshot.appendSections([.view])
        //Row 스냅샷에 항목으로 4개의 인스턴스를 제공함.  + [19] 섹션 .updateSnapshot().view을 추가하는 방법을 변경 0 -> .view
        //[22] 빈 머리글 항목을 스냅샷 항목의 첫번째 요소로 삽입한다.
        snapshot.appendItems( [Row.header(""), Row.title, Row.date, Row.time, Row.notes], toSection: .view)
        
        //스냅샷을 데이터 소스를 적용함
        dataSource.apply(snapshot)
    }
    
    //[19] section(for:)인덱스 경로를 받는 함수
    private func section(for indexPath: IndexPath) -> Section {
        //인덱스 경로를 사용하여 섹션 번호를 생성함.
        let sectionNumber = isEditing ? indexPath.section + 1 : indexPath.section
        //섹션 번호를 사용하여 section의 인스턴스를 만듦.
        guard let section = Section(rawValue: sectionNumber) else {
            fatalError("Unable to find matching section")
        }
        return section
    }
}
