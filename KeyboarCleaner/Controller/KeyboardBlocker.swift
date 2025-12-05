//
//  KeyboardBlocker.swift
//  KeyboarCleaner
//
//  Created by Mateusz Rybczyński on 12/4/2025.
//
import SwiftUI
import CoreGraphics
internal import Combine

class KeyboardBlocker: ObservableObject {
    @Published var isBlocking: Bool = false
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    
    func startBlocking() {
        let eventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue)
        guard let eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: {(proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                guard let refcon = refcon else {return Unmanaged.passUnretained(event)}
                let blocker = Unmanaged<KeyboardBlocker>.fromOpaque(refcon).takeUnretainedValue()
                
                if blocker.isBlocking {
                    return nil
                }
                
                return Unmanaged.passUnretained(event)
            },
            userInfo: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        ) else {
            return
        }
        self.eventTap = eventTap
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        isBlocking = true
    }
    
    func stopBlocking() {
        if let eventTap = eventTap, let runLoopSource = runLoopSource {
            CGEvent.tapEnable(tap: eventTap, enable: false)
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            self.eventTap = nil
            self.runLoopSource = nil
        }
        isBlocking = false
    }
}
