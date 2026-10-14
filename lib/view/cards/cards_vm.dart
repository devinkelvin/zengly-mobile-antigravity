import 'package:flutter_riverpod/flutter_riverpod.dart';

class ZenglyCardData {
  final String id;
  final String cardHolderName;
  final String pan;
  final String expiryDate;
  final String cvv;
  final double balanceUsd;
  final double balanceNgn;
  final double dailyLimit;
  final double spentToday;
  final bool isFrozen;
  final bool isPhysical;
  final String brand; // Mastercard / Visa
  final String billingAddress;
  final String postalCode;
  final String city;
  final String country;

  const ZenglyCardData({
    required this.id,
    required this.cardHolderName,
    required this.pan,
    required this.expiryDate,
    required this.cvv,
    required this.balanceUsd,
    required this.balanceNgn,
    required this.dailyLimit,
    required this.spentToday,
    this.isFrozen = false,
    this.isPhysical = false,
    this.brand = "Mastercard",
    this.billingAddress = "1200 Brickell Ave, Suite 1950",
    this.postalCode = "33131",
    this.city = "Miami, FL",
    this.country = "United States",
  });

  String get maskedPan {
    if (pan.length >= 4) {
      final last4 = pan.substring(pan.length - 4);
      return "•••• •••• •••• $last4";
    }
    return pan;
  }

  String get formattedPan {
    final cleaned = pan.replaceAll(RegExp(r'\s+'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < cleaned.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(cleaned[i]);
    }
    return buffer.toString();
  }

  ZenglyCardData copyWith({
    String? id,
    String? cardHolderName,
    String? pan,
    String? expiryDate,
    String? cvv,
    double? balanceUsd,
    double? balanceNgn,
    double? dailyLimit,
    double? spentToday,
    bool? isFrozen,
    bool? isPhysical,
    String? brand,
    String? billingAddress,
    String? postalCode,
    String? city,
    String? country,
  }) {
    return ZenglyCardData(
      id: id ?? this.id,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      pan: pan ?? this.pan,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      balanceUsd: balanceUsd ?? this.balanceUsd,
      balanceNgn: balanceNgn ?? this.balanceNgn,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      spentToday: spentToday ?? this.spentToday,
      isFrozen: isFrozen ?? this.isFrozen,
      isPhysical: isPhysical ?? this.isPhysical,
      brand: brand ?? this.brand,
      billingAddress: billingAddress ?? this.billingAddress,
      postalCode: postalCode ?? this.postalCode,
      city: city ?? this.city,
      country: country ?? this.country,
    );
  }
}

class CardTransactionItem {
  final String id;
  final String merchant;
  final double amountUsd;
  final String date;
  final String category;
  final bool isSuccess;

  const CardTransactionItem({
    required this.id,
    required this.merchant,
    required this.amountUsd,
    required this.date,
    required this.category,
    this.isSuccess = true,
  });
}

class CardsState {
  final List<ZenglyCardData> cards;
  final int selectedCardIndex;
  final bool showSensitiveDetails;
  final List<CardTransactionItem> recentTransactions;
  final bool isLoading;

  const CardsState({
    required this.cards,
    this.selectedCardIndex = 0,
    this.showSensitiveDetails = false,
    required this.recentTransactions,
    this.isLoading = false,
  });

  ZenglyCardData? get currentCard {
    if (cards.isEmpty) return null;
    if (selectedCardIndex >= 0 && selectedCardIndex < cards.length) {
      return cards[selectedCardIndex];
    }
    return cards.first;
  }

  CardsState copyWith({
    List<ZenglyCardData>? cards,
    int? selectedCardIndex,
    bool? showSensitiveDetails,
    List<CardTransactionItem>? recentTransactions,
    bool? isLoading,
  }) {
    return CardsState(
      cards: cards ?? this.cards,
      selectedCardIndex: selectedCardIndex ?? this.selectedCardIndex,
      showSensitiveDetails: showSensitiveDetails ?? this.showSensitiveDetails,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CardsNotifier extends StateNotifier<CardsState> {
  CardsNotifier()
      : super(
          CardsState(
            cards: const [
              ZenglyCardData(
                id: "card_v_01",
                cardHolderName: "KELVIN EKUHOHO",
                pan: "5399820048927163",
                expiryDate: "12/28",
                cvv: "839",
                balanceUsd: 1250.00,
                balanceNgn: 1875000.00,
                dailyLimit: 2500.00,
                spentToday: 480.00,
                isFrozen: false,
                isPhysical: false,
                brand: "Mastercard",
              ),
              ZenglyCardData(
                id: "card_p_01",
                cardHolderName: "KELVIN EKUHOHO",
                pan: "4111234567894210",
                expiryDate: "09/29",
                cvv: "312",
                balanceUsd: 500.00,
                balanceNgn: 750000.00,
                dailyLimit: 5000.00,
                spentToday: 120.00,
                isFrozen: false,
                isPhysical: true,
                brand: "Visa",
              ),
            ],
            recentTransactions: const [
              CardTransactionItem(
                id: "tx_01",
                merchant: "Netflix US",
                amountUsd: 19.99,
                date: "Today, 10:45 AM",
                category: "Subscription",
              ),
              CardTransactionItem(
                id: "tx_02",
                merchant: "DigitalOcean Cloud",
                amountUsd: 48.00,
                date: "Yesterday, 03:12 PM",
                category: "Infrastructure",
              ),
              CardTransactionItem(
                id: "tx_03",
                merchant: "Spotify Premium",
                amountUsd: 10.99,
                date: "11 Oct, 09:20 AM",
                category: "Entertainment",
              ),
              CardTransactionItem(
                id: "tx_04",
                merchant: "Amazon.com",
                amountUsd: 124.50,
                date: "09 Oct, 07:15 PM",
                category: "Shopping",
              ),
            ],
          ),
        );

  void toggleSensitiveDetails() {
    state = state.copyWith(showSensitiveDetails: !state.showSensitiveDetails);
  }

  void selectCard(int index) {
    if (index >= 0 && index < state.cards.length) {
      state = state.copyWith(selectedCardIndex: index);
    }
  }

  void toggleCardFrozen(String cardId) {
    final updatedList = state.cards.map((card) {
      if (card.id == cardId) {
        return card.copyWith(isFrozen: !card.isFrozen);
      }
      return card;
    }).toList();
    state = state.copyWith(cards: updatedList);
  }

  void fundCard(String cardId, double amountUsd) {
    final updatedList = state.cards.map((card) {
      if (card.id == cardId) {
        return card.copyWith(
          balanceUsd: card.balanceUsd + amountUsd,
          balanceNgn: card.balanceNgn + (amountUsd * 1500.0),
        );
      }
      return card;
    }).toList();

    final newTx = CardTransactionItem(
      id: "tx_${DateTime.now().millisecondsSinceEpoch}",
      merchant: "Top Up (Zed Wallet)",
      amountUsd: amountUsd,
      date: "Just now",
      category: "Funding",
    );

    state = state.copyWith(
      cards: updatedList,
      recentTransactions: [newTx, ...state.recentTransactions],
    );
  }
}

final cardsProvider = StateNotifierProvider<CardsNotifier, CardsState>((ref) {
  return CardsNotifier();
});
