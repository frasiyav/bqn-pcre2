null ← 8⥊0

hasField ← @ •FFI "i8"‿"bqn_hasField"‿">𝕨a"‿">𝕩a"
getField ← @ •FFI "a"‿"bqn_getField"‿">𝕨a"‿">𝕩a"
Get ← Hasfield⟜⊑◶⟨1⊸⊑, Getfield⟜⊑⟩

opt ← ×∘≠◶⟨{⇐}, ("•arg 0 not a namespace"!6≡•Type)⊸⊢⊑⟩ •args

# Defaults
utf       ← opt Get⟨"utf",       0⟩
jit       ← opt Get⟨"jit",       1⟩
ucp       ← opt Get⟨"ucp",       0⟩
bufsize   ← opt Get⟨"bufsize",   0⟩
multiline ← opt Get⟨"multiline", 1⟩
greedy    ← opt Get⟨"greedy",    1⟩
anchored  ← opt Get⟨"anchored",  0⟩
caseless  ← opt Get⟨"caseless",  0⟩
extended  ← opt Get⟨"extended",  0⟩
overlap   ← opt Get⟨"overlap",   0⟩
substitute_extended ← opt Get⟨"substitute_extended", 0⟩

file‿chartype‿citype ← (⊑ 0‿8‿16‿32 ⊐ utf)⊑⟨
  "bqn-pcre2-8.so"‿"*u8:c8"‿"c8arr"
  "bqn-pcre2-8.so"‿"*u8:c8"‿"c8arr"
  "bqn-pcre2-16.so"‿"*u16:c16"‿"c16arr"
  "bqn-pcre2-32.so"‿"*u32:c32"‿"c32arr"
⟩

pcre2_compile  ← file •FFI ⟨"i32", "compile", chartype, "&*:i8"⟩∾8⥊⋈"i8"
pcre2_test     ← file •FFI ⟨"i8", "test", ">𝕨*:i8", ">𝕩"∾chartype⟩
pcre2_match    ← file •FFI ⟨"a", "match", ">𝕨*:i8", ">𝕩"∾chartype⟩
pcre2_imatch   ← file •FFI ⟨"a", "imatch", ">𝕨*:i8", ">𝕩"∾chartype⟩
pcre2_matchall ← file •FFI ⟨"a", "matchall", ">𝕨*:i8", chartype, "i8"⟩
pcre2_replace  ← file •FFI ⟨"a", "replace", ">𝕨*:i8", chartype, chartype, "u64", "i8"⟩
pcre2_re_free  ← file •FFI ⟨"", "re_free", ">*:i8"⟩


Compile ⇐ {
    𝕊 𝕩: {⇐}𝕊𝕩;
  o 𝕊 pattern:

    jit       ←  o Get⟨"jit", jit⟩
    ucp       ←  o Get⟨"ucp", ucp⟩
    multiline ←  o Get⟨"multiline", multiline⟩
    greedy    ←  o Get⟨"greedy", greedy⟩
    anchored  ←  o Get⟨"anchored", anchored⟩
    caseless  ←  o Get⟨"caseless", caseless⟩
    extended  ←  o Get⟨"extended", extended⟩
    overlap   ←  o Get⟨"overlap", overlap⟩
    substitute_extended ← o Get⟨"substitute_extended", substitute_extended⟩

    e‿re ← PCRE2_Compile ⟨ pattern∾@, null,
                           jit, utf>0, ucp,
                           multiline, greedy, anchored,
                           caseless, extended⟩
    "Regex error"!e

    f←0 ⋄ Free ⇐ {·: PCRE2_RE_Free re ⋄ f↩1}
    ferr ← "Compiled expession was already freed"

    StrChk ← {
      t ← •internal.Type 𝕩
      CW ← ⊑"c8arr"‿"c16arr"‿"c32arr"⊐<
      "regular expression being called on non-string"! 3≢CW t
      "regular expression being called on array of rank > 1"! 1≡=𝕩
      citype <○CW t?
        •Out "Warning: "∾(¯3↓citype)∾" regular expression being called on "∾t
      ;
      @
    }


    Test        ⇐ {ferr!¬f ⋄ StrChk 𝕩 ⋄ re PCRE2_Test   𝕩∾@}
    Match       ⇐ {ferr!¬f ⋄ StrChk 𝕩 ⋄ re PCRE2_Match  𝕩∾@}
    IMatch      ⇐ {ferr!¬f ⋄ StrChk 𝕩 ⋄ re PCRE2_IMatch 𝕩∾@}
    Matchall    ⇐ {ferr!¬f ⋄ StrChk 𝕩 ⋄ re PCRE2_MatchAll ⟨𝕩∾@, (𝕨⊣{⇐}) Get⟨"overlap", overlap⟩⟩}
    _Replace    ⇐ {ferr!¬f ⋄ StrChk 𝕩 ⋄ re PCRE2_Replace  ⟨𝕗∾@, 𝕩∾@, bufsize, 0, substitute_extended⟩}
    _Replaceall ⇐ {ferr!¬f ⋄ StrChk 𝕩 ⋄ re PCRE2_Replace  ⟨𝕗∾@, 𝕩∾@, bufsize, 1, (𝕨⊣{⇐}) Get⟨"extended", substitute_extended⟩⟩}

}

_MatchAll ⇐ {
  𝕗_𝕣 𝕩: {⇐} 𝕗_𝕣 𝕩;
  o pattern _𝕣 𝕩:
    re ← o Compile pattern
    {·:re.Free@}⊸⊢ re.MatchAll 𝕩
}

_ReplaceAll_ ⇐ {
  𝕗_𝕣_𝕘 𝕩: {⇐} 𝕗_𝕣_𝕘 𝕩;
  o pattern _𝕣_ replacement 𝕩:
    re ← o Compile pattern
    {·:re.Free@}⊸⊢ replacement re._ReplaceAll 𝕩
}
