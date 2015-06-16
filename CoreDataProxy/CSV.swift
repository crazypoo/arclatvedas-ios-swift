//
//  CSV.swift
//  SwiftCSV
//
//  Created by naoty on 2014/06/09.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
// from https://github.com/naoty/SwiftCSV.git

import Foundation

public class CSV {
    public var headers: [String] = []
    public var rows: [Dictionary<String, String>] = []
    public var rowsarray: [Dictionary<String, [String]>] = []   // colonnes dans un array, permet de recuperer des colonnes homonymes
    
    public var columns = Dictionary<String, [String]>()
    var delimiter = NSCharacterSet(charactersInString: ";")
    
    public init?(contentsOfURL url: NSURL, delimiter: NSCharacterSet, encoding: UInt, error: NSErrorPointer) {
        let csvString = String(contentsOfURL: url, encoding: encoding, error: error);
        if let csvStringToParse = csvString {
            self.delimiter = delimiter
            
            let newline = NSCharacterSet.newlineCharacterSet()
            var lines: [String] = []
            csvStringToParse.stringByTrimmingCharactersInSet(newline).enumerateLines { line, stop in lines.append(line) }
            
            self.headers = self.parseHeaders(fromLines: lines)
            self.rows = self.parseRows(fromLines: lines)
            self.rowsarray = self.parseRowsArray(fromLines: lines)
            self.columns = self.parseColumns(fromLines: lines)
        }
    }
    
    public convenience init?(contentsOfURL url: NSURL, error: NSErrorPointer) {
        let comma = NSCharacterSet(charactersInString: ";")
        self.init(contentsOfURL: url, delimiter: comma, encoding: NSUTF8StringEncoding, error: error)
    }
    
    public convenience init?(contentsOfURL url: NSURL, encoding: UInt, error: NSErrorPointer) {
        let comma = NSCharacterSet(charactersInString: ";")
        self.init(contentsOfURL: url, delimiter: comma, encoding: encoding, error: error)
    }
    
    func parseHeaders(fromLines lines: [String]) -> [String] {
        return lines[0].componentsSeparatedByCharactersInSet(self.delimiter)
    }
    
    func parseRows(fromLines lines: [String]) -> [Dictionary<String, String>] {
        var rows: [Dictionary<String, String>] = []
        
        for (lineNumber, line) in enumerate(lines) {
            if lineNumber == 0 {
                continue
            }
            
            var row = Dictionary<String, String>()
            let values = line.componentsSeparatedByCharactersInSet(self.delimiter)
            for (index, header) in enumerate(self.headers) {
                if index < values.count {
                    row[header] = values[index]
                } else {
                    row[header] = ""
                }
            }
            rows.append(row)
        }
        
        return rows
    }
    
    func parseRowsArray(fromLines lines: [String]) -> [Dictionary<String, [String]>] {
        var rows: [Dictionary<String, [String]>] = []
        
        for (lineNumber, line) in enumerate(lines) {
            if lineNumber == 0 {
                continue
            }
            
            var row = Dictionary<String, [String]>()
            let values = line.componentsSeparatedByCharactersInSet(self.delimiter)
            for (index, header) in enumerate(self.headers) {
                if index < values.count {
                    let val = values[index]
                    if (row[header] == nil)  {
                        row[header] = []
                    }
                    row[header]?.append(values[index])
                    
                } else {
                    row[header]?.append("")
                }
            }
            rows.append(row)
        }
        
        return rows
    }

    
    func parseColumns(fromLines lines: [String]) -> Dictionary<String, [String]> {
        var columns = Dictionary<String, [String]>()
        
        for header in self.headers {
            let column = self.rows.map { row in row[header] != nil ? row[header]! : "" }
            columns[header] = column
        }
        
        return columns
    }
}
