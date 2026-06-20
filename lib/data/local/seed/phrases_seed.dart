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

  // --- Expanded Phrases ---

  // Common Conversation
  [PhraseCategory.greetings, 'What did you say?', 'Ulisema nini?'],
  [PhraseCategory.greetings, 'I do not understand.', 'Sielewi.'],
  [PhraseCategory.greetings, 'Could you speak slowly?', 'Unaweza kusema polepole?'],
  [PhraseCategory.greetings, 'Please write it down.', 'Tafadhali aandike.'],
  [PhraseCategory.greetings, 'What does this mean?', 'Hii inamaanisha nini?'],
  [PhraseCategory.greetings, 'How do you say ... in Swahili?', 'Unasemaje ... kwa Kiswahili?'],
  [PhraseCategory.greetings, 'Can you translate this for me?', 'Unaweza kunitafsiria hii?'],
  [PhraseCategory.greetings, 'Where are you from?', 'Unatoka wapi?'],
  [PhraseCategory.greetings, 'I am from...', 'Natoka...'],
  [PhraseCategory.greetings, 'How old are you?', 'Una umri gani?'],
  [PhraseCategory.greetings, 'I am ... years old.', 'Nina umri wa miaka ...'],
  [PhraseCategory.greetings, 'Are you married?', 'Umeoa? (to male) / Umeolewa? (to female)'],
  [PhraseCategory.greetings, 'Do you have children?', 'Una watoto?'],
  [PhraseCategory.greetings, 'What is your phone number?', 'Namba yako ya simu ni gani?'],
  [PhraseCategory.greetings, 'Do you use WhatsApp?', 'Unatumia WhatsApp?'],

  // Shopping & Money
  [PhraseCategory.business, 'How much does this cost?', 'Hii ni bei gani?'],
  [PhraseCategory.business, 'It is too expensive.', 'Ni ghali sana.'],
  [PhraseCategory.business, 'Can you lower the price?', 'Unaweza kupunguza bei?'],
  [PhraseCategory.business, 'I will give you ... shillings.', 'Nitakupa shilingi ...'],
  [PhraseCategory.business, 'Do you accept credit cards?', 'Unakubali kadi za mkopo?'],
  [PhraseCategory.business, 'I only have cash.', 'Nina pesa taslimu tu.'],
  [PhraseCategory.business, 'Where is the nearest ATM?', 'ATM iliyo karibu iko wapi?'],
  [PhraseCategory.business, 'I want to buy this.', 'Nataka kununua hii.'],
  [PhraseCategory.business, 'I am just looking.', 'Niangalia tu.'],
  [PhraseCategory.business, 'Do you have this in a different color?', 'Je, unayo hii katika rangi tofauti?'],
  [PhraseCategory.business, 'Do you have a smaller size?', 'Je, unayo saizi ndogo zaidi?'],
  [PhraseCategory.business, 'Can I have a receipt?', 'Naweza kupata risiti?'],

  // Food & Dining
  [PhraseCategory.travel, 'I am hungry.', 'Nina njaa.'],
  [PhraseCategory.travel, 'I am thirsty.', 'Nina kiu.'],
  [PhraseCategory.travel, 'Where is a good restaurant?', 'Mkahawa mzuri uko wapi?'],
  [PhraseCategory.travel, 'A table for two, please.', 'Meza ya watu wawili, tafadhali.'],
  [PhraseCategory.travel, 'Can I see the menu?', 'Naweza kuona menyu?'],
  [PhraseCategory.travel, 'I would like to order...', 'Ningependa kuagiza...'],
  [PhraseCategory.travel, 'Is it spicy?', 'Ina pilipili?'],
  [PhraseCategory.travel, 'I am a vegetarian.', 'Mimi sili nyama.'],
  [PhraseCategory.travel, 'I do not eat pork.', 'Sili nyama ya nguruwe.'],
  [PhraseCategory.travel, 'Can I have some water?', 'Naweza kupata maji?'],
  [PhraseCategory.travel, 'The food was delicious.', 'Chakula kilikuwa kitamu.'],
  [PhraseCategory.travel, 'The bill, please.', 'Hesabu, tafadhali.'],

  // Directions & Transport
  [PhraseCategory.travel, 'I am lost.', 'Nimepotea.'],
  [PhraseCategory.travel, 'Can you show me on the map?', 'Unaweza kunionyesha kwenye ramani?'],
  [PhraseCategory.travel, 'Turn left.', 'Pinda kushoto.'],
  [PhraseCategory.travel, 'Turn right.', 'Pinda kulia.'],
  [PhraseCategory.travel, 'Go straight ahead.', 'Nenda moja kwa moja.'],
  [PhraseCategory.travel, 'Is it far?', 'Ni mbali?'],
  [PhraseCategory.travel, 'It is near.', 'Ni karibu.'],
  [PhraseCategory.travel, 'Wait here.', 'Subiri hapa.'],
  [PhraseCategory.travel, 'Take me to this address.', 'Nipeleke kwenye anwani hii.'],
  [PhraseCategory.travel, 'Stop here, please.', 'Simama hapa, tafadhali.'],
  [PhraseCategory.travel, 'What time does the bus leave?', 'Basi linaondoka saa ngapi?'],
  [PhraseCategory.travel, 'Is there a bathroom nearby?', 'Kuna choo karibu?'],

  // Emergencies
  [PhraseCategory.healthcare, 'Help me!', 'Nisaidie!'],
  [PhraseCategory.healthcare, 'It is an emergency.', 'Ni dharura.'],
  [PhraseCategory.healthcare, 'Call the police.', 'Piga simu polisi.'],
  [PhraseCategory.healthcare, 'Call an ambulance.', 'Ita gari la wagonjwa.'],
  [PhraseCategory.healthcare, 'I have been robbed.', 'Nimeibiwa.'],
  [PhraseCategory.healthcare, 'I lost my passport.', 'Nimepoteza pasipoti yangu.'],
  [PhraseCategory.healthcare, 'I am sick.', 'Mimi ni mgonjwa.'],
  [PhraseCategory.healthcare, 'Where is the pharmacy?', 'Duka la dawa liko wapi?'],
  [PhraseCategory.healthcare, 'My head hurts.', 'Kichwa kinaniuma.'],
  [PhraseCategory.healthcare, 'I have a fever.', 'Nina homa.'],
  [PhraseCategory.healthcare, 'I need medicine for...', 'Nahitaji dawa ya...'],

  // Work & Technology
  [PhraseCategory.business, 'What is your job?', 'Kazi yako ni nini?'],
  [PhraseCategory.business, 'I work in an office.', 'Ninafanya kazi ofisini.'],
  [PhraseCategory.business, 'Do you have Wi-Fi?', 'Je, una Wi-Fi?'],
  [PhraseCategory.business, 'What is the password?', 'Nywila ni nini?'],
  [PhraseCategory.business, 'My phone has no signal.', 'Simu yangu haina mawimbi.'],
  [PhraseCategory.business, 'I need to charge my phone.', 'Nahitaji kuchaji simu yangu.'],
  [PhraseCategory.business, 'Where can I buy a SIM card?', 'Naweza kununua kadi ya SIM wapi?'],
  [PhraseCategory.business, 'The internet is slow.', 'Mtandao ni wa polepole.'],

  // Time & Dates
  [PhraseCategory.greetings, 'What time is it?', 'Ni saa ngapi?'],
  [PhraseCategory.greetings, 'It is eight o\'clock.', 'Ni saa mbili.'], // Swahili time is shifted by 6 hours
  [PhraseCategory.greetings, 'In the morning.', 'Asubuhi.'],
  [PhraseCategory.greetings, 'In the afternoon.', 'Mchana.'],
  [PhraseCategory.greetings, 'In the evening.', 'Jioni.'],
  [PhraseCategory.greetings, 'At night.', 'Usiku.'],
  [PhraseCategory.greetings, 'Today.', 'Leo.'],
  [PhraseCategory.greetings, 'Tomorrow.', 'Kesho.'],
  [PhraseCategory.greetings, 'Yesterday.', 'Jana.'],
  [PhraseCategory.greetings, 'Next week.', 'Wiki ijayo.'],
  [PhraseCategory.greetings, 'Last month.', 'Mwezi uliopita.'],
  [PhraseCategory.greetings, 'When is your birthday?', 'Siku yako ya kuzaliwa ni lini?'],

  // Family & Social
  [PhraseCategory.greetings, 'This is my husband.', 'Huyu ni mume wangu.'],
  [PhraseCategory.greetings, 'This is my wife.', 'Huyu ni mke wangu.'],
  [PhraseCategory.greetings, 'I love you.', 'Nakupenda.'],
  [PhraseCategory.greetings, 'I miss you.', 'Nimekukumbuka.'],
  [PhraseCategory.greetings, 'Congratulations!', 'Hongera!'],
  [PhraseCategory.greetings, 'Happy birthday!', 'Heri ya siku ya kuzaliwa!'],
  [PhraseCategory.greetings, 'Good luck!', 'Kila la heri!'],
  [PhraseCategory.greetings, 'Cheers!', 'Afya!'],

  // --- Further Expansion ---

  // At the Airport
  [PhraseCategory.travel, 'Where is check-in?', 'Dawati la kuingia liko wapi?'],
  [PhraseCategory.travel, 'Here is my passport.', 'Hii hapa pasipoti yangu.'],
  [PhraseCategory.travel, 'Which gate?', 'Lango lipi?'],
  [PhraseCategory.travel, 'Is the flight delayed?', 'Je, ndege imechelewa?'],
  [PhraseCategory.travel, 'I have only one bag.', 'Nina mfuko mmoja tu.'],

  // At the Hotel
  [PhraseCategory.travel, 'I have a reservation.', 'Nina uhifadhi.'],
  [PhraseCategory.travel, 'I would like a room for tonight.', 'Ningependa chumba cha leo usiku.'],
  [PhraseCategory.travel, 'Does it have air conditioning?', 'Je, kina kiyoyozi?'],
  [PhraseCategory.travel, 'What time is breakfast?', 'Kiamsha kinywa ni saa ngapi?'],
  [PhraseCategory.travel, 'Can I have some towels?', 'Naweza kupata taulo?'],

  // Emergencies & Safety
  [PhraseCategory.healthcare, 'Please call my embassy.', 'Tafadhali pigia ubalozi wangu.'],
  [PhraseCategory.healthcare, 'I am lost, can you help me?', 'Nimepotea, unaweza kunisaidia?'],
  [PhraseCategory.healthcare, 'Someone stole my phone.', 'Mtu ameiiba simu yangu.'],
  [PhraseCategory.healthcare, 'Leave me alone!', 'Niache!'],
  [PhraseCategory.healthcare, 'I need a bandage.', 'Nahitaji bendeji.'],

  // Weather
  [PhraseCategory.travel, 'Is it going to rain?', 'Je, mvua itanyesha?'],
  [PhraseCategory.travel, 'It is very hot today.', 'Leo kuna joto sana.'],
  [PhraseCategory.travel, 'It is cold.', 'Kuna baridi.'],
  [PhraseCategory.travel, 'The weather is beautiful.', 'Hali ya hewa ni nzuri.'],

  // Religion & Culture
  [PhraseCategory.greetings, 'God bless you.', 'Mungu akubariki.'],
  [PhraseCategory.greetings, 'Thank God.', 'Namshukuru Mungu.'],
  [PhraseCategory.greetings, 'Which church do you go to?', 'Unasali kanisa gani?'],
  [PhraseCategory.greetings, 'When is the service?', 'Ibadada ni lini?'],

  // Common Questions
  [PhraseCategory.greetings, 'Why?', 'Kwa nini?'],
  [PhraseCategory.greetings, 'Who?', 'Nani?'],
  [PhraseCategory.greetings, 'Which one?', 'Ipi? / Gani?'],
  [PhraseCategory.greetings, 'How many?', 'Ngapi?'],

  // Agreement & Opinion
  [PhraseCategory.greetings, 'I agree.', 'Nakubali.'],
  [PhraseCategory.greetings, 'I don\'t think so.', 'Sidhani.'],
  [PhraseCategory.greetings, 'It depends.', 'Inategemea.'],
  [PhraseCategory.greetings, 'Of course.', 'Bila shaka.'],
  [PhraseCategory.greetings, 'No problem.', 'Hamna shida.'],
  [PhraseCategory.greetings, 'Exactly.', 'Kabisa.'],

  // At the Market
  [PhraseCategory.business, 'Is this fresh?', 'Hii ni mbichi?'],
  [PhraseCategory.business, 'I want two kilos.', 'Nataka kilo mbili.'],
  [PhraseCategory.business, 'Where can I find vegetables?', 'Naweza kupata wapi mboga?'],
  [PhraseCategory.business, 'Give me change, please.', 'Nipe chenji, tafadhali.'],

  // School & Learning
  [PhraseCategory.education, 'I am learning Swahili.', 'Najifunza Kiswahili.'],
  [PhraseCategory.education, 'My Swahili is not good.', 'Kiswahili changu si kizuri.'],
  [PhraseCategory.education, 'I need to practice more.', 'Nahitaji kufanya mazoezi zaidi.'],
  [PhraseCategory.education, 'Teacher, I have a question.', 'Mwalimu, nina swali.'],
  [PhraseCategory.education, 'Can you explain this?', 'Unaweza kuelezea hii?'],

  // Daily Routine
  [PhraseCategory.greetings, 'I am going to work.', 'Naenda kazini.'],
  [PhraseCategory.greetings, 'I am coming home.', 'Naja nyumbani.'],
  [PhraseCategory.greetings, 'I am tired.', 'Nimechoka.'],
  [PhraseCategory.greetings, 'I want to sleep.', 'Nataka kulala.'],
  [PhraseCategory.greetings, 'I am taking a bath.', 'Naoga.'],

  // Expressing Feelings
  [PhraseCategory.greetings, 'I am happy.', 'Nina furaha.'],
  [PhraseCategory.greetings, 'I am sad.', 'Nina huzuni.'],
  [PhraseCategory.greetings, 'I am angry.', 'Nimekasirika.'],
  [PhraseCategory.greetings, 'I am surprised.', 'Nimeshangaa.'],
  [PhraseCategory.greetings, 'I am bored.', 'Nimechoshwa.'],

  // --- Even More Expansion ---

  // Sports & Leisure
  [PhraseCategory.travel, 'Do you like sports?', 'Je, unapenda michezo?'],
  [PhraseCategory.travel, 'I like football.', 'Napenda mpira wa miguu.'],
  [PhraseCategory.travel, 'Who is winning?', 'Nani anashinda?'],
  [PhraseCategory.travel, 'Let\'s go for a walk.', 'Twende tukatembee.'],
  [PhraseCategory.travel, 'I am going to the beach.', 'Naenda uwanjani / pwani.'],

  // Hobbies
  [PhraseCategory.education, 'What are your hobbies?', 'Unapenda kufanya nini wakati wa mapumziko?'],
  [PhraseCategory.education, 'I like reading books.', 'Napenda kusoma vitabu.'],
  [PhraseCategory.education, 'I like listening to music.', 'Napenda kusikiliza muziki.'],
  [PhraseCategory.education, 'I like cooking.', 'Napenda kupika.'],
  [PhraseCategory.education, 'I like traveling.', 'Napenda kusafiri.'],

  // Social Invitations
  [PhraseCategory.greetings, 'Would you like to have coffee?', 'Je, ungependa kupata kahawa?'],
  [PhraseCategory.greetings, 'Are you free tonight?', 'Uko huru leo usiku?'],
  [PhraseCategory.greetings, 'Let\'s meet at six.', 'Tukutane saa kumi na mbili.'],
  [PhraseCategory.greetings, 'Thank you for the invitation.', 'Asante kwa mwaliko.'],
  [PhraseCategory.greetings, 'I would love to come.', 'Ningependa kuja.'],

  // On the Phone
  [PhraseCategory.business, 'Hello, who is calling?', 'Habari, nani anapiga?'],
  [PhraseCategory.business, 'Wait a moment, please.', 'Subiri kidogo, tafadhali.'],
  [PhraseCategory.business, 'I will call you back.', 'Nitakupigia baadaye.'],
  [PhraseCategory.business, 'The line is busy.', 'Simu inatumika.'],
  [PhraseCategory.business, 'I can\'t hear you well.', 'Sikusikii vizuri.'],

  // Driving & Car
  [PhraseCategory.travel, 'I need gas.', 'Nahitaji mafuta.'],
  [PhraseCategory.travel, 'Where is the gas station?', 'Kituo cha mafuta kiko wapi?'],
  [PhraseCategory.travel, 'The car won\'t start.', 'Gari haliwaki.'],
  [PhraseCategory.travel, 'I have a flat tire.', 'Nina tairi iliyopasuka.'],
  [PhraseCategory.travel, 'Is there a mechanic nearby?', 'Kuna fundi makenika karibu?'],

  // At the Bank
  [PhraseCategory.business, 'I want to open an account.', 'Nataka kufungua akaunti.'],
  [PhraseCategory.business, 'What is the exchange rate?', 'Kiwango cha kubadilisha fedha ni nini?'],
  [PhraseCategory.business, 'I want to withdraw money.', 'Nataka kutoa pesa.'],
  [PhraseCategory.business, 'I want to deposit money.', 'Nataka kuweka pesa.'],
  [PhraseCategory.business, 'Where do I sign?', 'Wapi ninasaini?'],

  // Cleaning & Laundry
  [PhraseCategory.greetings, 'I need to do laundry.', 'Nahitaji kufua nguo.'],
  [PhraseCategory.greetings, 'Where is the dry cleaner?', 'Duka la kufua nguo liko wapi?'],
  [PhraseCategory.greetings, 'Can you wash this?', 'Unaweza kuosha hii?'],
  [PhraseCategory.greetings, 'Is it ready?', 'Je, tayari?'],

  // Feelings & Emotions (More)
  [PhraseCategory.greetings, 'I am excited.', 'Nimesisimka.'],
  [PhraseCategory.greetings, 'I am worried.', 'Nina wasiwasi.'],
  [PhraseCategory.greetings, 'I am confident.', 'Nina ujasiri.'],
  [PhraseCategory.greetings, 'I am shy.', 'Nina aibu.'],
  [PhraseCategory.greetings, 'I am proud of you.', 'Ninakuonea fahari.'],

  // Weather & Nature (More)
  [PhraseCategory.travel, 'Look at the sunset.', 'Tazama machweo.'],
  [PhraseCategory.travel, 'It is very windy.', 'Kuna upepo mwingi sana.'],
  [PhraseCategory.travel, 'The stars are bright.', 'Nyota zinang\'aa.'],
  [PhraseCategory.travel, 'Is the water clean?', 'Je, maji ni safi?'],

  // Emergency (More)
  [PhraseCategory.healthcare, 'Stop, thief!', 'Simama, mwizi!'],
  [PhraseCategory.healthcare, 'I am bleeding.', 'Ninavuja damu.'],
  [PhraseCategory.healthcare, 'I think I broke my leg.', 'Nadhani nimevunja mguu wangu.'],
  [PhraseCategory.healthcare, 'Is it poisonous?', 'Je, ni ya sumu?'],

  // --- Even More Expansion (Part 2) ---

  // At the Restaurant (Ordering)
  [PhraseCategory.travel, 'I would like to pay by cash.', 'Ningependa kulipa kwa pesa taslimu.'],
  [PhraseCategory.travel, 'Can I have the bill, please?', 'Naweza kupata bili, tafadhali?'],
  [PhraseCategory.travel, 'Is service included?', 'Je, huduma imejumuishwa?'],
  [PhraseCategory.travel, 'This is not what I ordered.', 'Hiki si nilichoagiza.'],
  [PhraseCategory.travel, 'It is too salty.', 'Ina chumvi nyingi sana.'],
  [PhraseCategory.travel, 'I would like some more water.', 'Ningependa maji zaidi.'],
  [PhraseCategory.travel, 'Where is the kitchen?', 'Jikoni iko wapi?'],

  // Shopping (Preferences)
  [PhraseCategory.business, 'I like this one.', 'Napenda hii.'],
  [PhraseCategory.business, 'I don\'t like that one.', 'Sipendi hiyo.'],
  [PhraseCategory.business, 'It is too big.', 'Ni kubwa sana.'],
  [PhraseCategory.business, 'It is too small.', 'Ni ndogo sana.'],
  [PhraseCategory.business, 'Do you have other colors?', 'Je, unazo rangi nyingine?'],
  [PhraseCategory.business, 'Is there a discount?', 'Je, kuna punguzo?'],
  [PhraseCategory.business, 'I am looking for a gift.', 'Natafuta zawadi.'],

  // Travel (Asking for Help)
  [PhraseCategory.travel, 'Can you help me with my bags?', 'Unaweza kunisaidia na mifuko yangu?'],
  [PhraseCategory.travel, 'Where is the information desk?', 'Dawati la habari liko wapi?'],
  [PhraseCategory.travel, 'I missed my bus.', 'Nimekosa basi langu.'],
  [PhraseCategory.travel, 'When is the next train?', 'Treni inayofuata ni lini?'],
  [PhraseCategory.travel, 'How long does it take?', 'Inachukua muda gani?'],

  // Healthcare (Symptoms)
  [PhraseCategory.healthcare, 'I have a cough.', 'Nina kikohozi.'],
  [PhraseCategory.healthcare, 'I have a sore throat.', 'Nina koo linalouma.'],
  [PhraseCategory.healthcare, 'I feel dizzy.', 'Nahisi kizunguzungu.'],
  [PhraseCategory.healthcare, 'I need to see a specialist.', 'Nahitaji kuona daktari bingwa.'],
  [PhraseCategory.healthcare, 'Do I need a prescription?', 'Je, nahitaji cheti cha daktari?'],

  // Business (Meeting & Office)
  [PhraseCategory.business, 'Let\'s start the meeting.', 'Tuanze mkutano.'],
  [PhraseCategory.business, 'I will send you the report.', 'Nitakutumia ripoti.'],
  [PhraseCategory.business, 'What is your opinion?', 'Maoni yako ni nini?'],
  [PhraseCategory.business, 'We need to sign the contract.', 'Tunahitaji kusaini mkataba.'],
  [PhraseCategory.business, 'Where is the printer?', 'Printa iko wapi?'],

  // General Social
  [PhraseCategory.greetings, 'What is happening?', 'Kuna nini kinatokea?'],
  [PhraseCategory.greetings, 'Nothing much.', 'Hakuna mengi.'],
  [PhraseCategory.greetings, 'I am busy right now.', 'Niko na kazi sasa hivi.'],
  [PhraseCategory.greetings, 'Call me later.', 'Nipigie baadaye.'],
  [PhraseCategory.greetings, 'Have a good trip!', 'Safari njema!'],
  [PhraseCategory.greetings, 'Have a nice day!', 'Siku njema!'],
  [PhraseCategory.greetings, 'Welcome back!', 'Karibu tena!'],

  // Technology (Internet)
  [PhraseCategory.business, 'The Wi-Fi is not working.', 'Wi-Fi haifanyi kazi.'],
  [PhraseCategory.business, 'I need to download this file.', 'Nahitaji kupakua faili hili.'],
  [PhraseCategory.business, 'Can I use your computer?', 'Naweza kutumia kompyuta yako?'],
  [PhraseCategory.business, 'I forgot my password.', 'Nimesahau nywila yangu.'],

  // Numbers & Quantities
  [PhraseCategory.greetings, 'Just a little.', 'Kidogo tu.'],
  [PhraseCategory.greetings, 'A lot.', 'Nyingi sana.'],
  [PhraseCategory.greetings, 'None.', 'Hakuna.'],
  [PhraseCategory.greetings, 'Everything.', 'Kila kitu.'],
  [PhraseCategory.greetings, 'Something.', 'Kitu fulani.'],

  // House & Home
  [PhraseCategory.greetings, 'Is anyone home?', 'Hodi? (used when knocking)'],
  [PhraseCategory.greetings, 'Come in.', 'Karibu ndani.'],
  [PhraseCategory.greetings, 'Please sit down.', 'Tafadhali keti.'],
  [PhraseCategory.greetings, 'Would you like some tea?', 'Je, ungependa chai?'],
  [PhraseCategory.greetings, 'Where is the bathroom?', 'Choo kiko wapi?'],

  // Weather (Seasons)
  [PhraseCategory.travel, 'It is the rainy season.', 'Ni msimu wa mvua.'],
  [PhraseCategory.travel, 'It is very dry.', 'Kuna ukame sana.'],
  [PhraseCategory.travel, 'The sun is very strong.', 'Jua ni kali sana.'],
  [PhraseCategory.travel, 'It is cloudy.', 'Kuna mawingu.'],

  // Emergency (Specifics)
  [PhraseCategory.healthcare, 'I am lost, where am I?', 'Nimepotea, niko wapi?'],
  [PhraseCategory.healthcare, 'Please help me find my way.', 'Tafadhali nisaidie kupata njia yangu.'],
  [PhraseCategory.healthcare, 'My bag was stolen.', 'Mfuko wangu umeibiwa.'],
  [PhraseCategory.healthcare, 'I need a lawyer.', 'Nahitaji mwanasheria.'],

  // Phrases for Education
  [PhraseCategory.education, 'How do you spell that?', 'Unatamajaje neno hilo?'],
  [PhraseCategory.education, 'Can you repeat that?', 'Unaweza kurudia hiyo?'],
  [PhraseCategory.education, 'I am here to learn.', 'Niko hapa kujifunza.'],
  [PhraseCategory.education, 'What is the homework?', 'Kazi ya nyumbani ni nini?'],

  // Time (Relative)
  [PhraseCategory.greetings, 'Soon.', 'Hivi karibuni.'],
  [PhraseCategory.greetings, 'Already.', 'Tayari.'],
  [PhraseCategory.greetings, 'Not yet.', 'Bado.'],
  [PhraseCategory.greetings, 'Always.', 'Daima.'],
  [PhraseCategory.greetings, 'Sometimes.', 'Mara nyingine.'],
  [PhraseCategory.greetings, 'Never.', 'Kamwe.'],
];
