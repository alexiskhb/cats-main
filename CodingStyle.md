# CATS Coding Style

This document describes coding style conventions used by CATS project.
Code for this project is located in `cats-main`, `cats-judge` and `cats-problem` repositories.

## Required conventions
Required conventions are designated by words MUST and MUST NOT.
Existing code (mostly) conforms with required conventions.
Non-conforming new contributions will probably be rejected.
Patches fixing violations in existing code will probably be accepted.

## Recommended conventions
Recommended conventions are designated by words SHOULD and SHOULD NOT.
Existing code partially conforms with recommended conventions. However there are significant exceptions due to either historical or practical reasons.
Non-conforming new contributions may be accepted if there is a good reason
for violation.
Patches fixing violations of recommended conventions in existing code without any other changes will probably be rejected.

## Absent conventions
Absent conventions are designated by words MAY or OPTIONAL(LY).
Those choices are explicitly not standardized and may be different in each instance.

## Deprecated code
Some historical code, mostly located in `unused` directory, does not conform to any conventions and is not expected to ever change.

## Whitespace
* Perl code MUST be indented by 4 (four) spaces.
* Template and Javascript code SHOULD be indented by 2 (two) spaces.
* Operators, including fat comma (`=>`) and conditional (`?:`) MUST be surrounded by a single space from each side.
* Comma MUST be have a single space on the right and MUST NOT have a space on the left.
* Functions and `use` statement categories MUST be separated by a single empty line.
* Single empty lines MAY be used to separate logical blocks of code.
* Code MUST not have two or more consecutive empty lines,
* Parentheses MUST NOT have spaces inside.
* Parentheses MUST have spaces outside except between subroutine name and parameter list, where space MUST NOT be present.
* Square brackets MUST NOT have spaces inside when they designate array index and MUST have spaces inside otherwise.
* Curly brackets MUST NOT have spaces inside when they designate hash index and MUST have spaces inside otherwise.
* Code lines MUST be shorter than 120 characters.
* Code lines SHOULD be shorter than 100 characters.
* When a statement is split into several lines, split position SHOULD be after the  operator of the lowest possible priority. Exception: if a line is split at the position of low-priority logical operator (`and`, `or`), such operator MUST go on the new line.
* Semicolon MUST NOT have space on the left and SHOULD be followed by either a comment or end of line.
* Single-statement subroutines SHOULD omit trailing semicolon.
* Subroutines SHOULD omit the `return` keyword in the final statement.

## Statements and blocks
* There SHOULD be no more than one statement per line.
* For compound statements and subroutines, opening braces of body code blocks MUST be at the end of the line, not on a separate line.
* Prefix and suffix compound statements as well as low-priority logical operators MAY be used interchangeably.
* Suffix compound statements MUST NOT have parentheses around the condition.
* Low-priority logical operators MUST NOT be used inside of statements (`if ($x and $y)` is wrong).
* High-priority logical operators MUST NOT be used between statements (`$x || return` is wrong).
* Embedded SQL MUST start from a new line, after opening quote. Exception: very short SQL parts during request construction.
* Parameters passed to SQL statement MUST start from the new line.
* Lists spanning more than one line SHOULD have a trailing comma.
* Redundant parentheses SHOULD be omitted.
* `for` keyword MUST be used instead of `foreach`.
* Parameter assignment MUST be the first line of subroutine and SHOULD be of the form `my ($p1, $p2, ...) = @_;`.

## Comments
* Comments MUST be worded as full English sentences, with capitalization and full stops.
* Comment MUST have a single space between `#` character and text.
* Comments SHOULD be on a separate line immediately preceding commented code.
* Commented-out code SHOULD NOT be committed.

## Quoting
* Strings without interpolation MUST use single quotes.
* Regexps SHOULD use slash.
* If alternative quoting is desired, tilde character MUST be used for both strings and regexps (i.e. use `q~`, `qq~`, `m~`, `s~`).
* Alternative quoting with tilde MUST be used for all embedded SQL.
* Identifiers used as hash indexes MUST not be quoted (except where required by language).

## Identifiers and packages
* Package/class identifiers MUST use `CamelCase` (exception: `cats` package for global constants defined in `CATS::Constants`).
* All other identifiers MUST use `snake_case`.
* Object instance variable MUST be named `$self`.
* Packages MUST NOT export anything by default (exception: `CATS::DB`).
* `use` statements MUST be sorted alphabetically inside of each category. Categories MUST be listed in the following order:
    * directives
    * `Exporter`
    * standard packages
    * CATS packages.
* Import lists MUST use `qw()` and MUST be sorted alphabetically.
* New code SHOULD NOT introduce new global variables.
* Leading underscore MAY be used to indicate package-local subroutines.

## Strictness and warnings
* All packages MUST start from `use strict` and `use warnings` statements.
* `no strict` statement MUST be enclosed in a smallest possible block.
* Code SHOULD NOT generate any warnings.

## Security
* User-supplied values MUST be passed to SQL via parameters only.
* User-supplied data MUST be quoted with either `html` or `$Javascript` filter in templates.
* HTTP parameters SHOULD be verified using `CATS::Router`.

## Templates
* CATS-specific URLs MUST be generated by Perl code (using `url_f`/`url_function`).
* User-visible text in templates MUST be internationalized (see `lang` directory).
* `PROCESS` directive MUST NOT use quotes around argument except when interpolation is required.
* Templates SHOULD try to avoid extra whitespace in HTML by using `[%- -%]` and `[%~ ~%]` constructs.
* Templates MUST use loop variable in `FOREACH` loops.

## General
* Code from `cats-main` and `cats-problem` repositories MUST be compatible with Perl v5.10.
* Code from `cats-judge` repository MUST be compatible with Perl v5.14.