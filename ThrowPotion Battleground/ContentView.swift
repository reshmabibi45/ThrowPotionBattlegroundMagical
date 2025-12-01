

import SwiftUI
import Combine



// MARK: - Game Models
enum Element: String, CaseIterable {
    case fire = "🔥"
    case water = "💧"
    case earth = "🌍"
    case air = "💨"
    case light = "✨"
    case shadow = "🌑"
    
    var color: Color {
        switch self {
        case .fire: return .orange
        case .water: return .blue
        case .earth: return .green
        case .air: return .teal
        case .light: return .yellow
        case .shadow: return .purple
        }
    }
    
    var name: String {
        switch self {
        case .fire: return "Fire"
        case .water: return "Water"
        case .earth: return "Earth"
        case .air: return "Air"
        case .light: return "Light"
        case .shadow: return "Shadow"
        }
    }
}

struct ElementCard: Identifiable {
    let id = UUID()
    let element: Element
    var isSelected: Bool = false
    var isNew: Bool = false
}

struct PotionRecipe: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let description: String
    let elements: [Element]
    let points: Int
    let color: Color
    let emoji: String
    
    static func == (lhs: PotionRecipe, rhs: PotionRecipe) -> Bool {
        lhs.id == rhs.id
    }
}

struct GameState {
    var score: Int = 0
    var moves: Int
    var discoveredPotions: [PotionRecipe] = []
    var currentGoal: PotionRecipe?
    var showDiscovery: Bool = false
    var hasWon: Bool = false
    
    init(moves: Int) {
        self.moves = moves
    }
}

struct Mission: Identifiable {
    let id: Int
    let title: String
    let description: String
    let elements: [Element]
    let potionsToDiscover: Int
    let difficulty: String
    let maxMoves: Int
}



// MARK: - Main Menu View
struct MainMenuView: View {
    @State private var showMissions = false
    @State private var showSettings = false
    @State private var showStats = false
    @State private var showBallThrowGame = false
    @State private var animateTitle = false
    @State private var buttonScale: [Bool] = [false, false, false, false]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Epic Game Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.1, green: 0.0, blue: 0.3),
                        Color(red: 0.3, green: 0.0, blue: 0.5),
                        Color(red: 0.1, green: 0.0, blue: 0.2)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                
                // Animated Magic Particles
                MagicParticlesView()
                
                // Floating Islands Background
                FloatingIslandsView()
                ScrollView{
                VStack(spacing: 30) {
                    // Epic Header with Animation
                    VStack(spacing: 15) {
                        ZStack {
                            // Glowing Orb
                            Circle()
                                .fill(
                                    RadialGradient(
                                        gradient: Gradient(colors: [
                                            Color.gold.opacity(0.8),
                                            Color.orange.opacity(0.4),
                                            Color.clear
                                        ]),
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 80
                                    )
                                )
                                .frame(width: 160, height: 160)
                                .blur(radius: 20)
                                .scaleEffect(animateTitle ? 1.1 : 0.9)
                                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animateTitle)
                            
                            // Main Crystal
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.blue.opacity(0.8),
                                                Color.purple.opacity(0.6)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 120, height: 120)
                                
                                Image("icon")
                                    .resizable()
                                    .frame(width: 150,height: 150)
                            }
                        }
                        
                        // Game Title with Glow
                        VStack(spacing: 8) {
                            Text("ThrowPotion\nBattleground")
                                .font(.system(size: 36, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .shadow(color: .gold, radius: 10)
                                .scaleEffect(animateTitle ? 1.05 : 1.0)
                                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateTitle)
                            
                            Text("MASTER THE ELEMENTS")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.gold)
                                .tracking(3)
                                .opacity(0.9)
                            
                            // Animated Subtitle
                            Text("Brew • Battle • Conquer")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                                .italic()
                        }
                    }
                    .padding(.top, 40)
                    .onAppear {
                        animateTitle = true
                        // Stagger button animations
                        for i in buttonScale.indices {
                            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.2) {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    buttonScale[i] = true
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Epic Action Buttons
                    VStack(spacing: 16) {
                        // Main Action Buttons
                        GameActionButton(
                            title: "START QUEST",
                            subtitle: "Begin Your Alchemy Journey",
                            icon: "🎮",
                            color: .heroBlue,
                            delay: 0,
                            isAnimated: buttonScale[0]
                        ) {
                            showMissions = true
                        }
                        
                        GameActionButton(
                            title: "ELEMENT THROW",
                            subtitle: "Test Your Aim & Skill",
                            icon: "🎯",
                            color: .magicPurple,
                            delay: 0.1,
                            isAnimated: buttonScale[1]
                        ) {
                            showBallThrowGame = true
                        }
                        
                        
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                }
            }
            }
            .fullScreenCover(isPresented: $showMissions) {
                MissionsView()
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showStats) {
                StatsView()
            }
            .fullScreenCover(isPresented: $showBallThrowGame) {
                BallThrowGameView()
            }
        }
    }
}

// MARK: - Game Action Button
struct GameActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let delay: Double
    let isAnimated: Bool
    let action: () -> Void
    
    @State private var glow = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                Text(icon)
                    .font(.system(size: 30))
                    .scaleEffect(glow ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: glow)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(25)
            .background(
                ZStack {
                    // Main Button Background
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    color.opacity(0.8),
                                    color.opacity(0.4)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Glow Effect
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(color.opacity(glow ? 0.6 : 0.3), lineWidth: 3)
                        .shadow(color: color.opacity(glow ? 0.4 : 0.1), radius: glow ? 10 : 5)
                }
            )
            .scaleEffect(isAnimated ? 1.0 : 0.8)
            .opacity(isAnimated ? 1.0 : 0.0)
            .rotation3DEffect(
                .degrees(isAnimated ? 0 : -45),
                axis: (x: 1.0, y: 0.0, z: 0.0)
            )
        }
        .buttonStyle(GameButtonStyle())
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                glow = true
            }
        }
    }
}

// MARK: - Small Game Button
struct SmallGameButton: View {
    let title: String
    let icon: String
    let color: Color
    let delay: Double
    let isAnimated: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(icon)
                    .font(.system(size: 24))
                
