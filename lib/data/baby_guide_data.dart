/// Local content for the Baby Care Guide. Made-up but realistic filler text
/// (general guidance only, not medical advice). No storage needed.
enum AgeGroup { m0to6, m6to12, y1to3, y3plus }

extension AgeGroupInfo on AgeGroup {
  String get chipLabel => switch (this) {
        AgeGroup.m0to6 => '0-6 mo',
        AgeGroup.m6to12 => '6-12 mo',
        AgeGroup.y1to3 => '1-3 yrs',
        AgeGroup.y3plus => '3+ yrs',
      };

  String get subtitle => switch (this) {
        AgeGroup.m0to6 => 'For infants/babies months 0 to 6',
        AgeGroup.m6to12 => 'For infants/babies months 6 to 12',
        AgeGroup.y1to3 => 'For toddlers 1 to 3 years',
        AgeGroup.y3plus => 'For children 3 years and up',
      };
}

class GuideSection {
  final String title;
  final String body;
  final List<String> points; // shown in the Quick Access drawer

  const GuideSection(this.title, this.body, this.points);
}

class GuideTopic {
  final String id;
  final String title;
  final String blurb;
  final Set<AgeGroup> ages;
  final Map<AgeGroup, String> intro; // opening paragraph per age group
  final List<GuideSection> sections;

  const GuideTopic({
    required this.id,
    required this.title,
    required this.blurb,
    required this.ages,
    required this.intro,
    required this.sections,
  });

  String introFor(AgeGroup age) => intro[age] ?? intro.values.first;
}

const Set<AgeGroup> _allAges = {
  AgeGroup.m0to6,
  AgeGroup.m6to12,
  AgeGroup.y1to3,
  AgeGroup.y3plus,
};

class BabyGuideData {
  BabyGuideData._();

