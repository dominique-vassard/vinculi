module Utils.ZipList
    exposing
        ( ZipList
        , init
        , back
        , forward
        , current
        , add
        , update
        , hasPrevious
        , hasNext
        )

{-| This module is designed to provide a simple ZipList.
Typical usecase is history management


# the `ZipList` type

@docs ZipList


# Initializing

@docs init


# Manage

@docs add, update


# Movinf around

@docs current, back, forward


# Checks

@docs hasPrevious, hasNext

-}


{-| ZipList a record containing three pieces of information:

  - `previous`: contains all previous items
  - `current`: holds the current item
  - `next`: contains all next items

Therefore, the complete list of items is: `previous ++ [current] ++ next`

-}
type alias ZipList item =
    { previous : List item
    , current : item
    , next : List item
    }


{-| Initializes the `ZipList`.

Note that `ZipList` is initialize with an empty `previous` List.


### Arguments

  - `(item)`: The current item

  - `(List item)`: The next items

    init 1 [2, 3, 4, 5] == {previous = [], current = 1, next = [2, 3, 4, 5]}

-}
init : item -> List item -> ZipList item
init item items =
    ZipList [] item items


{-| Get one step backward into ZipList.

If previous list is empty, current item is returned

    --  ziplist = {previous = [1, 2], current = 3, next = [4, 5]}
    back ziplist == {previous = [1], current = 2, next = [3, 4, 5]}

-}
back : ZipList item -> ZipList item
back items =
    let
        checkCurrent =
            items.previous
                |> List.reverse
                |> List.head

        newItems =
            case checkCurrent of
                Maybe.Just current ->
                    { items
                        | previous =
                            items.previous
                                |> List.reverse
                                |> List.tail
                                |> toList
                                |> List.reverse
                        , current = current
                        , next = items.current :: items.next
                    }

                Maybe.Nothing ->
                    items
    in
        newItems


{-| Get one step forward into ZipList.

If next list is empty, current item is returned.

    --  ziplist = {previous = [1, 2], current = 3, next = [4, 5]}
    back ziplist == {previous = [1, 2, 3], current = 4, next = [5]}

-}
forward : ZipList item -> ZipList item
forward items =
    let
        checkCurrent =
            List.head items.next

        newItems =
            case checkCurrent of
                Maybe.Just current ->
                    { items
                        | previous = items.previous ++ [ items.current ]
                        , current = current
                        , next =
                            items.next
                                |> List.tail
                                |> toList
                    }

                Maybe.Nothing ->
                    items
    in
        newItems


{-| Return current item

    --  ziplist = {previous = [1, 2], current = 3, next = [4, 5]}
    current ziplist == 3

-}
current : ZipList item -> item
current items =
    items.current


{-| Add a new items to ZipList.

Clean `next` list, add the new `item` to it and move ZipList forward.

This method should be used to rewrite the `next` part of ZipList while
keeping all `previous` items

    -- ziplist = {previous = [1, 2], current = 3, next = [4, 5]}
    add 6 ziplist == {previous = [1, 2, 3], current = 6, next = []}

-}
add : item -> ZipList item -> ZipList item
add item items =
    let
        newItems =
            { items | next = [ item ] }
    in
        newItems |> forward


{-| Update current item.

    -- ziplist = {previous = [1, 2], current = 3, next = [4, 5]}
    update 6 ziplist == {previous = [1, 2], current = 6, next = [4, 5]}

-}
update : item -> ZipList item -> ZipList item
update item items =
    { items | current = item }


{-| Determine wether there is any previous items

    -- ziplist = {previous = [1, 2], current = 3, next = [4, 5]}
    hasPrevious ziplist == True

    -- ziplist2 = {previous = [], current = 1, next = [2, 3, 4, 5]}
    hasPrevious ziplist2 == False

-}
hasPrevious : ZipList item -> Bool
hasPrevious items =
    List.length items.previous > 0


{-| Determine wether there is any previous items

    -- ziplist = {previous = [1, 2], current = 3, next = [4, 5]}
    hasNext ziplist == True

    -- ziplist2 = {previous = [1, 2, 3, 4], current = 5, next = []}
    hasPrevious ziplist2 == False

-}
hasNext : ZipList item -> Bool
hasNext items =
    List.length items.next > 0


{-| Convert a `Maybe List` to a `List`

    toList (Just [1, 2]) == [1, 2]
    toList Nothing == []

-}
toList : Maybe (List a) -> List a
toList items =
    case items of
        Maybe.Just list ->
            list

        Maybe.Nothing ->
            []
