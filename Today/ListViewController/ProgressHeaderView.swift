//[44] 관계형 제약 조건 생성
//[45] 진행률 원 모양 사용자 지정
//[46] 머리글 보기 표시
//[47] 진행 상황을 동적으로 업데이트
//[48] 진행률 보기를 액세스 가능하게 만들기

import UIKit

class ProgressHeaderView: UICollectionReusableView {
    //[46]
    static var elementKind: String { UICollectionView.elementKindSectionHeader }
    
    //[44] 기본값이 0인 progress 추가함
    var progress: CGFloat = 0 {
        //[45] progress의 값이 변경될 때 하단 뷰의 높이 제한을 업데이트함
        didSet {
            //[48]
            setNeedsLayout()
            
            heightConstraint?.constant = progress * bounds.height
            //[45] 애니메이션 블록을 생성하도록 호출하여 View에 대한 변경 사항을 애니메이션화한 후 ViewAnimation 클로저를 호출함.
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.layoutIfNeeded()
            }
        }
    }
    
    //[44] 프레임 view를 0으로 초기화함
    private let upperView = UIView(frame: .zero)
    private let lowerView = UIView(frame: .zero)
    private let containerView = UIView(frame: .zero)
    
    //[45] 속성 추가
    private var heightConstraint: NSLayoutConstraint?
    
    //[48]
    private var valueFormat: String {
        NSLocalizedString("%d percent", comment: "progress percentage value format")
    }
    
    //[45] 재정의 및 일부 사용자 지정 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        //[45] 이니셜라이저를 호출함.
        prepareSubview()
        
        //[48]
        isAccessibilityElement = true
        //[48] 지역화된 문자열을 할당함
        accessibilityLabel = NSLocalizedString("Progress", comment: "Progress view accessibility label")
        //[48] update 값으로 설정함
        accessibilityTraits.update(with: .updatesFrequently)
    }
    
    //[45] 실패 이니셜라이저
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //[45] 재정의 및 superView의 구현을 호출함.
    override func layoutSubviews() {
        super.layoutSubviews()
        //[48] 값 및 값 포맷터를 사용하여 새 문자열을 할당함
        accessibilityValue = String(format: valueFormat, Int(progress * 100.0))
        
        //[47] 높이 제약 조건의 상수를 업데이트함
        heightConstraint?.constant = progress * bounds.height
        
        //[45] containerView의 레이어에서 활성화하고 모서리 반경을 조정함.
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 0.5 * containerView.bounds.width
    }
    
    //[44] containerView 구조에 하위 뷰를 추가하는 함수
    private func prepareSubview() {
        containerView.addSubview(upperView)
        containerView.addSubview(lowerView)
        addSubview(containerView)
        
        //[44] lowerView에 대한 제약 조건을 수정할 수 있도록 lowerView에 대해 비활성화함.
        upperView.translatesAutoresizingMaskIntoConstraints = false
        lowerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        //[44] superView와 containerView에 대해 1:1 고정 영상비를 유지함.
        heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1).isActive = true
        
        //[44] layOut 프레임에서 containerView를 수평 및 수직 중앙에 배치함
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        //[44] 진행률 headerView 크기의 85%로 containerView를 확장함.
        containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85).isActive = true
        
        //[44] lowerView를 세로로 제한함(상단 앵커를 진행 headerView의 상단 앵커로, 하단 앵커를 진행 headerView 하단 앵커로 설정함)
        upperView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        upperView.bottomAnchor.constraint(equalTo: lowerView.topAnchor).isActive = true
        lowerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        //[44] 선행 및 후행 앵커를 진행률 headerView와 동일하게 설정 및 lowerView를 수평으로 제한함
        upperView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        upperView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        lowerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        lowerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        //[45] lowerView에 대해 조정 가능한 높이 제약 조건을 만들고 높이 앵커에 시작 크기를 할당함.
        heightConstraint = lowerView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.isActive = true
        
        //[45] View 배경색 설정함
        backgroundColor = .clear
        containerView.backgroundColor = .clear
        upperView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.3)
        lowerView.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 0.75)
    }
}
