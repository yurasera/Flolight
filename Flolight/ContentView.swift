import SwiftUI

struct ContentView: View {

    @State private var isFlashOn = false
    @State private var showPaywall = false

    var body: some View {
        ZStack {

            Color(red: 0.05, green: 0.05, blue: 0.06)
                .ignoresSafeArea()

            if isFlashOn {

                RadialGradient(
                    colors: [
                        .white.opacity(0.9),
                        .white.opacity(0.25),
                        .clear
                    ],
                    center: .center,
                    startRadius: 10,
                    endRadius: 420
                )
                .blur(radius: 30)
                .ignoresSafeArea()

                RadialGradient(
                    colors: [
                        .white.opacity(0.18),
                        .clear
                    ],
                    center: .center,
                    startRadius: 100,
                    endRadius: 900
                )
                .ignoresSafeArea()
            }

            VStack {

                Spacer()

                Image(systemName: isFlashOn ? "flashlight.on.fill" : "flashlight.off.fill")
                    .font(.system(size: 96, weight: .light))
                    .foregroundStyle(.white)
                    .shadow(color: .white.opacity(isFlashOn ? 0.45 : 0),
                            radius: 45)

                Text(isFlashOn ? "Flashlight On" : "Flashlight Off")
                    .font(.title2.weight(.medium))
                    .foregroundStyle(.white)

                Text(isFlashOn ?
                     "Tap again to turn it off." :
                     "Tap below to turn it on.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                Button {

                    if isFlashOn {
                        showPaywall = true
                    } else {
                        isFlashOn = true
                    }

                } label: {

                    ZStack {

                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 88, height: 88)

                        Circle()
                            .stroke(.white.opacity(0.15), lineWidth: 1)

                        Image(systemName: "power")
                            .font(.system(size: 30, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
                .buttonStyle(.plain)
                .padding(.bottom, 70)

            }
        }
        .preferredColorScheme(.dark)
        .animation(.easeInOut(duration: 0.35), value: isFlashOn)
        .sheet(isPresented: $showPaywall) {
            PaywallView {
                showPaywall = false
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}

struct PaywallView: View {

    var close: () -> Void

    var body: some View {

        VStack(spacing: 28) {

            Capsule()
                .fill(.secondary.opacity(0.3))
                .frame(width: 42, height: 5)

            Image(systemName: "flashlight.on.fill")
                .font(.system(size: 64))
                .foregroundStyle(.yellow)

            VStack(spacing: 8) {
                Text("Flashlight Pro")
                    .font(.largeTitle.bold())

                Text("Unlock the revolutionary ability to turn your flashlight off.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 14) {
                FeatureRow(title: "Turn flashlight off")
                FeatureRow(title: "Unlimited OFF actions")
                FeatureRow(title: "Premium darkness")
            }
            .padding()
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 24))

            // MARK: Plans

            HStack(spacing: 14) {

                SubscribeCard(
                    title: "Monthly",
                    price: "$9.99",
                    period: "/month",
                    badge: nil,
                    selected: false
                )

                SubscribeCard(
                    title: "Lifetime",
                    price: "$299",
                    period: "once",
                    badge: "BEST VALUE",
                    selected: true
                )

            }

            Button(action: close) {

                Text("Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(.white)
                    .foregroundStyle(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 18))

            }

            Button("Maybe Later", action: close)
                .foregroundStyle(.secondary)
        }
        .padding(24)
    }
}

struct FeatureRow: View {

    let title: String

    var body: some View {

        HStack {

            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)

            Text(title)

            Spacer()
        }
    }
}

struct SubscribeCard: View {

    let title: String
    let price: String
    let period: String
    let badge: String?
    let selected: Bool

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            if let badge {

                Text(badge)
                    .font(.caption2.weight(.bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.yellow)
                    .foregroundStyle(.black)
                    .clipShape(Capsule())

            }

            Spacer(minLength: 0)

            Text(title)
                .font(.headline)

            HStack(alignment: .firstTextBaseline, spacing: 2) {

                Text(price)
                    .font(.title.bold())

                Text(period)
                    .font(.caption)
                    .foregroundStyle(.secondary)

            }

            Text(title == "Lifetime"
                 ? "Pay once.\nNever turn off limits again."
                 : "Unlimited OFF actions every month.")
            .font(.caption)
            .foregroundStyle(.secondary)

        }
        .padding(18)
        .frame(maxWidth: .infinity, minHeight: 190)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.thinMaterial)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    selected
                    ? Color.yellow
                    : Color.white.opacity(0.08),
                    lineWidth: selected ? 2 : 1
                )
        }
    }
}

#Preview {
    ContentView()
}
