import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ParticipantSplitStatus {
  paid,      // Has paid (Settled)
  pending,   // Awaiting payment
  overdue,   // Past due date / Has not paid
  declined,  // Rejected split request with reason
}

enum SplitAllocationMode {
  equal,
  customAmount,
  percentage,
}

class SplitParticipant {
  final String id;
  final String name;
  final String username;
  final String phone;
  final String? bankName;
  final String? accountNumber;
  final String? photo;
  final String avatarInitial;
  final Color avatarColor;
  final double amount;
  final double percentage;
  final ParticipantSplitStatus status;
  final String? statusReason;
  final bool isYou;
  final String? paidAt;
  final int reminderCount;

  const SplitParticipant({
    required this.id,
    required this.name,
    this.username = "",
    this.phone = "",
    this.bankName,
    this.accountNumber,
    this.photo,
    this.avatarInitial = "",
    this.avatarColor = const Color(0xFFE5A93C),
    required this.amount,
    this.percentage = 0.0,
    this.status = ParticipantSplitStatus.pending,
    this.statusReason,
    this.isYou = false,
    this.paidAt,
    this.reminderCount = 0,
  });

  bool get isPaid => status == ParticipantSplitStatus.paid;
  bool get isPending => status == ParticipantSplitStatus.pending;
  bool get isOverdue => status == ParticipantSplitStatus.overdue;
  bool get isDeclined => status == ParticipantSplitStatus.declined;

  SplitParticipant copyWith({
    String? id,
    String? name,
    String? username,
    String? phone,
    String? bankName,
    String? accountNumber,
    String? photo,
    String? avatarInitial,
    Color? avatarColor,
    double? amount,
    double? percentage,
    ParticipantSplitStatus? status,
    String? statusReason,
    bool? isYou,
    String? paidAt,
    int? reminderCount,
  }) {
    return SplitParticipant(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      photo: photo ?? this.photo,
      avatarInitial: avatarInitial ?? this.avatarInitial,
      avatarColor: avatarColor ?? this.avatarColor,
      amount: amount ?? this.amount,
      percentage: percentage ?? this.percentage,
      status: status ?? this.status,
      statusReason: statusReason ?? this.statusReason,
      isYou: isYou ?? this.isYou,
      paidAt: paidAt ?? this.paidAt,
      reminderCount: reminderCount ?? this.reminderCount,
    );
  }
}

class SplitBillItem {
  final String id;
  final String title;
  final String category;
  final String merchantName;
  final String merchantBank;
  final String merchantAccount;
  final double totalAmount;
  final String date;
  final List<SplitParticipant> participants;
  final String status; // "Active", "Completed", "Action Required"
  final bool isCreatedByYou;
  final String note;

  const SplitBillItem({
    required this.id,
    required this.title,
    this.category = "Dining",
    this.merchantName = "",
    this.merchantBank = "GTBank",
    this.merchantAccount = "0428658653",
    required this.totalAmount,
    required this.date,
    required this.participants,
    this.status = "Active",
    this.isCreatedByYou = true,
    this.note = "",
  });

  int get participantsCount => participants.length;
  int get paidCount => participants.where((p) => p.isPaid).length;
  int get pendingCount => participants.where((p) => p.isPending).length;
  int get overdueCount => participants.where((p) => p.isOverdue).length;
  int get declinedCount => participants.where((p) => p.isDeclined).length;

  double get paidAmount => participants
      .where((p) => p.isPaid)
      .fold<double>(0.0, (sum, p) => sum + p.amount);

  double get pendingAmount => totalAmount - paidAmount;

  double get progress => totalAmount > 0 ? (paidAmount / totalAmount).clamp(0.0, 1.0) : 0.0;

  SplitParticipant? get youParticipant {
    try {
      return participants.firstWhere((p) => p.isYou);
    } catch (_) {
      return null;
    }
  }

  SplitBillItem copyWith({
    String? id,
    String? title,
    String? category,
    String? merchantName,
    String? merchantBank,
    String? merchantAccount,
    double? totalAmount,
    String? date,
    List<SplitParticipant>? participants,
    String? status,
    bool? isCreatedByYou,
    String? note,
  }) {
    return SplitBillItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      merchantName: merchantName ?? this.merchantName,
      merchantBank: merchantBank ?? this.merchantBank,
      merchantAccount: merchantAccount ?? this.merchantAccount,
      totalAmount: totalAmount ?? this.totalAmount,
      date: date ?? this.date,
      participants: participants ?? this.participants,
      status: status ?? this.status,
      isCreatedByYou: isCreatedByYou ?? this.isCreatedByYou,
      note: note ?? this.note,
    );
  }
}

