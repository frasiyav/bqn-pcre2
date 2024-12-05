void ⇐ ""
bqnv ⇐ "a"
ptr ⇐ "*:i8"
i8‿i16‿i32     ⇐ "i8"‿"i16"‿"i32"
c8‿c16‿c32     ⇐ "c8"‿"c16"‿"c32"
u8‿u16‿u32‿u64 ⇐ "u8"‿"u16"‿"u32"‿"u64"

[
  c8str‿c16str‿c32str‿utf8str,
  mc8str‿mc16str‿mc32str‿mutf8str ] ⇐ "*&"∾⌜"u8:c8"‿"u16:c16"‿"u32:c32"‿"u8:c8"

M ← "&"⊸∾
W ← ">𝕨"⊸∾
X ← ">"⊸∾

_bqn ← { @ •FFI ⟨𝕨⟩ ∾ ⟨"bqn_"∾𝕗⟩ ∾ (⋈">"∾⊢)⍟(1≡≡)𝕩}

makeC8Vec  ⇐ bqnv "makeC8Vec" _bqn ⟨W u64, X ptr⟩
makeC16Vec ⇐ bqnv "makeC16Vec"_bqn ⟨W u64, X ptr⟩
makeC32Vec ⇐ bqnv "makeC32Vec"_bqn ⟨W u64, X ptr⟩
makeF64Vec ⇐ bqnv "makeF64Vec"_bqn ⟨W u64, X ptr⟩

directC8  ⇐ ptr "directC8" _bqn bqnv
directC16 ⇐ ptr "directC16"_bqn bqnv
directC32 ⇐ ptr "directC32"_bqn bqnv


U64VecRead ⇐ +˝⟨1,2⋆32⟩×·⍉∘‿2⥊@-˜·⟨64,32‿'c'⟩•bit._Cast MakeF64Vec
PtrVecRead ⇐ <˘∘‿8⥊·⟨64,8‿'i'⟩•bit._Cast MakeF64Vec

U64ToU32 ⇐ (2⋆32)⊸{(𝕩-𝕨×⊢)⊸⋈⌊𝕩÷𝕨}
U32ToU64 ⇐ +´⟨1,2⋆32⟩⊸×
