import 'package:flutter/material.dart';

import '../models/emergency_situation.dart';

/// MOCK / STATIC CONTENT for the prototype.
/// IMPORTANT: have this reviewed by a doctor, nurse or midwife and check it
/// against DOH / WHO / Red Cross guidance before real users rely on it.
/// Later this can be loaded from your backend instead of being hardcoded.
class EmergencyData {
  EmergencyData._();

  /// Philippine national emergency hotline. Verify before release.
  static const String emergencyNumber = '911';

  static const List<EmergencySituation> child = [
    EmergencySituation(
      id: 'child_choking',
      title: 'Choking',
      summary: "Can't cry, cough or breathe",
      icon: Icons.warning_amber_rounded,
      urgency: EmergencyUrgency.callNow,
      warningSigns: [
        'Baby cannot cry, cough, or breathe',
        'Lips or skin turning blue or gray',
        'Baby suddenly goes limp',
      ],
      steps: [
        'Call 911, or ask someone nearby to call. Do not leave your baby alone.',
        'Lay your baby face-down along your forearm, head lower than the body, supporting the jaw.',
        'Give up to 5 firm back blows between the shoulder blades with the heel of your hand.',
        'Turn your baby face-up and give 5 chest thrusts with two fingers on the center of the chest.',
        'Repeat until the object comes out or your baby stops responding.',
        'If your baby stops responding, start infant CPR and keep going until help arrives.',
        'These steps are for babies under 1 year. For a child over 1, use abdominal thrusts.',
      ],
      avoid: [
        'Do not blindly sweep your finger inside the mouth.',
        'Do not hold your baby upside down by the legs.',
        'Do not give water or food.',
      ],
    ),
    EmergencySituation(
      id: 'child_breathing',
      title: 'Trouble breathing',
      summary: 'Fast, noisy or hard breathing',
      icon: Icons.air_rounded,
      urgency: EmergencyUrgency.callNow,
      warningSigns: [
        'Very fast breathing or pauses in breathing',
        'Skin pulling in between the ribs or at the neck',
        'Grunting, noisy breathing, or flaring nostrils',
        'Blue or gray lips or face',
      ],
      steps: [
        'Call 911 now.',
        'Keep your baby upright and as calm as possible.',
        'Loosen tight clothing around the chest and neck.',
        'Stay with your baby and watch the breathing until help arrives.',
      ],
      avoid: [
        'Do not give food, drink, or medicine.',
        'Do not wait to see if it gets better.',
      ],
    ),
    EmergencySituation(
      id: 'child_seizure',
      title: 'Seizure',
      summary: 'Shaking, stiffening, not responding',
      icon: Icons.bolt_rounded,
      urgency: EmergencyUrgency.callNow,
      warningSigns: [
        'Shaking or stiffening of the body',
        'Eyes rolling, or not responding to you',
        'Lasting more than a few minutes, or coming back',
        'Trouble breathing or very sleepy afterward',
      ],
      steps: [
        'Call 911.',
        'Lay your baby on a soft surface, on their side.',
        'Move hard or sharp objects away.',
        'Note the time it started and how long it lasts.',
        'Stay close and calm. Keep your baby on their side after it stops.',
      ],
      avoid: [
        'Do not put anything in the mouth.',
        'Do not hold your baby down or try to stop the shaking.',
        'Do not give food or drink until fully awake.',
      ],
    ),
    EmergencySituation(
      id: 'child_poison',
      title: 'Swallowed something harmful',
      summary: 'Medicine, chemicals, batteries',
      icon: Icons.science_rounded,
      urgency: EmergencyUrgency.callNow,
      warningSigns: [
        'Your child swallowed medicine, cleaning products, batteries, or chemicals',
        'You are not sure what or how much was swallowed',
        'Drooling, vomiting, coughing, or unusual sleepiness',
      ],
      steps: [
        'Call 911, or go to the nearest emergency room right away.',
        'Bring the container, pills, or product with you.',
        'If the product is on the skin or in the eyes, rinse with clean running water.',
        'Tell the staff what it was, how much, and when.',
      ],
      avoid: [
        'Do not make your child vomit.',
        'Do not give milk, water, or food unless a health worker tells you to.',
      ],
    ),
    EmergencySituation(
      id: 'child_fever',
      title: 'Fever',
      summary: 'Hot, fussy or very sleepy baby',
      icon: Icons.thermostat_rounded,
      urgency: EmergencyUrgency.helpToday,
      warningSigns: [
        'Baby is under 3 months old with a temperature of 38°C or higher',
        'Fever with trouble breathing, stiff neck, a rash that does not fade when pressed, or a seizure',
        'Baby is very sleepy, hard to wake, or limp',
        'Baby refuses feeds or has far fewer wet diapers than usual',
      ],
      steps: [
        'Check the temperature with a thermometer if you have one.',
        'Dress your baby in light clothes and keep the room comfortably cool.',
        'Offer breast milk, formula, or fluids often.',
        "Give fever medicine only if a doctor told you the right kind and dose for your baby's age and weight.",
        'Contact your doctor or health center today.',
      ],
      avoid: [
        'Do not give aspirin to a baby or child.',
        'Do not use cold baths, ice, or alcohol rubs.',
        'Do not wrap your baby in thick blankets.',
      ],
    ),
    EmergencySituation(
      id: 'child_burn',
      title: 'Burn or scald',
      summary: 'Hot water, oil, fire or chemicals',
      icon: Icons.local_fire_department_rounded,
      urgency: EmergencyUrgency.helpToday,
      warningSigns: [
        "The burn is larger than your baby's palm",
        'It is on the face, hands, feet, or private parts',
        'It is from chemicals, electricity, or hot oil',
        'The skin looks white, charred, or blistered',
      ],
      steps: [
        'Move your baby away from the heat.',
        'Run cool (not ice-cold) water over the burn for 20 minutes.',
        'Remove clothing or jewelry near the burn, unless stuck to the skin.',
        'Cover loosely with a clean, non-fluffy cloth.',
        'Get medical help, even for small burns on a baby.',
      ],
      avoid: [
        'Do not use ice, butter, toothpaste, or oil.',
        'Do not pop blisters.',
        'Do not pull off clothing that is stuck to the skin.',
      ],
    ),
    EmergencySituation(
      id: 'child_head',
      title: 'Fall or head injury',
      summary: 'Bump, fall from bed or arms',
      icon: Icons.personal_injury_rounded,
      urgency: EmergencyUrgency.helpToday,
      warningSigns: [
        'Baby passed out or cannot be woken',
        'Vomiting more than once, or a seizure',
        'Unusual sleepiness, confusion, or crying that cannot be soothed',
        'Clear fluid or blood from the nose or ears',
        'A swollen or bulging soft spot',
        'Bleeding that does not stop after 10 minutes of pressure',
      ],
      steps: [
        'Keep your baby calm and still.',
        'Press a clean cloth on any bleeding.',
        'Place a cold pack wrapped in cloth on the bump for short periods.',
        'Watch your baby closely for the next 24 hours.',
        'Call your doctor, even if your baby seems fine.',
      ],
      avoid: [
        'Do not shake your baby.',
        "Do not move your baby's neck if a neck injury is possible.",
        'Do not give medicine unless a doctor says so.',
      ],
    ),
  ];

