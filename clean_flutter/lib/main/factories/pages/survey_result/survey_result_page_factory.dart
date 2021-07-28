import 'package:get/get.dart';

import '../../../../ui/pages/pages.dart';
import '../pages.dart';

SurveyResultPage makeSurveyResultPage() {
  return SurveyResultPage(
      makeGetxSurveyResultPresenter(Get.parameters['survey_id']!));
}
