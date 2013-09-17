" Vim syntax file
" Language:	CleverCSS
" Maintainer:	Zak Johnson <zakj@nox.cx>
" Last Change:	2013-01-15

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

setlocal iskeyword+=45  " -

" http://simon.html5.org/html5-elements
syn keyword ccssElement contained
\ a address area article aside abbr audio b base bdo blockquote body br button
\ canvas caption cite code col colgroup command datalist dd del details dfn div
\ dl dt em embed fieldset figure footer form h1 h2 h3 h4 h5 h6 head header
\ hgroup hr html i iframe img input ins kbd keygen label legend li link map
\ mark menu meta meter nav noscript object ol optgroup option output p param
\ pre progress q rp rt ruby samp script section select small source span strong
\ style sub sup table tbody td textarea tfoot th thead time title tr ul var
\ video

" http://www.cssportal.com/css-properties/
syn keyword ccssProperty contained
\ alignment-adjust alignment-baseline appearance azimuth background
\ background-attachment background-break background-clip background-color
\ background-image background-origin background-position background-repeat
\ background-size baseline-shift binding bookmark-label bookmark-level
\ bookmark-target border border-bottom border-bottom-color
\ border-bottom-left-radius border-bottom-right-radius border-bottom-style
\ border-bottom-width border-break border-collapse border-color border-image
\ border-left border-left-color border-left-style border-left-width
\ border-length border-radius border-right border-right-color
\ border-right-style border-right-width border-spacing border-style border-top
\ border-top-color border-top-left-radius border-top-right-radius
\ border-top-style border-top-width border-width bottom box-align box-direction
\ box-flex box-flex-group box-lines box-orient box-pack box-shadow box-sizing
\ caption-side clear clip color color-profile column-break-after
\ column-break-before column-count column-fill column-gap column-rule
\ column-rule-color column-rule-style column-rule-width column-span
\ column-width columns content counter-increment counter-reset crop cue
\ cue-after cue-before cursor direction display dominant-baseline
\ drop-initial-after-adjust drop-initial-after-align drop-initial-before-adjust
\ drop-initial-before-align drop-initial-size drop-initial-value elevation
\ empty-cells fit fit-position float float-offset font font-effect
\ font-emphasize font-emphasize-position font-emphasize-style font-family
\ font-size font-size-adjust font-smooth font-stretch font-style font-variant
\ font-weight grid-columns grid-rows hanging-punctuation height hyphenate-after
\ hyphenate-before hyphenate-character hyphenate-lines hyphenate-resource
\ hyphens icon image-orientation image-resolution inline-box-align left
\ letter-spacing line-height line-stacking line-stacking-ruby
\ line-stacking-shift line-stacking-strategy list-style list-style-image
\ list-style-position list-style-type margin margin-bottom margin-left
\ margin-right margin-top mark mark-after mark-before marker-offset marks
\ marquee-direction marquee-play-count marquee-speed marquee-style max-height
\ max-width min-height min-width move-to nav-down nav-index nav-left nav-right
\ nav-up opacity orphans outline outline-color outline-offset outline-style
\ outline-width overflow overflow-style overflow-x overflow-y padding
\ padding-bottom padding-left padding-right padding-top page page-break-after
\ page-break-before page-break-inside page-policy pause pause-after
\ pause-before phonemes pitch pitch-range play-during position
\ presentation-level punctuation-trim quotes rendering-intent resize rest
\ rest-after rest-before richness right rotation rotation-point ruby-align
\ ruby-overhang ruby-position ruby-span size speak speak-header speak-numeral
\ speak-punctuation speech-rate stress string-set tab-side table-layout target
\ target-name target-new target-position text-align text-align-last
\ text-decoration text-emphasis text-height text-indent text-justify
\ text-outline text-replace text-shadow text-transform text-wrap top
\ unicode-bibi vertical-align visibility voice-balance voice-duration
\ voice-family voice-pitch voice-pitch-range voice-rate voice-stress
\ voice-volume volume white-space white-space-collapse widows width word-break
\ word-spacing word-wrap z-index

syn keyword ccssElement contained *
syn match ccssClassName contained "\.[A-Za-z][A-Za-z0-9_-]\+"
syn match ccssIdentifier contained "#[A-Za-z_@][A-Za-z0-9_@-]*"

syn match ccssPsuedoClass contained ":\S\+" contains=ccssPseudoClassId
syn keyword ccssPseudoClassId contained link visited active hover focus before after left right
syn match ccssPseudoClassId contained "\<first\(-\(line\|letter\|child\)\)\=\>"

syn match ccssValueInteger contained "[-+]\=\d\+"
syn match ccssValueNumber contained "[-+]\=\d\+\(\.\d*\)\="
syn match ccssValueLength contained "[-+]\=\d\+\(\.\d*\)\=\(%\|mm\|cm\|in\|pt\|pc\|em\|ex\|px\)"

syn match ccssValueColor contained "\<transparent\>"
syn match ccssValueColor contained "#[0-9A-Fa-f]\{3\}\>"
syn match ccssValueColor contained "#[0-9A-Fa-f]\{6\}\>"

syn region ccssValueURL contained start="\<url\s*(" end=")" matchgroup=ccssFunctionName oneline keepend
syn region ccssValueFunction contained start="\<\(rgb\|clip\|attr\|counter\|rect\)\s*(" end=")" matchgroup=ccssFunctionName oneline keepend

syn match ccssSelector "^\s*\zs[^:]\+" contains=ccssElement,ccssClassName,ccssIdentifier,ccssPseudo,ccssProperty nextgroup=ccssColon
syn match ccssColon ":\s*" nextgroup=ccssRightSide
syn match cCssRightSide "[^:]\+$" contains=ALLBUT,ccssElement,ccssProperty,ccssClassName,ccssIdentifier,ccssPseudo
syn region ccssComment start="//" end="$" oneline contains=@Spell

syn match ccssVariable contained "\$[A-Za-z][A-Za-z0-9_]*"

syn keyword ccssMethod contained abs
syn keyword ccssMethod contained brighten
syn keyword ccssMethod contained darken
syn keyword ccssMethod contained eval
syn keyword ccssMethod contained join
syn keyword ccssMethod contained length
syn keyword ccssMethod contained lower
syn keyword ccssMethod contained round
syn keyword ccssMethod contained split
syn keyword ccssMethod contained string
syn keyword ccssMethod contained strip
syn keyword ccssMethod contained upper


if version >= 508 || !exists("did_ccss_syn_inits")
  if version < 508
    let did_ccss_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink ccssElement Statement
  HiLink ccssClassName Label
  HiLink ccssIdentifier Label
  HiLink ccssPseudoClassId PreProc

  HiLink ccssProperty Type

  HiLink ccssComment Comment

  HiLink ccssValueInteger Number
  HiLink ccssValueNumber Number
  HiLink ccssValueLength Number
  HiLink ccssValueColor Constant
  HiLink ccssValueFunctionName Function

  HiLink ccssMethod Function
  HiLink ccssVariable Identifier

  delcommand HiLink
endif

let b:current_syntax = "clevercss"
