//[24] 재사용 가능한 레이아웃 기능 만들기

import UIKit

extension UIView {
    //[24] 하위 보기, 높이 및 삽입을 허용하는 함수
    func addPinnedSubview(
        _ subview: UIView, height: CGFloat? = nil,
        insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    ) {
        //[24] 하위 보기를 추가함.
        addSubview(subview)
        
        //[24] 비활성화하면 시스템이 보기에 대한 자동 제약 조건을 생성하지 않음.
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        //[24] 상단 앵커 제약 조건을 추가 및 활성화하여 하위 뷰를 상위 뷰 상단에 고정함.
        subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top).isActive = true
        
        //[24] 선행 앵커 제약 조건을 지정 및 활성화하여 하위 보기의 선행 가장자리에 패딩을 추가함.
        subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left).isActive = true
        
        //[24] 후행 앵커 제약 조건을 지정 및 활성화하여 하위 보기의 후행 가장자리에 패딩을 추가함.
        subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1.0 * insets.right).isActive = true
        
        //[24] 아래쪽 앵커 제약 조건을 정의 및 활성화하여 하위 보기의 아래쪽에 패딩을 추가함.
        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1.0 * insets.bottom).isActive = true
        
        //[24] 호출자가 명시적으로 함수에 높이를 제공하는 경우 하위 뷰를 해당 높이로 제한함.
        //하위 뷰는 상위 뷰의 상단과 하단에 고정되어 있고, 하위 뷰의 높이를 조정하면 상위 뷰도 높이를 조정해야 한다.
        if let height {
            subview.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