  static const List<EmergencySituation> parent = [
    EmergencySituation(
      id: 'parent_bleeding',
      title: 'Heavy bleeding after birth',
      summary: 'Soaking pads, large clots, dizziness',
      icon: Icons.bloodtype_rounded,
      urgency: EmergencyUrgency.callNow,
      warningSigns: [
        'Soaking a pad in an hour or less',
        'Passing large clots',
        'Feeling dizzy, faint, weak, or a racing heartbeat',
        'Bleeding that suddenly gets heavier',
      ],
      steps: [
        'Call 911, or ask someone to take you to the hospital now.',
        'Lie down and keep warm.',
        'Do not stand or walk alone.',
        'Note how many pads you used and when.',
        'Bring your health records if you can.',
      ],
      avoid: [
        'Do not drive yourself.',
        'Do not wait to see if it slows down.',
        'Do not insert anything into the vagina.',
      ],
    ),
    EmergencySituation(
      id: 'parent_headache',
      title: 'Severe headache or vision changes',
      summary: 'In pregnancy or after birth',
      icon: Icons.visibility_rounded,
      urgency: EmergencyUrgency.callNow,
      warningSigns: [
        'A severe headache that will not go away',
        'Blurry vision, spots, or flashing lights',
        'Swelling of the face or hands',
        'Pain in the upper belly',
        'A seizure',
      ],
      steps: [
        'Call 911, or go to the nearest hospital now.',
        'Sit or lie down, preferably on your left side.',
        'Ask someone to go with you.',
        'Tell the staff if you are pregnant or recently gave birth.',
      ],
      avoid: [
        'Do not drive yourself.',
        'Do not wait for the symptoms to go away.',
        "Do not take extra medicine without a doctor's advice.",
      ],
    ),
    EmergencySituation(
      id: 'parent_chest',
      title: 'Chest pain or trouble breathing',
      summary: 'Pressure, short of breath, painful leg',
      icon: Icons.monitor_heart_rounded,
      urgency: EmergencyUrgency.callNow,
      warningSigns: [
        'Chest pain or pressure',
        'Hard time breathing or catching your breath',
        'Coughing up blood',
        'One leg that is swollen, red, or painful',
      ],
      steps: [
        'Call 911 now.',
        'Sit upright and try to stay calm.',
        'Loosen tight clothing.',
        'Unlock the door so help can get in.',
      ],
      avoid: [
        'Do not drive yourself.',
        'Do not lie flat if breathing is hard.',
      ],
    ),
    EmergencySituation(
      id: 'parent_infection',
      title: 'Fever or infection after birth',
      summary: 'Fever, bad smell, painful wound',
      icon: Icons.healing_rounded,
      urgency: EmergencyUrgency.helpToday,
      warningSigns: [
        'Temperature of 38°C or higher',
        'Foul-smelling discharge',
        'Severe belly pain',
        'A C-section wound or tear that is red, swollen, or leaking',
        'Shaking chills',
      ],
      steps: [
        'Check your temperature.',
        'Rest and drink fluids.',
        'Call your doctor or go to a health center today.',
        'Tell them when and how you gave birth.',
      ],
      avoid: [
        'Do not ignore a fever after giving birth.',
        'Do not take leftover antibiotics.',
      ],
    ),
    EmergencySituation(
      id: 'parent_mental',
      title: 'Overwhelmed or thinking of self-harm',
      summary: "You're not alone. Help is available.",
      icon: Icons.volunteer_activism_rounded,
      urgency: EmergencyUrgency.support,
      warningSigns: [
        'You have thoughts of hurting yourself or your baby',
        'You feel hopeless or like you cannot cope',
        'You cannot sleep or eat for days',
        'You feel numb or cut off from your baby',
      ],
      steps: [
        'What you feel is real, and it can be treated. Asking for help is a strong step.',
        'If you are in immediate danger, call 911.',
        'Call the NCMH Crisis Hotline at 1553 to talk to someone now.',
        'Tell someone you trust, like your partner, a family member, or a friend, and ask them to stay with you.',
        'If you fear you may harm your baby, ask someone else to care for the baby while you get help.',
        'Book a visit with a doctor or your barangay health center.',
      ],
      avoid: [
        'Do not stay alone with these thoughts.',
        'Do not wait for it to pass on its own.',
      ],
      hotlineName: 'NCMH Crisis Hotline',
      hotlineNumber: '1553',
    ),
  ];
}
