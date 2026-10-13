import '../../app_images.dart';

class SprayItem {
  final String id;
  final String name;
  final String category;
  final double amount;
  final String displayAmount;
  final String image;
  final double fee;

  const SprayItem({
    required this.id,
    required this.name,
    required this.category,
    required this.amount,
    required this.displayAmount,
    required this.image,
    this.fee = 1000.0,
  });

  static List<SprayItem> get defaultItems => [
        // Spray
        SprayItem(
          id: "spray_notes",
          name: "Spray Notes",
          category: "Spray",
          amount: 5000.0,
          displayAmount: "Custom amount",
          image: AppImages.flyingMoneyBill,
        ),
        SprayItem(
          id: "spray_preset",
          name: "Cash Bundles",
          category: "Spray",
          amount: 10000.0,
          displayAmount: "Preset amount",
          image: AppImages.bundle10k,
        ),
        // Bundles
        SprayItem(
          id: "bundle_10k",
          name: "Cash Bundles",
          category: "Bundles",
          amount: 10000.0,
          displayAmount: "₦10,000.00",
          image: AppImages.bundle10k,
        ),
        SprayItem(
          id: "bundle_20k",
          name: "Cash Bundles",
          category: "Bundles",
          amount: 20000.0,
          displayAmount: "₦20,000.00",
          image: AppImages.bundle20k,
        ),
        SprayItem(
          id: "bundle_50k",
          name: "Cash Bundles",
          category: "Bundles",
          amount: 50000.0,
          displayAmount: "₦50,000.00",
          image: AppImages.bundle50k,
        ),
        SprayItem(
          id: "bundle_100k",
          name: "Cash Bundles",
          category: "Bundles",
          amount: 100000.0,
          displayAmount: "₦100,000.00",
          image: AppImages.bundle100k,
        ),
        // Gifts
        SprayItem(
          id: "gift_200k",
          name: "Cash Bundles",
          category: "Gifts",
          amount: 200000.0,
          displayAmount: "₦200,000.00",
          image: AppImages.cashEnvelopeBrown,
        ),
        SprayItem(
          id: "gift_300k",
          name: "Cash Bundles",
          category: "Gifts",
          amount: 300000.0,
          displayAmount: "₦300,000.00",
          image: AppImages.cashEnvelopeWhite,
        ),
        SprayItem(
          id: "gift_500k",
          name: "Cash Bundles",
          category: "Gifts",
          amount: 500000.0,
          displayAmount: "₦500,000.00",
          image: AppImages.cashBouquet,
        ),
        SprayItem(
          id: "gift_1m",
          name: "Cash Bundles",
          category: "Gifts",
          amount: 1000000.0,
          displayAmount: "₦1M",
          image: AppImages.giftBoxCash,
        ),
        // Premium
        SprayItem(
          id: "premium_black_briefcase",
          name: "Black Briefcase",
          category: "Premium",
          amount: 2000000.0,
          displayAmount: "₦2M",
          image: AppImages.blackBriefcase,
        ),
        SprayItem(
          id: "premium_gold_briefcase",
          name: "Gold Briefcase",
          category: "Premium",
          amount: 3000000.0,
          displayAmount: "₦3M",
          image: AppImages.goldBriefcase,
        ),
        // Legendary
        SprayItem(
          id: "legendary_black_money_bag",
          name: "Black Money Bag",
          category: "Legendary",
          amount: 4000000.0,
          displayAmount: "₦4M",
          image: AppImages.blackMoneyBag,
        ),
        SprayItem(
          id: "legendary_gold_money_bag",
          name: "Gold Money Bag",
          category: "Legendary",
          amount: 5000000.0,
          displayAmount: "₦5M",
          image: AppImages.goldMoneyBag,
        ),
        SprayItem(
          id: "legendary_black_goody_bag",
          name: "Black Goody Bag",
          category: "Legendary",
          amount: 6000000.0,
          displayAmount: "₦6M",
          image: AppImages.blackGoodyBag,
        ),
        SprayItem(
          id: "legendary_gold_goody_bag",
          name: "Gold Goody Bag",
          category: "Legendary",
          amount: 10000000.0,
          displayAmount: "₦10M",
          image: AppImages.goldGoodyBag,
        ),
        SprayItem(
          id: "legendary_vault",
          name: "Vault",
          category: "Legendary",
          amount: 100000000.0,
          displayAmount: "₦100M",
          image: AppImages.vaultSafe,
        ),
      ];
}
