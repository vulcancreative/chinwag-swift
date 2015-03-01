//
//  Chinwag.swift
//  Chinwag
//
//  Created by Chris Calo on 2/26/15.
//  Copyright (c) 2015 Chris Calo. All rights reserved.
//

import Foundation

public let version = String.fromCString(CW_VERSION)!

// public typealias CWDict = cwdict_t
public class CWDict: NSObject, NSCopying {
  public var name: String {
    get {
      return String.fromCString(self.dict.name)!
    }

    set(name) {
      var nameC = UnsafeMutablePointer<Int8>.alloc(12)

      strcpy(nameC, (name as NSString).UTF8String)
      free(self.dict.name)
      self.dict.name = nameC
    }
  }

  public var length: UInt {
    return UInt(cwdict_length(self.dict))
  }

  public var isValid: Bool {
    return self.validate() == nil ? true : false
  }

  public var isSorted: Bool {
    get {
      return self.dict.sorted
    }

    set(sorted) {
      self.dict.sorted = sorted
    }
  }

  internal var dict: cwdict_t = cwdict_open()

  override init() {
    super.init()
    self.name = ""
  }

  convenience init(dict: cwdict_t) {
    self.init()
    self.dict = dict
  }

  convenience init(name: String) {
    self.init()
    self.name = name
  }
}

public enum CWError: String {
  case InvalidOutputType = "CWError.InvalidOutputType"
  case MinLessThanOne = "CWError.MinLessThanOne"
  case MaxLessThanMin = "CWError.MaxLessThanMin"
  case MaxTooHigh = "CWError.MaxTooHigh"
  case DictTooSmall = "CWError.DictTooSmall"
  case DictUnsortable = "CWError.DictUnsortable"
  case DictUnknown = "CWError.DictUnknown"
}

public enum CWType: cw_t {
  case Letters = 0
  case Words = 1
  case Sentences = 2
  case Paragraphs = 3
}

public enum CWEmbedded {
  case Seuss
  case Seussian
  case Latin
}

public var defaultDict: CWDict = open(embedded: .Seuss)!
public var defaultType = CWType.Words
public var defaultMinOutput: UInt = 1
public var defaultMaxOutput: UInt = 5

public func generate(dict: CWDict, kind: CWType, min: UInt, max: UInt)
-> (result: String, err: CWError?) {
    var err = dict.validate()
    if err != nil {
      return ("", err)
    }

    // TODO : not currently a primary feature in core library
    if max > 10000 {
      return ("", CWError.MaxTooHigh)
    }

    var errC = cwerror_t()
    var resultC = chinwag(kind.rawValue, min, max, dict.dict, &errC)

    if resultC == nil {
      switch errC {
        case cwerror_t(0):
          return ("", CWError.InvalidOutputType)
        case cwerror_t(1):
          return ("", CWError.MinLessThanOne)
        case cwerror_t(2):
          return ("", CWError.MaxLessThanMin)
        case cwerror_t(3):
          return ("", CWError.MaxTooHigh)
        default:
          return ("", CWError.DictUnknown)
      }
    }

    var result = String.fromCString(resultC)!
    free(resultC)

    return ("", nil)
}

public func generate()
-> (result: String, err: CWError?) {
    return generate(defaultDict, defaultType, defaultMinOutput, defaultMaxOutput)
}

public func open()
-> CWDict {
  return CWDict()
}

