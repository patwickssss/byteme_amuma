import 'package:flutter/material.dart';

/// MOCK content for BodyWise. Written in plain language for first-time
/// parents in the Philippines. It is general education only.
/// BEFORE A REAL RELEASE: have a doctor/midwife review every module and
/// check it against DOH (Philippines) and WHO guidance.

class BodyWiseSection {
  final String title;
  final String body;
  final List<String> points;

  const BodyWiseSection(this.title, this.body, [this.points = const []]);
}

class BodyWiseModule {
  final String id;
  final String title;
  final String summary;
  final String category;
  final IconData icon;
  final Color tint;
  final int readMinutes;
  final List<String> keyPoints; // "Quick takeaways" card
  final List<BodyWiseSection> sections;
  final List<String> getHelpWhen; // "When to get help" card

  const BodyWiseModule({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    required this.icon,
    required this.tint,
    required this.readMinutes,
    required this.keyPoints,
    required this.sections,
    required this.getHelpWhen,
  });

  /// Everything the search box looks at.
  String get searchText =>
      '$title $summary $category ${sections.map((s) => s.title).join(' ')}'
          .toLowerCase();
}

class BodyWiseData {
  BodyWiseData._();

  static const List<String> categories = [
    'All',
    'Family Planning',
    'Cycle',
    'Pregnancy',
    'After Birth',
    'Sexual Health',
    'Relationships',
  ];

