## Introduction


Chinwag, other than being a funny word, is an open-source, developer toolset used for text-synthesis. The goal is to allow for developers and designers (with a little programming experience) to be able to rapidly prototype text-heavy interfaces, but in a fun manner.

It is primarily written in C99 (for the sake of speed and portability), but has many official language bindings, covering C, Ruby, Python, Swift, and Go.

The library universally features:

* Powerful dictionary type with accompanying routines
* Several embedded dictionaries
* Easy custom dictionary creation and use
* Easy output configuration
* C99-based for speed and portability
* Zero dependencies

## Installation


```shell
$ pod install
```

## Versioning


When we make releases to the API, we strive for consistency across all of the various, language-flavors. Meaning &ndash; when we release an update to the core Chinwag API (in C99), we update all sister components. This should guarantee a consistent version release number across all equivalent libraries.


```swift
// EXAMPLE IN
import chinwag
println(CWVersion)
// Swift is minimally modular, hence a prefixed global constant
```

```sample
// EXAMPLE OUT
1.2.3
```

## Dictionaries


To generate output, you need to open a dictionary object. The dictionary can be blank, pulled from a custom token file, or loaded from one of Chinwag's embedded options &ndash; `Seussian` or `Latin`.


### Opening an Embedded Dictionary


```swift
// EXAMPLE IN
import chinwag
var seuss = CWDictOpen("Seussian")
var latin = CWDictOpen("Latin")
```

```sample
// EXAMPLE OUT
```


### Opening a Custom Dictionary

If you need a valid, custom dictionary to test against, we recommend our <a href="http://vulcanca.com/babble/docs/noise.dict" target="_blank">Noise dictionary</a>. It has several thousand entries, and will have no problem passing any and all internal validation procedures.


> Note : loading a custom dictionary does invoke quite a bit of IO overhead. It is best practice to load a dictionary and cache it for the entirety of its use cycle (often in a global variable).


### Opening a Blank Dictionary

While having a blank dictionary is not particularly useful, you can append to it after the fact, gradually building a functional dictionary. Blank, unnamed dictionaries have no internal heap allocations, when first initialized.

```swift
// EXAMPLE IN
import chinwag
var blank = CWDictOpen()
```

```sample
// EXAMPLE OUT
```


### Examining Dictionaries

If there is ever a reason you need to visually debug a dictionary, each of our libraries supports a visualization component. This forces the dictionary instance to spill its guts, via the command-line.

```swift
// EXAMPLE IN
import chinwag
var seuss = CWDictOpen("Seussian")
CWPrint(seuss)
```

```sample
// EXAMPLE OUT
```


### Dictionary Arithmetic


```swift
// EXAMPLE IN
import chinwag
var blank = CWDictOpen()
blank = CWPlaceWord(blank, "test")
blank = CWPlaceWords(blank, ["quick", "test"])
```

```sample
// EXAMPLE OUT
```


### Sorting and Pruning





### Duplication

As dictionaries are rooted as complex structs in C99, and require a variety of resources to initialize and close, duplication is a slightly complex procedure.

Nevertheless, we allow deep copies, via the library. Duplication will respect any sorting or pruning that has been done previously to the dictionary being copied, and will have a new address in memory.

```swift
// EXAMPLE IN
import chinwag
var seuss = CWDictOpen("Seussian")
var copy = CWDictCopy(seuss)
```

```sample
// EXAMPLE OUT
```


### In-Place Modification





### Closing a Dictionary


```swift
// EXAMPLE IN
import chinwag
var blank = CWDictClose(seuss)
// Clears all of seuss' internal, dynamic memory,
// and resets it to a blank dictionary, which
// you are free to capture
```

```sample
// EXAMPLE OUT
```

## Validation and Errors



```swift
// EXAMPLE IN
import chinwag
var blank = CWDictOpen("Blank")
let error = cwdict_valid(blank)

switch error
{
	case .CWDictTooSmall:
		// The dictionary had too few valid entries
		cwdict_warn(blank, error)
	case .CWDictUnsortable:
		// The dictionary couldn't sort entries by length
		cwdict_warn(blank, error)
	default:
		// You received another error, unrelated to the library
		cwdict_fail(blank, error)
}
```

```sample
// EXAMPLE OUT
CWDictTooSmall: too few acceptable entries (0 of 300)
```

## Generation



```swift
// EXAMPLE IN
import chinwag
var seuss = CWDictOpen("Seussian")
let output: String = CWGenerate(CWWords, 10, 20, seuss)
// Generates ten to twenty words in Seussian
```

```sample
// EXAMPLE OUT
```

## Legal


Chinwag is available under the <a href="http://opensource.org/licenses/MIT" target="_blank">MIT License</a>.<br>
Use, abuse, and please don't bite the hand that feeds you.
