import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Type declarations: struct / class / enum

extension q {

  @inlinable @inline(__always)
  public static func `struct`(
    _ name: String,
    modifiers: DeclModifierListSyntax = [],
    generics: GenericParameterClauseSyntax? = nil,
    inherits: InheritanceClauseSyntax? = nil,
    where whereClause: GenericWhereClauseSyntax? = nil,
    @qmembers _ members: () -> [MemberBlockItemSyntax]
  ) -> StructDeclSyntax {
    `struct`(
      _token(name),
      modifiers: modifiers,
      generics: generics,
      inherits: inherits,
      where: whereClause,
      members
    )
  }

  @inlinable @inline(__always)
  public static func `struct`(
    _ name: TokenSyntax,
    modifiers: DeclModifierListSyntax = [],
    generics: GenericParameterClauseSyntax? = nil,
    inherits: InheritanceClauseSyntax? = nil,
    where whereClause: GenericWhereClauseSyntax? = nil,
    @qmembers _ members: () -> [MemberBlockItemSyntax]
  ) -> StructDeclSyntax {
    StructDeclSyntax(
      modifiers: modifiers,
      structKeyword: .keyword(.struct),
      name: name,
      genericParameterClause: generics,
      inheritanceClause: inherits,
      genericWhereClause: whereClause,
      memberBlock: qmemberBlock(members)
    )
  }

  @inlinable @inline(__always)
  public static func `class`(
    _ name: String,
    modifiers: DeclModifierListSyntax = [],
    generics: GenericParameterClauseSyntax? = nil,
    inherits: InheritanceClauseSyntax? = nil,
    where whereClause: GenericWhereClauseSyntax? = nil,
    @qmembers _ members: () -> [MemberBlockItemSyntax]
  ) -> ClassDeclSyntax {
    `class`(
      _token(name),
      modifiers: modifiers,
      generics: generics,
      inherits: inherits,
      where: whereClause,
      members
    )
  }

  @inlinable @inline(__always)
  public static func `class`(
    _ name: TokenSyntax,
    modifiers: DeclModifierListSyntax = [],
    generics: GenericParameterClauseSyntax? = nil,
    inherits: InheritanceClauseSyntax? = nil,
    where whereClause: GenericWhereClauseSyntax? = nil,
    @qmembers _ members: () -> [MemberBlockItemSyntax]
  ) -> ClassDeclSyntax {
    ClassDeclSyntax(
      modifiers: modifiers,
      classKeyword: .keyword(.class),
      name: name,
      genericParameterClause: generics,
      inheritanceClause: inherits,
      genericWhereClause: whereClause,
      memberBlock: qmemberBlock(members)
    )
  }

  @inlinable @inline(__always)
  public static func `enum`(
    _ name: String,
    modifiers: DeclModifierListSyntax = [],
    generics: GenericParameterClauseSyntax? = nil,
    inherits: InheritanceClauseSyntax? = nil,
    where whereClause: GenericWhereClauseSyntax? = nil,
    @qmembers _ members: () -> [MemberBlockItemSyntax]
  ) -> EnumDeclSyntax {
    `enum`(
      _token(name),
      modifiers: modifiers,
      generics: generics,
      inherits: inherits,
      where: whereClause,
      members
    )
  }

  @inlinable @inline(__always)
  public static func `enum`(
    _ name: TokenSyntax,
    modifiers: DeclModifierListSyntax = [],
    generics: GenericParameterClauseSyntax? = nil,
    inherits: InheritanceClauseSyntax? = nil,
    where whereClause: GenericWhereClauseSyntax? = nil,
    @qmembers _ members: () -> [MemberBlockItemSyntax]
  ) -> EnumDeclSyntax {
    EnumDeclSyntax(
      modifiers: modifiers,
      enumKeyword: .keyword(.enum),
      name: name,
      genericParameterClause: generics,
      inheritanceClause: inherits,
      genericWhereClause: whereClause,
      memberBlock: qmemberBlock(members)
    )
  }
}


@inlinable @inline(__always)
public func _struct(
  _ name: String,
  modifiers: DeclModifierListSyntax = [],
  generics: GenericParameterClauseSyntax? = nil,
  inherits: InheritanceClauseSyntax? = nil,
  where whereClause: GenericWhereClauseSyntax? = nil,
  @qmembers _ members: () -> [MemberBlockItemSyntax]
) -> StructDeclSyntax {
  q.struct(
    name,
    modifiers: modifiers,
    generics: generics,
    inherits: inherits,
    where: whereClause,
    members
  )
}

@inlinable @inline(__always)
public func _struct(
  _ name: TokenSyntax,
  modifiers: DeclModifierListSyntax = [],
  generics: GenericParameterClauseSyntax? = nil,
  inherits: InheritanceClauseSyntax? = nil,
  where whereClause: GenericWhereClauseSyntax? = nil,
  @qmembers _ members: () -> [MemberBlockItemSyntax]
) -> StructDeclSyntax {
  q.struct(
    name,
    modifiers: modifiers,
    generics: generics,
    inherits: inherits,
    where: whereClause,
    members
  )
}

@inlinable @inline(__always)
public func _class(
  _ name: String,
  modifiers: DeclModifierListSyntax = [],
  generics: GenericParameterClauseSyntax? = nil,
  inherits: InheritanceClauseSyntax? = nil,
  where whereClause: GenericWhereClauseSyntax? = nil,
  @qmembers _ members: () -> [MemberBlockItemSyntax]
) -> ClassDeclSyntax {
  q.class(
    name,
    modifiers: modifiers,
    generics: generics,
    inherits: inherits,
    where: whereClause,
    members
  )
}

@inlinable @inline(__always)
public func _class(
  _ name: TokenSyntax,
  modifiers: DeclModifierListSyntax = [],
  generics: GenericParameterClauseSyntax? = nil,
  inherits: InheritanceClauseSyntax? = nil,
  where whereClause: GenericWhereClauseSyntax? = nil,
  @qmembers _ members: () -> [MemberBlockItemSyntax]
) -> ClassDeclSyntax {
  q.class(
    name,
    modifiers: modifiers,
    generics: generics,
    inherits: inherits,
    where: whereClause,
    members
  )
}

@inlinable @inline(__always)
public func _enum(
  _ name: String,
  modifiers: DeclModifierListSyntax = [],
  generics: GenericParameterClauseSyntax? = nil,
  inherits: InheritanceClauseSyntax? = nil,
  where whereClause: GenericWhereClauseSyntax? = nil,
  @qmembers _ members: () -> [MemberBlockItemSyntax]
) -> EnumDeclSyntax {
  q.enum(
    name,
    modifiers: modifiers,
    generics: generics,
    inherits: inherits,
    where: whereClause,
    members
  )
}

@inlinable @inline(__always)
public func _enum(
  _ name: TokenSyntax,
  modifiers: DeclModifierListSyntax = [],
  generics: GenericParameterClauseSyntax? = nil,
  inherits: InheritanceClauseSyntax? = nil,
  where whereClause: GenericWhereClauseSyntax? = nil,
  @qmembers _ members: () -> [MemberBlockItemSyntax]
) -> EnumDeclSyntax {
  q.enum(
    name,
    modifiers: modifiers,
    generics: generics,
    inherits: inherits,
    where: whereClause,
    members
  )
}
