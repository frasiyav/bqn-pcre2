error ⇐ {
  end_backslash                  ⇐ 101
  end_backslash_c                ⇐ 102
  unknown_escape                 ⇐ 103
  quantifier_out_of_order        ⇐ 104
  quantifier_too_big             ⇐ 105
  missing_square_bracket         ⇐ 106
  escape_invalid_in_class        ⇐ 107
  class_range_order              ⇐ 108
  quantifier_invalid             ⇐ 109
  internal_unexpected_repeat     ⇐ 110
  invalid_after_parens_query     ⇐ 111
  posix_class_not_in_class       ⇐ 112
  posix_no_support_collating     ⇐ 113
  missing_closing_parenthesis    ⇐ 114
  bad_subpattern_reference       ⇐ 115
  null_pattern                   ⇐ 116
  bad_options                    ⇐ 117
  missing_comment_closing        ⇐ 118
  parentheses_nest_too_deep      ⇐ 119
  pattern_too_large              ⇐ 120
  heap_failed                    ⇐ 121
  unmatched_closing_parenthesis  ⇐ 122
  internal_code_overflow         ⇐ 123
  missing_condition_closing      ⇐ 124
  lookbehind_not_fixed_length    ⇐ 125
  zero_relative_reference        ⇐ 126
  too_many_condition_branches    ⇐ 127
  condition_assertion_expected   ⇐ 128
  bad_relative_reference         ⇐ 129
  unknown_posix_class            ⇐ 130
  internal_study_error           ⇐ 131
  unicode_not_supported          ⇐ 132
  parentheses_stack_check        ⇐ 133
  code_point_too_big             ⇐ 134
  lookbehind_too_complicated     ⇐ 135
  lookbehind_invalid_backslash_c ⇐ 136
  unsupported_escape_sequence    ⇐ 137
  callout_number_too_big         ⇐ 138
  missing_callout_closing        ⇐ 139
  escape_invalid_in_verb         ⇐ 140
  unrecognized_after_query_p     ⇐ 141
  missing_name_terminator        ⇐ 142
  duplicate_subpattern_name      ⇐ 143
  invalid_subpattern_name        ⇐ 144
  unicode_properties_unavailable ⇐ 145
  malformed_unicode_property     ⇐ 146
  unknown_unicode_property       ⇐ 147
  subpattern_name_too_long       ⇐ 148
  too_many_named_subpatterns     ⇐ 149
  class_invalid_range            ⇐ 150
  octal_byte_too_big             ⇐ 151
  internal_overran_workspace     ⇐ 152
  internal_missing_subpattern    ⇐ 153
  define_too_many_branches       ⇐ 154
  backslash_o_missing_brace      ⇐ 155
  internal_unknown_newline       ⇐ 156
  backslash_g_syntax             ⇐ 157
  parens_query_r_missing_closing ⇐ 158
  verb_argument_not_allowed      ⇐ 159
  verb_unknown                   ⇐ 160
  subpattern_number_too_big      ⇐ 161
  subpattern_name_expected       ⇐ 162
  internal_parsed_overflow       ⇐ 163
  invalid_octal                  ⇐ 164
  subpattern_names_mismatch      ⇐ 165
  mark_missing_argument          ⇐ 166
  invalid_hexadecimal            ⇐ 167
  backslash_c_syntax             ⇐ 168
  backslash_k_syntax             ⇐ 169
  internal_bad_code_lookbehinds  ⇐ 170
  backslash_n_in_class           ⇐ 171
  callout_string_too_long        ⇐ 172
  unicode_disallowed_code_point  ⇐ 173
  utf_is_disabled                ⇐ 174
  ucp_is_disabled                ⇐ 175
  verb_name_too_long             ⇐ 176
  backslash_u_code_point_too_big ⇐ 177
  missing_octal_or_hex_digits    ⇐ 178
  version_condition_syntax       ⇐ 179
  internal_bad_code_auto_possess ⇐ 180
  callout_no_string_delimiter    ⇐ 181
  callout_bad_string_delimiter   ⇐ 182
  backslash_c_caller_disabled    ⇐ 183
  query_barjx_nest_too_deep      ⇐ 184
  backslash_c_library_disabled   ⇐ 185
  pattern_too_complicated        ⇐ 186
  lookbehind_too_long            ⇐ 187
  pattern_string_too_long        ⇐ 188
  internal_bad_code              ⇐ 189
  internal_bad_code_in_skip      ⇐ 190
  no_surrogates_in_utf16         ⇐ 191
  bad_literal_options            ⇐ 192
  supported_only_in_unicode      ⇐ 193
  invalid_hyphen_in_options      ⇐ 194
  alpha_assertion_unknown        ⇐ 195
  script_run_not_available       ⇐ 196
  too_many_captures              ⇐ 197
  condition_atomic_assertion_expected ⇐ 198
  backslash_k_in_lookaround      ⇐ 199

  nomatch    ⇐  ¯1
  partial    ⇐  ¯2

  utf8_err1  ⇐  ¯3
  utf8_err2  ⇐  ¯4
  utf8_err3  ⇐  ¯5
  utf8_err4  ⇐  ¯6
  utf8_err5  ⇐  ¯7
  utf8_err6  ⇐  ¯8
  utf8_err7  ⇐  ¯9
  utf8_err8  ⇐ ¯10
  utf8_err9  ⇐ ¯11
  utf8_err10 ⇐ ¯12
  utf8_err11 ⇐ ¯13
  utf8_err12 ⇐ ¯14
  utf8_err13 ⇐ ¯15
  utf8_err14 ⇐ ¯16
  utf8_err15 ⇐ ¯17
  utf8_err16 ⇐ ¯18
  utf8_err17 ⇐ ¯19
  utf8_err18 ⇐ ¯20
  utf8_err19 ⇐ ¯21
  utf8_err20 ⇐ ¯22
  utf8_err21 ⇐ ¯23

  utf16_err1 ⇐ ¯24
  utf16_err2 ⇐ ¯25
  utf16_err3 ⇐ ¯26

  utf32_err1 ⇐ ¯27
  utf32_err2 ⇐ ¯28

  baddata           ⇐ ¯29
  mixedtables       ⇐ ¯30
  badmagic          ⇐ ¯31
  badmode           ⇐ ¯32
  badoffset         ⇐ ¯33
  badoption         ⇐ ¯34
  badreplacement    ⇐ ¯35
  badutfoffset      ⇐ ¯36
  callout           ⇐ ¯37
  dfa_badrestart    ⇐ ¯38
  dfa_recurse       ⇐ ¯39
  dfa_ucond         ⇐ ¯40
  dfa_ufunc         ⇐ ¯41
  dfa_uitem         ⇐ ¯42
  dfa_wssize        ⇐ ¯43
  internal          ⇐ ¯44
  jit_badoption     ⇐ ¯45
  jit_stacklimit    ⇐ ¯46
  matchlimit        ⇐ ¯47
  nomemory          ⇐ ¯48
  nosubstring       ⇐ ¯49
  nouniquesubstring ⇐ ¯50
  null              ⇐ ¯51
  recurseloop       ⇐ ¯52
  depthlimit        ⇐ ¯53
  recursionlimit    ⇐ ¯53
  unavailable       ⇐ ¯54
  unset             ⇐ ¯55
  badoffsetlimit    ⇐ ¯56
  badrepescape      ⇐ ¯57
  repmissingbrace   ⇐ ¯58
  badsubstitution   ⇐ ¯59
  badsubspattern    ⇐ ¯60
  toomanyreplace    ⇐ ¯61
  badserializeddata ⇐ ¯62
  heaplimit         ⇐ ¯63
  convert_syntax    ⇐ ¯64
  internal_dupmatch ⇐ ¯65
  dfa_uinvalid_utf  ⇐ ¯66
}


newline ⇐ {
  ⟨
    cr
    lf
    crlf
    any
    anycrlf
    nul
  ⟩ ⇐ 1+↕6
}

bsr ⇐ {
  ⟨
    unicode
    anycrlf
  ⟩ ⇐ 1+↕2
}

info ⇐ {
  ⟨
    alloptions
    argoptions
    backrefmax
    bsr
    capturecount
    firstcodeunit
    firstcodetype
    firstbitmap
    hascrorlf
    jchanged
    jitsize
    lastcodeunit
    lastcodetype
    matchempty
    matchlimit
    maxlookbehind
    minlength
    namecount
    nameentrysize
    nametable
    newline
    depthlimit
    size
    hasbackslashc
    framesize
    heaplimit
    extraoptions
  ⟩ ⇐ ↕27
  recursionlimit ⇐ depthlimit # Obsolete synonym
}

config ⇐ {
  ⟨
    bsr
    jit
    jittarget
    linksize
    matchlimit
    newline
    parenslimit
    depthlimit
    stackrecurse
    unicode
    unicode_version
    version
    heaplimit
    never_backslash_c
    compiled_widths
    tables_length
  ⟩ ⇐ ↕16
  recursionlimit ⇐ depthlimit # Obsolete synonym
}
