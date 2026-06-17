//
//  KeyboardBlocker.swift
//  KeyboarCleaner
//
//  Created by Mateusz Rybczyński on 12/4/2025.
//
import SwiftUI
import CoreGraphics
import ApplicationServices
internal import Combine

class KeyboardBlocker: ObservableObject {
    @Published var isBlocking: Bool = false
    @Published var hasPermissions: Bool = false
    
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    
    init() {
        checkPermissions(prompt: false)
    }
    
    // Sprawdza, czy aplikacja ma uprawnienia Dostępności (Accessibility)
    // To uprawnienie jest znacznie stabilniejsze do blokowania klawiszy niż Input Monitoring
    @discardableResult
    func checkPermissions(prompt: Bool = true) -> Bool {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: prompt]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)
        
        DispatchQueue.main.async {
            self.hasPermissions = accessEnabled
        }
        return accessEnabled
    }
    
    func startBlocking() {
        guard checkPermissions(prompt: true) else {
            print("Brak uprawnień Dostępności. Otwieram systemowy prompt.")
            return
        }
        
        // Rozszerzamy maskę o dodatkowe zdarzenia (np. modyfikatory), aby klawiatura była w pełni "martwa"
        let eventMask = (1 << CGEventType.keyDown.rawValue) |
                        (1 << CGEventType.keyUp.rawValue) |
                        (1 << CGEventType.flagsChanged.rawValue)
        
        guard let eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                
                // Zabezpieczenie przed timeoutem (np. gdy system zresetuje tapy)
                if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
                    guard let refcon = refcon else { return Unmanaged.passUnretained(event) }
                    let blocker = Unmanaged<KeyboardBlocker>.fromOpaque(refcon).takeUnretainedValue()
                    
                    // Próba ponownego włączenia nasłuchu
                    if blocker.isBlocking, let tap = blocker.eventTap {
                        CGEvent.tapEnable(tap: tap, enable: true)
                    }
                    return Unmanaged.passUnretained(event)
                }
                
                guard let refcon = refcon else { return Unmanaged.passUnretained(event) }
                let blocker = Unmanaged<KeyboardBlocker>.fromOpaque(refcon).takeUnretainedValue()
                
                if blocker.isBlocking {
                    // Połknięcie zdarzenia
                    return nil
                }
                
                return Unmanaged.passUnretained(event)
            },
            userInfo: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        ) else {
            print("Nie udało się utworzyć eventTap. Sprawdź Sandbox i Uprawnienia.")
            return
        }
        
        self.eventTap = eventTap
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        
        // Dodajemy do wspólnego trybu, aby nasłuch działał również np. podczas scrollowania UI
        CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        
        DispatchQueue.main.async {
            self.isBlocking = true
        }
    }
    
    func stopBlocking() {
        if let eventTap = eventTap, let runLoopSource = runLoopSource {
            CGEvent.tapEnable(tap: eventTap, enable: false)
            CFRunLoopRemoveSource(CFRunLoopGetMain(), runLoopSource, .commonModes)
            self.eventTap = nil
            self.runLoopSource = nil
        }
        
        DispatchQueue.main.async {
            self.isBlocking = false
        }
    }
}
