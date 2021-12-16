//
//  FilteredImage.swift
//  UMem
//  use core image
//  Created by lq on 2021/12/16.
//

import Foundation
import SwiftUI

struct FilteredImage:Identifiable{
    var id = UUID().uuidString
    var image: UIImage
    var filter: CIFilter
}
