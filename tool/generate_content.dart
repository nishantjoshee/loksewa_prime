import 'dart:convert';
import 'dart:io';
import 'dart:math';

final rng = Random(42);

const categories = [
  {'np': 'राजनीति', 'en': 'Politics'},
  {'np': 'अर्थतन्त्र', 'en': 'Economy'},
  {'np': 'विज्ञान/प्रविधि', 'en': 'Science/Tech'},
  {'np': 'खेलकुद', 'en': 'Sports'},
  {'np': 'अन्तर्राष्ट्रिय', 'en': 'International'},
  {'np': 'नेपाल', 'en': 'Nepal'},
];

const sources = [
  'Gorkhapatra',
  'Kantipur',
  'Online Khabar',
  'BBC Nepali',
  'Setopati',
  'Nagarik News',
  'The Kathmandu Post',
  'Himalayan Times',
  'Annapurna Post',
  'Naya Patrika',
  'Rajdhani',
  'ESPN Cricinfo',
];

final templatesNp = [
  {
    't': 'सरकारले नयाँ ## नीति सार्वजनिक गर्याे',
    's':
        'सरकारले ## सम्बन्धी नयाँ नीति सार्वजनिक गरेको छ। यो नीतिले आगामी आर्थिक वर्षदेखि लागु हुनेछ।',
  },
  {
    't': '## मा ऐतिहासिक सफलता हात',
    's':
        'नेपालले ## क्षेत्रमा उल्लेखनीय प्रगति हासिल गरेको छ। विज्ञहरूले यसलाई महत्वपूर्ण उपलब्धी मानेका छन्।',
  },
  {
    't': '## सम्झौतामा हस्ताक्षर',
    's':
        'नेपाल सरकारले ## सम्बन्धी अन्तर्राष्ट्रिय सम्झौतामा हस्ताक्षर गरेको छ। सम्झौता अनुसार आगामी ५ वर्षमा कार्यान्वयन हुनेछ।',
  },
  {
    't': '## ले नयाँ कीर्तिमान बनायो',
    's':
        '## ले नयाँ राष्ट्रिय कीर्तिमान कायम गरेको छ। यसअघिको कीर्तिमान २०७८ सालमा बनेको थियो।',
  },
  {
    't': '## परियोजना स्वीकृत, लगानी ५ अर्ब',
    's':
        'सरकारले ## परियोजनालाई स्वीकृति दिएको छ। परियोजनाको कुल लागत ५ अर्ब रुपैयाँ रहेको छ।',
  },
  {
    't': '## मा सुधारको आवश्यकता — प्रतिवेदन',
    's':
        'राष्ट्रिय योजना आयोगले ## क्षेत्रमा सुधार आवश्यक रहेको प्रतिवेदन सार्वजनिक गरेको छ। प्रतिवेदनमा १० बुँदे सुझाव दिइएको छ।',
  },
  {
    't': 'अन्तर्राष्ट्रिय सम्मेलनमा नेपालको ## प्रस्तुति',
    's':
        '## सम्बन्धी अन्तर्राष्ट्रिय सम्मेलनमा नेपालले आफ्नो धारणा प्रस्तुत गरेको छ। सम्मेलनमा ५० भन्दा बढी राष्ट्र सहभागी थिए।',
  },
  {
    't': '## ले जित्यो अन्तर्राष्ट्रिय पुरस्कार',
    's':
        'नेपालको ## ले प्रतिष्ठित अन्तर्राष्ट्रिय पुरस्कार जितेको छ। यो नेपालको लागि गौरवको विषय भएको छ।',
  },
  {
    't': 'नयाँ ## केन्द्रको उद्घाटन',
    's':
        'प्रधानमन्त्रीले ## केन्द्रको उद्घाटन गरेका छन्। यो केन्द्रले ५०० लाई रोजगारी प्रदान गर्ने अपेक्षा गरिएको छ।',
  },
  {
    't': '## निर्यातमा २०% वृद्धि',
    's':
        'चालु आर्थिक वर्षमा ## को निर्यातमा २० प्रतिशत वृद्धि भएको छ। व्यवसायीहरूले यसलाई सकारात्मक संकेत मानेका छन्।',
  },
];

final topics = [
  'शिक्षा',
  'स्वास्थ्य',
  'कृषि',
  'पर्यटन',
  'ऊर्जा',
  'यातायात',
  'प्रविधि',
  'वातावरण',
  'खेलकुद',
  'संस्कृति',
  'उद्योग',
  'वाणिज्य',
  'सञ्चार',
  'जलविद्युत',
  'भूकम्प पुनर्निर्माण',
  'स्वच्छ पानी',
  'दूरसञ्चार',
  'डिजिटल भुक्तानी',
  'स्टार्टअप',
  'वन संरक्षण',
];

final tags = [
  ['policy', 'government', 'reform'],
  ['economy', 'trade', 'development'],
  ['technology', 'digital', 'innovation'],
  ['sports', 'cricket', 'football', 'volleyball'],
  ['international', 'diplomacy', 'UN', 'SAARC'],
  ['Nepal', 'infrastructure', 'development'],
  ['education', 'health', 'agriculture'],
  ['energy', 'hydropower', 'renewable'],
  ['tourism', 'culture', 'heritage'],
  ['environment', 'climate', 'conservation'],
];

