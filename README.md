# bqn-pcre2
Basic regex functionality via the pcre2 library.

Requires installed pcre2 library and CBQN compiled with FFI support.

## Modes
Set the character width when importing by passing an options namespace with `mode ⇐ "c8","c16","c32", or "utf8"`.
For example: `pcre2 ← {mode⇐"c8"} •Import "pcre2.bqn"`
If not given, it is imported in the mode specified in `defaults.bqn`.
(Note that CBQN uses c8, c16, and c32 representations by default so utf8 mode is not usually what you want.)

## Functions

### `Compile`
`𝕩` - string containing a valid pcre2 regular expression.

`𝕨`(optional) - options namespace `{option⇐value, ...}`.

Returns a namespace containing the compiled expression and the following functions:
  * `Test`: Returns `1` if `𝕩` matches, `0` otherwise.
  * `Match`: Returns a list containing the first match in text `𝕩` and any capture groups.
  * `IMatch`: Returns a list containing pairs of indices of the first match and capture groups.
  * `MatchAll`: Global match. Returns a list of all matches in `𝕩`.
  * `_Replace`: Replace first match in `𝕩` according to replacement pattern `𝕗`.
  * `_ReplaceAll`: Global replace. Replace all matches in `𝕩` according to pattern `𝕗`.
  * `Free`: Free the compiled expression.
  
  ### `_MatchAll`
  `𝕗` - string containing a valid pcre2 regular expression.
  
  `𝕩` - text to match against.
  
  `𝕨`(optional) - options namespace `{option⇐value, ...}`.
  
  Compiles expression `𝕗` and calls `MatchAll` on `𝕩`, calls `Free` when finished.
  
  ### `_ReplaceAll_`
  `𝕗` - string containing a valid pcre2 regular expression.
  
  `𝕘` - replacement pattern.
  
  `𝕩` - text to match against.
  
  `𝕨`(optional) - options namespace `{option⇐value, ...}`.
  
  Compiles expression `𝕗` and calls `_ReplaceAll` with pattern `𝕘` on `𝕩`, calls `Free` when finished.

## Options
Options are given as a namespace `{option⇐value, ...}` and can be passed as `𝕨` to `•Import` to set default, or passed to `Compile`, `_MatchAll`, and `_ReplaceAll_`.
  * `utf` - Must be set when calling `•Import`. Sets encoding width. Possible values: `8`, `16`, `32`.
  * `jit` - Enable jit compiling of regular expressions. Default: `jit⇐1`.
  * `ucp` - Use unicode properties to determine character types for \w, \d, as well as character cases. Default: `ucp⇐0`.
  * `multiline` - Multiline matching mode. Default: `multiline⇐1`.
  * `greedy` - If `0` inverts greedy modifiers. Default: `greedy⇐1`.
  * `anchored` - Force pattern anchoring. Default: `anchored⇐0`.
  * `caseless` - Ignore cases when matching. Default: `caseless⇐0`.
  * `extended` - Ignore whitespace and comments in regular expressions. Default: `extended⇐0`.
  * `substitute_extended` - Extended replacement processing mode. Default: `substitute_extended⇐0`.
  

Other options:
  * `bufsize` - Initial size of output buffer when doing replacement. Automatically resizes if too small. Default: `bufsize⇐0`.
  * `overlap` - MatchAll, after matching, will only move offset by 1 character rather than to end of the match. Default: `overlap⇐0`.

Options are given as a namespace `{option⇐value, ...}` and can be passed as `𝕨` to `•Import`, `Compile`, `_MatchAll`, and `_ReplaceAll_`.
  * `usejit` - Enable jit compiling of regular expressions.
  * `overlapping` - Whether `MatchAll` should advance only a single character after a previous match instead of to the end of the match. (Currently must be set when pcre2.bqn is imported.)
  * `initsubbuf` - Initial buffer size for replacements.
