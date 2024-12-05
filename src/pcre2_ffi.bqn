⟨
  void, ptr, i32, u32, u64
  c8str, c16str, c32str, utf8str
  mc8str, mc16str, mc32str, mUtf8str
⟩ ← •Import "bqn_ffi.bqn"

cw‿str‿mstr ← •args.mode ⊑¨⟨
  "8"‿"16"‿"32"‿"8"
  c8str‿c16str‿c32str‿utf8str
  mc8str‿mc16str‿mc32str‿mutf8str
⟩

pcre2_so ← •args.pcre2parentfolder∾"libpcre2-"∾cw∾".so" #TODO check path and give error message if not found

bm32 ← i32
M ← "&"⊸∾
W ← ">𝕨"⊸∾
X ← ">"⊸∾

_pcre2 ← { pcre2_so •FFI ⟨𝕨⟩ ∾ ⟨"pcre2_"∾𝕗∾"_"∾cw⟩ ∾ (⋈">"∾⊢)⍟(1≡≡)𝕩}

code_free                      ⇐ void "code_free"                     _pcre2 ptr
compile                        ⇐ ptr  "compile"                       _pcre2 ⟨ptr, u64, bm32, M i32, M u32, ptr⟩
# get_error_message              ⇐ i32  "get_error_message "            _pcre2 ⟨i32, mc8str, u32⟩
get_error_message              ⇐ i32  "get_error_message"             _pcre2 ⟨i32, mstr, u32⟩
get_ovector_pointer            ⇐ ptr  "get_ovector_pointer"           _pcre2 ptr
jit_compile                    ⇐ i32  "jit_compile"                   _pcre2 ⟨ptr, bm32⟩
match                          ⇐ i32  "match"                         _pcre2 ⟨ptr, ptr, u64, u64, bm32, ptr, ptr⟩
match_data_create_from_pattern ⇐ ptr  "match_data_create_from_pattern"_pcre2 ⟨ptr, ptr⟩
match_data_free                ⇐ void "match_data_free"               _pcre2 ptr
substitute                     ⇐ i32  "substitute"                    _pcre2 ⟨ptr, ptr, u64, u64, bm32, ptr, ptr, str, u64, mstr, M u32⟩
substring_list_free            ⇐ void "substring_list_free"           _pcre2 ptr
substring_list_get             ⇐ i32  "substring_list_get"            _pcre2 ⟨ptr, M ptr, M ptr⟩
# pattern_info                   ⇐ i32  "pattern_info"                  _pcre2 ⟨ptr, u32, M u32⟩

match_context_create           ⇐ ptr  "match_context_create"          _pcre2 ptr
match_context_free             ⇐ void "match_context_free"            _pcre2 ptr

set_depth_limit                ⇐ i32  "set_depth_limit"               _pcre2 ⟨W ptr, X u32⟩
set_match_limit                ⇐ i32  "set_match_limit"               _pcre2 ⟨W ptr, X u32⟩
set_heap_limit                 ⇐ i32  "set_heap_limit"                _pcre2 ⟨W ptr, X u32⟩
set_offset_limit               ⇐ i32  "set_offset_limit"              _pcre2 ⟨W ptr, X u64⟩
