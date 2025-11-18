import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Inheritance (optional)

public enum qinherit {
  
  /// `: A, B, C`
  @inlinable @inline(__always)
  public static func types(_ inherited: TypeSyntax...) -> InheritanceClauseSyntax {
    types(inherited)
  }

  @inlinable @inline(__always)
  public static func types(_ inherited: [TypeSyntax]) -> InheritanceClauseSyntax {
    InheritanceClauseSyntax(
      colon: .colonToken(trailingTrivia: .space),
      inheritedTypes: InheritedTypeListSyntax(
        inherited.enumerated().map { index, type in
          InheritedTypeSyntax(
            type: type,
            trailingComma: index < inherited.count - 1 ? .commaToken(trailingTrivia: .space) : nil
          )
        }
      )
    )
  }
}
