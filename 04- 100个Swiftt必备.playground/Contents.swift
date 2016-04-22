//: Playground - noun: a place where people can play

import UIKit

//1 currying
func addOne(num: Int) ->Int{

    return num + 1
}

// 1.2 定义一个通用的函数,它将接受需要与数字相加的数-返回一个函数
// 返回的函数接受输入数字本身,然后进行操作:
func addTo(adder: Int) ->Int ->Int{

    return {
    
        num in return num + adder
    }
    
}

let addTwo = addTo(2)
let result = addTwo(6)
let result1 = addTo(4)(3)


// 1.3 比较两个数的大小

func greaterThan(comparer:Int) -> Int ->Bool {
    return {$0 > comparer}
}

let greaterThan10 = greaterThan(10)(9)
let greaterThan9 = greaterThan(9)(13)

func LessThan(comparer:Int) -> (Int ->Bool) {
    return{y in return y < comparer}
}

let lessThan10 = LessThan(10)(9)

//////////////////////////////////////////////////////////////////////////////
//////////////////////02-将protocol的方法声明为mutation/////////////////////////
//////////////////////////////////////////////////////////////////////////////
// swift 的protocol 不仅可以被class类型实现,也适用于struct 和 enum. so 在写给别人的接口
// 时需要多考虑是否使用mutation

// 02.1 
protocol Vehicle
{
     var numberOfWheels: Int{get}
    var color: UIColor {get set}
    mutating func changeColor()
}

//“把 protocol 定义中的 mutating 去掉的话，MyCar 就怎么都过不了编译了”
struct MyCar: Vehicle {
    let numberOfWheels: Int = 4
    var color: UIColor = UIColor.blueColor()
    mutating func changeColor() {
        color = UIColor.redColor()
    }
    
}


//////////////////////////////////////////////////////////////////////////////
//////////////////////03-static 和 class/////////////////////////
//////////////////////////////////////////////////////////////////////////////

// swift 中表示"类型范围作用域" 分别是static 和 class
// 在非class 的类型上下文中,统一使用static来描述类型作用域,这包括emum 和 struct 中表述类型方法
// 和类型属性. 在这两个值类型中,我们可以在类型范围内申明并使用存储属性. 计算属性和方法

struct Point {
    let x : Double
    let y : Double
    
    // 存储属性
    static let zero = Point(x: 0, y: 0)
    
    // 计算属性
    static var ones: [Point]{
    
        return [Point(x: 1, y: 1),
                Point(x: -1, y: 1),
                Point(x: 1, y: -1),
                Point(x: -1, y: -1)
        ]
        
    }
    
    
    // 类型方法
    static func add(p1: Point, p2: Point)->Point{
    
        return Point(x: p1.x + p2.x, y: p1.y + p2.y)
    }
    
}

// class 中不能出现class 的存储属性的,
//class MyClass{
//    class var bar : Bar?
//    }
//}

// 在protocol中,在swift中class,struct,enum 都是可以实现某个protocol的
// 在protocol里定义一个类型域上的方法或者计算属性的话,应该用static进行定义
// 在struct 和 enum中 仍然使用static , 而在class中 既可以用class,也可以用static都一样

protocol MyProtocol {
    static func foo()->String
}


struct MyStruct:MyProtocol {
    static func foo() -> String {
        return "MyStruct"
    }
}

enum MyEnum:MyProtocol {
    static func foo() -> String {
        return "MyEnum"
    }
}

class MyClass: MyProtocol {
    // 在class中可以使用class
    static func foo() -> String {
        return "MyClass.foo()"
    }
    
    
}


//////////////////////////////////////////////////////////////////////////////
//////////////////////04- selector/////////////////////////
//////////////////////////////////////////////////////////////////////////////
// 从2.2开始,使用#selector来暴露给objective-c的代码中来获取一个seletor

 private func callMe() {
    //------
}
 private func callMeWithParam(obj:AnyObject)  {
    //.......
}

//注意: seletor其实是oc runtime的概念,如果你的seletor对应的方法只有在swift中可见的
//(也就是说它是一个swift中的private方法)在调用这个selector时你会遇到unrecognize selector的
//
//let someMethod = #selector(callMe)
//let anotherMethod = #selector(callMeWithParam(_:))