  static const List<GuideTopic> topics = [
    GuideTopic(
      id: 'feeding',
      title: 'Feeding and Nutrition',
      blurb: 'Breastfeeding, formula, solid foods',
      ages: _allAges,
      intro: {
        AgeGroup.m0to6:
            'Milk is all your baby needs for the first six months. Feed whenever your baby shows hunger cues like rooting, sucking on hands or fussing, rather than watching the clock.',
        AgeGroup.m6to12:
            'Around six months you can start soft, mashed foods while continuing breast milk or formula. Introduce one new food at a time and wait a few days before trying the next.',
        AgeGroup.y1to3:
            'Toddlers do well on three meals and two or three small snacks a day. Offer a variety of colors and textures, and expect appetite to change from day to day.',
        AgeGroup.y3plus:
            'Children this age can eat most family foods. Build a routine of regular meals, water as the main drink, and fruits and vegetables at every meal.',
      },
      sections: [
        GuideSection(
          'Must Remember',
          'Every baby feeds a little differently, so watch your child more than the schedule. Steady weight gain and plenty of wet diapers are better signs than any exact amount of milk.',
          [
            'Wash hands before preparing food or milk',
            "Follow your child's hunger and fullness cues",
            'Never leave a child alone while eating',
          ],
        ),
        GuideSection(
          'Safe Foods',
          'Some foods are unsafe at young ages. Honey should wait until after the first birthday, and hard or round foods like whole grapes, nuts and hot dog slices should be cut small or avoided until your child chews well.',
          [
            'No honey before 12 months',
            'Cut round foods into small pieces',
            "Cow's milk as a main drink only after 12 months",
          ],
        ),
        GuideSection(
          'Feeding Routine',
          'A predictable routine helps children feel secure around food. Sit together when you can, keep screens off at the table, and let your child decide how much to eat from what you offer.',
          [
            'Offer meals at regular times',
            'Let your child stop when full',
            'Keep mealtimes calm and short',
          ],
        ),
      ],
    ),
    GuideTopic(
      id: 'sleep',
      title: 'Sleep',
      blurb: 'How to make them sleep fast, tips',
      ages: _allAges,
      intro: {
        AgeGroup.m0to6:
            'Newborns sleep 14 to 17 hours a day in short stretches of two to four hours. Longer nighttime stretches usually begin to appear from around three to four months.',
        AgeGroup.m6to12:
            'Most babies this age sleep about 12 to 15 hours in total, including two or three naps. A steady bedtime routine helps them settle more easily.',
        AgeGroup.y1to3:
            'Toddlers need around 11 to 14 hours including one nap. Bedtime pushback is common, so stay consistent with your routine and keep the room calm.',
        AgeGroup.y3plus:
            'Preschoolers need about 10 to 13 hours of sleep. A short wind-down, dim lights and a set bedtime make mornings much easier.',
      },
      sections: [
        GuideSection(
          'Must Remember',
          'Safe sleep matters most for young babies. Always place your baby on their back on a firm, flat surface in their own sleep space, with nothing else in it.',
          [
            'Back to sleep for every sleep under 12 months',
            'Firm, flat mattress with a fitted sheet',
            'Keep pillows, bumpers and toys out of the crib',
          ],
        ),
        GuideSection(
          'Bedtime Routine',
          'A short, repeated routine tells your child that sleep is coming. Try a bath or wipe-down, pajamas, a story or lullaby, then lights out at about the same time each night.',
          [
            'Start winding down 20 to 30 minutes early',
            'Dim the lights and lower your voice',
            'Put baby down drowsy but awake',
          ],
        ),
        GuideSection(
          'Room Setup',
          'A cool, quiet, dark room supports longer sleep. Aim for a comfortable temperature, dress your child in light layers, and use gentle white noise if it helps them settle.',
          [
            'Keep the room comfortably cool',
            'Use blackout curtains if mornings are bright',
            'Avoid screens for an hour before bed',
          ],
        ),
      ],
    ),
    GuideTopic(
      id: 'hygiene',
      title: 'Hygiene and Safety',
      blurb: 'Bathing, Diaper care, home safety',
      ages: _allAges,
      intro: {
        AgeGroup.m0to6:
            'Until the umbilical cord stump falls off, stick to gentle sponge baths. Afterward, two or three baths a week is plenty, with quick daily washing of the face, neck and diaper area.',
        AgeGroup.m6to12:
            'As your baby starts crawling and pulling up, home safety becomes as important as bathing. Get down to floor level and look for hazards within reach.',
        AgeGroup.y1to3:
            'Toddlers explore everything, so lock away cleaning products and medicines and start simple habits like handwashing and brushing teeth twice a day.',
        AgeGroup.y3plus:
            'Children can begin washing hands and brushing teeth with your supervision. Teach basic safety rules for roads, water and strangers.',
      },
      sections: [
        GuideSection(
          'Must Remember',
          'Most accidents happen in a few seconds. Stay within arm\'s reach during baths and changing, and check the water temperature with your wrist or elbow first.',
          [
            'Never leave a child alone in the bath',
            'Keep one hand on your baby on any raised surface',
            'Use an age-appropriate car seat on every ride',
          ],
        ),
        GuideSection(
          'Diaper Care',
          'Change diapers every two to three hours and right after a bowel movement. Clean gently front to back, let the skin dry, and apply a thin layer of barrier cream if you see redness.',
          [
            'Wash hands before and after each change',
            'Pat dry instead of rubbing',
            'Give more diaper-free time if redness lingers',
          ],
        ),
        GuideSection(
          'Home Safety Check',
          'Walk through your home every few months looking for hazards. Cover outlets, secure heavy furniture to the wall, use stair gates, and keep small objects, plastic bags and cords out of reach.',
          [
            'Secure furniture and TVs to the wall',
            'Keep medicines and cleaners locked away',
            'Use gates on stairs and guards on windows',
          ],
        ),
      ],
    ),
    GuideTopic(
      id: 'development',
      title: 'Development',
      blurb: 'Teething, play with them, stimulations',
      ages: _allAges,
      intro: {
        AgeGroup.m0to6:
            'In the first months babies learn to lift their head, follow faces and smile. Short periods of supervised tummy time each day build the strength they need to roll and sit.',
        AgeGroup.m6to12:
            'Babies begin to sit, crawl, babble and pass toys between hands. Teething often starts around four to seven months, bringing drool and fussiness.',
        AgeGroup.y1to3:
            'Toddlers take their first steps, say their first words and copy what you do. Talk, sing and read together every day to grow their vocabulary.',
        AgeGroup.y3plus:
            'Preschoolers ask endless questions, play pretend and start to share and take turns. Give them time for active play, drawing and simple chores.',
      },
      sections: [
        GuideSection(
          'Must Remember',
          'Every child grows at their own pace. Milestones are a rough guide and small differences are normal, but talk to your pediatrician if you notice lost skills or big delays.',
          [
            'Celebrate small progress',
            'Talk and read to your child every day',
            'Ask your pediatrician about any worries',
          ],
        ),
        GuideSection(
          'Play and Stimulation',
          'Simple play is the best learning. Rattles, safe mirrors, stacking cups, songs and peekaboo all help your child explore senses, movement and language without expensive toys.',
          [
            "Follow your child's lead during play",
            'Rotate a few toys instead of many',
            'Limit screen time for young children',
          ],
        ),
        GuideSection(
          'Teething Tips',
          'Sore gums are normal. Offer a clean chilled (not frozen) teething ring or a cool damp washcloth, wipe drool often, and clean new teeth with a soft brush and a smear of fluoride toothpaste.',
          [
            'Avoid teething gels and amber necklaces',
            'Wipe drool to prevent rashes',
            'Call your doctor if the fever is high',
          ],
        ),
      ],
    ),
    GuideTopic(
      id: 'illness',
      title: 'Illness and Vaccines',
      blurb: 'Signs, Care, Tips',
      ages: _allAges,
      intro: {
        AgeGroup.m0to6:
            'Young babies can become sick quickly. A rectal temperature of 38°C (100.4°F) or higher in a baby under three months needs urgent medical attention.',
        AgeGroup.m6to12:
            'Colds are common as babies meet new germs. Keep them hydrated, clear stuffy noses with saline drops and watch closely for trouble breathing or poor feeding.',
        AgeGroup.y1to3:
            'Toddlers catch many mild infections in their first years, especially around other children. Rest, fluids and comfort are usually enough, but know the warning signs.',
        AgeGroup.y3plus:
            'School-age exposure brings more coughs and stomach bugs. Teach handwashing and check that vaccines and boosters are up to date.',
      },
      sections: [
        GuideSection(
          'Must Remember',
          'Trust your instincts. If your child seems unusually sleepy, is hard to wake, breathes with effort, refuses fluids or has a fever with a rash, seek medical care right away.',
          [
            'Keep a thermometer at home',
            'Note the time and dose of any medicine',
            'Never give aspirin to children',
          ],
        ),
        GuideSection(
          'Warning Signs',
          'Call your doctor or go to the nearest hospital for trouble breathing, blue lips, repeated vomiting, signs of dehydration such as no wet diaper for eight hours, seizures or a stiff neck.',
          [
            'Fast or noisy breathing',
            'No wet diaper in 8 hours',
            'Fever with a rash or stiff neck',
          ],
        ),
        GuideSection(
          'Vaccine Basics',
          'Vaccines protect your child from serious diseases. Follow the immunization schedule recommended in your country and keep the record card safe so every dose is given on time.',
          [
            'Bring the vaccine record to every check-up',
            'Mild fever after shots is common',
            'Ask your health worker about missed doses',
          ],
        ),
      ],
    ),
    GuideTopic(
      id: 'toilet',
      title: 'Toilet Training',
      blurb: 'Readiness signs, potty routine, accidents',
      ages: {AgeGroup.y1to3, AgeGroup.y3plus},
      intro: {
        AgeGroup.y1to3:
            'Most children show readiness between 18 and 30 months. Look for dry stretches, interest in the bathroom and telling you when a diaper is wet.',
        AgeGroup.y3plus:
            'Many children are dry in the daytime by three or four. Nighttime dryness can take longer, and accidents are normal, so stay patient and encouraging.',
      },
      sections: [
        GuideSection(
          'Must Remember',
          'Pressure slows progress. Let your child set the pace and treat accidents calmly, without scolding.',
          [
            'Wait for signs of readiness',
            'Praise effort, not perfection',
            'Keep spare clothes nearby',
          ],
        ),
        GuideSection(
          'Potty Routine',
          'Sit your child on the potty at regular times, such as after meals and before bath. Keep sessions short and offer a book or song to make it relaxed.',
          [
            'Use a stable potty or seat insert',
            'Teach handwashing every time',
            'Dress in easy pull-down clothes',
          ],
        ),
        GuideSection(
          'Handling Accidents',
          'Accidents happen, especially during play or in new places. Clean up quietly, remind your child about the potty next time, and go back to diapers for a while if things feel stressful.',
          [
            'Stay calm and reassuring',
            'Never punish accidents',
            'Try again after a short break',
          ],
        ),
      ],
    ),
  ];
}
