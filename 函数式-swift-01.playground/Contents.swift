//: Playground - noun: a place where people can play

import UIKit

// 位于原点的船舶射程范围的点
// 1 定义两种类型 Distance & Position
typealias Distance = Double

struct Position {
    var x : Double
    var y : Double
}

// 2 在positon中添加一个函数inRange,来检验一个点是否在灰色区域内
extension Position{

    func inRange(range:Distance) -> Bool {
        return sqrt(x * x + y * y) <= range
    }
}

// 3 允许船有它自己的位置
struct Ship{
    var position : Position
    var firingRange : Distance
    var unsafeRange : Distance
}

// 4 添加一个canEngageShip, 允许我们检验是否有另一搜船在范围内
extension Ship{

    func canEngageShip(target: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance <= firingRange
        
    }

}

// 5 避免目标船离太近

extension Ship {

    func canSafelyEngageShip(target: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance <= firingRange && targetDistance >= unsafeRange
    }
}

// 6 避免地方过于接近友方船舶
extension Ship{

    func canSafelyEngageShip1(target: Ship,friendly: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx - dy * dy)
        let friendlyDx = friendly.position.x - target.position.y
        let friendlyDy = friendly.position.y - friendly.position.y
        let friendlyDistance = sqrt(friendlyDx * friendlyDx + friendlyDy * friendlyDy)
        
        return targetDistance <= friendlyDistance &&
                targetDistance > unsafeRange &&
                (friendlyDistance > unsafeRange)
    }
}

// 7 给posion添加负责几何运算的辅助函数

extension Position{

    func minus(p:Position) -> Position {
        return Position(x:x - p.x,y: y - p.y)
    }

    var length: Double{
    
        return sqrt(x * x + y * y)
    }
    
}

// 8 改修改ship
extension Ship{
    
    func canSafelyEngageShip2(target: Ship,friendly : Ship) -> Bool {
        let targetDistance = target.position.minus(position).length
        let friendlyDistance = friendly.position.minus(target.position).length
        return targetDistance <= firingRange && targetDistance >= unsafeRange && friendlyDistance > unsafeRange
    }

}

// : ## 优化
// (1)定义一个点是否在范围内
// fun pointInRange(point: Position)->Bool{

    //方法实现
//}

//1 .Region 类型将指代把 Position 转化为 Bool 的函数”
//“在 Swift 中函数是一等值”
typealias Region = Position ->Bool

//2 定义第一个区域是以原点为圆心的圆
func circle(redius: Distance) -> Region {
    return {point in point.length <= redius}
}

func circle2(redius: Distance,center: Position) -> Region {
    return {point in point.minus(center).length <= redius}
}
//“如果我们想对更多的图形组件(例如，想象我们不仅有圆，还有矩形或其它形状)做出同样的改变，可能需要重复这些代码。更加函数式的方式是写一个区域变换函数”
func shift(region: Region,offset:Position) -> Region {
    return { point in region(point.minus(offset)) }
}

func invert(region: Region) -> Region {
    return{point in !region(point)}
}
//“两个函数分别可以计算参数中两个区域的交集和并集：”
func intersection(region1:Region,region2:Region)->Region{

    return {point in region1(point) && region2(point)}

}

func union(region1:Region,region2:Region) -> Region {
    return{point in region1(point) || region2(point)}
}

// “difference 函数接受两个区域作为参数 —— 原来的区域和要减去的区域 —— 然后为所有在第一个区域中且不在第二个区域中的点构建一个新的区域：”

func difference(region: Region,minus:Region) -> Region {
    return intersection(region, region2: invert(minus))
}

extension Ship {

    func canSaefEngageShip(target:Ship,friendly:Ship) -> Bool {
        let rangeRegion = difference(circle(firingRange), minus: circle(unsafeRange))
        let firingRegion = shift(rangeRegion, offset: position)
        let friendlyRegion = shift(circle(unsafeRange), offset: friendly.position)
        let resultRegion = difference(firingRegion, minus: friendlyRegion)
        
        return resultRegion(target.position)

    }
}
