/// Copyright (c) 2017 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

class SongBuilder: NSObject {

  // MARK: - Properties
  private var title: String?
  private var duration: TimeInterval = 0
  private var artist: String?
  private var mediaURL: URL?
  private var coverArtURL: URL?
  
  func build() -> Song? {
    guard let title = title,
      let artist = artist else {
        return nil
    }

    return Song(title: title, duration: duration, artist: artist, mediaURL: mediaURL, coverArtURL: coverArtURL)
  }
  
  func with(title: String?) -> Self {
    self.title = title
    return self
  }
  
  func with(duration: TimeInterval?) -> Self {
    self.duration = duration ?? 0
    return self
  }
  
  func with(artist: String?) -> Self {
    self.artist = artist
    return self
  }
  
  func with(mediaURL url: String?) -> Self {
    guard let urlstring = url else {
      return self
    }
    
    self.mediaURL = URL(string: urlstring)
    return self
  }
  
  func with(coverArtURL url: String?) -> Self {
    guard let urlstring = url else {
      return self
    }
    
    self.coverArtURL = URL(string: urlstring)
    return self
  }
}
