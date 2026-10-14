class LegalDocSection {
  final String title;
  final String content;
  final bool isDraftNotice;

  const LegalDocSection({
    required this.title,
    required this.content,
    this.isDraftNotice = false,
  });
}

class LegalDoc {
  final String id;
  final String title;
  final String subtitle;
  final String effectiveDate;
  final String lastUpdatedDate;
  final String version;
  final String operatorEntity;
  final List<LegalDocSection> sections;

  const LegalDoc({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.effectiveDate,
    required this.lastUpdatedDate,
    required this.version,
    required this.operatorEntity,
    required this.sections,
  });
}

class LegalRepository {
  static const String operatorName = "Lynexa Innovations Ltd.";
  static const String officialWebsite = "https://zengly.com";
  static const String privacyContact = "privacy@zengly.com";
  static const String supportContact = "support@zengly.com";

  static LegalDoc get termsOfUse => const LegalDoc(
        id: "terms_of_use",
        title: "Terms of Use",
        subtitle: "Wallet funds, reversal rules, liability & platform responsibilities",
        effectiveDate: "November 1, 2026",
        lastUpdatedDate: "October 14, 2026",
        version: "v1.0.0-MVP",
        operatorEntity: operatorName,
        sections: [
          LegalDocSection(
            title: "1. Wallet Funds and Usage",
            content:
                "By creating a wallet within this application, you acknowledge and agree that all funds deposited into the wallet are strictly intended for use within the platform. Such funds shall not be withdrawn, transferred, or otherwise utilized outside the app, whether electronically, physically, or by any other means. The wallet is intended solely as a medium to facilitate transactions, purchases, or services available through the app.",
          ),
          LegalDocSection(
            title: "2. Failed or Reversed Transactions",
            content:
                "In the event that a debit is processed on a payment card or other linked financial instrument and such transaction fails or is declined, the amount in question shall be automatically credited back to your wallet. The platform shall not be held liable for any delay or failure in the reversal of funds due to circumstances beyond its reasonable control, including banking system delays.",
          ),
          LegalDocSection(
            title: "3. Limitation of Liability",
            content:
                "The wallet, its operation, and the funds therein are provided on an “as is” basis. The platform disclaims any liability for indirect, incidental, or consequential losses arising from wallet usage, including but not limited to failed transactions, technical errors, or unauthorized access, except as expressly provided by law.",
          ),
          LegalDocSection(
            title: "4. User Responsibilities & Security",
            content:
                "You agree to maintain the confidentiality of your wallet credentials, Transaction PIN, and biometric access. You shall not permit any third party to access or use your wallet without explicit authorization. You are solely responsible for all activity occurring under your account. The platform reserves the right to suspend, restrict, or terminate wallet access in cases of suspected fraud, misuse, or breach of these terms.",
          ),
          LegalDocSection(
            title: "5. Digital Gifting & Vaniti Interaction",
            content:
                "Funds utilized for Vaniti cash spraying, gifts, or event tipping are debited immediately and irrevocably from your active balance upon confirmation of your Transaction PIN or biometric approval. The platform is not responsible for misdirected gifts or spray transfers resulting from user input errors.",
          ),
          LegalDocSection(
            title: "6. Regulatory Review Notice",
            content:
                "[LEGAL REVIEW REQUIRED]\nThis terms document is binding for all active wallet operations. Final formal updates are subject to periodic audit by Lynexa Innovations Ltd. Legal Counsel and our licensed banking partners.",
            isDraftNotice: true,
          ),
        ],
      );

