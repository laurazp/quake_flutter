/// Mirrors Quake/Entities/FAQItem.swift — question/answer content is kept
/// identical to the original app's English strings.
class FaqItem {
  final String question;
  final String answer;

  const FaqItem({required this.question, required this.answer});
}

abstract class FaqData {
  static const List<FaqItem> items = [
    FaqItem(
      question: 'Why are there earthquakes with negative magnitudes?',
      answer:
          "A negative magnitude means an earthquake that is not felt by humans because it's smaller than those originally chosen for zero magnitude in the Richter scale. That's possible because modern seismographs can detect smaller seismic waves than before.",
    ),
    FaqItem(
      question: "What's the depth of an earthquake?",
      answer:
          "It's the distance from the ground at which the earthquake occurred. If we have a depth of 0km or a negative depth, it's because the earthquake was too shallow and it's so difficult to determine its exact depth (it's possible to have an error of 1-2km when determining the actual depth of an earthquake).",
    ),
    FaqItem(
      question: 'Can earthquakes be predicted?',
      answer:
          'No, it is currently not possible to accurately predict when, where, and with what magnitude an earthquake will occur. Science can identify risk zones, but not make exact predictions.',
    ),
    FaqItem(
      question: 'What is an aftershock?',
      answer:
          "It's a smaller earthquake that follows the main one in the same area. There may be many aftershocks, and some may be felt quite strongly.",
    ),
    FaqItem(
      question:
          'Why are some earthquakes more destructive even if they are not as strong?',
      answer:
          'Factors such as the depth of the earthquake, proximity to populated areas, soil type, and the quality of buildings influence the level of damage beyond magnitude.',
    ),
    FaqItem(
      question: 'Why are there so many earthquakes in certain regions of the world?',
      answer:
          'Because they are close to tectonic plate boundaries, such as the Pacific Ring of Fire, where there is more seismic activity.',
    ),
    FaqItem(
      question: 'How reliable is the data displayed by the app?',
      answer:
          'Data comes from official sources such as the USGS, EMSC, or other reliable seismological centers, but may change slightly as information is updated.',
    ),
  ];
}
