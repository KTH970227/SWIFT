//[1] 컬렉션을 목록으로 구성
//[2] 데이터 소스 구성
//[3] 스냅샷 적용
//[5] 보기 컨트롤러 구성
//[8] 모델 식별 가능하게 만들기

import UIKit

class ReminderListViewController: UICollectionViewController {
//    //[3] diff 가능한 데이터 소스 스냅샷에 대한 유형 별칭 추가함.
//    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
//    //[2] diffable 데이터 소스에 대한 별칭을 추가함.
//    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    //[2] 암시적으로 래핑을 해제하는 속성을 추가함.
    var dataSource: DataSource!
    
    //[8] reminders 인스턴스 배열을 저장하는 속성을 추가 및 샘플 데이터로 배열을 초기화함.
    var reminders: [Reminder] = Reminder.sampleData
    
    override func viewDidLoad() {
        //View Controller가 View 계층 구조를 메모리에 로드한 후 시스템은 [.viewDidLoad()]를 실행
        super.viewDidLoad()

        //[1] 컬렉션 보기 레이아웃에 목록 레이아웃을 할당함.
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        //[2] 새 셀 등록을 만듦.
//        let cellRegistration = UICollectionView.CellRegistration {
//            (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: String) in
//            //항목에 해당하는 미리 알림을 검색함.
//            let reminder = Reminder.sampleData[indexPath.item]
//            //셀의 기본 콘텐츠 구성을 검색함.
//            var contentConfiguartion = cell.defaultContentConfiguration()
//            //콘텐츠 구성 텍스트에 할당함.
//            contentConfiguartion.text = reminder.title
//            //콘텐츠 구성을 셀에 할당함.
//            cell.contentConfiguration = contentConfiguartion
//        }
        //[5] 클로저를 제거 후 새 함수를 핸들러 매개변수로 전달함.
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        
        //[2] 새 데이터 원본을 만듦. + [8] 데이터 소스 이니셜라이저의 유형을 String -> Reminder.ID로 변경
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in
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
        
        //[11]
        updateSnapshot()
        
        //[3] 콜렉션 보기에 데이터 소스를 지정함.
        collectionView.dataSource = dataSource
    }

    //[1] Collect 단위 : Item -> Group -> Section 메커니즘을 가지고 있음.
    private func listLayout() -> UICollectionViewCompositionalLayout {
        //목록 레이아웃에 [섹션] 만들기
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .darkGray
        
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }

}