  static LegalDoc get termsOfService => const LegalDoc(
        id: "terms",
        title: "Terms of Service",
        subtitle: "Rules governing your Zengly profile, wallet, and lifestyle services",
        effectiveDate: "November 1, 2026",
        lastUpdatedDate: "October 14, 2026",
        version: "v1.0.0-MVP",
        operatorEntity: operatorName,
        sections: [
          LegalDocSection(
            title: "1. Introduction & Operating Entity",
            content:
                "Welcome to Zengly. These Terms of Service (\"Terms\") govern your access to and use of the mobile application, website, and related digital services (collectively, the \"Service\") operated by Lynexa Innovations Ltd. (\"Zengly\", \"we\", \"us\", or \"our\"), a company incorporated in the Federal Republic of Nigeria.\n\nBy downloading, installing, registering, or using Zengly, you agree to be bound by these Terms and our Privacy Policy. If you do not agree, you must immediately cease using the Service.",
          ),
          LegalDocSection(
            title: "2. Banking & Regulated Financial Rails",
            content:
                "Zengly is a social-finance and lifestyle technology platform. We are not a licensed commercial deposit bank.\n\nAll deposit holding, bank verification numbers (BVN) validation, Nigerian Inter-Bank Settlement System (NIBSS) payment switching, interbank settlement rails, and physical/virtual payment card issuance are provided exclusively through licensed financial institution partners duly authorized by the Central Bank of Nigeria (CBN). Your funds are deposited with and safeguarded by our licensed partner commercial banks and microfinance banking partners.",
          ),
          LegalDocSection(
            title: "3. Account Eligibility & KYC Requirements",
            content:
                "To maintain an active Zengly account, you must:\n• Be at least 18 years of age or possess legal capacity in your jurisdiction.\n• Complete statutory Know-Your-Customer (KYC) identity verification as mandated by Nigerian anti-money laundering and combating the financing of terrorism (AML/CFT) regulations.\n• Provide accurate legal name, mobile phone number, valid Bank Verification Number (BVN) or National Identification Number (NIN).\n• Maintain strict confidentiality of your login passwords, biometric access, and 4-digit Transaction PIN.",
          ),
          LegalDocSection(
            title: "4. Digital Cash Spraying (Vaniti)",
            content:
                "Zengly Vaniti allows users to digitally transfer funds during social celebrations, events, or live streams.\n\n• Spraying actions represent immediate, irrevocable electronic fund debits from your available balance to the host or designated recipient.\n• Vaniti animations, visual bill flying effects, and leaderboard badges are graphical user interfaces and do NOT represent virtual cryptocurrency or speculative tokens.\n• All monetary values sprayed reflect real currency transfers in Nigerian Naira (NGN) or eligible wallet balance.\n• Event hosts agree to comply with applicable cultural and legal payment standards. Zengly disclaims liability for unauthorized spraying conducted through compromised devices.",
          ),
          LegalDocSection(
            title: "5. Peer-to-Peer Splitting & Group Wallets",
            content:
                "Users may initiate bill splits and participate in Ajo group savings circles. Zengly provides calculation and transfer routing tools. Zengly is not a guarantor of individual participant contributions and does not guarantee payment if a participant defaults on their share.",
          ),
          LegalDocSection(
            title: "6. Prohibited Activities",
            content:
                "You agree not to use Zengly for:\n• Money laundering, terrorist financing, or financial fraud.\n• Transacting with sanctions-restricted entities or illicit gambling platforms.\n• Reverse engineering, decompiling, or exploiting application code or APIs.\n• Imputing false compliance approvals or creating simulated financial balances.",
          ),
          LegalDocSection(
            title: "7. Regulatory Review Notice",
            content:
                "[LEGAL REVIEW REQUIRED]\nThis draft policy reflects production MVP architecture. Final wording is subject to sign-off by Lynexa Innovations Ltd. Legal Counsel and our Regulated Partner Banks prior to commercial public launch.",
            isDraftNotice: true,
          ),
        ],
      );