                Text(title)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(15)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color.opacity(0.7),
                                color.opacity(0.3)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(color.opacity(0.4), lineWidth: 2)
                    )
            )
            .scaleEffect(isAnimated ? 1.0 : 0.6)
            .opacity(isAnimated ? 1.0 : 0.0)
        }
        .buttonStyle(GameButtonStyle())
    }
}

// MARK: - Game Stat Badge
struct GameStatBadge: View {
    let count: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(count)
                .font(.system(size: 16, weight: .black, design: .rounded))
                .foregroundColor(.gold)
            
            Text(label)
                .font(.system(size: 8, weight: .bold))
                .foregroundColor(.white.opacity(0.7))
                .tracking(1)
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gold.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// MARK: - Custom Button Style
struct GameButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .brightness(configuration.isPressed ? -0.1 : 0.0)
    }
}

// MARK: - Magic Particles View
struct MagicParticlesView: View {
    @State private var particles: [Particle] = []
    
    struct Particle {
        let x: CGFloat
        let y: CGFloat
        let size: CGFloat
        let opacity: Double
        let speed: Double
    }
    
    init() {
        for _ in 0..<30 {
            particles.append(Particle(
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: CGFloat.random(in: 0...UIScreen.main.bounds.height),
                size: CGFloat.random(in: 2...6),
                opacity: Double.random(in: 0.1...0.4),
                speed: Double.random(in: 2...8)
            ))
        }
    }
    
    var body: some View {
        ForEach(particles.indices, id: \.self) { index in
            Circle()
                .fill(Color.gold.opacity(particles[index].opacity))
                .frame(width: particles[index].size, height: particles[index].size)
                .position(x: particles[index].x, y: particles[index].y)
                .blur(radius: 1)
        }
    }
}

// MARK: - Floating Islands View
struct FloatingIslandsView: View {
    @State private var floatOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Floating crystals in background
            ForEach(0..<8, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.blue.opacity(0.3),
                                Color.purple.opacity(0.1),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 40
                        )
                    )
                    .frame(width: CGFloat.random(in: 60...120))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .blur(radius: 10)
                    .offset(y: floatOffset + CGFloat(index) * 10)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                floatOffset = 20
            }
        }
    }
}

// MARK: - Color Extensions
extension Color {
    static let heroBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let magicPurple = Color(red: 0.6, green: 0.2, blue: 1.0)
    static let forestGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let metalGray = Color(red: 0.4, green: 0.4, blue: 0.6)
}




struct FeatureTag: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .medium))
            .foregroundColor(.white.opacity(0.8))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)
    }
}

struct AnimatedBackground: View {
    @State private var rotation = 0.0
    
    var body: some View {
        ZStack {
            // Animated circles
            ForEach(0..<3) { index in
                Circle()
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.gold.opacity(0.3), .clear]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: CGFloat(200 + index * 100), height: CGFloat(200 + index * 100))
                    .offset(x: CGFloat(index * 50) - 100, y: CGFloat(index * 30) - 60)
                    .rotationEffect(.degrees(rotation + Double(index * 45)))
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

// MARK: - Missions View
struct MissionsView: View {
    let missions = [
        Mission(id: 1, title: "Apprentice Brewer", description: "Learn basic element combinations", elements: [.fire, .water], potionsToDiscover: 3, difficulty: "Easy", maxMoves: 15),
        Mission(id: 2, title: "Novice Alchemist", description: "Master earth and air elements", elements: [.fire, .water, .earth, .air], potionsToDiscover: 5, difficulty: "Medium", maxMoves: 20),
        Mission(id: 3, title: "Adept Wizard", description: "Discover the power of light", elements: [.fire, .water, .earth, .air, .light], potionsToDiscover: 8, difficulty: "Hard", maxMoves: 25),
        Mission(id: 4, title: "Expert Sorcerer", description: "Harness shadow magic", elements: Element.allCases, potionsToDiscover: 12, difficulty: "Expert", maxMoves: 30),
        Mission(id: 5, title: "Master Archmage", description: "Ultimate brewing challenge", elements: Element.allCases, potionsToDiscover: 15, difficulty: "Master", maxMoves: 35)
    ]
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMission: Mission?
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.darkPurple, Color.mysticBlue]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                StarsView()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 10) {
                        Text("Select Mission")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundColor(.gold)
                        
                        Text("Choose your brewing challenge")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 30)
                    
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(missions) { mission in
                                MissionCard(mission: mission) {
                                    selectedMission = mission
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarHidden(true)
            .overlay(
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
                .padding(.top, 16)
                .padding(.trailing, 16),
                alignment: .topTrailing
            )
            .fullScreenCover(item: $selectedMission) { mission in
                GameView(mission: mission)
            }
        }
    }
}

struct MissionCard: View {
    let mission: Mission
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("MISSION \(mission.id)")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.gold)
                            .tracking(1)
                        
                        Text(mission.title)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(mission.description)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        DifficultyBadge(difficulty: mission.difficulty)
                        
                        Text("\(mission.maxMoves) Moves")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                
                // Elements preview
                HStack {
                    Text("Select Elements")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        ForEach(mission.elements.prefix(4), id: \.self) { element in
                            Text(element.rawValue)
                                .font(.system(size: 18))
                        }
                        
                        if mission.elements.count > 4 {
                            Text("+\(mission.elements.count - 4)")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                }
                
                HStack {
                    Label("\(mission.potionsToDiscover) Potions to Brew", systemImage: "flame")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Spacer()
                    
                    HStack(spacing: 6) {
                        Text("PLAY")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.gold)
                        
                        Image(systemName: "play.fill")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.gold)
                    }
                }
            }
            .padding(20)
            .background(Color.white.opacity(0.1))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gold.opacity(0.3), lineWidth: 2)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct DifficultyBadge: View {
    let difficulty: String
    
    var body: some View {
        Text(difficulty.uppercased())
            .font(.system(size: 10, weight: .black))
            .foregroundColor(getDifficultyTextColor())
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(getDifficultyColor())
            .cornerRadius(6)
    }
    
    private func getDifficultyColor() -> Color {
        switch difficulty {
        case "Easy": return .green
        case "Medium": return .yellow
        case "Hard": return .orange
        case "Expert": return .red
        case "Master": return .purple
        default: return .gray
        }
    }
    
    private func getDifficultyTextColor() -> Color {
        switch difficulty {
        case "Easy", "Master": return .white
        default: return .black
        }
    }
}

