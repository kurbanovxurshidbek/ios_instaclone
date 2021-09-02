

import Foundation
import SwiftUI

class Utils {
    static var color1 = Color(red: 131/255, green: 58/255, blue: 180/255)
    static var color2 = Color(red: 193/255, green: 53/255, blue: 132/255)
    
    static var image1 = "https://lh6.googleusercontent.com/-9lzOk_OWZH0/URquoo4xYoI/AAAAAAAAAbs/AwgzHtNVCwU/s1024/Frantic.jpg"
    static var image2 = "https://lh4.googleusercontent.com/-JhFi4fb_Pqw/URquuX-QXbI/AAAAAAAAAbs/IXpYUxuweYM/s1024/Horseshoe%252520Bend.jpg"
    
    static func currentDate() -> String{
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = df.string(from: date)
        return dateString
    }
}

extension UIScreen{
   static let width = UIScreen.main.bounds.size.width
   static let height = UIScreen.main.bounds.size.height
   static let size = UIScreen.main.bounds.size
}
