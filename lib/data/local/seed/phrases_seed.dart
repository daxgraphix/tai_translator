import '../../../core/constants/app_constants.dart';

/// Starter phrase bank used to seed Isar on first launch, organized by
/// the categories named in the spec's Phrase Database section.
/// Format: [category, english, swahili]
const List<List<dynamic>> phrasesSeedData = [
  // Greetings
  [PhraseCategory.greetings, 'How are you?', 'Habari yako?'],
  [PhraseCategory.greetings, 'I am fine, thank you.', 'Nzuri, asante.'],
  [PhraseCategory.greetings, 'Good morning.', 'Habari za asubuhi.'],
  [PhraseCategory.greetings, 'Good evening.', 'Habari za jioni.'],
  [PhraseCategory.greetings, 'Nice to meet you.', 'Nafurahi kukutana nawe.'],
  [PhraseCategory.greetings, 'What is your name?', 'Jina lako nani?'],
  [PhraseCategory.greetings, 'My name is...', 'Jina langu ni...'],
  [PhraseCategory.greetings, 'See you later.', 'Tutaonana baadaye.'],

  // Travel
  [PhraseCategory.travel, 'Where is the bus station?', 'Kituo cha mabasi kiko wapi?'],
  [PhraseCategory.travel, 'How much is the ticket?', 'Tiketi ni bei gani?'],
  [PhraseCategory.travel, 'I would like to go to the airport.', 'Ningependa kwenda uwanja wa ndege.'],
  [PhraseCategory.travel, 'Is this seat taken?', 'Kiti hiki kimechukuliwa?'],
  [PhraseCategory.travel, 'Where can I find a taxi?', 'Naweza kupata teksi wapi?'],
  [PhraseCategory.travel, 'How far is it from here?', 'Ni umbali gani kutoka hapa?'],

  // Education
  [PhraseCategory.education, 'Where is the library?', 'Maktaba iko wapi?'],
  [PhraseCategory.education, 'I am a student.', 'Mimi ni mwanafunzi.'],
  [PhraseCategory.education, 'Can you help me with my homework?', 'Unaweza kunisaidia na kazi yangu ya nyumbani?'],
  [PhraseCategory.education, 'When is the exam?', 'Mtihani ni lini?'],

  // Business
  [PhraseCategory.business, 'I have a meeting at ten.', 'Nina mkutano saa nne.'],
  [PhraseCategory.business, 'Can we schedule a call?', 'Tunaweza kupanga simu?'],
  [PhraseCategory.business, 'What is the price?', 'Bei ni gani?'],
  [PhraseCategory.business, 'I would like to negotiate.', 'Ningependa kujadiliana.'],

  // Healthcare
  [PhraseCategory.healthcare, 'I need a doctor.', 'Nahitaji daktari.'],
  [PhraseCategory.healthcare, 'Where is the nearest hospital?', 'Hospitali iliyo karibu iko wapi?'],
  [PhraseCategory.healthcare, 'I am not feeling well.', 'Sijisikii vizuri.'],
  [PhraseCategory.healthcare, 'I am allergic to...', 'Nina mzio wa...'],
];
