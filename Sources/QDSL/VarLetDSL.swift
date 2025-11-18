import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - var / let and typealias decls

public enum qdecls {

  /// `var name: Type = value`
  @inlinable @inline(__always)
  public static func `var`(_ name: String,
                           modifiers: DeclModifierListSyntax = [],
                           _ type: TypeSyntax? = nil,
                           _ initializer: InitializerClauseSyntax? = nil) -> DeclSyntax {
    varLet(false, modifiers: modifiers, name, type, initializer)
  }

  /// `var name: Type = value`
  @inlinable @inline(__always)
  public static func `var`(_ name: TokenSyntax,
                           modifiers: DeclModifierListSyntax = [],
                           _ type: TypeSyntax? = nil,
                           _ initializer: InitializerClauseSyntax? = nil) -> DeclSyntax {
    varLet(false, modifiers: modifiers, name, type, initializer)
  }

  /// `let name: Type = value`
  @inlinable @inline(__always)
  public static func `let`(_ name: String,
                           modifiers: DeclModifierListSyntax = [],
                           _ type: TypeSyntax? = nil,
                           _ initializer: InitializerClauseSyntax? = nil) -> DeclSyntax {
    varLet(true, modifiers: modifiers, name, type, initializer)
  }

  /// `let name: Type = value`
  @inlinable @inline(__always)
  public static func `let`(_ name: TokenSyntax,
                           modifiers: DeclModifierListSyntax = [],
                           _ type: TypeSyntax? = nil,
                           _ initializer: InitializerClauseSyntax? = nil) -> DeclSyntax {
    varLet(true, modifiers: modifiers, name, type, initializer)
  }

  /// `var/let name: Type = value`
  @inlinable @inline(__always)
  public static func varLet(_ isLet: Bool = false,
                            modifiers: DeclModifierListSyntax = [],
                            _ name: String,
                            _ type: TypeSyntax? = nil,
                            _ initializer: InitializerClauseSyntax? = nil) -> DeclSyntax {
    varLet(isLet, modifiers: modifiers, _token(name), type, initializer)
  }

  /// `var/let name: Type = value`
  @inlinable @inline(__always)
  public static func varLet(_ isLet: Bool = false,
                            modifiers: DeclModifierListSyntax = [],
                            _ name: TokenSyntax,
                            _ type: TypeSyntax? = nil,
                            _ initializer: InitializerClauseSyntax? = nil) -> DeclSyntax {
    DeclSyntax(
      VariableDeclSyntax(
        modifiers: modifiers,
        bindingSpecifier: .keyword(isLet ? .let : .var),
        bindings: PatternBindingListSyntax {
          PatternBindingSyntax(
            pattern: PatternSyntax(
              IdentifierPatternSyntax(identifier: name)
            ),
            typeAnnotation: type.map {
              TypeAnnotationSyntax(colon: .colonToken(trailingTrivia: .space), type: $0)
            },
            initializer: initializer
          )
        }
      )
    )
  }

  @inlinable @inline(__always)
  public static func computedVar(_ name: String,
                                 modifiers: DeclModifierListSyntax = [],
                                 _ type: TypeSyntax? = nil,
                                 @qstmts body: () -> [CodeBlockItemSyntax]) -> DeclSyntax {
    computedVar(_token(name), modifiers: modifiers, type, body: body)
  }

  @inlinable @inline(__always)
  public static func computedVar(_ name: TokenSyntax,
                                 modifiers: DeclModifierListSyntax = [],
                                 _ type: TypeSyntax? = nil,
                                 @qstmts body: () -> [CodeBlockItemSyntax]) -> DeclSyntax {
    DeclSyntax(
      VariableDeclSyntax(
        modifiers: modifiers,
        bindingSpecifier: .keyword(.var),
        bindings: PatternBindingListSyntax {
          PatternBindingSyntax(
            pattern: PatternSyntax(
              IdentifierPatternSyntax(identifier: name)
            ),
            typeAnnotation: type.map {
              TypeAnnotationSyntax(colon: .colonToken(trailingTrivia: .space), type: $0)
            },
            accessorBlock: AccessorBlockSyntax(accessors: .getter(CodeBlockItemListSyntax(body())))
          )
        }
      )
    )
  }

  /// `typealias Name = Type`
  @inlinable @inline(__always)
  public static func `typealias`(_ name: String,
                                 genericParameters: GenericParameterClauseSyntax? = nil,
                                 modifiers: DeclModifierListSyntax,
                                 _ aliased: TypeSyntax,
                                 where genericWhere: GenericWhereClauseSyntax? = nil) -> DeclSyntax {
    DeclSyntax(
      TypeAliasDeclSyntax(
        modifiers: modifiers,
        typealiasKeyword: .keyword(.typealias),
        name: q.tok.id(name),
        genericParameterClause: genericParameters,
        initializer: TypeInitializerClauseSyntax(
          equal: .equalToken(trailingTrivia: .space),
          value: aliased
        ),
        genericWhereClause: genericWhere
      )
    )
  }
}


@inlinable @inline(__always)
public func _var(_ name: String,
                 modifiers: DeclModifierListSyntax = [],
                 _ type: TypeSyntax? = nil,
                 _ initializer: InitializerClauseSyntax? = nil) -> DeclSyntax {
  qdecls.var(name, modifiers: modifiers, type, initializer)
}


@inlinable @inline(__always)
public func _var(_ name: TokenSyntax,
                 modifiers: DeclModifierListSyntax = [],
                 _ type: TypeSyntax? = nil,
                 _ initializer: InitializerClauseSyntax? = nil) -> DeclSyntax {
  qdecls.var(name, modifiers: modifiers, type, initializer)
}


@inlinable @inline(__always)
public func _computedVar(_ name: String,
                         modifiers: DeclModifierListSyntax = [],
                         _ type: TypeSyntax? = nil,
                         @qstmts body: () -> [CodeBlockItemSyntax]) -> DeclSyntax {
  qdecls.computedVar(name, modifiers: modifiers, type, body: body)
}


@inlinable @inline(__always)
public func _computedVar(_ name: TokenSyntax,
                         modifiers: DeclModifierListSyntax = [],
                         _ type: TypeSyntax? = nil,
                         @qstmts body: () -> [CodeBlockItemSyntax]) -> DeclSyntax {
  qdecls.computedVar(name, modifiers: modifiers, type, body: body)
}


@inlinable @inline(__always)
public func _let(modifiers: DeclModifierListSyntax = [],
                 _ name: String,
                 _ type: TypeSyntax? = nil,
                 _ initializer: InitializerClauseSyntax? = nil) -> DeclSyntax {
  qdecls.let(name, modifiers: modifiers, type, initializer)
}


@inlinable @inline(__always)
public func _typealias(modifiers: DeclModifierListSyntax = [],
                       _ name: String,
                       genericParameters: GenericParameterClauseSyntax? = nil,
                       _ aliased: TypeSyntax,
                       where genericWhere: GenericWhereClauseSyntax? = nil) -> DeclSyntax {
  qdecls.typealias(
    name,
    genericParameters: genericParameters,
    modifiers: modifiers,
    aliased,
    where: genericWhere
  )
}
