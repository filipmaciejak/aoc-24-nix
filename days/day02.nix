let
  utils = import ./../utils.nix;

  inherit (builtins)
    all
    any
    elemAt
    genList
    head
    length
    tail;

  inherit (utils)
    abs
    parseInt
    readLines
    splitBy
    sublist
    sum
    zip;

  parseLines = lines:
    map
    (pair: map parseInt pair)
    (map (splitBy " ") lines);

  parseInput = path: parseLines (readLines path);

  delta = list:
    let
      indexes = genList (x: x) ((length list) - 1);
      start = map (x: -(elemAt list x)) indexes;
      end = map (x: elemAt list (x + 1)) indexes;
    in
      map sum (zip [ start end ]);

  allPositive = list: all (x: x > 0) list;

  allNegative = list: all (x: x < 0) list;

  validValue = num:
    let
      value = abs num;
    in
      (value >= 1) && (value <= 3);

  allValidValues = list: all validValue list;
  
  f = list: (allValidValues list) && ((allNegative list) || (allPositive list));

  countTrue = list: sum (map (x: parseInt (toString x)) list);

  solvePart1 = input: countTrue (map f (map delta input));

  skip = index: list: (sublist 0 index list) ++ (sublist (index + 1) (length list) list);

  skipEach = list: map (x: skip x list) (genList (x: x) (length list));

  g = list: any (x: f (delta x)) ([ list ] ++ (skipEach list));

  solvePart2 = input: countTrue (map g input);

in
  {
    part1 = solvePart1 (parseInput ./input);
    part2 = solvePart2 (parseInput ./input);
  }
