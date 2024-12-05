⟨SetOptions⟩ ← •Import "src/pcre2_options.bqn"
global_options ← •args SetOptions⍟(6≡•Type∘⊣) SetOptions •Import "defaults.bqn"

pcre2_fns ← global_options •Import "src/pcre2_fns.bqn"

Compile ⇐ {
  options 𝕊 pattern:
    o ← options SetOptions global_options
    ce ← pcre2_fns.Compile ⟨pattern, o⟩

    pcre2_fns.CompileJit⍟o.usejit ⟨⊑ce, o.jit⟩

    MatchType ← {𝕊 f: {
              𝕊 text: F ⟨ce, text, o.match⟩;
      options 𝕊 text: F ⟨ce, text, (options SetOptions o).match⟩
    }}

    test     ⇐ MatchType pcre2_fns.test
    match    ⇐ MatchType pcre2_fns.match
    imatch   ⇐ MatchType pcre2_fns.imatch
    matchall ⇐ MatchType pcre2_fns.matchall

    ReplaceType ← {𝕊 f: {
              pattern _𝕣 text: pattern F ⟨ce, text, o.sub⟩;
      options pattern _𝕣 text: pattern F ⟨ce, text, (options SetOptions o).sub⟩
    }}

    replace    ⇐ ReplaceType pcre2_fns.replace
    replaceall ⇐ ReplaceType pcre2_fns.replaceall

    FErr ← "Compiled expression was already freed"!0˙
    Free ⇐ {𝕊:
      pcre2_fns.CEFree ce
      test‿match‿imatch‿matchall‿replace‿replaceall‿free fErr˙¨↩
      @
    }
;
  𝕊 pattern: {⇐} 𝕊 pattern
}


_MatchAll ⇐ { 𝕨 pattern _𝕣 text:
  re ← 𝕨 Compile pattern
  re.Free⊸⊢ re.MatchAll text
}

_ReplaceAll_ ⇐ { 𝕨 pattern _𝕣_ replacement text:
  re ← 𝕨 Compile pattern
  re.Free⊸⊢ replacement re._ReplaceAll text
}
