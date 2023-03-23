//[49] 그라데이션 배경 만들기

import UIKit

extension CAGradientLayer {
    //[49]
    static func gradientLayer(for style: ReminderListStyle, in frame: CGRect) -> Self {
        //[49] 새 layer 상수를 추가
        let layer = Self()
        //[49] 결과를 colors(for:) 레이어의 colors 속성에 할당함
        layer.colors = colors(for: style)
        //[49] frame 레이어의 속성에 frame를 할당함
        layer.frame = frame
        //[49] layer를 반환함
        return layer
    }
    
    //[49] listStyle을 허용하고 CGColor의 배열을 반환하는 정적 함수
    private static func colors(for style: ReminderListStyle) -> [CGColor] {
        //[49]
        let beginColor: UIColor
        let endColor: UIColor
        
        //[49] 분할된 컨트롤의 각 필더(Today, Future 및 All)에 대해 시작 및 종료 색상을 할당하는 케이스
        switch style {
        case .all:
            beginColor = UIColor(red: 0.6, green: 0.2, blue: 0.6, alpha: 0.5)
            endColor = UIColor(red: 0.9, green: 0.2, blue: 0.9, alpha: 1.0)
        case .future:
            beginColor = UIColor(red: 0.2, green: 0.2, blue: 0.6, alpha: 0.5)
            endColor = UIColor(red: 0.2, green: 0.2, blue: 0.9, alpha: 1.0)
        case .today:
            beginColor = UIColor(red: 0.6, green: 0.2, blue: 0.2, alpha: 0.5)
            endColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0)
        }
        //[49] 시작 객체와 종료 CGColor 객체를 포함하는 배열을 반환함.
        return [beginColor.cgColor, endColor.cgColor]
    }
}
