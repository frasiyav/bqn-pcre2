bm32 ← =⌜˜↕32

pcre2_options ⇐ {
  zero_terminated ⇐ unset ⇐ ⊑⟨1,64⟩•bit._Cast 64⥊1

  [
    anchored
    no_utf_check
    endanchored
  ] ⇐ 31‿30‿29⊏bm32

  [
    allow_empty_class
    alt_bsux
    auto_callout
    caseless
    dollar_endonly
    dotall
    dupnames
    extended
    firstline
    match_unset_backref
    multiline
    never_ucp
    never_utf
    no_auto_capture
    no_auto_possess
    no_dotstar_anchor
    no_start_optimize
    ucp
    ungreedy
    utf
    never_backslash_c
    alt_circumflex
    alt_verbnames
    use_offset_limit
    extended_more
    literal
    match_invalid_utf
  ] ⇐ 27↑bm32

  [
    extra_allow_surrogate_escapes
    extra_bad_escape_is_literal
    extra_match_word
    extra_match_line
    extra_escaped_cr_is_lf
    extra_alt_bsux
    extra_allow_lookaround_bsk
  ] ⇐ 7↑bm32

  [
    jit_complete
    jit_partial_soft
    jit_partial_hard
    jit_invalid_utf
  ] ⇐ 0‿1‿2‿8⊏bm32

  [
    notbol
    noteol
    notempty
    notempty_atstart
    partial_soft
    partial_hard
    dfa_restart
    dfa_shortest
    substitute_global
    substitute_extended
    substitute_unset_empty
    substitute_unknown_unset
    substitute_overflow_length
    no_jit
    copy_matched_subject
    substitute_literal
    substitute_matched
    substitute_replacement_only
  ] ⇐ 18↑bm32

  [
    convert_utf
    convert_no_utf_check
    convert_posix_basic
    convert_posix_extended
  ] ⇐ 4↑bm32

  convert_glob ⇐ 4⊏bm32
  convert_glob_no_wild_separator ⇐ convert_glob ∨ 5⊏bm32
  convert_glob_no_starstar ⇐ convert_glob ∨ 6⊏bm32
}

validOpts ← ∾⟨

  compOpts ← ⟨
    "anchored"
    "allowemptyclass"
    "altbsux"
    "altcircumflex"
    "altverbnames"
    "autocallout"
    "caseless"
    "dollarendonly"
    "dotall"
    "dupnames"
    "endanchored"
    "extended"
    "firstline"
    "literal"
    "matchinvalidutf"
    "matchunsetbackref"
    "multiline"
    "neverbackslashc"
    "neverucp"
    "neverutf"
    "noautocapture"
    "noautopossess"
    "nodotstaranchor"
    "nostartoptimize"
    "noutfcheck"
    "ucp"
    "ungreedy"
    "useoffsetlimit"
    "utf"
  ⟩

  jitOpts ← ⟨
    "jitcomplete"
    "jitpartialsoft"
    "jitpartialhard"
  ⟩

  matchOpts ← ⟨
    "anchored"
    "copymatchedsubject"
    "endanchored"
    "notbol"
    "noteol"
    "notempty"
    "notemptyatstart"
    "nojit"
    "noutfcheck"
    "partialhard"
    "partialsoft"
  ⟩

  subOpts ← ⟨
    "anchored"
    "endanchored"
    "notbol"
    "noteol"
    "notempty"
    "notemptyatstart"
    "nojit"
    "noutfcheck"
    "substituteextended"
    "substituteglobal"
    "substituteliteral"
    "substitutematched"
    "substituteoverflowlength"
    "substitutereplacementonly"
    "substituteunknownunset"
    "substituteunsetempty"
  ⟩

  otherOpts ← ⟨
    "pcre2parentfolder"
    "mode"
    "usejit"
    "overlapping"
    "initsubbuf"
    "depthlimit"
    "matchlimit"
    "heaplimit"
    "offsetlimit"
  ⟩
⟩

_set ← {o group _𝕣 mask:
  Get ← •ns.Get¨ ⋄ Keys ← •ns.Keys
  E ← ⊢⊣"non-boolean option value"!·∧´⊢∊0‿1˙
  valid ← ∊⟜group⊸/ Keys o
  off‿on ← ∨´¨ (o E∘Get valid) ∾⟜2⊸⊔ pcre2_options Get valid
  off ¬⊸∧ mask ∨ on
}

empty_opt ← {
  pcre2parentfolder ⇐ ""
  mode ⇐ ""

  usejit ⇐ 0
  overlapping ⇐ 0
  initsubbuf ⇐ 0

  depthlimit ⇐ @
  matchlimit ⇐ @
  heaplimit ⇐ @
  offsetlimit ⇐ @

  comp ⇐ 32⥊0
  jit ⇐ 32⥊0
  match ⇐ 32⥊0
  sub ⇐ 32⥊0
}

Get ← •ns.Has⟜⊑◶⟨1⊸⊑, •ns.Get⟜⊑⟩

SetOptions ⇐ {
  𝕊 new: new 𝕊 empty_opt;
  new 𝕊 old:
    (0!˜"invalid option "∾∾⟜", "⊸∾´)⍟(×≠) (/∘¬ ∊⟜validOpts)⊸⊏ •ns.Keys new

    mode ⇐ ("c8"‿"c16"‿"c32"‿"utf8"⊑∘⊐<)⍟(0≡•Type) new Get ⟨"mode", old.mode⟩
    comp ⇐ {new •ns.Has "mode"? {utf⇐3≡mode} CompOpts _Set old.comp; old.comp}

    pcre2parentfolder ⇐ new Get ⟨"pcre2parentfolder", old.pcre2parentfolder⟩

    usejit      ⇐ new Get ⟨"usejit",      old.usejit      ⟩
    overlapping ⇐ new Get ⟨"overlapping", old.overlapping ⟩
    initsubbuf  ⇐ new Get ⟨"initsubbuf",  old.initsubbuf  ⟩
    depthlimit  ⇐ new Get ⟨"depthlimit",  old.depthlimit  ⟩
    matchlimit  ⇐ new Get ⟨"matchlimit",  old.matchlimit  ⟩
    heaplimit   ⇐ new Get ⟨"heaplimit",   old.heaplimit   ⟩
    offsetlimit ⇐ new Get ⟨"offsetlimit", old.offsetlimit ⟩

    comp  ↩ new CompOpts  _set comp
    jit   ⇐ new JitOpts   _set old.jit
    match ⇐ new MatchOpts _set old.match
    sub   ⇐ new SubOpts   _set old.sub
}
