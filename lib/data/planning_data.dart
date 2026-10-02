import 'package:flutter/material.dart';

/// MOCK content and numbers for Family & Budget Planning.
/// - Budget split and childcare costs are rough demo values, NOT real prices.
/// - Assistance programs are written in general terms only. BEFORE A REAL
///   RELEASE verify every program (requirements, agency, current status)
///   with the agency itself or an official source.

class BudgetCategory {
  final String id;
  final String label;
  final String hint;
  final IconData icon;
  final Color tint; // soft background for icons
  final Color color; // stronger color for the split bar
  final double weight; // base share of income (percent)

  const BudgetCategory({
    required this.id,
    required this.label,
    required this.hint,
    required this.icon,
    required this.tint,
    required this.color,
    required this.weight,
  });
}

class PlanningTool {
  final String id;
  final String eyebrow;
  final String title;
  final String description;
  final String chip; // which filter chip this tool belongs to
  final IconData icon;
  final Color tint;

  const PlanningTool({
    required this.id,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.chip,
    required this.icon,
    required this.tint,
  });

  String get searchText =>
      '$eyebrow $title $description $chip'.toLowerCase();
}

class AssistanceProgram {
  final String name;
  final String agency;
  final String tag;
  final IconData icon;
  final String offers;
  final String whoMay;
  final String whereToAsk;

  const AssistanceProgram({
    required this.name,
    required this.agency,
    required this.tag,
    required this.icon,
    required this.offers,
    required this.whoMay,
    required this.whereToAsk,
  });
}

class CostRange {
  final int low;
  final int high;
  const CostRange(this.low, this.high);
}

class PlanningData {
  PlanningData._();

  // ---------------- List screen ----------------

  static const List<String> chips = [
    'For you',
    'Create Budget',
    'Set Savings Goal',
    'Estimate Childcare Costs',
    'Find Financial Assistance',
  ];

  static const List<PlanningTool> tools = [
    PlanningTool(
      id: 'budget_planner',
      eyebrow: 'Smart Budget Planner',
      title: 'Create My Family Budget',
      description:
          'Enter your monthly income and get a suggested split for food, bills, baby needs, and savings.',
      chip: 'Create Budget',
      icon: Icons.auto_awesome_rounded,
      tint: Color(0xFFFCE4EC),
    ),
    PlanningTool(
      id: 'breakdown',
      eyebrow: 'Family Budget Breakdown',
      title: 'Where Does My Money Go?',
      description:
          'Log your spending and see how it compares with your budget, category by category.',
      chip: 'Create Budget',
      icon: Icons.pie_chart_outline_rounded,
      tint: Color(0xFFEDE6F8),
    ),
    PlanningTool(
      id: 'savings',
      eyebrow: 'Savings Goals',
      title: 'Save for What Matters',
      description:
          "Set a goal like an emergency fund or your baby's check-ups, and see how much to set aside each month.",
      chip: 'Set Savings Goal',
      icon: Icons.savings_outlined,
      tint: Color(0xFFE2F3EC),
    ),
    PlanningTool(
      id: 'childcare_cost',
      eyebrow: 'Childcare Cost Estimator',
      title: 'How Much Will Baby Cost?',
      description:
          "Get a rough monthly estimate for milk, diapers, health care, and childcare based on your baby's age.",
      chip: 'Estimate Childcare Costs',
      icon: Icons.calculate_outlined,
      tint: Color(0xFFFFE9DC),
    ),
    PlanningTool(
      id: 'assistance',
      eyebrow: 'Financial Assistance',
      title: 'Find Help You May Qualify For',
      description:
          'Browse Philippine programs for families, mothers, and solo parents, and where to ask about them.',
      chip: 'Find Financial Assistance',
      icon: Icons.volunteer_activism_outlined,
      tint: Color(0xFFFCE4EC),
    ),
  ];

  // ---------------- Budget planner ----------------