  static const List<BodyWiseModule> modules = [
    BodyWiseModule(
      id: 'contraception',
      title: 'Learn About Contraception',
      summary:
          'Know your options for preventing pregnancy, how each one works, and where to get them.',
      category: 'Family Planning',
      icon: Icons.health_and_safety_outlined,
      tint: Color(0xFFFCE4EC),
      readMinutes: 6,
      keyPoints: [
        'Contraception helps you decide if and when to have a baby.',
        'No method is best for everyone. The right one depends on your health, your daily life, and your goals.',
        'Condoms are the only method that also protects against most sexually transmitted infections (STIs).',
      ],
      sections: [
        BodyWiseSection(
          'Common methods',
          'Methods work in different ways. Some are used every day, some every few months, and some last for years.',
          [
            'Pills: taken at the same time every day. Some types are suitable while breastfeeding.',
            'Injectables: an injection from a health worker, every 2 to 3 months depending on the type.',
            'Implant: a small rod placed under the skin of the upper arm that protects for several years.',
            'IUD: a small device placed in the uterus by a trained provider. It protects for several years.',
            'Condoms: worn during sex. Use a new one every time.',
            'Natural methods: such as tracking fertile days. These need careful, steady use and the cooperation of both partners.',
          ],
        ),
        BodyWiseSection(
          'How well do they work?',
          'The implant and IUD are the most effective: fewer than 1 in 100 users become pregnant in a year. Injectables, pills, and condoms work well when used correctly, but missed doses and mistakes lower their protection.',
          [
            'Set a phone alarm for pill times or injection dates.',
            'Check the expiry date on condoms.',
            'If you miss a pill, read the leaflet or ask a health worker what to do.',
          ],
        ),
        BodyWiseSection(
          'After giving birth',
          'You can get pregnant again even before your period returns. Ask a health worker which methods fit you, including those that are suitable while breastfeeding.',
          [
            'Breastfeeding can delay pregnancy, but only if your baby is under 6 months, you breastfeed fully (day and night), and your period has not returned.',
            'WHO advises waiting at least 2 years after a birth before the next pregnancy, when possible.',
          ],
        ),
        BodyWiseSection(
          'Emergency contraception',
          'If you had sex without protection or your method failed, emergency contraception pills can lower the chance of pregnancy. They work best the sooner they are taken, and up to 5 days after sex.',
          [
            'It is not meant for regular use.',
            'It does not end a pregnancy that has already started.',
            'Ask a pharmacist or health worker for help.',
          ],
        ),
        BodyWiseSection(
          'Where to get help',
          'Family planning counseling and methods are offered at your Barangay Health Station, Rural Health Unit (RHU), city health office, and at private clinics and hospitals, often at low or no cost in public facilities. Services and requirements can differ, especially for minors, so ask a health worker what applies to you.',
          [
            'Write your questions down before you go.',
            'Ask about side effects before choosing.',
            'You can switch methods if one does not suit you.',
          ],
        ),
      ],
      getHelpWhen: [
        'Sudden severe headache, chest pain, or a painful swollen leg after starting a hormonal method',
        'Very heavy or non-stop bleeding',
        'You think you may be pregnant while using a method',
        'Redness, pus, or fever where an injection or implant was placed',
      ],
    ),
    BodyWiseModule(
      id: 'cycle',
      title: 'Understanding Your Menstrual Cycle',
      summary:
          'What a normal cycle looks like, how to track it, and when changes need a check-up.',
      category: 'Cycle',
      icon: Icons.water_drop_outlined,
      tint: Color(0xFFEDE6F8),
      readMinutes: 5,
      keyPoints: [
        'A cycle is counted from the first day of one period to the first day of the next.',
        'Many cycles last 21 to 35 days, and periods usually last 2 to 7 days. Teen cycles can be longer and less regular.',
        'Tracking helps you learn what is normal for you.',
      ],
      sections: [
        BodyWiseSection(
          'The four phases',
          'Hormones move your body through four phases each cycle.',
          [
            'Period: the lining of the uterus leaves the body as bleeding.',
            'Follicular phase: the body prepares an egg to be released.',
            'Ovulation: an egg is released, usually about 12 to 16 days before the next period.',
            'Luteal phase: the body prepares for a possible pregnancy. If there is none, the next period starts.',
          ],
        ),
        BodyWiseSection(
          'Your fertile days',
          'You are most likely to get pregnant in the days before ovulation and on the day itself. Sperm can live up to 5 days in the body, so pregnancy is possible from sex a few days before ovulation. Because cycles vary, calendars and apps only give estimates.',
          [
            'Do not rely on a calendar alone to avoid pregnancy.',
            'Irregular cycles make estimates less reliable.',
          ],
        ),
        BodyWiseSection(
          'Tracking your cycle',
          'A few notes each month are enough to see your pattern.',
          [
            'Mark the first day of every period.',
            'Note how heavy the flow is and any pain or mood changes.',
            'Track for a few months before judging what is normal for you.',
          ],
        ),
        BodyWiseSection(
          'Easing period pain',
          'Mild cramps are common. These can help:',
          [
            'A warm compress on your lower belly.',
            'Gentle movement such as walking or stretching.',
            'Rest and enough water.',
            'Ask a pharmacist or doctor which pain reliever is safe for you and how much to take.',
          ],
        ),
      ],
      getHelpWhen: [
        'No period for 3 months or more and you are not pregnant',
        'Soaking a pad or tampon every hour for several hours',
        'Pain so strong you cannot do your daily activities',
        'Bleeding between periods or after sex',
        'A sudden, big change from your usual pattern',
      ],
    ),
    BodyWiseModule(
      id: 'pregnancy',
      title: 'Pregnancy: Early Signs and First Steps',
      summary:
          'Recognize early signs, confirm a pregnancy, and start prenatal care early.',
      category: 'Pregnancy',
      icon: Icons.pregnant_woman_rounded,
      tint: Color(0xFFFFE9DC),
      readMinutes: 5,
      keyPoints: [
        'A missed period is often the first sign, but not the only one.',
        'Starting prenatal care early helps keep you and your baby healthy.',
        'Pregnancy at any age deserves respect and support. You do not have to go through it alone.',
      ],
      sections: [
        BodyWiseSection(
          'Early signs',
          'Signs differ from person to person, and some people notice nothing in the first weeks.',
          [
            'A missed or late period.',
            'Nausea or vomiting. It can happen at any time of day.',
            'Tender or swollen breasts.',
            'Feeling very tired.',
            'Needing to urinate more often.',
          ],
        ),
        BodyWiseSection(
          'Confirming a pregnancy',
          'A home pregnancy test works best from the first day of a missed period. If it is negative but your period still does not come, test again after a few days or visit a health center. A health worker can confirm the pregnancy and estimate your due date.',
          [
            'Follow the instructions on the test.',
            'Note the first day of your last period.',
          ],
        ),
        BodyWiseSection(
          'Starting prenatal care',
          'Visit your Barangay Health Station, Rural Health Unit, or a doctor or midwife as early as you can. Check-ups follow your health and your baby\'s growth and can catch problems early.',
          [
            'Ask about iron and folic acid supplements.',
            'Ask about recommended vaccines during pregnancy.',
            'Ask where to give birth and how to get there.',
            'Bring a companion if you like.',
          ],
        ),
        BodyWiseSection(
          'Taking care of yourself',
          'Small daily habits make a difference.',
          [
            'Eat a variety of foods: vegetables, fruits, protein, and whole grains.',
            'Drink enough clean water.',
            'Avoid alcohol, smoking, and illegal drugs.',
            'Ask a health worker before taking any medicine or herbal product.',
            'Rest whenever you can.',
          ],
        ),
      ],
      getHelpWhen: [
        'Vaginal bleeding',
        'Severe or constant belly pain',
        'Severe headache, blurred vision, or sudden swelling of the face or hands',
        'Fever, or fluid leaking from the vagina',
        'Your baby moves much less than usual',
        'Fits (convulsions)',
      ],
    ),
    BodyWiseModule(
      id: 'after_birth',
      title: 'Recovery After Birth',
      summary:
          'What to expect in your body and mood after delivery, and when to get help.',
      category: 'After Birth',
      icon: Icons.favorite_border_rounded,
      tint: Color(0xFFE2F3EC),
      readMinutes: 5,
      keyPoints: [
        'Bleeding and cramps after birth are normal and slowly lessen over several weeks.',
        'Mood swings (the baby blues) are common in the first two weeks.',
        'Your post-birth check-up is for you, not only for your baby.',
      ],
      sections: [
        BodyWiseSection(
          'What is normal',
          'Your body needs time to heal.',
          [
            'Vaginal bleeding that is heavy at first, then lighter, and can last up to about 6 weeks.',
            'Cramping, especially while breastfeeding.',
            'Soreness from stitches for a few weeks.',
            'Tiredness and broken sleep.',
          ],
        ),
        BodyWiseSection(
          'Rest and recovery',
          'You are healing and caring for a newborn at the same time. Ask for help.',
          [
            'Sleep when your baby sleeps if you can.',
            'Accept help with cooking, laundry, and chores.',
            'Eat regular meals and drink water, especially if you breastfeed.',
            'Keep stitches clean and dry as your health worker showed you.',
          ],
        ),
        BodyWiseSection(
          'Your feelings',
          'Many new parents feel weepy, anxious, or overwhelmed in the first days. This usually passes within about two weeks. If sadness or worry lasts longer, gets stronger, or makes it hard to care for yourself or your baby, it may be postpartum depression. It is common, treatable, and not your fault.',
          [
            'Talk to someone you trust.',
            'Tell your health worker how you feel at your check-up.',
            'If you have thoughts of harming yourself or your baby, go to the nearest hospital or call 911 right away.',
          ],
        ),
        BodyWiseSection(
          'Family planning after birth',
          'You can become pregnant again before your first period returns. Ask your health worker about methods that fit your situation, including options suitable while breastfeeding.',
          [
            'WHO advises waiting at least 2 years between births when possible.',
            'You can bring this up at your check-up.',
          ],
        ),
      ],
      getHelpWhen: [
        'Soaking a pad in about an hour, or passing large clots',
        'Fever or foul-smelling vaginal discharge',
        'Severe headache, blurred vision, chest pain, or trouble breathing',
        'A painful, swollen, red, or hot leg',
        'Stitches that open, leak pus, or become very painful',
        'Feeling hopeless, or having thoughts of harming yourself or your baby',
      ],
    ),
    BodyWiseModule(
      id: 'sexual_health',
      title: 'Sexual Health and STIs',
      summary:
          'How to protect yourself, why testing matters, and where to get checked.',
      category: 'Sexual Health',
      icon: Icons.shield_outlined,
      tint: Color(0xFFFCE4EC),
      readMinutes: 5,
      keyPoints: [
        'Many STIs have no symptoms, so you can have one without knowing.',
        'Condoms used correctly every time lower the risk of most STIs and also prevent pregnancy.',
        'Many STIs can be cured, and others, like HIV, can be controlled with treatment.',
      ],
      sections: [
        BodyWiseSection(
          'Protecting yourself',
          'Protection is a shared responsibility.',
          [
            'Use a condom every time you have sex.',
            'Talk openly with your partner about testing and protection.',
            'Having fewer partners lowers your risk.',
            'Ask a health worker about the HPV vaccine.',
          ],
        ),
        BodyWiseSection(
          'Possible signs',
          'Some people have symptoms and some do not. Signs can include:',
          [
            'Unusual discharge from the vagina or penis.',
            'Burning when urinating.',
            'Sores, bumps, or itching in the genital area.',
            'Pain in the lower belly or during sex.',
            'No symptoms does not mean you are in the clear.',
          ],
        ),
        BodyWiseSection(
          'Testing and treatment',
          'Testing is quick and is the only way to be sure. Treatment works best when started early, and your partner should be tested and treated too. Social Hygiene Clinics, Rural Health Units, and many hospitals offer STI and HIV testing and counseling. Ask your city or municipal health office where to go.',
        ),
        BodyWiseSection(
          'During pregnancy',
          'Some STIs can affect a baby during pregnancy or birth. Tell your health worker if you think you may have been exposed so you can be tested and treated early.',
        ),
      ],
      getHelpWhen: [
        'You notice any of the signs above',
        'A partner tells you they have an STI',
        'You had unprotected sex and are worried about HIV. Ask right away about PEP, a medicine that must be started within 72 hours',
        'You are pregnant and think you may have an STI',
      ],
    ),
    BodyWiseModule(
      id: 'relationships',
      title: 'Healthy Relationships and Consent',
      summary:
          'Know the signs of a safe relationship and where to find help if you feel unsafe.',
      category: 'Relationships',
      icon: Icons.people_outline_rounded,
      tint: Color(0xFFEDE6F8),
      readMinutes: 4,
      keyPoints: [
        'Consent is a clear, freely given yes. Silence or pressure is not consent.',
        'You can change your mind at any time, even during sex.',
        'You deserve to feel safe and respected in your relationship.',
      ],
      sections: [
        BodyWiseSection(
          'What consent looks like',
          'Consent is about respect.',
          [
            'It is given freely, without pressure, threats, or guilt.',
            'It is specific: yes to one thing is not yes to everything.',
            'It can be taken back at any time.',
            'A person who is asleep, intoxicated, or too young cannot give consent.',
          ],
        ),
        BodyWiseSection(
          'Signs of a healthy relationship',
          'In a healthy relationship:',
          [
            'You feel safe saying no.',
            'You can talk about money, contraception, and plans.',
            'Your partner respects your friends, family, and privacy.',
            'Disagreements are handled without insults or violence.',
          ],
        ),
        BodyWiseSection(
          'Warning signs',
          'Be careful if your partner:',
          [
            'Controls who you see, where you go, or your phone.',
            'Insults, threatens, or pushes you.',
            'Pressures you to have sex, to get pregnant, or to skip contraception.',
            'Controls your money.',
          ],
        ),
        BodyWiseSection(
          'Where to get help',
          'Abuse is never your fault. In the Philippines you can ask for help at your Barangay VAW Desk, the PNP Women and Children Protection Desk, or the social welfare office of your city or municipality. The Anti-VAWC Law (RA 9262) protects women and their children from abuse by a partner or former partner, including through a Barangay Protection Order.',
          [
            'If you are in danger right now, go to a safe place and call 911.',
          ],
        ),
      ],
      getHelpWhen: [
        'You are afraid of your partner',
        'You have been hurt, threatened, or forced',
        'You do not feel safe to say no or to leave',
        'You are worried about someone else\'s safety',
      ],
    ),
  ];
}