  static LegalDoc get privacyPolicy => const LegalDoc(
        id: "privacy",
        title: "Privacy Policy",
        subtitle: "How we collect, protect, process, and respect your personal data",
        effectiveDate: "November 1, 2026",
        lastUpdatedDate: "October 14, 2026",
        version: "v1.0.0-MVP",
        operatorEntity: operatorName,
        sections: [
          LegalDocSection(
            title: "1. Scope & Privacy Commitment",
            content:
                "Lynexa Innovations Ltd. (\"Zengly\", \"we\", \"us\") is dedicated to protecting your fundamental right to privacy. This Privacy Policy sets out how we collect, process, retain, and secure your personal data in full compliance with the Nigeria Data Protection Act 2023 (NDPA), the NDPC General Application & Implementation Directive 2025, and international privacy standards.",
          ),
          LegalDocSection(
            title: "2. Personal Information We Collect",
            content:
                "We collect only personal data necessary for authorized fintech and lifestyle operations:\n\n• Identity & KYC Information: Full legal name, date of birth, residential address, telephone number, email, BVN, NIN, and photographic identity capture for biometric liveliness verification.\n• Financial & Transaction Data: Transaction histories, account balances, payment beneficiary details, bill payment tokens, and Vaniti gifting records.\n• Device & Technical Telemetry: IP address, operating system version, unique device identifier (for fraud detection), and biometric authentication status (biometric raw data never leaves your device's secure enclave).\n• Contacts Data: Optional, just-in-time access only when explicitly approved to search friends for Split Bills and Vaniti sprays. We NEVER sell, scrape, or upload your entire contact book to third parties, nor do we access contacts for lending underwriting.",
          ),
          LegalDocSection(
            title: "3. Lawful Bases for Processing",
            content:
                "We process your data under the following NDPA legal bases:\n• Performance of Contract: To execute requested payments, transfers, and wallet operations.\n• Legal & Regulatory Obligation: To fulfill statutory AML/CFT reporting and identity verification mandated by the CBN, NFIU, and NDPC.\n• Legitimate Interests: To detect unauthorized fraud, prevent multiple account exploitation, and ensure platform security.\n• Explicit Consent: For optional marketing communications, non-essential performance cookies, and location-based lifestyle discovery. You may withdraw consent at any time via the Privacy Centre.",
          ),
          LegalDocSection(
            title: "4. Data Sharing & Third Parties",
            content:
                "We share your data strictly on a need-to-know basis with:\n• Licensed Commercial Partner Banks & CBN-approved payment switches (for fund clearing and account numbers).\n• Certified Identity Verification Providers (NIMC/NIBSS-licensed verification partners).\n• Cloud Infrastructure Providers adhering to ISO/IEC 27001 security standards.\n• Law enforcement or regulatory authorities only when presented with a valid statutory subpoena or court warrant.",
          ),
          LegalDocSection(
            title: "5. Data Retention & Erasure Limitations",
            content:
                "In compliance with Nigerian financial regulations (Money Laundering Prevention & Prohibition Act 2022), statutory transaction records and KYC logs must be securely retained for a minimum of five (5) to seven (7) years following account closure. Non-statutory behavioral data and optional profile materials will be permanently erased within thirty (30) days of a verified deletion request.",
          ),
          LegalDocSection(
            title: "6. Your Data Subject Rights",
            content:
                "Under the NDPA 2023, you have the right to:\n• Access your personal data and request an export in a structured, machine-readable format.\n• Rectify inaccurate, misleading, or outdated personal details.\n• Object to or restrict processing for direct marketing.\n• Request Account Deletion via Profile → Settings → Account Management → Delete Account.\n• Contact our designated Data Protection Officer (DPO) at privacy@zengly.com.",
          ),
          LegalDocSection(
            title: "7. Regulatory Review Notice",
            content:
                "[LEGAL REVIEW REQUIRED]\nThis document is formulated in accordance with NDPA 2023 principles. Final sign-off is pending review by the internal Compliance Officer and external Data Protection Compliance Organization (DPCO).",
            isDraftNotice: true,
          ),
        ],
      );

