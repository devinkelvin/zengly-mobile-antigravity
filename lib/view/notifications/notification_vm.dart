import 'package:flutter_riverpod/flutter_riverpod.dart';

class ZenglyNotification {
  final String id;
  final String title;
  final String message;
  final String date;
  final bool isRead;
  final String category; // 'transfer', 'vaniti', 'ajo', 'card', 'security', 'reward'

  const ZenglyNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    this.isRead = false,
    this.category = 'general',
  });

  ZenglyNotification copyWith({
    String? id,
    String? title,
    String? message,
    String? date,
    bool? isRead,
    String? category,
  }) {
    return ZenglyNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      date: date ?? this.date,
      isRead: isRead ?? this.isRead,
      category: category ?? this.category,
    );
  }
}

class NotificationState {
  final List<ZenglyNotification> notifications;
  final String activeFilter; // 'all', 'unread', 'transfers'

  const NotificationState({
    required this.notifications,
    this.activeFilter = 'all',
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  List<ZenglyNotification> get filteredList {
    if (activeFilter == 'unread') {
      return notifications.where((n) => !n.isRead).toList();
    }
    if (activeFilter == 'transfers') {
      return notifications.where((n) => n.category == 'transfer' || n.category == 'reward').toList();
    }
    return notifications;
  }

  NotificationState copyWith({
    List<ZenglyNotification>? notifications,
    String? activeFilter,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier()
      : super(
          const NotificationState(
            notifications: [
              ZenglyNotification(
                id: "notif_1",
                title: "Transfer Received 💸",
                message: "You received ₦50,000.00 from @damilola into your Zed Wallet. Instant zero-fee credit.",
                date: "10 mins ago",
                isRead: false,
                category: "transfer",
              ),
              ZenglyNotification(
                id: "notif_2",
                title: "Vaniti Cash Spray Alert 🎉",
                message: "You were showered with ₦15,000 at Lekki Summer Fest 2026. Claim your badge on the leaderboard!",
                date: "2 hours ago",
                isRead: false,
                category: "vaniti",
              ),
              ZenglyNotification(
                id: "notif_3",
                title: "Ajo Circle Payout Upcoming 🤝",
                message: "'Tech Bros Thrift Circle': You are scheduled for payout rotation #3 (₦500,000) on 1st November.",
                date: "Yesterday",
                isRead: true,
                category: "ajo",
              ),
              ZenglyNotification(
                id: "notif_4",
                title: "Virtual Dollar Card Debited 💳",
                message: "Your Zengly Platinum Dollar Card was debited \$19.99 for Netflix US. Balance is \$1,230.01.",
                date: "Yesterday",
                isRead: true,
                category: "card",
              ),
              ZenglyNotification(
                id: "notif_5",
                title: "Cashback Credited 🎁",
                message: "₦1,200 Cashback credited to your balance from your recent IKEDC electricity payment.",
                date: "3 days ago",
                isRead: true,
                category: "reward",
              ),
              ZenglyNotification(
                id: "notif_6",
                title: "Security: New Device Login 🛡️",
                message: "A new login was verified for your account from Samsung Galaxy S24 (Lagos, Nigeria).",
                date: "5 days ago",
                isRead: true,
                category: "security",
              ),
            ],
          ),
        );

  void markAsRead(String id) {
    state = state.copyWith(
      notifications: state.notifications.map((n) {
        if (n.id == id) return n.copyWith(isRead: true);
        return n;
      }).toList(),
    );
  }

  void markAllAsRead() {
    state = state.copyWith(
      notifications: state.notifications.map((n) => n.copyWith(isRead: true)).toList(),
    );
  }

  void setFilter(String filter) {
    state = state.copyWith(activeFilter: filter);
  }
}

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier();
});
