//: Playground - noun: a place where people can play

import UIKit

//1 currying
func addOne(num: Int) ->Int{

    return num + 1
}

// 2 定义一个通用的函数,它将接受需要与数字相加的数-返回一个函数
// 返回的函数接受输入数字本身,然后进行操作:
func addTo(adder: Int) ->Int ->Int{

    return {
    
        num in return num + adder
    }
    
}

let addTwo = addTo(2)
let result = addTwo(6)
let result1 = addTo(4)(3)


// 3 比较两个数的大小

func greaterThan(comparer:Int) -> Int ->Bool {
    return {$0 > comparer}
}

let greaterThan10 = greaterThan(10)(9)
let greaterThan9 = greaterThan(9)(13)

func LessThan(comparer:Int) -> (Int ->Bool) {
    return{y in return y < comparer}
}

let lessThan10 = LessThan(10)(9)




