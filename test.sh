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
$PROGRAM ${args[@]@Q}
EXPECTS: ${result[@]@Q}
OUTPUTS: ${ret[@]@Q}
EOF
    ERROR+=1
  fi
  return $err
}

PROGRAM=tm-0n1n.sr
for i in 0 00 000 0000; do
  i+=${i//0/1}
  assert $i EXPECTS accept
done

PROGRAM=tm-02n.sr
for i in 0 00 0000 00000000; do
  assert $i EXPECTS accept
done

if ((ERROR)); then
  echo "$ERROR errors found"
  exit 1
fi
