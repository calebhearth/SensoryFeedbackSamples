import SwiftUI

struct ContentView: View {
  @State var currentFeedback: SensoryFeedbackType? = nil
  @State var buttonWidth: CGFloat = 100
  @State private var query = ""
  @State private var filteredPlatforms = Set(SensoryFeedbackType.Platform.allCases)

  var body: some View {
#if !os(watchOS)
    Text("Sensory Feedback Samples")
      .font(.title)
#endif
    NavigationStack {
      List {
        VStack {
          ForEach(searchResults) { feedbackType in
            Button(action: {
              currentFeedback = feedbackType
            }) {
              HStack {
                HStack {
                  ForEach(feedbackType.platforms, id: \.self) { platform in
                    Image(systemName: platform.rawValue)
                  }
                }
                .frame(width: 40)
                Text(feedbackType.title)
                  .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
#if !os(watchOS)
                  .font(.subheadline.monospaced())
#endif
              }
              .frame(maxWidth: .infinity, alignment: .leading)
            }
          }
          .buttonStyle(.borderedProminent)
          .sensoryFeedback(trigger: currentFeedback) { _, new in
            return new?.sensoryFeedback
          }
#if !os(watchOS)
          .padding(.horizontal)
#endif
          .disabled(currentFeedback != nil)
          .task(id: currentFeedback) {
            if currentFeedback != nil {
              try? await Task.sleep(nanoseconds: 250_000_000)
              currentFeedback = nil
            }
          }
        }
        .fixedSize()
#if !os(watchOS)
        if searchResults.contains(.increase) || searchResults.contains(.decrease) {
          Text("* While documented as watch only, increase and decrease seem to play a haptic feedback on iPhone as well.")
            .font(.footnote)
        }
#endif
      }
#if !os(watchOS)
      .toolbar {
        ToolbarItemGroup(placement: .bottomBar) {
          Spacer()
          ForEach(SensoryFeedbackType.Platform.allCases, id: \.self) { platform in
            Button(platform.rawValue.localizedUppercase, systemImage: platform.rawValue) {
              withAnimation {
                if filteredPlatforms.contains(platform) {
                  filteredPlatforms.remove(platform)
                } else {
                  filteredPlatforms.insert(platform)
                }
              }
            }
            .accessibilityLabel("Filter by \(platform.rawValue)")
            .buttonStyle(.bordered)
            .tint(filteredPlatforms.contains(platform) ? .primary : .secondary)
            Spacer()
          }
        }
      }
#endif
    }
#if !os(watchOS)
    .searchable(text: $query)
#endif
  }

  var searchResults: [SensoryFeedbackType] {
#if os(watchOS)
    return SensoryFeedbackType.allCases.filter { $0.platforms.contains(.watch)}
#else
    let searched = if query.isEmpty {
      SensoryFeedbackType.allCases
    } else {
      SensoryFeedbackType.allCases.filter { $0.rawValue.localizedStandardContains(query.lowercased())}
    }
    return searched.filter { !filteredPlatforms.intersection($0.platforms).isEmpty }
#endif
  }
}

#Preview {
  ContentView()
}
