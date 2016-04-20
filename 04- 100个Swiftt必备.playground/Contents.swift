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