final englishTopics = [
  'Education',
  'Healthcare',
  'Agriculture',
  'Tourism',
  'Energy',
  'Transport',
  'Technology',
  'Environment',
  'Sports',
  'Culture',
  'Industry',
  'Commerce',
  'Communication',
  'Hydropower',
  'Reconstruction',
  'Clean Water',
  'Telecom',
  'Digital Payment',
  'Startup',
  'Forest Conservation',
];

String fill(String template, String topic) => template.replaceAll('##', topic);

void main() {
  final entries = <Map<String, dynamic>>[];

  // Preserve original hand-crafted entries
  final originalJson = File(
    'assets/content/current_affairs.json',
  ).readAsStringSync();
  final originalData = jsonDecode(originalJson) as Map<String, dynamic>;
  final originals = (originalData['entries'] as List)
      .take(5)
      .map((e) => Map<String, dynamic>.from(e as Map))
      .toList();

  entries.addAll(originals);

  for (int i = 6; i <= 1500; i++) {
    final cat = categories[rng.nextInt(categories.length)];
    final template = templatesNp[rng.nextInt(templatesNp.length)];
    final topicIdx = rng.nextInt(topics.length);
    final topic = topics[topicIdx];
    final enTopic = englishTopics[topicIdx];

    // Spread dates across last 90 days, weighted toward recent
    final daysAgo = rng.nextInt(90);
    // Weight: 40% chance of last 7 days, 30% chance of 7-30 days, 30% chance of 30-90 days
    final weightedDays = rng.nextDouble() < 0.4
        ? rng.nextInt(7)
        : rng.nextDouble() < 0.6
        ? 7 + rng.nextInt(23)
        : 30 + rng.nextInt(60);

    final date = DateTime(2026, 6, 12).subtract(Duration(days: weightedDays));
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final titleNp = fill(template['t']!, topic);

    // Generate English title from the Nepali one (simplified)
    final titleEnBase = template['t']!.replaceAll('##', enTopic);
    final titleEn = _nepToEng(titleEnBase);

    final summaryNp = fill(template['s']!, topic);
    final summaryEnBase = template['s']!.replaceAll('##', enTopic);
    final summaryEn = _nepToEng(summaryEnBase);

    // Pick 2-3 random tags
    final tagPool = tags[rng.nextInt(tags.length)];
    final entryTags = tagPool.sublist(
      0,
      min(2 + rng.nextInt(2), tagPool.length),
    );

    entries.add({
      'id': i.toString(),
      'title_np': titleNp,
      'title_en': titleEn,
      'summary_np': summaryNp,
      'summary_en': summaryEn,
      'category': cat['np'],
      'category_en': cat['en'],
      'date': dateStr,
      'source': sources[rng.nextInt(sources.length)],
      'tags': [...entryTags, cat['en']!.toLowerCase()],
    });
  }

  // Sort by date descending
  entries.sort((a, b) => (b['date'] as String).compareTo(a['date'] as String));

  final output = {
    'entries': entries,
    'last_updated': '2026-06-12',
    'version': 2,
  };

  final file = File('assets/content/current_affairs.json');
  file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(output));

  print('Generated ${entries.length} entries.');
  print('Date range: ${entries.last['date']} to ${entries.first['date']}');
  // Approximate file size
  final bytes = file.lengthSync();
  print('File size: ${(bytes / 1024).toStringAsFixed(0)} KB');
}

String _nepToEng(String nepali) {
  // Simple mapping for generating English variants
  return nepali
      .replaceAll('सरकारले', 'Government')
      .replaceAll('नयाँ', 'new')
      .replaceAll('नीति', 'policy')
      .replaceAll('सार्वजनिक', 'announced')
      .replaceAll('गर्याे', '')
      .replaceAll('मा', 'in')
      .replaceAll('ऐतिहासिक', 'historic')
      .replaceAll('सफलता', 'achievement')
      .replaceAll('हात', 'recorded')
      .replaceAll('सम्झौतामा', 'agreement')
      .replaceAll('हस्ताक्षर', 'signed')
      .replaceAll('ले', 'achieves')
      .replaceAll('नयाँ', 'new')
      .replaceAll('कीर्तिमान', 'milestone')
      .replaceAll('बनायो', '')
      .replaceAll('परियोजना', 'project')
      .replaceAll('स्वीकृत', 'approved')
      .replaceAll('लगानी', 'investment of')
      .replaceAll('अर्ब', 'billion')
      .replaceAll('सुधारको', 'reform')
      .replaceAll('आवश्यकता', 'needed')
      .replaceAll('प्रतिवेदन', 'report')
      .replaceAll('अन्तर्राष्ट्रिय', 'international')
      .replaceAll('सम्मेलनमा', 'conference')
      .replaceAll('प्रस्तुति', 'presentation')
      .replaceAll('जित्यो', 'wins')
      .replaceAll('पुरस्कार', 'award')
      .replaceAll('केन्द्रको', 'center')
      .replaceAll('उद्घाटन', 'inaugurated')
      .replaceAll('निर्यातमा', 'export')
      .replaceAll('वृद्धि', 'growth')
      .replaceAll('२०%', '20%')
      .trim();
}
