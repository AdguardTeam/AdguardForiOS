/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © Adguard Software Limited. All rights reserved.

    Adguard for iOS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Adguard for iOS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
 */

import Foundation

/**
 `ChunkFileReader` is responsible for reading file by chunks without fully loading it to RAM,
 because in `SafariWebExtension` we have a limit of 6mb and average file is about 7mb

 There are 2 ways of using `ChunkFileReader`:
 1. You can use `nextChunk` which will return file content while it is not endded
 ```
 let fileReader = ChunkFileReader(fileUrl: someUrl)
 var totalString = ""
 while let string = fileReader.nextChunk {
    totalString += string
 }
 ```
 2. `ChunkFileReader` conforms to `Sequence` and can be used as any other sequence
 ```
 let fileReader = ChunkFileReader(fileUrl: someUrl)
 var totalString = ""
 for chunk in fileReader {
    totalString += chunk
 }
 ```

 - Important: Don't forget to close file with `close` function after finished reading it
 */
final class ChunkFileReader {

    // TODO: - write tests

    private let chunkSize: UInt64
    private var fileHandle: FileHandle?
    private var offset: UInt64 = 0

    init?(fileUrl: URL, chunkSize: UInt64 = 32768) {
        guard let fileHandle = FileHandle(forReadingAtPath: fileUrl.path) else {
            DDLogError("(ChunkFileReader) - init error")
            return nil
        }
        self.chunkSize = chunkSize
        self.fileHandle = fileHandle
    }

    deinit {
        close()
    }

    func nextChunk() -> String? {
        guard let fileHandle = fileHandle else {
            DDLogError("(ChunkFileReader) - nextChunk; Attempt to read from closed file")
            return nil
        }

        do {
            if let data = try fileHandle.read(upToCount: Int(chunkSize)) {
                offset += chunkSize
                try fileHandle.seek(toOffset: offset)
                return String(data: data, encoding: .utf8)
            } else {
                return nil
            }
        } catch {
            DDLogError("(ChunkFileReader) - nextChunk; Error reading file: \(error)")
            return nil
        }
    }

    func rewind() -> Bool {
        guard let fileHandle = fileHandle else {
            DDLogError("(ChunkFileReader) - rewind; Attempt to rewind with closed file")
            return false
        }

        do {
            try fileHandle.seek(toOffset: 0)
            return true
        } catch {
            DDLogError("(ChunkFileReader) - rewind; Error when rewinding: \(error)")
            return false
        }
    }

    func close() {
        do {
            try fileHandle?.close()
        } catch {
            DDLogError("(ChunkFileReader) - close; Error closing file: \(error)")
        }
        fileHandle = nil
    }
}

// MARK: - ChunkFileReader + Sequence

extension ChunkFileReader: Sequence {
    func makeIterator() -> some IteratorProtocol { AnyIterator { self.nextChunk() } }
}