// MARK: - Game Manager
class GameManager: ObservableObject {
    @Published var elementCards: [ElementCard] = []
    @Published var cauldronElements: [Element] = []
    @Published var gameState: GameState
    @Published var showAnimation: Bool = false
    @Published var animationType: String = ""
    
    private let mission: Mission
    private let allRecipes: [PotionRecipe] = [
        PotionRecipe(name: "Steam Cloud", description: "Fire meets Water", elements: [.fire, .water], points: 50, color: .gray, emoji: "☁️"),
        PotionRecipe(name: "Lava Flow", description: "Earth heated by Fire", elements: [.earth, .fire], points: 60, color: .red, emoji: "🌋"),
        PotionRecipe(name: "Dust Storm", description: "Earth swept by Air", elements: [.earth, .air], points: 55, color: .brown, emoji: "💨"),
        PotionRecipe(name: "Rain Cloud", description: "Water carried by Air", elements: [.water, .air], points: 45, color: .blue, emoji: "🌧️"),
        PotionRecipe(name: "Volcanic Ash", description: "Elemental fury aftermath", elements: [.fire, .earth, .air], points: 100, color: .black, emoji: "🌫️"),
        PotionRecipe(name: "Healing Spring", description: "Blessed waters", elements: [.water, .earth, .light], points: 120, color: .green, emoji: "💫"),
        PotionRecipe(name: "Shadow Flame", description: "Fire consuming light", elements: [.fire, .shadow, .air], points: 150, color: .purple, emoji: "🔥"),
        PotionRecipe(name: "Starlight Elixir", description: "Pure light captured", elements: [.light, .light, .air], points: 200, color: .yellow, emoji: "⭐"),
        PotionRecipe(name: "Abyssal Tincture", description: "Essence of nothingness", elements: [.shadow, .shadow, .water], points: 180, color: .indigo, emoji: "⚫"),
        PotionRecipe(name: "Elemental Harmony", description: "Perfect balance", elements: [.fire, .water, .earth, .air], points: 300, color: .pink, emoji: "🌈")
    ]
    
    init(mission: Mission) {
        self.mission = mission
        self.gameState = GameState(moves: mission.maxMoves)
        setupGame()
    }
    
    func setupGame() {
        elementCards = mission.elements.map { ElementCard(element: $0) }
        cauldronElements = []
        setNewGoal()
    }
    
    func resetGame() {
        gameState = GameState(moves: mission.maxMoves)
        setupGame()
    }
    
    func setNewGoal() {
        let availableForMission = allRecipes.filter { recipe in
            recipe.elements.allSatisfy { element in
                mission.elements.contains(element)
            }
        }
        gameState.currentGoal = availableForMission.randomElement()
    }
    
    func selectCard(_ card: ElementCard) {
        guard gameState.moves > 0 && !gameState.hasWon else { return }
        
        if let index = elementCards.firstIndex(where: { $0.id == card.id }) {
            elementCards[index].isSelected.toggle()
            
            if elementCards[index].isSelected {
                if cauldronElements.count < 4 {
                    cauldronElements.append(card.element)
                    playAnimation("add_element")
                } else {
                    elementCards[index].isSelected = false
                }
            } else {
                if let cauldronIndex = cauldronElements.firstIndex(of: card.element) {
                    cauldronElements.remove(at: cauldronIndex)
                }
            }
            
            checkForRecipe()
        }
    }
    
    func checkForRecipe() {
        guard cauldronElements.count >= 2 else { return }
        
        for recipe in allRecipes {
            if isMatchingRecipe(cauldronElements, recipe.elements) {
                gameState.score += recipe.points
                gameState.moves -= 1
                
                if !gameState.discoveredPotions.contains(where: { $0.id == recipe.id }) {
                    gameState.discoveredPotions.append(recipe)
                    gameState.showDiscovery = true
                    playAnimation("potion_discovery")
                }
                
                if recipe.id == gameState.currentGoal?.id {
                    gameState.score += 100
                    setNewGoal()
                    playAnimation("goal_complete")
                }
                
                // Check win condition
                if gameState.discoveredPotions.count >= mission.potionsToDiscover {
                    gameState.hasWon = true
                }
                
                resetCauldron()
                return
            }
        }
        
        // If no recipe found and elements >= 2, it's a wrong combination
        if cauldronElements.count >= 2 {
            gameState.moves -= 1
            resetCauldron()
            playAnimation("wrong_combination")
        }
    }
    
    private func isMatchingRecipe(_ elements: [Element], _ recipe: [Element]) -> Bool {
        let sortedElements = elements.sorted(by: { $0.rawValue < $1.rawValue })
        let sortedRecipe = recipe.sorted(by: { $0.rawValue < $1.rawValue })
        return sortedElements == sortedRecipe
    }
    
    func resetCauldron() {
        cauldronElements.removeAll()
        for index in elementCards.indices {
            elementCards[index].isSelected = false
        }
    }
    
    func clearCauldron() {
        guard !cauldronElements.isEmpty else { return }
        gameState.moves -= 1
        resetCauldron()
        playAnimation("clear_cauldron")
    }
    
    private func playAnimation(_ type: String) {
        animationType = type
        showAnimation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.showAnimation = false
        }
    }
}

// MARK: - Game View
struct GameView: View {
    let mission: Mission
    @StateObject private var gameManager: GameManager
    @Environment(\.dismiss) private var dismiss
    @State private var showGameOver = false
    @State private var showSuccess = false
    
    init(mission: Mission) {
        self.mission = mission
        _gameManager = StateObject(wrappedValue: GameManager(mission: mission))
    }
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [Color.darkPurple, Color.mysticBlue]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            StarsView()
            
