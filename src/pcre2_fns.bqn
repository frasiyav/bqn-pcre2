global_options ← •args

⟨BM32, _DoWhile_⟩ ← •Import "util.bqn"
ffi ← global_options •Import "pcre2_ffi.bqn"
⟨pcre2_options⟩ ← •Import "pcre2_options.bqn"
⟨error⟩ ← •Import "pcre2_codes.bqn"
⟨U64ToU32, U32ToU64, U64VecRead, PtrVecRead⟩ ← •Import "bqn_ffi.bqn"
⟨ReadStrPtr, VerifyStr, DirectPtr⟩ ← global_options •Import "strings.bqn"

null ← 8⥊0

FnErr ← {!𝕩∾⊢}

CEFree ⇐ {𝕊 re‿match_data‿match_context:
  ffi.Match_Context_Free match_context
  ffi.Match_Data_Free match_data
  ffi.Code_Free re
}

ErrorMsg ← {𝕊 errcode:
  e ← FnErr "pcre2_get_error_message "
  r‿message ← ffi.Get_Error_Message ⟨errcode, 256⥊@, 256⟩
  {
    r ≡ error.nomemory? E "buffer too small to contain error message";
    r ≡ error.baddata? E "unrecognized error code";
    r ≥ 0? r↑message;
    E "error"
  }
}

U32 ← (2⋆32)|⊢

CreateMContext ← {𝕊 options:
  e ← FnErr "pcre2_match_context_create "
  d‿m‿h‿o ← co ← options •ns.Get¨ "depthlimit"‿"matchlimit"‿"heaplimit"‿"offsetlimit"
  { ∧´@=co? null;
    c ← ffi.Match_Context_Create null
    E⍟(c≡null) "could not obtain memory for match context"
    c ffi.Set_Depth_Limit⟜U32⍟(@⊸≢) d
    c ffi.Set_Match_Limit⟜U32⍟(@⊸≢) m
    c ffi.Set_Heap_Limit ⟜U32⍟(@⊸≢) h
    c ffi.Set_Offset_Limit⍟(@⊸≢)    o
    c
  }
}

CreateMData ← {𝕊 re:
  e ← FnErr "pcre2_match_data_create_from_pattern "
  match_data ← ffi.Match_Data_Create_From_Pattern ⟨re, null⟩
  E⍟(match_data≡null) "could not obtain memory for match data block"
  match_data
}

Compile ⇐ {𝕊 pattern‿options: # TODO: show error position on failure
  e ← FnErr "pcre2_compile "
  pattern VerifyStr↩
  ccontext ← null # TODO compilecontext to allow setting LF character
  re‿⟨err⟩‿erroffset ← ffi.Compile ⟨ DirectPtr pattern, ≠pattern,
                                     BM32 options.comp,
                                     ⟨0⟩, 0‿0, ccontext ⟩
  E∘ErrorMsg⍟(re≡null) err

  match_data ← CreateMData re
  match_context ← CreateMContext options

  re‿match_data‿match_context
}

CompileJIT ⇐ {𝕊 re‿options:
  e ← FnErr "pcre2_jit_compile "
  err ← ffi.JIT_Compile ⟨re, BM32 options⟩
  {
    err ≡ error.nomemory? E "unable to allocate executable memory";
    err < 0? E Errormsg err;
    err ≡ 0? re;
    E "unreachable"
  }
}

_OnMatch_ ← {default _𝕣_ Fn ⟨re‿match_data‿match_context, pinput‿ninput‿offset, optionmask⟩:
  e ← FnErr "pcre2_match "
  rc ← ffi.Match ⟨ re, pinput, ninput, offset,
                   optionmask,
                   match_data, match_context ⟩
  {
    rc ≡ error.nomatch? default;
    rc ≡ 0? E "ovector size error";
    rc < 0? E ErrorMsg rc;
    rc Fn match_data
  }
}

GetSubstrings ← {n 𝕊 match_data:
  e ← FnErr  "pcre2_substring_list_get "
  err‿plists‿plengths ← ffi.Substring_List_Get ⟨match_data, null, null⟩
  {
    err ≢ 0? E ErrorMsg err;
    lengths ← n U64VecRead plengths
    pstrs ← n PtrVecRead plists
    res ← lengths ReadStrPtr¨ pstrs
    ffi.Substring_List_Free plists
    •FromUtf8⚇1⍟(global_options.mode≡3) ⊑⍟(n≡1) res
  }
}

GetOVecs ← {n 𝕊 match_data:
  <˘∘‿2⥊ (2×n) U64VecRead ffi.Get_OVector_Pointer match_data
}

ProcInput ← {𝕊 ⟨ce, input, options⟩:
  input VerifyStr↩
  ⟨ce, ⟨DirectPtr input, ≠input, 0⟩, BM32 options⟩
}

Test   ⇐ 0 _OnMatch_ 1              ProcInput
Match  ⇐ ⟨⟩_OnMatch_ GetSubstrings  ProcInput
IMatch ⇐ ⟨⟩_OnMatch_ GetOVecs       ProcInput

MatchAll ⇐ {𝕊 ⟨ce, pinput‿len‿offset, optionmask⟩:
  iter ← global_options.overlapping ⊑ ⟨1⊸⊑, 1+⊑⟩ # potential bug from inc 1+⊑ in utf8 mode?
  NextOffset ← {offset↩ Iter ⊑ 1 GetOVecs 𝕩}
  I←{𝕊: ce‿⟨pinput, len, offset⟩‿optionmask}

  results ← ⟨⟩ ⋄ Append ← {results∾↩<𝕩}
  ⟨⟩_OnMatch_(GetSubstrings⊣NextOffset)∘I _DoWhile_ {⟨⟩:0; 1⊣Append𝕩} @
  results
}∘ProcInput

Substitute ← { buflen 𝕊 ⟨re‿match_data‿match_context, pattern, pinput‿ninput‿offset, optionmask⟩:
  e ← FnErr "pcre2_substitute "
  rc‿out‿nout ← ffi.Substitute ⟨ re, pinput, ninput, offset,
                                 optionmask, match_data, match_context,
                                 pattern, ≠pattern,
                                 @⥊˜U32ToU64 buflen, buflen ⟩
  {
    rc ≡ error.nomemory? nout Substitute 𝕩;
    rc < 0? E ErrorMsg rc;
    •FromUtf8⚇1⍟(global_options.mode≡3) (U32ToU64 nout) ↑ out
  }𝕩
}

SetOverflow ← pcre2_options.substitute_overflow_length⊸∨⌾(2⊸⊑)
SetGlobal   ← pcre2_options.         substitute_global⊸∨⌾(2⊸⊑)

Replace ⇐ { pattern 𝕊 ⟨ce, input, option_mask⟩:
  bufsize ← U64ToU32 global_options.InitSubBuf 1⊑input
  bufsize Substitute ⟨ce, VerifyStr pattern, input, option_mask⟩
}⟜(ProcInput SetOverflow)

ReplaceAll ⇐ Replace⟜SetGlobal