  static const List<BudgetCategory> budgetCategories = [
    BudgetCategory(
      id: 'food',
      label: 'Food and groceries',
      hint: 'Rice, viand, groceries',
      icon: Icons.restaurant_rounded,
      tint: Color(0xFFFFE9DC),
      color: Color(0xFFF2A65A),
      weight: 30,
    ),
    BudgetCategory(
      id: 'housing',
      label: 'Rent and utilities',
      hint: 'Rent, electricity, water, internet',
      icon: Icons.home_rounded,
      tint: Color(0xFFEDE6F8),
      color: Color(0xFF9A8FD1),
      weight: 22,
    ),
    BudgetCategory(
      id: 'baby',
      label: 'Baby essentials',
      hint: 'Milk, diapers, vitamins',
      icon: Icons.child_care_rounded,
      tint: Color(0xFFFCE4EC),
      color: Color(0xFFFB77B0),
      weight: 15,
    ),
    BudgetCategory(
      id: 'transport',
      label: 'Transport',
      hint: 'Fare, fuel, trips to work or clinic',
      icon: Icons.directions_bus_rounded,
      tint: Color(0xFFE2F3EC),
      color: Color(0xFF7FB7A4),
      weight: 8,
    ),
    BudgetCategory(
      id: 'health',
      label: 'Health and check-ups',
      hint: 'Check-ups, medicines',
      icon: Icons.medical_services_outlined,
      tint: Color(0xFFFFEFEA),
      color: Color(0xFFE26A6A),
      weight: 5,
    ),
    BudgetCategory(
      id: 'savings',
      label: 'Savings and emergency fund',
      hint: 'For emergencies and your goals',
      icon: Icons.savings_outlined,
      tint: Color(0xFFE2F3EC),
      color: Color(0xFF63263B),
      weight: 12,
    ),
    BudgetCategory(
      id: 'other',
      label: 'Family and other',
      hint: 'Load, family needs, small treats',
      icon: Icons.family_restroom_rounded,
      tint: Color(0xFFEDE6F8),
      color: Color(0xFFB9A6AE),
      weight: 8,
    ),
  ];

  static BudgetCategory categoryById(String id) => budgetCategories
      .firstWhere((c) => c.id == id, orElse: () => budgetCategories.last);

  /// MOCK "smart" suggestion: simple rules, not real AI.
  /// Replace with a Gemini call through the backend later.
  static Map<String, double> suggestSplit({
    required double income,
    required bool paysRent,
    required String babyStage, // 'expecting' | 'infant' | 'toddler'
  }) {
    final w = <String, double>{
      for (final c in budgetCategories) c.id: c.weight,
    };
    if (!paysRent) w['housing'] = 10;
    switch (babyStage) {
      case 'expecting':
        w['baby'] = 10;
        w['health'] = 8;
        w['savings'] = 15;
        break;
      case 'infant':
        w['baby'] = 18;
        break;
      case 'toddler':
        w['baby'] = 12;
        w['food'] = 32;
        break;
    }
    final total = w.values.fold<double>(0, (a, b) => a + b);
    return {for (final e in w.entries) e.key: income * e.value / total};
  }

  // ---------------- Savings goals ----------------

  static const List<String> goalPresets = [
    'Emergency fund',
    "Baby's check-ups",
    'Delivery fund',
    'Baby essentials',
    'School fund',
    'Other',
  ];

  // ---------------- Childcare cost estimator (MOCK ranges, pesos / month) ----

  static const List<String> ageGroups = ['0-6 months', '6-12 months', '1-3 years'];
  static const List<String> feedingOptions = ['Breastfeeding', 'Formula', 'Mixed'];
  static const List<String> diaperOptions = ['Disposable', 'Cloth', 'Mixed'];
  static const List<String> healthOptions = ['Health center', 'Private clinic'];
  static const List<String> careOptions = [
    'Parent or family',
    'Relative or helper',
    'Daycare',
  ];

  // [age index][option index]
  static const List<List<CostRange>> feedingCosts = [
    [CostRange(0, 300), CostRange(2500, 5500), CostRange(1200, 3000)],
    [CostRange(800, 1800), CostRange(3300, 6500), CostRange(1800, 4000)],
    [CostRange(1000, 2000), CostRange(3500, 6500), CostRange(2500, 4500)],
  ];
  static const List<List<CostRange>> diaperCosts = [
    [CostRange(1800, 3000), CostRange(500, 1000), CostRange(1200, 2000)],
    [CostRange(1500, 2600), CostRange(400, 900), CostRange(1000, 1800)],
    [CostRange(1200, 2200), CostRange(300, 800), CostRange(800, 1500)],
  ];
  // Routine vaccines are free at government health centers.
  static const List<CostRange> healthCosts = [
    CostRange(100, 500),
    CostRange(1000, 3000),
  ];
  static const List<CostRange> gearCosts = [
    CostRange(800, 2000),
    CostRange(600, 1500),
    CostRange(500, 1200),
  ];
  static const List<CostRange> careCosts = [
    CostRange(0, 0),
    CostRange(1500, 4000),
    CostRange(3000, 8000),
  ];

