import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


extension DeclGroupSyntax {

  public var asNamedDeclaration: NamedDeclSyntax? {
    asProtocol(NamedDeclSyntax.self)
  }

  var storedProperties: [StoredProperty] {
    memberBlock.members
      .compactMap { $0.decl.as(VariableDeclSyntax.self) }
      .compactMap(\.asStoredProperty)
  }

  public var initializers: [InitializerDeclSyntax] {
    explicitInitializers + implicitInitializer.asSequence
  }

  var explicitInitializers: [InitializerDeclSyntax] {
    memberBlock.members.compactMap { $0.decl.as(InitializerDeclSyntax.self) }
  }

  var implicitInitializer: InitializerDeclSyntax? {
    inferredMemberwiseInitializer.filter { _ in
      explicitInitializers.isEmpty
    }
  }

  public var visibilityPrefix: DeclModifierListSyntax {
    .init(
      modifiers.compactMap(\.asMemberwiseInitVisibilityModifier)
    )
  }

  var inferredMemberwiseInitializer: InitializerDeclSyntax? {
    _init(
      modifiers: visibilityPrefix,
      params: _funcParams {
        for p in storedProperties where p.canBeInitialized {
          _funcParam(
            p.name,
            p.typeDeclWithEscapingIfNecessary,
            default: p.defaultValueDecl ?? p.implicitDefaultValueDecl
          )
        }
      }) {
        for p in storedProperties where p.canBeInitialized {
          _self_dot(p.name) ^=== _ref(p.name)
        }
      }
  }
}
