mode ← •args.mode

⟨ makeC8Vec, makeC16Vec, makeC32Vec
  directC8, directC16, directC32 ⟩ ← •Import "bqn_ffi.bqn"

ElType ← •internal.ElType
bqnElType ← {⟨unk, i8, i16, i32, f64, c8, c16, c32⟩ ⇐ ↕8}

IsStr ⇐ ⊢⊣"expected a string"!(⊑ElType∊5‿6‿7˙)∧0≡•Type

PromoteC16 ← "Ac16" •internal.Variation ⊢
PromoteC32 ← "Ac32" •internal.Variation ⊢

IsC8Str  ←            ("incompatible elType"!5≡ElType)⊸⊢ IsStr
IsC16Str ← PromoteC16·("incompatible elType"!6≥ElType)⊸⊢ IsStr
IsC32Str ← PromoteC32 IsStr
IsUTF8Str ← IsStr

readStrPtr ⇐ mode ⊑ ⟨makeC8Vec,    makeC16Vec,    makeC32Vec,    makeC8Vec⟩
verifyStr  ⇐ mode ⊑ ⟨isC8Str,      isC16Str,      isC32Str,      isUTF8Str⟩
directPtr  ⇐ mode ⊑ ⟨directC8,     directC16,     directC32,     directC8⟩
