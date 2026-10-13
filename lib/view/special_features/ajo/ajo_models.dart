enum AjoStatus { active, pending, completed }
enum MemberPaymentStatus { paid, pending, paidOut }

class AjoMember {
  final String id;
  final String name;
  final int position;
  final MemberPaymentStatus status;
  final String payoutDate;
  final bool isMe;

  const AjoMember({
    required this.id,
    required this.name,
    required this.position,
    required this.status,
    required this.payoutDate,
    this.isMe = false,
  });
}

class AjoGroup {
  final String id;
  final String name;
  final String category;
  final double contributionAmount;
  final String frequency; // "Weekly" or "Monthly"
  final int totalMembers;
  final int currentRound;
  final double totalPool;
  final String nextPayoutDate;
  final int myPosition;
  final bool isCreator;
  final AjoStatus status;
  final List<AjoMember> members;

  const AjoGroup({
    required this.id,
    required this.name,
    required this.category,
    required this.contributionAmount,
    required this.frequency,
    required this.totalMembers,
    required this.currentRound,
    required this.totalPool,
    required this.nextPayoutDate,
    required this.myPosition,
    this.isCreator = false,
    this.status = AjoStatus.active,
    required this.members,
  });
}
