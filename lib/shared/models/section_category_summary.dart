import 'category_summary.dart';
import 'section.dart';

class SectionCategorySummary {
  final Map<Section, double> sectionMap;
  final List<CategorySummary> categorySummaryList;

  const SectionCategorySummary(
      {required this.sectionMap, required this.categorySummaryList});
}
