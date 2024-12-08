let
  utils = import ./../utils.nix;

  inherit (builtins)
    elemAt
    filter
    genList
    isList
    length
    readFile
    split;

  inherit (utils)
    nestedMap
    parseInt
    product
    sum;

  parseInput1 = input: filter (isList) (split "mul\\\(([0-9]+),([0-9]+)\\\)" input);

  solvePart1 = input: sum (map product (nestedMap parseInt 2 (parseInput1 input)));

  splitChunks = input: split "(do\\\(\\\)|don't\\\(\\\))" input;

  f = input:
    map
    (x:
      let
        item = elemAt input x;
      in
        if (isList item) then 0 else
	if (x == 0) || (elemAt input (x - 1) == [ "do()" ]) then (solvePart1 item) else
	0
    )
    (genList (x: x) (length input));

  solvePart2 = input: sum (f (splitChunks input));

in
  {
    part1 = solvePart1 (readFile ./input);
    part2 = solvePart2 (readFile ./input);
  }
