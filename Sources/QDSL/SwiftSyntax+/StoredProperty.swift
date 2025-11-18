import SwiftSyntax


struct StoredProperty: Equatable, Hashable {

  var kind: String?
  var name: TokenSyntax
  var typeDecl: TypeSyntax
  var defaultValueDecl: InitializerClauseSyntax?

  init(kind: String?,
       name: TokenSyntax,
       typeDecl: TypeSyntax,
       defaultValueDecl: InitializerClauseSyntax?) {
    self.kind = kind
    self.name = name
    self.typeDecl = typeDecl
    self.defaultValueDecl = defaultValueDecl
  }

  init?(kind: String?,
        name: TokenSyntax?,
        typeDecl: TypeSyntax?,
        defaultValueDecl: InitializerClauseSyntax?) {
    guard let name, let typeDecl else { return nil }

    self.kind = kind
    self.name = name
    self.typeDecl = typeDecl
    self.defaultValueDecl = defaultValueDecl
  }


  var canBeInitialized: Bool { !canNotBeInitialized }

  var canNotBeInitialized: Bool {
    kind == "let" && defaultValueDecl != nil
  }

  var isOptionalProperty: Bool {
    typeDecl.is(OptionalTypeSyntax.self)
  }

  var implicitDefaultValueDecl: InitializerClauseSyntax? {
    if isOptionalProperty {
      .init(
        value: ExprSyntax(
          NilLiteralExprSyntax(nilKeyword: .keyword(.nil))
        )
      )
    } else {
      nil
    }
  }

  var typeDeclWithEscapingIfNecessary: TypeSyntax {
    typeDecl.withEscapingIfNecessary
  }
}
