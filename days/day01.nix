let
  utils = import ./../utils.nix;

  inherit (builtins)
    attrNames
    attrValues
    elemAt
    groupBy
    intersectAttrs
    length
    mapAttrs;

  inherit (utils)
    abs
    parseInt
    readLines
    sortAscending
    splitBy
    sum
    unzip
    zip;

  parseLines = lines:
    map
    (pair: map parseInt pair)
    (map (splitBy " +") lines);

  parseInput = path: parseLines (readLines path);

  sortColumnwise = lists: zip (map sortAscending (unzip lists));

  f = list:
    let
      left = elemAt list 0;
      right = elemAt list 1;
    in
      abs (left - right);

  solvePart1 = input: sum (map f (sortColumnwise input));

  countElements = list:
    mapAttrs
    (name: value: length value)
    (groupBy (x: toString x) list);

  mulElementwise = list1: list2:
    map
    (l: (elemAt l 0) * (elemAt l 1))
    (zip [ list1 list2 ]);

  g = counts:
    let
      counts1 = elemAt counts 0;
      counts2 = elemAt counts 1;
      intersection1 = intersectAttrs counts1 counts2;
      intersection2 = intersectAttrs counts2 counts1;
      a = attrValues intersection1;
      b = attrValues intersection2;
      c = map parseInt (attrNames intersection1);
      product = mulElementwise a (mulElementwise b c);
    in
      sum product;

  solvePart2 = input: g (map countElements (unzip input));
in
  {
    part1 = solvePart1 (parseInput ./input);
    part2 = solvePart2 (parseInput ./input);
  }
