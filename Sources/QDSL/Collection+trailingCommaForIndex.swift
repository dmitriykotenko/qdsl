import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


extension Collection {

  public var isNotEmpty: Bool { !isEmpty }

  public func filterNot(_ condition: (Element) -> Bool) -> [Element] {
    filter { !condition($0) }
  }

  @inlinable @inline(__always)
  public func trailingComma(forIndex index: Int) -> TokenSyntax? {
    index < (count - 1) ? .commaToken(trailingTrivia: .space) : nil
  }
}
