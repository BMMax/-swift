//: Playground - noun: a place where people can play

import UIKit

// 1 泛型介绍

func incrementArray(xs:[Int]) -> [Int] {
    var result: [Int] = []
    for x in xs{
        result.append(x + 1)
    }
    return result
}


func doubleArray(xs: [Int]) -> [Int] {
    var result: [Int] = []
    for x in xs{
        result.append(x * 2)
    }
    return result
}

func computeInArray(xs: [Int],transform: Int->Int) -> [Int] {
    var result: [Int] = []
    for x in xs{
    
        result.append(transform(x))
    
    }
    return result
}


func doubleArray2(xs: [Int]) -> [Int] {
    return computeInArray(xs){x in x * 2}
}

//func isEvenArray(xs: [Int]) -> [Bool] {
//    computeInArray(xs){x in x % 2 == 0}
//}

// “将 genericComputeArray<T> 理解为一个函数族”
// “类型参数 T 的每个选择都会确定一个新函数。该函数接受一个整型数组和一个 Int -> T 类型的函数作为参数，并返回一个 [T] 类型的数组。”

func genericComputeArray1<T>(xs:[Int],transform:Int->T) -> [T] {
    var result:[T] = []
    
    for x in xs {
        result.append(transform(x))
    }
    return result
}


//“一个 map 函数，它在两个维度都是通用的：对于任何 Element 的数组和 transform: Element -> T 函数，它都会生成一个 T 的新数组。”
//func map<Element,T>(xs:[Element],transform:Element->T) -> [T] {
//    var result:[T] = []
//    for x in xs {
//        result.append(transform(x))
//    }
//    return result
//}

// “函数的 transform 参数中所使用的 Element 类型源自于 Swift 的 Array 中对 Element 所进行的泛型定义。”
//extension Array{
//
//    func map<T>(transform:Element->T) -> [T] {
//        var result:[T] = []
//        for x in self {
//            result.append(transform(x))
//        }
//        return result
//    }
//}

func genericComputeArray<T>(xs:[Int],transform:Int->T) -> [T] {
    return xs.map(transform)
}

//extension Array{
//
//
//    func filter(includeElement:Element->Bool) -> [Element] {
//        var result:[Element] = []
//        for x in self where includeElement(x) {
//            result.append(x)
//            
//        }
//        return result
//    }
//
//
//}

func getSwiftFiles2(files:[String]) -> [String] {
    return files.filter{ file in
        file.hasPrefix(".swifft")}
}


//
struct City{

    let name: String
    let population: Int
}

let paris = City(name: "paris", population: 2241)
let madrid = City(name: "madrid", population: 3165)
let amsterdam = City(name: "Amsterdam", population: 817)
let berlin = City(name: "Berlin", population: 3562)

let citys = [paris,madrid,amsterdam,berlin]

//筛选居民数量至少一百万的城市
extension City{


    func cityByScalingPopulation() -> City {
        return City(name: name, population: population * 1000)
    }

}

citys.filter {$0.population>1000}.map{$0.cityByScalingPopulation()}.reduce("City:Populaytion"){result,c in return result + "\n" + "\(c.name):\(c.population)"}