public func open(#name: String)
-> CWDict! {
  return CWDict(name: name)
}

// TODO : implement
public func open(#tokens: NSData)
-> CWDict? {
  return nil
}

// TODO : implement
public func open(#name: String, #tokens: NSData)
-> CWDict? {
  return nil
}

public func open(#embedded: CWEmbedded)
-> CWDict? {
  switch embedded {
    case .Seuss, .Seussian:
      return CWDict(dict: cwdict_open_with_name_and_tokens("Seussian", dict_seuss, CW_DELIMITERS))
    case .Latin:
      return CWDict(dict: cwdict_open_with_name_and_tokens("Latin", dict_latin,
      CW_DELIMITERS))
    default:
      return nil
  }
}

/*
// TODO : implement
infix operator + { associativity left precedence 140 }
public func +(left: CWDict, right: String)
-> CWDict {
  return open()
}

// TODO : implement
public func +(left: CWDict, right: [String])
-> CWDict {
  return open()
}

// TODO : implement
infix operator += { associativity left precedence 90 }
public func +=(inout left: CWDict, right: String) {
  left = left + right
}

// TODO : implement
public func +=(inout left: CWDict, right: [String]) {
  left = left + right
}

// TODO : implement
infix operator << { associativity left precedence 140 }
public func <<(inout left: CWDict, right: String) {
  return
}

// TODO : implement
public func <<(inout left: CWDict, right: [String]) {
  return
}

infix operator == { associativity left precedence 130 }
public func ==(left: CWDict, right: CWDict)
-> Bool {
  return cwdict_equal(left.dict, right.dict)
}

infix operator != { associativity left precedence 130 }
public func !=(left: CWDict, right: CWDict)
-> Bool {
  return cwdict_inequal(left.dict, right.dict)
}
*/

// separate extension for the sake of organization
public extension CWDict {
  public func copyWithZone(zone: NSZone)
  -> AnyObject {
    var copy = open()

    copy.dict = self.dict

    return copy
  }

  public func sort() {
    self.dict = cwdict_sort(self.dict)
  }

  public func prune() {
    self.dict = cwdict_prune(self.dict, false, false)
  }

  public func clean() {
    self.dict = cwdict_prune(self.dict, true, false)
  }

  public func exclude(word: String)
  -> Bool {
    var wordC = UnsafeMutablePointer<Int8>.alloc(12)

    strcpy(wordC, (word as NSString).UTF8String)
    let result = cwdict_exclude(self.dict, wordC)
    free(wordC)

    return result
  }

  public func include(word: String)
  -> Bool {
    var wordC = UnsafeMutablePointer<Int8>.alloc(12)

    strcpy(wordC, (word as NSString).UTF8String)
    let result = cwdict_include(self.dict, wordC)
    free(wordC)

    return result
  }

  public func validate()
  -> CWError? {
    var err = cwerror_t()

    if !cwdict_valid(self.dict, &err) {
      switch err {
        case cwerror_t(4):
          return CWError.DictTooSmall
        case cwerror_t(5):
          return CWError.DictUnsortable
        default:
          return CWError.DictUnknown
      }
    }

    return nil
  }

  public var size: UInt {
    return self.length
  }

  public var count: UInt {
    return self.length
  }

  public var largest: UInt {
    return UInt(cwdict_largest(self.dict))
  }

  public var sample: String? {
    if self.length == 0 {
      return nil
    }
    return String.fromCString(cwdict_sample(self.dict))!
  }

  // TODO : implement
  public func join(joiner: String)
  -> String {
    return ""
  }

  // TODO : implement
  public func string()
  -> String {
    var result = ""; var index: UInt = 0; let length = self.length
    let rowCount = self.dict.count

    result += "["

    for var i: UInt = 0; i != rowCount; ++i {
      // if index >= length { break }
      result += "["

      let current = self.dict.drows[Int(i)]
      let wordCount = current.count

      if current.words != nil {
        for var j: UInt = 0; j != wordCount; ++j {
          // println("\(index) of \(length)")
          let word = String.fromCString(current.words[Int(j)])
          if word == nil {
            result += "]]"
            return result
          }
          // println("[\(index):\(length)] \(word)")

          result += word!

          ++index; // println("index : \(index)")
          if index >= length {
            result += "]]"
            return result
          }

          if j < wordCount - 1 {
            result += ", "
          }
        }
      }

      result += "]"

      if i < rowCount - 1 {
        result += ", "
      }
    }

    result += "]"

    return result
  }

  public func close() {
    cwdict_close(self.dict)
  }
}
