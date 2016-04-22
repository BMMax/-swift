//: Playground - noun: a place where people can play

import UIKit


typealias Filter = CIImage -> CIImage
// func myFilter()->Filter

//1 高斯模糊滤镜,只需要模糊半径这一个参数

//“blur 函数返回一个新函数，新函数接受一个 CIImage 类型的参数 image，并返回一个新图像 (return filter.outputImage)。因此，blur 函数的返回值满足我们之前定义的 CIImage -> CIImage，也就是 Filter 类型。”

func blur(radius: Double)->Filter{
    
    return{image in
        let parameters = [kCIInputRadiusKey : radius,kCIInputImageKey : image]
        guard let filter = CIFilter(name: "CIGaussianBlur",withInputParameters: parameters)else{fatalError()}
        guard let outPutImage = filter.outputImage else{fatalError()}
        return outPutImage
        }

}

// 2 颜色叠层
//“颜色生成滤镜 (CIConstantColorGenerator) 和图像覆盖合成滤镜 (CISourceOverCompositing)”
// 定义一个能够在图像上覆盖纯色叠层的滤镜
//2.1生成固定颜色的滤镜
//“这段代码看起来和我们用来定义模糊滤镜的代码非常相似，但是有一个显著的区别：颜色生成滤镜不检查输入图像。因此，我们不需要给返回函数中的图像参数命名。取而代之，我们使用一个匿名参数 _ 来强调滤镜的输入图像参数是被忽略的。”

func colorGenerator(color: UIColor) -> Filter {
    return { _ in
        let c = CIColor(color: color)
        let parameters = [kCIInputColorKey: c]
        guard let filter = CIFilter(name: "CIConstantColorGenerator",
                                    withInputParameters: parameters) else { fatalError() }
        guard let outputImage = filter.outputImage else { fatalError() }
        return outputImage
    }
}


// 2.2 定义合成滤镜
func compositeSourceOver(overlay: CIImage) -> Filter {
    return { image in
        let parameters = [
            kCIInputBackgroundImageKey: image,
            kCIInputImageKey: overlay
        ]
        guard let filter = CIFilter(name: "CISourceOverCompositing",
                                    withInputParameters: parameters) else { fatalError() }
        guard let outputImage = filter.outputImage else { fatalError() }
        let cropRect = image.extent
        return outputImage.imageByCroppingToRect(cropRect)
    }
}

// 2.3创建颜色叠层滤镜
//“colorOverlay 函数首先调用了 colorGenerator 滤镜。colorGenerator 滤镜需要一个 color 作为参数，然后返回一个新的滤镜，因此代码片段 colorGenerator(color) 是 Filter 类型。而 Filter 类型本身就是一个从 CIImage 到 CIImage 的函数；因此我们可以向 colorGenerator(color) 函数传递一个附加的 CIImage 类型的参数，最终我们能够得到一个 CIImage 类型的新叠层。这就是我们在定义 overlay 的过程中所发生的全部事情事，可以大致概括为 —— 首先使用 colorGenerator 函数创建一个滤镜，接着向这个滤镜传递一个 image 参数来创建新图像。与之类似，返回值 compositeSourceOver(overlay)(image) 由一个通过 compositeSourceOver(overlay) 函数构建的滤镜和随即被作为参数的 image 组成。”

func colorOverlay(color: UIColor) -> Filter {
    return { image in
        let overlay = colorGenerator(color)(image)
        return compositeSourceOver(overlay)(image)
    }
}

func composeFilters(filter1:Filter,_ filter2:Filter) -> Filter {
    return {image in filter2(filter1(image))}
}



let url = NSURL(string: "http://www.objc.io/images/covers/16.jpg")!
let image = CIImage(contentsOfURL: url)!
let blurRadius = 5.0
let overlayColor = UIColor.redColor().colorWithAlphaComponent(0.2)
let blurredImage = blur(blurRadius)(image)
//let overlaidImage = colorOverlay(overlayColor)(blurredImage)


let myFilter1 = composeFilters(blur(blurRadius), colorOverlay(overlayColor))
//let result1 = myFilter1(image)

infix operator >>> {associativity left}

func >>>(filter1:Filter,filter2:Filter) -> Filter {
    return {image in filter2(filter1(image))}
}

func  add1(x:Int, _ y:Int) -> Int {
    return x + y
}

// “这里的 add2 函数接受第一个参数 x 之后，返回一个闭包，然后等待第二个参数 y。这两个 add 函数的调用方法自然也是不同的：

//add1(1, 2)
//add2(1)(2)

func add2(x:Int) -> (Int ->Int) {
    return {y in return x + y}
}

add2(1)(2)
add1(1,2)
