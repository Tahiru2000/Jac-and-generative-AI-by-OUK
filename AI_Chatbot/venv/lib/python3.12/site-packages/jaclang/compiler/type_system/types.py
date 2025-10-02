"""Representation of types used during type analysis."""

from __future__ import annotations

# Pyright Reference: packages\pyright-internal\src\analyzer\types.ts
from abc import ABC
from enum import IntEnum, auto
from pathlib import Path
from typing import ClassVar, TYPE_CHECKING

if TYPE_CHECKING:
    from jaclang.compiler.unitree import Symbol, UniScopeNode as SymbolTable


class TypeCategory(IntEnum):
    """Enumeration of type categories."""

    Unbound = auto()  # Name is not bound to a value of any type
    Unknown = auto()  # Implicit Any type
    Never = auto()  # The bottom type, equivalent to an empty union
    Any = auto()  # Type can be anything
    Module = auto()  # Module instance
    Class = auto()  # Class definition
    Function = auto()  # Callable type
    Union = auto()  # Union of two or more other types


class TypeFlags(IntEnum):
    """Flags to set on a type.

    foo = 42  # <-- Here type of foo is `int` class, Instance type.
    foo = int # <-- Here type of foo is `type[int]`, Instantiable is set.
    foo: int = 42
         ^^^------- Here the type of the expression `int` is `type[int]`
                    That is same as the prefetched int_class that has the
                    flag Instantiable set.

                    calling convertToInstance() will return the same type
                    with Instance flag set.
    """

    Null = 0  # Pyright use None but python can't

    # This type refers to something that can be instantiated.
    Instantiable = 1 << 0

    # This type refers to something that has been instantiated.
    Instance = 1 << 1

    # This type is inferred within a py.typed source file and could be
    # inferred differently by other type checkers.
    Ambiguous = 1 << 2


class ParameterCategory(IntEnum):
    """Enumeration of parameter categories."""

    Positional = auto()
    ArgsList = auto()
    KwargsDict = auto()


class TypeBase(ABC):
    """Maps to pyright's TypeBase<T> in the types.ts file.

    This is the base class for all type instance of the jaclang that holds
    information about the type's category and any additional metadata and
    utilities to analyze type information and provide type checking.
    """

    # Each subclass should provide a class-level CATEGORY constant indicating its type category.
    CATEGORY: ClassVar[TypeCategory]

    def __init__(self, flags: TypeFlags = TypeFlags.Null) -> None:
        """Initialize obviously."""
        self.flags: TypeFlags = flags

    @property
    def category(self) -> TypeCategory:
        """Returns the category of the type."""
        return self.CATEGORY

    @staticmethod
    def unknown() -> "UnknownType":
        """Return an instance of an unknown type."""
        return UnknownType()

    def is_instantiable(self) -> bool:
        """Return whether the type is instantiable."""
        return bool(self.flags & TypeFlags.Instantiable)

    def is_instance(self) -> bool:
        """Return whether the type is an instance."""
        return bool(self.flags & TypeFlags.Instance)

    def is_instantiable_class(self) -> bool:
        """Return whether the class can be instantiated."""
        return (self.category == TypeCategory.Class) and self.is_instantiable()

    def is_class_instance(self) -> bool:
        """Return whether the class is an instance."""
        return (self.category == TypeCategory.Class) and self.is_instance()


class UnboundType(TypeBase):
    """Represents a type that is not bound to a specific value or context."""

    CATEGORY: ClassVar[TypeCategory] = TypeCategory.Unbound


class UnknownType(TypeBase):
    """Represents a type that is not known or cannot be determined."""

    CATEGORY: ClassVar[TypeCategory] = TypeCategory.Unknown


class NeverType(TypeBase):
    """Represents a type that can never occur."""

    CATEGORY: ClassVar[TypeCategory] = TypeCategory.Never


class AnyType(TypeBase):
    """Represents a type that can be anything."""

    CATEGORY: ClassVar[TypeCategory] = TypeCategory.Any


class ModuleType(TypeBase):
    """Represents a module type."""

    CATEGORY: ClassVar[TypeCategory] = TypeCategory.Module

    def __init__(
        self, mod_name: str, file_uri: Path, symbol_table: SymbolTable
    ) -> None:
        """Initialize the class."""
        super().__init__()
        self.mod_name = mod_name
        self.file_uri = file_uri
        self.symbol_table = symbol_table


class ClassType(TypeBase):
    """Represents a class type."""

    CATEGORY: ClassVar[TypeCategory] = TypeCategory.Class

    # Pyright has both ClassDetailsShared; and ClassDetailsPriv;
    # however we're only using shared instance and the private details
    # will be part of the class itself.

    class ClassDetailsShared:
        """Holds the shared details of class type.

        The shared detail of classes will points to the same instance across multiple clones
        of the same class. This is needed when we do `==` between two classes, if they have the
        same shared object, that means they both are the same class (with different context).
        """

        def __init__(
            self,
            class_name: str,
            symbol_table: SymbolTable,
            base_classes: list[TypeBase] | None = None,
        ) -> None:
            """Initialize obviously."""
            self.class_name = class_name
            self.symbol_table = symbol_table
            self.base_classes = base_classes or []

    def __init__(
        self,
        shared: ClassType.ClassDetailsShared,
        flags: TypeFlags = TypeFlags.Null,
    ) -> None:
        """Initialize the class type."""
        super().__init__(flags=flags)
        self.shared = shared

    def clone_as_instance(self) -> "ClassType":
        """Clone this class type as an instance type."""
        if self.is_instance():
            return self
        new_instance = ClassType(self.shared)

        # TODO: There is more to this but we're not over complicating this atm.
        new_flag = self.flags
        new_flag = TypeFlags(new_flag & ~TypeFlags.Instantiable)
        new_flags = TypeFlags(new_flag | TypeFlags.Instance)
        new_instance.flags = new_flags

        return new_instance

    def lookup_member_symbol(self, member: str) -> Symbol | None:
        """Lookup a member in the class type."""
        return self.shared.symbol_table.lookup(member, deep=True)


class Parameter:
    """Represents a function parameter."""

    def __init__(
        self, name: str, category: ParameterCategory, param_type: TypeBase | None
    ) -> None:
        """Initialize obviously."""
        super().__init__()
        self.name = name
        self.category = category
        self.param_type = param_type


class FunctionType(TypeBase):
    """Represents a function type."""

    CATEGORY: ClassVar[TypeCategory] = TypeCategory.Function

    def __init__(
        self,
        func_name: str,
        return_type: TypeBase | None = None,
        parameters: list[Parameter] | None = None,
        flags: TypeFlags = TypeFlags.Null,
    ) -> None:
        """Initialize obviously."""
        super().__init__(flags=flags)
        self.func_name = func_name
        self.return_type = return_type
        self.parameters = parameters or []


class UnionType(TypeBase):
    """Represents a union type."""

    CATEGORY: ClassVar[TypeCategory] = TypeCategory.Union

    def __init__(self, types: list[TypeBase]) -> None:
        """Initialize obviously."""
        super().__init__()
        self.types = types