func turnByAngle(theAngle:Int,speed: Float) {
    //......
}

//let method = #selector(turnByAngle(_:speed:))


//NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(callMe), userInfo: nil, repeats: true)

//



// 如果方法名字在方法所在域中是唯一的话,我们可以简单只是用方法的名字来作为#seletor的内容

// “let someMethod = #selector(callMe)
//  let anotherMethod = #selector(callMeWithParam)
//  let method = #selector(turnByAngle)”

// 对应名字相同,函数签名不同的可以使用强转

func commonFunc() {
    
}

func commonFunc(input: Int) -> Int {
    /// 
    return 1
}

/*
private struct Action{

    static let buttonTapped = #selector(Viewcontroller.buttonTaped(_:))

}

button.addTarget(self,action:Action.buttonTapped,forControlEvents: .TouchUpInside)
*/
/*
 
 private extension Selector {
 static let buttonTapped =
 #selector(ViewController.buttonTapped(_:))
 }
 ...
 button.addTarget(self, action: .buttonTapped,
 forControlEvents: .TouchUpInside)
 
 */

//
//let method1 = #selector(commonFunc as ()->())
//let method2 = #selector(commonFunc as Int ->Int)


//////////////////////////////////////////////////////////////////////////////
//////////////////////04-实例方法的动态调用/////////////////////////
//////////////////////////////////////////////////////////////////////////////

class ourClass {
    
    func method(number: Int) -> Int {
        return number + 1
    }
    
}

// oc中如果调用method方法,需要生成ourClass的实例,然后用.method来调用它

let object = ourClass()
let resultO = object.method(1)

let f = ourClass.method  //(Int)->Int
let obj = ourClass()
let res = f(object)(1)
//只能用于实例方法
let re = ourClass.method(ourClass())(1)

// 当我们遇到类型方法的名字有冲突的时候

class oursClass {
    func method(number: Int) -> Int {
        return number + 1
    }
    
    class func method(number: Int)  ->Int{
        return number
    }
    
}


//如果不加改动,oursClass.method讲获取的是类型方法,如果要获取实例的方法,可以显示地加上类型声明

let f1 = oursClass.method
// class func method的版本
let f2: Int->Int = oursClass.method
// 跟f1一样

let f3: oursClass->Int->Int = oursClass.method
let re33 = f3(oursClass())(1)


//////////////////////////////////////////////////////////////////////////////
//////////////////////04-单例/////////////////////////
//////////////////////////////////////////////////////////////////////////////

// oc 写法

class MyManager {
    class var sharedManager: MyManager{
        
        
        // swift1.2之前并不支持存储类型的类属性,需要用一个struct来存储类型变量
        struct Static {
            static var oneToken: dispatch_once_t = 0
            static var staticInstance: MyManager? = nil
        }
        
        dispatch_once(&Static.oneToken){
        
            Static.staticInstance = MyManager()
        }
    
        return Static.staticInstance!
    }
}

// 使用let简化

class MyManager1 {
    class var shareManager: MyManager1 {
        struct Static {
            static let shareInstance: MyManager1 = MyManager1()
        }
    return Static.shareInstance
    }
}

// swift1.2之前
//在swift1.2之前class不支持存储式的property,
//private let shareInstance = MyManager2()
//class MyManager2 {
//    class var sharedManager:MyManager2 {
//        return shareInstance
//    }
//}

// swift1.2之后
class MyManager3 {
    static let sharedInstance = MyManager3()
    private init(){}
}
//////////////////////////////////////////////////////////////////////////////
//////////////////////05-sting 和 NSString/////////////////////////
//////////////////////////////////////////////////////////////////////////////

let levels = "ABCDE"
for i in levels.characters{

    print(i)
}

// containString

if (levels as NSString).containsString("BC"){
    print("包含")

}

// 跟NSRange配合用NSSting
let nsRange = NSMakeRange(1, 4)
(levels as NSString).stringByReplacingCharactersInRange(nsRange, withString: "AAAA")