  static LegalDoc get feesAndCharges => const LegalDoc(
        id: "fees",
        title: "Fees & Charges Schedule",
        subtitle: "Transparent breakdown of all platform rates, fees, and limits",
        effectiveDate: "November 1, 2026",
        lastUpdatedDate: "October 14, 2026",
        version: "v1.0.0-MVP",
        operatorEntity: operatorName,
        sections: [
          LegalDocSection(
            title: "1. Core Banking & Wallet Transfers",
            content:
                "• Zengly-to-Zengly Transfers: 100% Free (₦0.00).\n• Outward Interbank Transfers (Up to ₦5,000): ₦10.00 + statutory VAT.\n• Outward Interbank Transfers (₦5,001 - ₦50,000): ₦25.00 + statutory VAT.\n• Outward Interbank Transfers (Above ₦50,000): ₦50.00 + statutory VAT.\n• Inward Transfers: Free (₦0.00).",
          ),
          LegalDocSection(
            title: "2. Bill Payments & Utilities",
            content:
                "• Airtime & Mobile Data: Free (₦0.00 platform markup; discounts up to 3% applied via Z-Coins).\n• Electricity Tokens (Prepaid/Postpaid): Standard DISCO convenience fee of ₦100.00.\n• Cable TV Subscriptions: Free platform fee.",
          ),
          LegalDocSection(
            title: "3. Vaniti Cash Spraying & Events",
            content:
                "• Virtual Spraying (Personal balance to Host): 0.5% settlement and maintenance fee capped at ₦250.00 per event bundle.\n• Digital Event Creation: Free for personal celebrations; premium live projector broadcast tools require Tier 2 verified host status.",
          ),
          LegalDocSection(
            title: "4. Virtual USD Cards",
            content:
                "• Card Issuance: \$3.00 one-time setup fee.\n• Monthly Maintenance: \$1.00.\n• Funding Fee: 1% transparent FX conversion rate derived from interbank market rates without hidden markups.",
          ),
        ],
      );

  static LegalDoc get disputePolicy => const LegalDoc(
        id: "disputes",
        title: "Refunds, Reversals & Disputes",
        subtitle: "Guidelines and SLAs for resolving failed or disputed payments",
        effectiveDate: "November 1, 2026",
        lastUpdatedDate: "October 14, 2026",
        version: "v1.0.0-MVP",
        operatorEntity: operatorName,
        sections: [
          LegalDocSection(
            title: "1. Failed or Debited Transfers",
            content:
                "If your account was debited for an outward transfer but the recipient did not receive funds within 15 minutes:\n• Interbank reversals are processed automatically within 24 to 48 banking hours in accordance with CBN NIBSS guidelines.\n• You can immediately file a dispute via Help & Support → Transaction Issues, selecting the failed transaction to generate an official tracking ticket.",
          ),
          LegalDocSection(
            title: "2. Utility Tokens & Airtime Delivery",
            content:
                "• Electricity tokens are generated instantly. In event of DISCO gateway timeouts, tokens are retrieved and re-delivered to your SMS/Email within 2 hours.\n• If a utility vendor permanently rejects an order, the entire debited amount is returned to your Zengly balance immediately.",
          ),
          LegalDocSection(
            title: "3. Vaniti & Unauthorized Spray Claims",
            content:
                "Because Vaniti sprays are instantaneous real-money transfers, completed sprays to a verified event host cannot be reversed once distributed to the host. If an event was fraudulent or canceled before completion, lodge a dispute with the Host within 24 hours.",
          ),
        ],
      );

  static LegalDoc get lendingTerms => const LegalDoc(
        id: "lending",
        title: "P2P Lending & Credit Terms",
        subtitle: "Regulatory disclosures, FCCPC compliance, and borrowing guidelines",
        effectiveDate: "November 1, 2026",
        lastUpdatedDate: "October 14, 2026",
        version: "v1.0.0-DRAFT",
        operatorEntity: operatorName,
        sections: [
          LegalDocSection(
            title: "1. Regulatory Sandbox Status",
            content:
                "NOTICE: Peer-to-Peer Lending and Credit features are currently deployed in a controlled regulatory sandbox environment. Real loan disbursements and borrowings are DISABLED until formal operating licenses, FCCPC compliance registrations, and CBN-regulated partner bank credit agreements are finalized.\n\nAll figures shown in the application are illustrative previews and do NOT represent binding loan offers.",
            isDraftNotice: true,
          ),
          LegalDocSection(
            title: "2. Consumer Protection & Fair Lending",
            content:
                "In strict accordance with the Federal Competition and Consumer Protection Act (FCCPA) 2018 and FCCPC Digital Lending Guidelines 2025:\n• Zengly prohibits abusive debt recovery practices, defamatory harassment, or contact scraping.\n• Zengly NEVER accesses your device contacts or photo gallery for lending or collection purposes.\n• Annual Percentage Rates (APR), processing fees, total repayment amounts, and late penalties will be transparently calculated and presented prior to loan acceptance.",
          ),
        ],
      );
}
