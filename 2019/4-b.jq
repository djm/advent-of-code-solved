# "111111-111121\n" |

def toNumArray:
  tostring | split("") | map(tonumber)
;

def parse:
  split("\n") | map(select(. != ""))[0] | split("-") | map(tonumber)
;

def oneThatAppearsTwice:
  reduce to_entries[] as $_ (
    {};
    . + { ($_.value | tostring): (.[($_.value | tostring)] + 1) }
  )
  | with_entries(select(.value == 1))
  | length > 0
;

def doubles:
  . as $source |
  reduce range(0; length) as $i (
    [];
    if $source[$i] == $source[$i+1] then
      . + [$source[$i]]
    else . end
  ) | if any and oneThatAppearsTwice then $source else [] end
;

def steady:
  . as $source | if length > 0 then
    reduce range(0; length - 1) as $i (
      .;
      if . and $source[$i] <= $source[$i+1] then true else empty end
    ) | if . then $source | join("") | tonumber else empty end
  else
    empty
  end
;

def inc:
  join("") | tonumber + 1
;

def search(last):
  [range(.; last + 1)]
  | map(
    select(toNumArray | doubles | steady)
  )

;

parse as [$first, $last] | $first | $first | search($last)
| length

# [677888] | map(search(.)[])
