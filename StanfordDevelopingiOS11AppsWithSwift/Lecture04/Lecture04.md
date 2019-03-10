#  Swift 补充

将 Concentration 由 class 改为 struct，Concentration.chooseCard() 加入关键字 mutating； 
设置 Card 遵循 Hashable 协议，将Card.identifier改为private；
将 viewcontroller.emoji 的 key 由 Int 改为 Card ，因为Card遵循Hashable协议，而字典类型的键遵循Hashable协议。
Concentration.chooseCard()中可以用==判断两个Card对象是否相等。
将emojiChoice由 [String] 改为 String ，修改代码以使用Sting的索引。  
使用NSAttributeSting自定义flipCountLabel字符串的样式，注意VCc的属性和@IBOutlet属性何时回触发didSet。
对Collection协议扩展，添加oneAndOnly属性，用于返回Collection的唯一元素（Int、Set、Dictionary都遵循Collection协议）。
对Concentration.IndexOfOneAndOnlyFaceUpCard的get修改，首先对Concentration.cards使用.filter方法，根据isFaceUp筛选出正面朝上的cards，随后返回oneAndOnly属性。
