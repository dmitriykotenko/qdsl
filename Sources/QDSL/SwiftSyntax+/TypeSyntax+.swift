import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


extension TypeSyntax {

  @inlinable @inline(__always)
  public var withEscapingIfNecessary: TypeSyntax {
    guard self.is(FunctionTypeSyntax.self) else { return self }

    return TypeSyntax(
      AttributedTypeSyntax(
        specifiers: [],
        attributes: AttributeListSyntax([.attribute(_escapingAttribute())]),
        baseType: self
      )
    )
  }

  @inlinable @inline(__always)
  public var withoutEscapingIfNecessary: TypeSyntax {
    guard var result = self.as(AttributedTypeSyntax.self) else { return self }

    result.attributes = []

    return TypeSyntax(result)
  }
}


@inlinable @inline(__always)
public func _escapingAttribute() -> AttributeSyntax {
  AttributeSyntax(
    atSign: .atSignToken(),
    attributeName: IdentifierTypeSyntax(name: .identifier("escaping"))
  )
}