  // ---------------- Financial assistance ----------------

  static const List<String> programTags = [
    'All',
    'Cash support',
    'Health',
    'Maternity and work',
    'Solo parents',
    'Crisis support',
  ];

  static const List<AssistanceProgram> programs = [
    AssistanceProgram(
      name: 'Pantawid Pamilyang Pilipino Program (4Ps)',
      agency: 'DSWD',
      tag: 'Cash support',
      icon: Icons.payments_outlined,
      offers:
          'Regular cash grants for qualified poor households, with conditions such as pregnancy check-ups, child vaccinations, and school attendance.',
      whoMay:
          'Poor households identified through DSWD assessment that have pregnant members or children.',
      whereToAsk:
          'Your city or municipal social welfare office (CSWDO/MSWDO) or your barangay.',
    ),
    AssistanceProgram(
      name: 'PhilHealth',
      agency: 'Philippine Health Insurance Corporation',
      tag: 'Health',
      icon: Icons.health_and_safety_outlined,
      offers:
          'Health insurance that can help pay for hospital care, including pregnancy-related and newborn care, depending on the benefit package.',
      whoMay:
          'Filipinos are generally covered under the Universal Health Care law. Benefits depend on your membership type.',
      whereToAsk:
          'A PhilHealth office, or the PhilHealth desk of your hospital or health center.',
    ),
    AssistanceProgram(
      name: 'Free childhood vaccines',
      agency: 'Department of Health (Expanded Program on Immunization)',
      tag: 'Health',
      icon: Icons.vaccines_outlined,
      offers:
          'Routine childhood vaccines are given free at government health centers.',
      whoMay: 'Babies and children who are due for their routine vaccines.',
      whereToAsk:
          "Your Barangay Health Station or Rural Health Unit. Bring your child's vaccination card.",
    ),
    AssistanceProgram(
      name: 'SSS Maternity Benefit',
      agency: 'Social Security System (SSS)',
      tag: 'Maternity and work',
      icon: Icons.pregnant_woman_rounded,
      offers:
          'A cash benefit for qualified female SSS members for childbirth or miscarriage, based on contributions and salary.',
      whoMay:
          'Female SSS members who meet the contribution requirement and follow the notification steps.',
      whereToAsk:
          'Your employer, if you are employed, or the nearest SSS branch.',
    ),
    AssistanceProgram(
      name: 'Expanded Maternity Leave (RA 11210)',
      agency: 'DOLE and SSS',
      tag: 'Maternity and work',
      icon: Icons.event_available_outlined,
      offers:
          "Paid maternity leave of 105 days for qualified working mothers, with extra days for solo parents. Some days can be shared with the child's father.",
      whoMay:
          'Qualified female workers in government and private work, including SSS-covered workers in the informal sector.',
      whereToAsk: 'Your HR or employer, and SSS for the cash benefit.',
    ),
    AssistanceProgram(
      name: "Solo Parents' Welfare Act (RA 8972, expanded by RA 11861)",
      agency: 'DSWD and your local government',
      tag: 'Solo parents',
      icon: Icons.person_outline_rounded,
      offers:
          'Benefits for qualified solo parents. These can include a Solo Parent ID, parental leave, and discounts on some child items, depending on your situation.',
      whoMay:
          "Parents who raise a child alone and meet the law's requirements.",
      whereToAsk:
          'The city or municipal social welfare office (CSWDO/MSWDO) where you live.',
    ),
    AssistanceProgram(
      name: 'Assistance to Individuals in Crisis Situation (AICS)',
      agency: 'DSWD',
      tag: 'Crisis support',
      icon: Icons.support_outlined,
      offers:
          'One-time help for people in crisis, such as medical, transport, food, or burial assistance, depending on the case.',
      whoMay:
          'Individuals and families in crisis. You may need to show proof, such as a medical certificate.',
      whereToAsk:
          'A DSWD field office, your city or municipal social welfare office, or your barangay for referral.',
    ),
  ];
}
