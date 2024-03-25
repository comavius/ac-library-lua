# TL;DR
This is Lua version of [ac-library](https://github.com/atcoder/ac-library).

# Usage
Currently, we do not have any ways to unfold Lua project with multiple files to single Lua file. WIP

# About Encapsulation
As you known, class structures are often expressed as a `table` instance in Lua. However, `table` does not support private members. Therefore, in this project, all member variables that need to be hidden are contained in ${CLASS_TABLE}.private, which is also a table.