            VStack(spacing: 0) {
                // Header with stats
                GameHeaderView(gameManager: gameManager) {
                    dismiss()
                }
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Current Mission
                        if let goal = gameManager.gameState.currentGoal {
                            GoalCardView(goal: goal)
                        }
                        
                        // Cauldron Section
                        CauldronSectionView(gameManager: gameManager)
                        
                        // Available Elements
                        ElementsSectionView(gameManager: gameManager)
                    }
                    .padding(20)
                }
            }
            
            // Overlays
            if gameManager.showAnimation {
                AnimationOverlay(gameManager: gameManager)
            }
        }
        .onReceive(gameManager.$gameState) { state in
            if state.moves <= 0 && !state.hasWon {
                showGameOver = true
            }
            if state.hasWon {
                showSuccess = true
            }
        }
        .sheet(isPresented: $showGameOver) {
            GameOverView(score: gameManager.gameState.score, mission: mission) {
                dismiss()
            } onRetry: {
                gameManager.resetGame()
                showGameOver = false
            }
        }
        .sheet(isPresented: $showSuccess) {
            SuccessView(
                score: gameManager.gameState.score,
                mission: mission,
                discoveredPotions: gameManager.gameState.discoveredPotions.count,
                totalPotions: mission.potionsToDiscover
            ) {
                dismiss()
            } onNextLevel: {
                // Move to next mission logic
                dismiss()
            }
        }
        .sheet(isPresented: $gameManager.gameState.showDiscovery) {
            DiscoverySheet(gameManager: gameManager)
        }
    }
}

// MARK: - Game Header
struct GameHeaderView: View {
    @ObservedObject var gameManager: GameManager
    let onClose: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onClose) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Text("Score")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                Text("\(gameManager.gameState.score)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.gold)
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Text("Moves Left")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                Text("\(gameManager.gameState.moves)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(gameManager.gameState.moves <= 5 ? .red : .green)
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Text("Progress")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                Text("\(gameManager.gameState.discoveredPotions.count)/\(gameManager.gameState.currentGoal != nil ? "?" : "0")")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 60)
        .padding(.bottom, 20)
        .background(Color.black.opacity(0.3))
    }
}

// MARK: - Goal Card
struct GoalCardView: View {
    let goal: PotionRecipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "target")
                    .foregroundColor(.gold)
                Text("CURRENT MISSION")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.gold)
                Spacer()
                Text("\(goal.points) pts")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gold.opacity(0.2))
                    .cornerRadius(8)
            }
            
            Text(goal.name)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Text(goal.description)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
            
            HStack(spacing: 12) {
                ForEach(goal.elements, id: \.self) { element in
                    ElementBadge(element: element)
                }
                Spacer()
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.5), goal.color.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(goal.color.opacity(0.5), lineWidth: 2)
                )
        )
    }
}

// MARK: - Cauldron Section
struct CauldronSectionView: View {
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Magic Cauldron")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.gold)
            
            ZStack {
                // Cauldron
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0.9),
                                Color.purple.opacity(0.7),
                                Color.blue.opacity(0.5)
                            ]),
                            center: .center,
                            startRadius: 30,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [.gold, .orange]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 4
                            )
                    )
                
                // Elements in cauldron
                if gameManager.cauldronElements.isEmpty {
                    
                    VStack(spacing: 6) {
                        Text("Selected elements")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white.opacity(0.9))
                        Text("will show here")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    
                } else {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(gameManager.cauldronElements, id: \.self) { element in
                            Text(element.rawValue)
                                .font(.system(size: 24))
                                .frame(width: 40, height: 40)
                                .background(element.color.opacity(0.8))
                                .clipShape(Circle())
                                .shadow(color: element.color, radius: 5)
                        }
                    }
                    .frame(width: 100)
                }
            }
            
            // Add instructional message
            Text("Select elements from the cards below")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
                .italic()
            
            HStack {
                Text("\(gameManager.cauldronElements.count)/4 elements")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                
                Spacer()
                
                if !gameManager.cauldronElements.isEmpty {
                    Button("Clear Cauldron") {
                        gameManager.clearCauldron()
                    }
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.red)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(8)
                }
            }
        }
        .padding(20)
        .background(Color.black.opacity(0.3))
        .cornerRadius(20)
    }
}


















// MARK: - Elements Section
struct ElementsSectionView: View {
    @ObservedObject var gameManager: GameManager
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Select Elements")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.gold)
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(gameManager.elementCards) { card in
                    ElementCardView(card: card, gameManager: gameManager)
                }
            }
        }
        .padding(20)
        .background(Color.black.opacity(0.3))
        .cornerRadius(20)
    }
}

// MARK: - Element Card View
struct ElementCardView: View {
    let card: ElementCard
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        Button(action: {
            gameManager.selectCard(card)
        }) {
            VStack(spacing: 8) {
                Text(card.element.rawValue)
                    .font(.system(size: 32))
                    .scaleEffect(card.isSelected ? 1.1 : 1.0)
                
                Text(card.element.name)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(height: 90)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(card.element.color.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                card.isSelected ? card.element.color : Color.white.opacity(0.2),
                                lineWidth: card.isSelected ? 3 : 1
                            )
                    )
            )
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(gameManager.gameState.moves <= 0 || gameManager.gameState.hasWon)
        .opacity((gameManager.gameState.moves <= 0 || gameManager.gameState.hasWon) ? 0.6 : 1.0)
    }
}

// MARK: - Element Badge
struct ElementBadge: View {
    let element: Element
    
    var body: some View {
        VStack(spacing: 4) {
            Text(element.rawValue)
                .font(.system(size: 20))
            Text(element.name)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(width: 50)
        .padding(8)
        .background(element.color.opacity(0.3))
        .cornerRadius(12)
    }
}

// MARK: - Animation Overlay
struct AnimationOverlay: View {
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                switch gameManager.animationType {
                case "potion_discovery":
                    Text("✨ Potion Discovered! ✨")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(.gold)
                    Text("+100 Points!")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                    
                case "goal_complete":
                    Text("🎯 Mission Complete! 🎯")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(.orange)
                    Text("Bonus +100 Points!")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                    
                case "wrong_combination":
                    Text("💥 Wrong Combination! 💥")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.red)
                    Text("Try different elements")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                    
                default:
                    Text("⚡ Element Added! ⚡")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(40)
            .background(Color.darkPurple)
            .cornerRadius(25)
            .shadow(radius: 20)
        }
        .transition(.opacity)
    }
}