class SplitBillState {
  final List<SplitBillItem> bills;
  final String? activeBillId;
  final bool isLoading;

  const SplitBillState({
    required this.bills,
    this.activeBillId,
    this.isLoading = false,
  });

  double get totalOwedToYou => bills
      .where((b) => b.isCreatedByYou && b.status != "Completed")
      .fold<double>(0.0, (sum, b) => sum + b.pendingAmount);

  double get totalYouOwe => bills
      .where((b) => !b.isCreatedByYou && (b.youParticipant != null && !b.youParticipant!.isPaid))
      .fold<double>(0.0, (sum, b) => sum + (b.youParticipant?.amount ?? 0.0));

  double get totalActiveVolume => bills
      .where((b) => b.status != "Completed")
      .fold<double>(0.0, (sum, b) => sum + b.totalAmount);

  SplitBillItem? get activeBill {
    if (activeBillId == null) return bills.isNotEmpty ? bills.first : null;
    try {
      return bills.firstWhere((b) => b.id == activeBillId);
    } catch (_) {
      return bills.isNotEmpty ? bills.first : null;
    }
  }

  SplitBillState copyWith({
    List<SplitBillItem>? bills,
    String? activeBillId,
    bool? isLoading,
  }) {
    return SplitBillState(
      bills: bills ?? this.bills,
      activeBillId: activeBillId ?? this.activeBillId,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SplitBillNotifier extends StateNotifier<SplitBillState> {
  SplitBillNotifier()
      : super(
          SplitBillState(
            activeBillId: "sb_1",
            bills: [
              // Use case 1: Active bill with Paid, Pending, and a Declined participant (with reason)
              SplitBillItem(
                id: "sb_1",
                title: "Dinner & Drinks at RSVP",
                category: "Dining",
                merchantName: "RSVP Restaurant Lagos",
                merchantBank: "Guaranty Trust Bank (GTBank)",
                merchantAccount: "0428658653",
                totalAmount: 500000.0,
                date: "18 Apr 2026",
                note: "Weekend VIP table & drinks",
                status: "Action Required",
                isCreatedByYou: true,
                participants: [
                  const SplitParticipant(
                    id: "p_1",
                    name: "You",
                    username: "@kelvin",
                    phone: "+234 802 000 1122",
                    avatarInitial: "K",
                    amount: 125000.0,
                    percentage: 25.0,
                    status: ParticipantSplitStatus.paid,
                    isYou: true,
                    paidAt: "18 Apr 2026, 8:45 PM",
                  ),
                  const SplitParticipant(
                    id: "p_2",
                    name: "Amara Williams",
                    username: "@amara",
                    phone: "+234 813 456 7890",
                    avatarInitial: "A",
                    avatarColor: Color(0xFF6C5CE7),
                    amount: 125000.0,
                    percentage: 25.0,
                    status: ParticipantSplitStatus.paid,
                    paidAt: "18 Apr 2026, 9:10 PM",
                  ),
                  const SplitParticipant(
                    id: "p_3",
                    name: "Tunde Bakare",
                    username: "@tundeb",
                    phone: "+234 809 112 3344",
                    avatarInitial: "T",
                    avatarColor: Color(0xFF00B894),
                    amount: 125000.0,
                    percentage: 25.0,
                    status: ParticipantSplitStatus.pending,
                    reminderCount: 1,
                  ),
                  const SplitParticipant(
                    id: "p_4",
                    name: "Fola Adeola",
                    username: "@fola_a",
                    phone: "+234 803 998 7766",
                    avatarInitial: "F",
                    avatarColor: Color(0xFFD63031),
                    amount: 125000.0,
                    percentage: 25.0,
                    status: ParticipantSplitStatus.declined,
                    statusReason: "I only had cocktails, did not order mains",
                  ),
                ],
              ),
              // Use case 2: Overdue participant
              SplitBillItem(
                id: "sb_2",
                title: "Apartment Power & Service",
                category: "Rent",
                merchantName: "Lekki Palms Management",
                merchantBank: "Zenith Bank",
                merchantAccount: "1012345678",
                totalAmount: 350000.0,
                date: "14 Apr 2026",
                note: "Generator diesel + monthly maintenance fee",
                status: "Active",
                isCreatedByYou: true,
                participants: [
                  const SplitParticipant(
                    id: "p_21",
                    name: "You",
                    username: "@kelvin",
                    avatarInitial: "K",
                    amount: 175000.0,
                    percentage: 50.0,
                    status: ParticipantSplitStatus.paid,
                    isYou: true,
                    paidAt: "14 Apr 2026",
                  ),
                  const SplitParticipant(
                    id: "p_22",
                    name: "Somi Balogun",
                    username: "@somi_b",
                    phone: "+234 808 333 4455",
                    avatarInitial: "S",
                    avatarColor: Color(0xFFE17055),
                    amount: 175000.0,
                    percentage: 50.0,
                    status: ParticipantSplitStatus.overdue,
                    statusReason: "Due date was 15 Apr 2026 (3 days overdue)",
                    reminderCount: 2,
                  ),
                ],
              ),
              // Use case 3: 100% Completed bill
              SplitBillItem(
                id: "sb_3",
                title: "Tarkwa Bay Beach House",
                category: "Travel",
                merchantName: "Tarkwa Luxury Escapes",
                merchantBank: "Access Bank",
                merchantAccount: "0691234567",
                totalAmount: 1200000.0,
                date: "10 Apr 2026",
                note: "Boat charter, beachfront villa & barbecue",
                status: "Completed",
                isCreatedByYou: true,
                participants: [
                  const SplitParticipant(
                    id: "p_31",
                    name: "You",
                    username: "@kelvin",
                    avatarInitial: "K",
                    amount: 300000.0,
                    percentage: 25.0,
                    status: ParticipantSplitStatus.paid,
                    isYou: true,
                    paidAt: "10 Apr 2026",
                  ),
                  const SplitParticipant(
                    id: "p_32",
                    name: "Zainab Bello",
                    username: "@zainab_b",
                    avatarInitial: "Z",
                    avatarColor: Color(0xFFFD79A8),
                    amount: 300000.0,
                    percentage: 25.0,
                    status: ParticipantSplitStatus.paid,
                    paidAt: "10 Apr 2026",
                  ),
                  const SplitParticipant(
                    id: "p_33",
                    name: "Emeka Obi",
                    username: "@emeka_o",
                    avatarInitial: "E",
                    avatarColor: Color(0xFF00CEC9),
                    amount: 300000.0,
                    percentage: 25.0,
                    status: ParticipantSplitStatus.paid,
                    paidAt: "11 Apr 2026",
                  ),
                  const SplitParticipant(
                    id: "p_34",
                    name: "Chioma Eze",
                    username: "@chioma_e",
                    avatarInitial: "C",
                    avatarColor: Color(0xFF0984E3),
                    amount: 300000.0,
                    percentage: 25.0,
                    status: ParticipantSplitStatus.paid,
                    paidAt: "11 Apr 2026",
                  ),
                ],
              ),
              // Use case 4: Bill someone sent to You (You owe your share)
              SplitBillItem(
                id: "sb_4",
                title: "Weekly Grocery Restock",
                category: "Groceries",
                merchantName: "Ebeano Supermarket",
                merchantBank: "Kuda Microfinance Bank",
                merchantAccount: "2001234567",
                totalAmount: 180000.0,
                date: "12 Apr 2026",
                note: "Shared apartment groceries",
                status: "Active",
                isCreatedByYou: false,
                participants: [
                  const SplitParticipant(
                    id: "p_41",
                    name: "Somi Balogun",
                    username: "@somi_b",
                    avatarInitial: "S",
                    avatarColor: Color(0xFF6C5CE7),
                    amount: 60000.0,
                    percentage: 33.3,
                    status: ParticipantSplitStatus.paid,
                    paidAt: "12 Apr 2026",
                  ),
                  const SplitParticipant(
                    id: "p_42",
                    name: "You",
                    username: "@kelvin",
                    avatarInitial: "K",
                    amount: 60000.0,
                    percentage: 33.3,
                    status: ParticipantSplitStatus.pending,
                    isYou: true,
                  ),
                  const SplitParticipant(
                    id: "p_43",
                    name: "Korede Bello",
                    username: "@korede",
                    avatarInitial: "K",
                    avatarColor: Color(0xFFE5A93C),
                    amount: 60000.0,
                    percentage: 33.4,
                    status: ParticipantSplitStatus.paid,
                    paidAt: "12 Apr 2026",
                  ),
                ],
              ),
            ],
          ),
        );

  void selectBill(String id) {
    state = state.copyWith(activeBillId: id);
  }

  void addBill(SplitBillItem bill) {
    state = state.copyWith(
      bills: [bill, ...state.bills],
      activeBillId: bill.id,
    );
  }

  void markParticipantPaid(String billId, String participantId) {
    final updated = state.bills.map((bill) {
      if (bill.id != billId) return bill;
      final updatedParticipants = bill.participants.map((p) {
        if (p.id == participantId) {
          return p.copyWith(
            status: ParticipantSplitStatus.paid,
            paidAt: "Just now",
          );
        }
        return p;
      }).toList();

      final allPaid = updatedParticipants.every((p) => p.isPaid);
      return bill.copyWith(
        participants: updatedParticipants,
        status: allPaid ? "Completed" : (bill.declinedCount > 0 ? "Action Required" : "Active"),
      );
    }).toList();

    state = state.copyWith(bills: updated);
  }

  void markParticipantDeclined(String billId, String participantId, String reason) {
    final updated = state.bills.map((bill) {
      if (bill.id != billId) return bill;
      final updatedParticipants = bill.participants.map((p) {
        if (p.id == participantId) {
          return p.copyWith(
            status: ParticipantSplitStatus.declined,
            statusReason: reason,
          );
        }
        return p;
      }).toList();

      return bill.copyWith(
        participants: updatedParticipants,
        status: "Action Required",
      );
    }).toList();

    state = state.copyWith(bills: updated);
  }

  void coverDeclinedShare(String billId, String declinedParticipantId) {
    final updated = state.bills.map((bill) {
      if (bill.id != billId) return bill;
      final declined = bill.participants.firstWhere(
        (p) => p.id == declinedParticipantId,
        orElse: () => bill.participants.first,
      );
      final declinedAmt = declined.amount;

      final updatedParticipants = bill.participants.map((p) {
        if (p.isYou) {
          return p.copyWith(
            amount: p.amount + declinedAmt,
          );
        }
        if (p.id == declinedParticipantId) {
          return p.copyWith(
            status: ParticipantSplitStatus.paid,
            statusReason: "Covered by creator (@kelvin)",
            paidAt: "Covered by you",
          );
        }
        return p;
      }).toList();

      final allPaid = updatedParticipants.every((p) => p.isPaid);
      return bill.copyWith(
        participants: updatedParticipants,
        status: allPaid ? "Completed" : "Active",
      );
    }).toList();

    state = state.copyWith(bills: updated);
  }

  void reassignDeclinedShare(String billId, String declinedParticipantId) {
    final updated = state.bills.map((bill) {
      if (bill.id != billId) return bill;
      final declined = bill.participants.firstWhere(
        (p) => p.id == declinedParticipantId,
        orElse: () => bill.participants.first,
      );
      final declinedAmt = declined.amount;

      final activeOthers = bill.participants.where((p) => p.id != declinedParticipantId).toList();
      if (activeOthers.isEmpty) return bill;
      final shareAddition = declinedAmt / activeOthers.length;

      final updatedParticipants = bill.participants.map((p) {
        if (p.id == declinedParticipantId) {
          return p.copyWith(
            amount: 0.0,
            status: ParticipantSplitStatus.paid,
            statusReason: "Reassigned among others",
            paidAt: "Reallocated",
          );
        } else {
          return p.copyWith(
            amount: p.amount + shareAddition,
          );
        }
      }).toList();

      final allPaid = updatedParticipants.every((p) => p.isPaid);
      return bill.copyWith(
        participants: updatedParticipants,
        status: allPaid ? "Completed" : "Active",
      );
    }).toList();

    state = state.copyWith(bills: updated);
  }

  void nudgeParticipant(String billId, String participantId) {
    final updated = state.bills.map((bill) {
      if (bill.id != billId) return bill;
      final updatedParticipants = bill.participants.map((p) {
        if (p.id == participantId) {
          return p.copyWith(reminderCount: p.reminderCount + 1);
        }
        return p;
      }).toList();
      return bill.copyWith(participants: updatedParticipants);
    }).toList();

    state = state.copyWith(bills: updated);
  }

  void payYourShare(String billId) {
    final updated = state.bills.map((bill) {
      if (bill.id != billId) return bill;
      final updatedParticipants = bill.participants.map((p) {
        if (p.isYou) {
          return p.copyWith(
            status: ParticipantSplitStatus.paid,
            paidAt: "Just now",
          );
        }
        return p;
      }).toList();

      final allPaid = updatedParticipants.every((p) => p.isPaid);
      return bill.copyWith(
        participants: updatedParticipants,
        status: allPaid ? "Completed" : "Active",
      );
    }).toList();

    state = state.copyWith(bills: updated);
  }
}

final splitBillProvider =
    StateNotifierProvider<SplitBillNotifier, SplitBillState>((ref) {
  return SplitBillNotifier();
});

class SplitDraft {
  final String title;
  final String category;
  final String merchantBank;
  final String merchantAccount;
  final String merchantResolvedName;
  final String merchantLogo;
  final bool isMerchantResolved;
  final double amount;
  final String note;
  final List<SplitParticipant> participants;
  final SplitAllocationMode allocationMode;

  const SplitDraft({
    this.title = "",
    this.category = "Dining",
    this.merchantBank = "Guaranty Trust Bank (GTBank)",
    this.merchantAccount = "",
    this.merchantResolvedName = "",
    this.merchantLogo = "assets/icons/gtbank.png",
    this.isMerchantResolved = false,
    this.amount = 0.0,
    this.note = "",
    this.participants = const [
      SplitParticipant(
        id: "p_you",
        name: "You",
        username: "@kelvin",
        phone: "+234 802 000 1122",
        avatarInitial: "K",
        amount: 0.0,
        status: ParticipantSplitStatus.paid,
        isYou: true,
      ),
      SplitParticipant(
        id: "p_amara",
        name: "Amara Williams",
        username: "@amara",
        phone: "+234 813 456 7890",
        avatarInitial: "A",
        avatarColor: Color(0xFF6C5CE7),
        amount: 0.0,
        status: ParticipantSplitStatus.pending,
      ),
      SplitParticipant(
        id: "p_tunde",
        name: "Tunde Bakare",
        username: "@tundeb",
        phone: "+234 809 112 3344",
        avatarInitial: "T",
        avatarColor: Color(0xFF00B894),
        amount: 0.0,
        status: ParticipantSplitStatus.pending,
      ),
    ],
    this.allocationMode = SplitAllocationMode.equal,
  });

  bool get splitEqually => allocationMode == SplitAllocationMode.equal;

  SplitDraft copyWith({
    String? title,
    String? category,
    String? merchantBank,
    String? merchantAccount,
    String? merchantResolvedName,
    String? merchantLogo,
    bool? isMerchantResolved,
    double? amount,
    String? note,
    List<SplitParticipant>? participants,
    SplitAllocationMode? allocationMode,
  }) {
    return SplitDraft(
      title: title ?? this.title,
      category: category ?? this.category,
      merchantBank: merchantBank ?? this.merchantBank,
      merchantAccount: merchantAccount ?? this.merchantAccount,
      merchantResolvedName: merchantResolvedName ?? this.merchantResolvedName,
      merchantLogo: merchantLogo ?? this.merchantLogo,
      isMerchantResolved: isMerchantResolved ?? this.isMerchantResolved,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      participants: participants ?? this.participants,
      allocationMode: allocationMode ?? this.allocationMode,
    );
  }
}

class SplitDraftNotifier extends StateNotifier<SplitDraft> {
  SplitDraftNotifier() : super(const SplitDraft());

  void updateTitle(String title) => state = state.copyWith(title: title);
  void updateCategory(String category) => state = state.copyWith(category: category);
  void updateAmount(double amount) => state = state.copyWith(amount: amount);
  void updateNote(String note) => state = state.copyWith(note: note);
  void updateRecipient({
    required String bank,
    required String account,
    required String resolvedName,
    required String logo,
    required bool isResolved,
  }) {
    state = state.copyWith(
      merchantBank: bank,
      merchantAccount: account,
      merchantResolvedName: resolvedName,
      merchantLogo: logo,
      isMerchantResolved: isResolved,
    );
  }

  void setParticipants(List<SplitParticipant> participants) {
    state = state.copyWith(participants: participants);
  }

  void addParticipant(SplitParticipant participant) {
    // Avoid duplicate IDs
    if (state.participants.any((p) => p.id == participant.id || (p.username.isNotEmpty && p.username == participant.username))) {
      return;
    }
    state = state.copyWith(participants: [...state.participants, participant]);
  }

  void removeParticipant(String id) {
    // Keep at least You if possible
    final updated = state.participants.where((p) => p.id != id).toList();
    state = state.copyWith(participants: updated);
  }

  void setAllocationMode(SplitAllocationMode mode) {
    state = state.copyWith(allocationMode: mode);
  }

  void reset() => state = const SplitDraft();
}

final splitDraftProvider =
    StateNotifierProvider<SplitDraftNotifier, SplitDraft>((ref) {
  return SplitDraftNotifier();
});
