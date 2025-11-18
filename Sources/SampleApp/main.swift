import Foundation
import SampleMacros
import NonEmpty


extension Array {

  func flatten<NestedElement>() -> [NestedElement] where Element == [NestedElement] {
    flatMap { $0 }
  }
}


func run() {
  let p1: Result<Pair, SampleError> = Pair<[Int], Bool>.tryInit(elements: .success([1]))
  let p2: Result<Pair2, SampleError> = Pair2<Int, Double>.tryInit(second: .failure(.instance))
  let p3: Result<Pair3, SampleError> = Pair3<String, Character>.tryInit(false)

  let t: Result<Triple, SampleError> = Triple.tryInit(abc: .success(1.23))

  let m1: Result<Money, SampleError> = Money.tryInit.roubles(.success(1))
  let m2: Result<Money, SampleError> = Money.tryInit.euros(amount: .success(2), fakeness: .failure(.instance))
  let m3: Result<Money, SampleError> = Money.tryInit.pounds(.success(3))
}


@TryInit
open class Pair<Third, Fourth> {

  var first: String?
  var second: Int
  var third: Third? = nil

  private init(_ first: String? = nil,
               _: Bool = false,
               second: Int) {
    self.first = first
    self.second = second
    self.third = nil
  }

  public init<Element: Equatable>(elements: [Element]) where Third == [Element] {
    self.first = ""
    self.second = 55555
    self.third = elements
  }
}


@TryInit
open class Pair2<First, Second> {

  var first: First?
  var second: Second

  init!(_: Bool = false,
        _ first: First? = nil,
        second: Second) {
    self.first = first
    self.second = second
  }

  public required init?(firstAndSecond: (First?, Second)) throws {
    self.first = firstAndSecond.0
    self.second = firstAndSecond.1
  }

  init<Element: Hashable>(elements: Set<Element>) where Second == [Element] {
    self.first = nil
    self.second = elements.map { $0 }
  }
}


@TryInit
open class Pair3<Third, Fourth> {

  var first: String?
  var second: Int
  var third: Third? = nil

  init(first _: String? = nil,
       _: Bool = false,
       _ _: Float = 0.5) {
    self.first = ""
    self.second = 333
  }

  fileprivate init(first _: String? = nil,
                   _: Bool = false,
                   third: Float = 0.5) {
    self.first = nil
    self.second = 333
  }
}


@TryInit
public struct Triple {

  var first: String?
  var second: Bool
  var third: (Int) -> Bool  = { $0 % 2 == 0 }

  init(abc: Double) {
    self.first = nil
    self.second = false
    self.third = { _ in false }
  }
}


@TryInit
public enum Money {

  case nothing
  case roubles(Int),
       euros(amount: Int, fakeness: Double), almostNothing
  case pounds(Int, royalness: Double = 999)

  private init(euros: Int) {
    self = .euros(amount: euros, fakeness: 1)
  }

  private static let sample = Self.init(euros: 20)
}


public protocol ComposableError: Error {

  static func composed(from children: NonEmpty<[String: Self]>) -> Self
}


public enum SampleError: ComposableError {

  case instance
  case composed(from: NonEmpty<[String: SampleError]>)
}


extension Result {

  var asError: Failure? {
    switch self {
    case .success: nil
    case .failure(let error): error
    }
  }
}