// MARK: - Discovery Sheet
struct DiscoverySheet: View {
    @ObservedObject var gameManager: GameManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        SheetContainer {
            VStack(spacing: 25) {
                Text("🎉 New Potion! 🎉")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundColor(.gold)
                
                if let potion = gameManager.gameState.discoveredPotions.last {
                    VStack(spacing: 20) {
                        Text(potion.emoji)
                            .font(.system(size: 80))
                        
                        Text(potion.name)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text(potion.description)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 15) {
                            ForEach(potion.elements, id: \.self) { element in
                                ElementBadge(element: element)
                            }
                        }
                        
                        Text("+\(potion.points) Points")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.gold)
                            .padding(.top, 10)
                    }
                }
                
                Button("Continue Brewing") {
                    dismiss()
                }
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 15)
                .background(Color.green)
                .cornerRadius(25)
            }
            .padding(30)
        }
    }
}

// MARK: - Game Over View
struct GameOverView: View {
    let score: Int
    let mission: Mission
    let onExit: () -> Void
    let onRetry: () -> Void
    
    var body: some View {
        SheetContainer {
            VStack(spacing: 30) {
                Text("💀 Game Over 💀")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundColor(.red)
                
                VStack(spacing: 20) {
                    Text("You ran out of moves!")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 15) {
                        InfoRow(title: "Mission", value: mission.title)
                        InfoRow(title: "Final Score", value: "\(score)")
                        InfoRow(title: "Difficulty", value: mission.difficulty)
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(15)
                }
                
                VStack(spacing: 15) {
                    Button("Try Again") {
                        onRetry()
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(15)
                    
                    Button("Exit to Menu") {
                        onExit()
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(15)
                }
            }
            .padding(30)
        }
    }
}

// MARK: - Success View
struct SuccessView: View {
    let score: Int
    let mission: Mission
    let discoveredPotions: Int
    let totalPotions: Int
    let onExit: () -> Void
    let onNextLevel: () -> Void
    
    var body: some View {
        SheetContainer {
            VStack(spacing: 30) {
                Text("🎉 Mission Complete! 🎉")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundColor(.gold)
                
                VStack(spacing: 20) {
                    Text("You mastered \(mission.title)!")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 15) {
                        InfoRow(title: "Mission", value: mission.title, isHighlighted: true)
                        InfoRow(title: "Final Score", value: "\(score)", isHighlighted: true)
                        InfoRow(title: "Potions Brewed", value: "\(discoveredPotions)/\(totalPotions)", isHighlighted: true)
                        InfoRow(title: "Difficulty", value: mission.difficulty)
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(15)
                }
                
                VStack(spacing: 15) {
                    Button("Next Mission") {
                        onNextLevel()
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(15)
                    
                    Button("Main Menu") {
                        onExit()
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(15)
                }
            }
            .padding(30)
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    var isHighlighted: Bool = false
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(isHighlighted ? .gold : .white)
        }
    }
}

// MARK: - Settings and Stats Views
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        SheetContainer {
            VStack(spacing: 25) {
                Text("Game Settings")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundColor(.gold)
                
                Text("Game settings will be here")
                    .foregroundColor(.white.opacity(0.8))
                
                Button("Close") {
                    dismiss()
                }
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 15)
                .background(Color.blue)
                .cornerRadius(25)
            }
            .padding(30)
        }
    }
}

struct StatsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        SheetContainer {
            VStack(spacing: 25) {
                Text("Game Statistics")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundColor(.gold)
                
                Text("Your brewing statistics will appear here")
                    .foregroundColor(.white.opacity(0.8))
                
                Button("Close") {
                    dismiss()
                }
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 15)
                .background(Color.blue)
                .cornerRadius(25)
            }
            .padding(30)
        }
    }
}

// MARK: - Supporting Views
struct StarsView: View {
    @State private var stars: [Star] = []
    
    struct Star {
        let x: CGFloat
        let y: CGFloat
        let size: CGFloat
        let opacity: Double
    }
    
    init() {
        var generatedStars: [Star] = []
        for _ in 0..<30 {
            generatedStars.append(Star(
                x: CGFloat.random(in: 0...1),
                y: CGFloat.random(in: 0...1),
                size: CGFloat.random(in: 1...2),
                opacity: Double.random(in: 0.1...0.6)
            ))
        }
        _stars = State(initialValue: generatedStars)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<stars.count, id: \.self) { index in
                Circle()
                    .fill(Color.white)
                    .frame(width: stars[index].size, height: stars[index].size)
                    .position(
                        x: stars[index].x * geometry.size.width,
                        y: stars[index].y * geometry.size.height
                    )
                    .opacity(stars[index].opacity)
            }
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SheetContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.darkPurple, Color.mysticBlue]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            StarsView()
            
            content
        }
    }
}

// MARK: - Custom Colors
extension Color {
    static let darkPurple = Color(red: 0.1, green: 0.05, blue: 0.2)
    static let mysticBlue = Color(red: 0.15, green: 0.1, blue: 0.3)
    static let gold = Color(red: 1.0, green: 0.8, blue: 0.0)
}

// MARK: - Preview
struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}




import SwiftUI

// MARK: - Stats View
struct StatsThrowView: View {
    @ObservedObject var gameManager: BallThrowGameManager
    
    var body: some View {
        HStack(spacing: 20) {
            StatCard(title: "SCORE", value: "\(gameManager.gameState.score)", color: .gold)
            StatCard(title: "DESTROYED", value: "\(gameManager.gameState.itemsDestroyed)/\(gameManager.gameState.totalItems)", color: .green)
            StatCard(title: "ACTIVE", value: gameManager.gameState.isGameActive ? "YES" : "NO", color: gameManager.gameState.isGameActive ? .blue : .red)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white.opacity(0.8))
                .tracking(1)
            
            Text(value)
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.3), lineWidth: 2)
        )
    }
}

