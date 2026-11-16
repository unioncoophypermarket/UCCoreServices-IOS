//
//  PaymentOutcomeTests.swift
//  UCPaymentKitTests
//
//  Created by Mahmoud Alaa on 16/11/2026.
//

import Foundation
import Testing
@testable import UCPaymentKit

@Suite("Payment outcome")
@MainActor
struct PaymentOutcomeTests {

    @Test("A legacy result keeps its case and its reference")
    func fromLegacy() {
        #expect(PaymentOutcome(.success(orderReference: "a")) == .paid(orderReference: "a"))
        #expect(PaymentOutcome(.cancelled(orderReference: "b")) == .cancelled(orderReference: "b"))
        #expect(PaymentOutcome(.failed(orderReference: "c")) == .failed(orderReference: "c"))
    }

    @Test("A legacy caller hears an unconfirmed payment as failed, as before")
    func toLegacy() {
        #expect(PaymentOutcome.paid(orderReference: "a").legacyResult == .success(orderReference: "a"))
        #expect(PaymentOutcome.cancelled(orderReference: "b").legacyResult == .cancelled(orderReference: "b"))
        #expect(PaymentOutcome.failed(orderReference: "c").legacyResult == .failed(orderReference: "c"))
        #expect(PaymentOutcome.unconfirmed(orderReference: "d").legacyResult == .failed(orderReference: "d"))
        #expect(PaymentOutcome.unconfirmed(orderReference: "d").orderReference == "d")
    }

    @Test("A host with only the legacy API reports through the new one, and can't settle a payment")
    func legacyHost() async {
        let host = LegacyHost(result: .cancelled(orderReference: "r"))
        var outcomes: [PaymentOutcome] = []
        host.presentPayment(withType: .threeDS(paymentDTO: Self.payment())) { outcomes.append($0) }

        #expect(outcomes == [.cancelled(orderReference: "r")])
        #expect(await host.resolvePayment(orderReference: "r") == .unconfirmed(orderReference: "r"))
    }

    @Test("A host that implements the new API is reached through the protocol")
    func newHostThroughTheProtocol() async {
        let host: any PaymentPresenter = OutcomeHost()
        var outcomes: [PaymentOutcome] = []
        var results: [PaymentResult] = []
        host.presentPayment(withType: .threeDS(paymentDTO: Self.payment())) { outcomes.append($0) }
        host.presentPayment(withType: .threeDS(paymentDTO: Self.payment())) { results.append($0) }

        #expect(outcomes == [.unconfirmed(orderReference: "u")])
        #expect(results == [.failed(orderReference: "u")])
        #expect(await host.resolvePayment(orderReference: "u") == .paid(orderReference: "u"))
    }

    private static func payment() -> NIPaymentDTO {
        // Every field of the DTO is optional.
        try! JSONDecoder().decode(NIPaymentDTO.self, from: Data("{}".utf8))
    }
}

private final class LegacyHost: PaymentPresenter {
    let result: PaymentResult

    init(result: PaymentResult) {
        self.result = result
    }

    func presentPayment(withType type: PaymentViewType, completion: @escaping (PaymentResult) -> Void) {
        completion(self.result)
    }
}

private final class OutcomeHost: PaymentPresenter {

    func presentPayment(withType type: PaymentViewType, completion: @escaping (PaymentResult) -> Void) {
        self.presentPayment(withType: type) { completion($0.legacyResult) }
    }

    func presentPayment(withType type: PaymentViewType, onOutcome: @escaping (PaymentOutcome) -> Void) {
        onOutcome(.unconfirmed(orderReference: "u"))
    }

    func resolvePayment(orderReference: String) async -> PaymentOutcome {
        .paid(orderReference: orderReference)
    }
}
