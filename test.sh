#!/bin/bash

declare -gi ERROR=0
assert() {
  local -a args result
  local -i i=1 err
  local a f=sample/$PROGRAM ret
  for a; do
    [[ $a == EXPECTS ]] && break
    i+=1
  done
  args=("${@:1:i-1}")
  result=("${@:i+1}")
  ret=$(./strew -q "$f" "${args[@]}" 2>/dev/null)
  if [[ "$ret" == "${result[*]}" ]]; then
    echo OK: "$PROGRAM" "$@"
  else
    cat <<EOF
NG: $PROGRAM ${args[@]@Q}
    EXPECTS: ${result[@]@Q}
    OUTPUTS: ${ret[@]@Q}
EOF
    ERROR+=1
  fi
  return $err
}

PROGRAM=char.sr
assert $'\a' EXPECTS bell
assert $'\b' EXPECTS backspace
assert $'\t' EXPECTS horizontal tab
assert $'\n' EXPECTS newline
assert $'\v' EXPECTS vertical tab
assert $'\f' EXPECTS form feed
assert $'\r' EXPECTS carriage ret
assert ' ' EXPECTS space
assert '!' EXPECTS exclamation mark
assert '"' EXPECTS quotation mark
assert '#' EXPECTS number sign
assert '$' EXPECTS dollar sign
assert '%' EXPECTS percent sign
assert '&' EXPECTS ampersand
assert "'" EXPECTS apostrophe
assert '(' EXPECTS left parenthesis
assert ')' EXPECTS right parenthesis
assert '*' EXPECTS asterisk
assert '+' EXPECTS plus sign
assert ',' EXPECTS comma
assert '-' EXPECTS hyphen minus
assert '.' EXPECTS full stop
assert '/' EXPECTS slash
assert ':' EXPECTS colon
assert ';' EXPECTS semicolon
assert '<' EXPECTS less-than sign
assert '=' EXPECTS equals sign
assert '>' EXPECTS greater-than sign
assert '?' EXPECTS question mark
assert '@' EXPECTS at sign
assert '[' EXPECTS left square bracket
assert '\' EXPECTS backslash
assert ']' EXPECTS right square bracket
assert '^' EXPECTS caret
assert '_' EXPECTS underscore
assert '`' EXPECTS grave accent
assert '{' EXPECTS left curly bracket
assert '|' EXPECTS vertical bar
assert '}' EXPECTS right curly bracket
assert '~' EXPECTS tilde

PROGRAM=tm-0n1n.sr
for i in 0 00 000 0000; do
  i+=${i//0/1}
  assert $i EXPECTS accept
done

PROGRAM=tm-02n.sr
for i in 0 00 0000 00000000; do
  assert $i EXPECTS accept
done

PROGRAM=fizzbuzz.sr
for i in $(seq 30); do
  if ((i%15==0)); then
    assert $i EXPECTS FizzBuzz
  elif ((i%3==0)); then
    assert $i EXPECTS Fizz
  elif ((i%5==0)); then
    assert $i EXPECTS Buzz
  else
    assert $i EXPECTS $i
  fi
done

if ((ERROR)); then
  echo "$ERROR errors found"
  exit 1
fi