// MARK: - Toast View
struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.gold, .orange]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(25)
            .shadow(color: .black.opacity(0.3), radius: 10, y: 5)
            .padding(.top, 100)
    }
}

// MARK: - Game Win Overlay
struct GameWinOverlay: View {
    let score: Int
    let onPlayAgain: () -> Void
    let onExit: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("🎉 You Win! 🎉")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundColor(.gold)
                
                VStack(spacing: 20) {
                    Text("All Elements Destroyed!")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text("Final Score: \(score)")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(.gold)
                }
                
                VStack(spacing: 15) {
                
                    Button("Exit & Play") {
                        onExit()
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(15)
                }
                .padding(.horizontal, 40)
            }
            .padding(40)
            .background(Color.darkPurple)
            .cornerRadius(25)
            .shadow(radius: 20)
        }
        .transition(.opacity)
    }
}

// MARK: - Ball Throw Game Models
struct ThrowableItem: Identifiable {
    let id = UUID()
    let element: Element
    var position: CGPoint
    var isDestroyed: Bool = false
    var points: Int {
        switch element {
        case .fire: return 100
        case .water: return 80
        case .earth: return 90
        case .air: return 70
        case .light: return 120
        case .shadow: return 110
        }
    }
}

struct BallThrowGameState {
    var score: Int = 0
    var itemsDestroyed: Int = 0
    var totalItems: Int = 6
    var isGameActive: Bool = true
    var showToast: Bool = false
    var toastMessage: String = ""
    var ballPosition: CGPoint = .zero
    var ballVelocity: CGPoint = .zero
    var paddlePosition: CGFloat = 0
}

// MARK: - Ball Throw Game Manager
class BallThrowGameManager: ObservableObject {
    @Published var gameState = BallThrowGameState()
    @Published var throwableItems: [ThrowableItem] = []
    
    private let ballSize: CGFloat = 20
    private let paddleWidth: CGFloat = 100
    private let paddleHeight: CGFloat = 20
    private let itemSize: CGFloat = 50 // Smaller item size
    private var displayLink: CADisplayLink?
    
    // Game area dimensions (will be set by the view)
    var gameAreaSize: CGSize = .zero
    
    init() {
        setupGame()
    }
    
    func setupGame() {
        gameState = BallThrowGameState()
        // Don't create items here - wait for gameAreaSize to be set
        startGameLoop()
    }
    
    private func createItems() {
        // Use default safe values if gameAreaSize is not set yet
        let width = gameAreaSize.width > 0 ? gameAreaSize.width : 300
        let height = gameAreaSize.height > 0 ? gameAreaSize.height : 500
        
        let safeMargin: CGFloat = 60
        let minX = safeMargin + itemSize/2
        let maxX = width - safeMargin - itemSize/2
        let minY: CGFloat = 80
        let maxY: CGFloat = 250
        
        // Ensure valid range
        guard maxX > minX && maxY > minY else {
            // Fallback to centered layout if range is invalid
            createCenteredItems(width: width, height: height)
            return
        }
        
        throwableItems = Element.allCases.prefix(6).map { element in
            let xPos = CGFloat.random(in: minX...maxX)
            let yPos = CGFloat.random(in: minY...maxY)
            
            return ThrowableItem(
                element: element,
                position: CGPoint(x: xPos, y: yPos)
            )
        }
        gameState.totalItems = throwableItems.count
    }
    
    private func createCenteredItems(width: CGFloat, height: CGFloat) {
        // Fallback layout - arrange items in 2 rows of 3
        let spacing: CGFloat = 15
        let itemsPerRow = 3
        let rows = 2
        
        throwableItems = Element.allCases.prefix(6).enumerated().map { index, element in
            let row = index / itemsPerRow
            let col = index % itemsPerRow
            
            let totalWidth = (itemSize * CGFloat(itemsPerRow)) + (spacing * CGFloat(itemsPerRow - 1))
            let startX = (width - totalWidth) / 2 + itemSize / 2
            let startY: CGFloat = 80
            
            let xPos = startX + CGFloat(col) * (itemSize + spacing)
            let yPos = startY + CGFloat(row) * (itemSize + spacing)
            
            return ThrowableItem(
                element: element,
                position: CGPoint(x: xPos, y: yPos)
            )
        }
        gameState.totalItems = throwableItems.count
    }
    
    func setupInitialPositions(in gameAreaSize: CGSize) {
        self.gameAreaSize = gameAreaSize
        
        // Position paddle at bottom center
        gameState.paddlePosition = gameAreaSize.width / 2
        
        // Position ball ON the paddle (centered on paddle)
        gameState.ballPosition = CGPoint(
            x: gameAreaSize.width / 2,
            y: gameAreaSize.height - 30 // On top of paddle
        )
        gameState.ballVelocity = .zero
        
        // Create items with proper positioning
        createItems()
    }
    
    func throwBall() {
        guard gameState.isGameActive && gameState.ballVelocity == .zero else { return }
        
        // Set stronger initial velocity (upward at an angle)
        let randomAngle = Double.random(in: -0.3...0.3)
        gameState.ballVelocity = CGPoint(x: randomAngle * 12, y: -15) // Stronger velocity for faster gameplay
    }
    
    func movePaddle(to xPosition: CGFloat) {
        guard gameState.isGameActive else { return }
        
        let halfPaddle = paddleWidth / 2
        let newPosition = min(max(xPosition, halfPaddle), gameAreaSize.width - halfPaddle)
        gameState.paddlePosition = newPosition
        
        // If ball hasn't been thrown yet, move it with the paddle
        if gameState.ballVelocity == .zero {
            gameState.ballPosition.x = newPosition
        }
    }
    
