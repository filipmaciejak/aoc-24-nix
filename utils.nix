let
  inherit (builtins)
    add
    elemAt
    filter
    foldl'
    head
    lessThan
    readFile
    split
    sort
    stringLength
    substring
    tail;

  abs = num: if num < 0 then -num else num;

  enumerate = { index ? 0, list}:
    if list == [] then [] else
    [ { idx = index; val = head list; } ]
    ++ (enumerate { index = index + 1; list = tail list; });

  parseInt = str:
    if str == "0" then 0 else
    if str == "1" then 1 else
    if str == "2" then 2 else
    if str == "3" then 3 else
    if str == "4" then 4 else
    if str == "5" then 5 else
    if str == "6" then 6 else
    if str == "7" then 7 else
    if str == "8" then 8 else
    if str == "9" then 9 else
    let
      str_length = stringLength str;
      str_head = substring 0 1 str;
      str_tail = substring 1 (str_length - 1) str;
      power = pow { num = 10; power = str_length - 1; };
    in
      (parseInt str_head) * power + (parseInt str_tail);

  pow = { num, power }:
    if power == 0 then 1 else
    num * (pow { num = num; power = power - 1; });

  readLines = path: splitLines (readFile path);

  sortAscending = list:
    sort lessThan list;

  splitBy = regex: str:
    filter (x: x != [] && x != "") (split regex str);

  splitLines = str: splitBy "\n" str;

  sum = list: foldl' add 0 list;

  unzip = list:
    foldl' (acc: item:
      let
        list1 = elemAt acc 0;
        list2 = elemAt acc 1;
        tail1 = elemAt item 0;
        tail2 = elemAt item 1;
      in
        [ (list1 ++ [ tail1 ]) (list2 ++ [ tail2 ]) ]
    )
    [ [] [] ]
    list;

  zip = lists:
    let
      list1 = elemAt lists 0;
      list2 = elemAt lists 1;
      head1 = head list1;
      head2 = head list2;
      tail1 = tail list1;
      tail2 = tail list2;
    in
      if (list1 == []) || (list2 == []) then [] else
      [ [ head1 head2 ] ] ++ (zip [ tail1 tail2 ]);
in
  {
    inherit
      abs
      enumerate
      parseInt
      pow
      readLines
      sortAscending
      splitBy
      splitLines
      sum
      unzip
      zip;
  }
