//
//  main.swift
//  Colors Everywhere
//
//  Created by Matthias Lamoureux on 10/09/2019.
//  Copyright © 2019 QSC. All rights reserved.
//
import Foundation

let fileManager = FileManager.default

// Project base directory
let rootPathURL = URL(fileURLWithPath: fileManager.currentDirectoryPath)
// Directory where the generated file should go
let filePathURL = rootPathURL.appendingPathComponent("TestApp/Resources/Generated")

extension FileManager {
    /// Enumerates all the sub directories of and url having a given extension.
    ///
    /// - parameter url: The root url
    /// - parameter ext: The extension of the searched subdirectories (without the '.')
    ///
    /// - returns: An array containing all the urls of the subdirectories
    func findSubDirectories(from url: URL, withExtension ext: String) -> [URL] {
        let directoryEnumerator = enumerator(at: url, includingPropertiesForKeys: [.isDirectoryKey])
        var result = [URL]()
        
        while let element = directoryEnumerator?.nextObject() as? URL {
            if (try? element.resourceValues(forKeys: [.isDirectoryKey]).allValues[.isDirectoryKey]) as? Bool == true {
                if element.pathExtension.lowercased() == ext {
                    directoryEnumerator?.skipDescendants()
                    result.append(element)
                }
            }
        }
        
        return result
    }
    
    /// Enumerates all the assets catalogs
    func findAssetsCatalogs(form url: URL) -> [URL] {
        return findSubDirectories(from: url, withExtension: "xcassets")
    }
    
    /// Enumerates all the color sets
    func findColorSets(form url: URL) -> [URL] {
        return findSubDirectories(from: url, withExtension: "colorset")
    }
}

/// Structure matching the `Contents.json` inside a color set
struct ColorSetContent : Decodable {
    let colors : [IdiomColor]
    struct IdiomColor: Decodable {
        let appearances : [Appearance]?
        let color: Color
        struct Color : Decodable {
            let components : Components
            struct Components : Decodable {
                let red: String
                let green: String
                let blue: String
                let alpha: String
            }
        }
        struct Appearance : Decodable { }
    }
    
    /// Loads the content of a color set content file
    ///
    /// - parameter jsonPath: The path to the json content file
    init(jsonPath : String) throws {
        let data = try Data(contentsOf: URL(fileURLWithPath: jsonPath))
        let decoder = JSONDecoder()
        self = try decoder.decode(ColorSetContent.self, from: data)
    }
    
    /// The default color components for a color set (the one without a specified appearcance)
    var defaultComponents : IdiomColor.Color.Components? {
        return colors.filter { $0.appearances == nil }.first?.color.components
    }
}

extension String {
    /// The double value, reduced to 1 when the string is a hexadecimal value
    ///
    /// If the string is a double, returns the double value.
    /// If it contains a 'x', it assumes it's an hexadecimal value and returns the value divided by 255.
    /// Returns 0 otherwise.
    var unitComponent : Double {
        guard let double = Double(self)
            else { return 0.0 }
        
        if contains("x") {
            return double / 255.0
        }
        else {
            return double
        }
    }
}

/// Header of the generated file
var fileContent = """
// ••••••••••••••••••
// • GENERATED FILE •
// ••••••••••••••••••
import UIKit
let _defaultColors : [String:UIColor] = [
"""

/// Finds all the assets catalogs
let catalogs = fileManager.findAssetsCatalogs(form: rootPathURL)

for catalog in catalogs {
    let catalogName = catalog.lastPathComponent
    fileContent += "    // • \(catalogName)\n"
    
    /// Find all the color sets of the catalog
    let colorSets = fileManager.findColorSets(form: catalog)
    for colorSet in colorSets {
        let content = colorSet.appendingPathComponent("Contents.json").path
        guard fileManager.fileExists(atPath: content)
            else { continue }
        
        let name = colorSet.deletingPathExtension().lastPathComponent
        
        guard let setContent = try? ColorSetContent(jsonPath: content)
            else {
                fileContent += "    // JSON Parsing error on color \"\(name)\"\n"
                continue
        }
    
        if let components = setContent.defaultComponents {
            /// Adds the directory entry
            fileContent += "    \"\(name)\" : UIColor(red: \(components.red.unitComponent), green: \(components.green.unitComponent), blue: \(components.blue.unitComponent), alpha: \(components.alpha.unitComponent)),\n"
        }
        else {
            fileContent += "    // Impossible to find defaults components on color \"\(name)\"\n"
        }
    }
}

/// Closing the final bracket
fileContent += "]\n"

print(fileContent)

do {
    /// Creates the destination directory if it does not exist
    if !fileManager.fileExists(atPath: filePathURL.path) {
        try fileManager.createDirectory(at: filePathURL, withIntermediateDirectories: true, attributes: nil)
    }
    
    /// Writes the generated file
    try fileContent.write(to: filePathURL.appendingPathComponent("DefaultColorsGenerated.swift"), atomically: true, encoding: .utf8)
    
    print("✅ File Saved to \(filePathURL.path)")
}
catch {
    print(error)
    exit(1)
}