    private func startGameLoop() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateGame))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc private func updateGame() {
        guard gameState.isGameActive && gameAreaSize != .zero else { return }
        
        // Update ball position only if it's moving
        if gameState.ballVelocity != .zero {
            gameState.ballPosition.x += gameState.ballVelocity.x
            gameState.ballPosition.y += gameState.ballVelocity.y
            
            // Apply gravity (weaker for better gameplay)
            gameState.ballVelocity.y += 0.15
            
            // Check collisions with walls with more bounce
            if gameState.ballPosition.x <= ballSize / 2 {
                gameState.ballPosition.x = ballSize / 2
                gameState.ballVelocity.x *= -0.9 // More bounce
            } else if gameState.ballPosition.x >= gameAreaSize.width - ballSize / 2 {
                gameState.ballPosition.x = gameAreaSize.width - ballSize / 2
                gameState.ballVelocity.x *= -0.9 // More bounce
            }
            
            // Check collision with ceiling
            if gameState.ballPosition.y <= ballSize / 2 {
                gameState.ballPosition.y = ballSize / 2
                gameState.ballVelocity.y *= -0.9 // More bounce
            }
            
            // Check collision with paddle with stronger response
            let paddleRect = CGRect(
                x: gameState.paddlePosition - paddleWidth / 2,
                y: gameAreaSize.height - 40, // Paddle position from bottom
                width: paddleWidth,
                height: paddleHeight
            )
            
            let ballRect = CGRect(
                x: gameState.ballPosition.x - ballSize / 2,
                y: gameState.ballPosition.y - ballSize / 2,
                width: ballSize,
                height: ballSize
            )
            
            if ballRect.intersects(paddleRect) && gameState.ballVelocity.y > 0 {
                // Calculate bounce angle based on where ball hits paddle
                let relativeHitPosition = (gameState.ballPosition.x - gameState.paddlePosition) / (paddleWidth / 2)
                gameState.ballVelocity.x = relativeHitPosition * 15 // Stronger horizontal bounce
                gameState.ballVelocity.y = -abs(gameState.ballVelocity.y) * 1.1 // Stronger vertical bounce
                
                // Ensure ball doesn't get stuck in paddle
                gameState.ballPosition.y = paddleRect.minY - ballSize / 2
            }
            
            // Check collision with items
            for index in throwableItems.indices where !throwableItems[index].isDestroyed {
                let item = throwableItems[index]
                let itemRect = CGRect(
                    x: item.position.x - itemSize / 2,
                    y: item.position.y - itemSize / 2,
                    width: itemSize,
                    height: itemSize
                )
                
                if ballRect.intersects(itemRect) {
                    // Destroy item
                    throwableItems[index].isDestroyed = true
                    gameState.score += item.points
                    gameState.itemsDestroyed += 1
                    
                    // Show toast
                    showToast("\(item.element.name) +\(item.points)!")
                    
                    // Stronger bounce when hitting items
                    gameState.ballVelocity.y *= -0.8
                    gameState.ballVelocity.x *= 1.1 // Slight speed increase on x
                    
                    // Check win condition
                    if gameState.itemsDestroyed >= gameState.totalItems {
                        gameState.isGameActive = false
                        showToast("You Win! Final Score: \(gameState.score)")
                    }
                    
                    break
                }
            }
            
            // Check if ball fell off bottom
            if gameState.ballPosition.y > gameAreaSize.height + 50 {
                resetBall()
            }
        }
    }
    
    private func resetBall() {
        gameState.ballPosition = CGPoint(
            x: gameState.paddlePosition,
            y: gameAreaSize.height - 30 // Back on paddle
        )
        gameState.ballVelocity = .zero
    }
    
    private func showToast(_ message: String) {
        gameState.toastMessage = message
        gameState.showToast = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.gameState.showToast = false
        }
    }
    
    func resetGame() {
        displayLink?.invalidate()
        setupGame()
    }
    
    deinit {
        displayLink?.invalidate()
    }
}


// MARK: - Ball Throw Game View
struct BallThrowGameView: View {
    @StateObject private var gameManager = BallThrowGameManager()
    @Environment(\.dismiss) private var dismiss
    @State private var contentSize: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [Color.darkPurple, Color.mysticBlue]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                Stars1View()
                
                // Use ScrollView for better adaptability
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Header with close button
                        HStack {
                            Button(action: { dismiss() }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(Circle())
                            }
                            
                            Spacer()
                            
                            Text("Element Throw")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.gold)
                            
                            Spacer()
                            
                            Button(action: { gameManager.resetGame() }) {
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // Stats View - Made more compact
                        StatsThrowView(gameManager: gameManager)
                            .padding(.horizontal, 20)
                        
                        Spacer(minLength: 20)
                        
                        // Game Area with adaptive sizing
                        GameAreaView(gameManager: gameManager)
                            .frame(height: calculateGameAreaHeight(for: geometry.size))
                            .padding(.horizontal, 20)
                            .background(Color.black.opacity(0.2))
                            .cornerRadius(16)
                            .padding(.horizontal, 20)
                        
                        // Instructions for smaller screens
                        if geometry.size.height < 700 {
                            Text("Drag the paddle at the bottom to move")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        
                        Spacer(minLength: 20)
                        
                        // Throw Button with adaptive padding
                        Button(action: {
                            gameManager.throwBall()
                        }) {
                            Text("Hit")
                                .font(.system(size: 20, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.green, .red]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(25)
                                .shadow(color: .red.opacity(0.5), radius: 10, y: 5)
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 20)
                        .disabled(!gameManager.gameState.isGameActive || gameManager.gameState.ballVelocity != .zero)
                        .opacity((!gameManager.gameState.isGameActive || gameManager.gameState.ballVelocity != .zero) ? 0.6 : 1.0)
                    }
                    .frame(minHeight: geometry.size.height)
                    .background(
                        GeometryReader { contentGeometry in
                            Color.clear
                                .onAppear {
                                    contentSize = contentGeometry.size
                                }
                                .onChange(of: contentGeometry.size) { oldSize, newSize in
                                    contentSize = newSize
                                }
                        }
                    )
                }
                
                // Toast Message
                if gameManager.gameState.showToast {
                    ToastView(message: gameManager.gameState.toastMessage)
                        .transition(.scale.combined(with: .opacity))
                }
                
                // Game Over Overlay
                if !gameManager.gameState.isGameActive && gameManager.gameState.itemsDestroyed >= gameManager.gameState.totalItems {
                    GameWinOverlay(score: gameManager.gameState.score) {
                        gameManager.resetGame()
                    } onExit: {
                        dismiss()
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func calculateGameAreaHeight(for screenSize: CGSize) -> CGFloat {
        // Adaptive game area height based on screen size
        if screenSize.height > 1000 {
           
            return 600
        } else if screenSize.height > 800 {
          
            return 500
        } else if screenSize.height > 700 {
           
            return 400
        } else {
           
            return 350
        }
    }
}

// MARK: - Game Area View (Improved for different screens)
struct GameAreaView: View {
    @ObservedObject var gameManager: BallThrowGameManager
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Game area background
                Rectangle()
                    .fill(Color.black.opacity(0.1))
                    .border(Color.white.opacity(0.3), width: 2)
                
                // Targets - Responsive sizing
                ForEach(gameManager.throwableItems) { item in
                    if !item.isDestroyed {
                        VStack(spacing: 2) {
                            Text(item.element.rawValue)
                                .font(.system(size: calculateTargetFontSize(for: geometry.size)))
                            
                            Text("\(item.points)")
                                .font(.system(size: calculatePointsFontSize(for: geometry.size), weight: .bold))
                                .foregroundColor(.gold)
                        }
                        .frame(width: calculateTargetSize(for: geometry.size),
                               height: calculateTargetSize(for: geometry.size))
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(item.element.color.opacity(0.3))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(item.element.color, lineWidth: 2)
                                )
                        )
                        .position(item.position)
                    }
                }
                
                // Ball with responsive sizing
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [.white, .yellow, .orange]),
                            center: .center,
                            startRadius: 2,
                            endRadius: calculateBallSize(for: geometry.size) / 2
                        )
                    )
                    .frame(width: calculateBallSize(for: geometry.size),
                           height: calculateBallSize(for: geometry.size))
                    .position(gameManager.gameState.ballPosition)
                    .shadow(color: .orange, radius: 8)
                
                // Paddle with responsive sizing
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: calculatePaddleWidth(for: geometry.size),
                           height: calculatePaddleHeight(for: geometry.size))
                    .position(
                        x: gameManager.gameState.paddlePosition,
                        y: geometry.size.height - calculatePaddleHeight(for: geometry.size) // Fixed at bottom
                    )
                    .shadow(color: .purple, radius: 5)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                // Only move paddle when dragging on the paddle area
                                let paddleRect = CGRect(
                                    x: gameManager.gameState.paddlePosition - calculatePaddleWidth(for: geometry.size) / 2,
                                    y: geometry.size.height - calculatePaddleHeight(for: geometry.size) * 1.5,
                                    width: calculatePaddleWidth(for: geometry.size),
                                    height: calculatePaddleHeight(for: geometry.size) * 2
                                )
                                
                                if paddleRect.contains(value.location) {
                                    gameManager.movePaddle(to: value.location.x)
                                }
                            }
                    )
                
                // Drag instruction - only show on larger screens
                if geometry.size.height > 400 {
                    Text("← Drag paddle to move →")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                        .position(x: geometry.size.width / 2, y: geometry.size.height - 10)
                }
            }
            .onAppear {
                // Initialize game positions with correct geometry
                gameManager.setupInitialPositions(in: geometry.size)
            }
            .onChange(of: geometry.size) { oldSize, newSize in
                // Update positions if size changes
                gameManager.setupInitialPositions(in: newSize)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // Only process drags that start near the paddle
                        let paddleYRange = (geometry.size.height - 60)...geometry.size.height
                        if paddleYRange.contains(value.startLocation.y) {
                            gameManager.movePaddle(to: value.location.x)
                        }
                    }
            )
        }
    }
    
    // MARK: - Responsive Sizing Functions
    
    private func calculateTargetSize(for screenSize: CGSize) -> CGFloat {
        if screenSize.height > 1000 { return 60 }
        else if screenSize.height > 800 { return 50 }
        else if screenSize.height > 700 { return 45 }
        else { return 40 }
    }
    
    private func calculateTargetFontSize(for screenSize: CGSize) -> CGFloat {
        if screenSize.height > 1000 { return 28 }
        else if screenSize.height > 800 { return 24 }
        else if screenSize.height > 700 { return 20 }
        else { return 18 }
    }
    
    private func calculatePointsFontSize(for screenSize: CGSize) -> CGFloat {
        if screenSize.height > 1000 { return 12 }
        else if screenSize.height > 800 { return 10 }
        else if screenSize.height > 700 { return 9 }
        else { return 8 }
    }
    
    private func calculateBallSize(for screenSize: CGSize) -> CGFloat {
        if screenSize.height > 1000 { return 24 }
        else if screenSize.height > 800 { return 20 }
        else if screenSize.height > 700 { return 18 }
        else { return 16 }
    }
    
    private func calculatePaddleWidth(for screenSize: CGSize) -> CGFloat {
        if screenSize.height > 1000 { return 120 }
        else if screenSize.height > 800 { return 100 }
        else if screenSize.height > 700 { return 90 }
        else { return 80 }
    }
    
    private func calculatePaddleHeight(for screenSize: CGSize) -> CGFloat {
        if screenSize.height > 1000 { return 24 }
        else if screenSize.height > 800 { return 20 }
        else if screenSize.height > 700 { return 18 }
        else { return 16 }
    }
}










// MARK: - Stars Background View
struct Stars1View: View {
    @State private var stars: [Star] = []
    
    struct Star {
        let x: CGFloat
        let y: CGFloat
        let size: CGFloat
        let opacity: Double
    }
    
    init() {
        var stars = [Star]()
        for _ in 0..<50 {
            stars.append(Star(
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: CGFloat.random(in: 0...UIScreen.main.bounds.height),
                size: CGFloat.random(in: 1...3),
                opacity: Double.random(in: 0.1...0.8)
            ))
        }
        _stars = State(initialValue: stars)
    }
    
    var body: some View {
        ForEach(stars.indices, id: \.self) { index in
            Circle()
                .fill(Color.white)
                .frame(width: stars[index].size, height: stars[index].size)
                .position(x: stars[index].x, y: stars[index].y)
                .opacity(stars[index].opacity)
        }
    }
}


