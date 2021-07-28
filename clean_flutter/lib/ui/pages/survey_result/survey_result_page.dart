import 'package:clean_flutter/ui/mixins/mixins.dart';
import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';
import 'components/components.dart';

class SurveyResultPage extends StatelessWidget with SessionManager {
  final SurveyResultPresenter presenter;

  SurveyResultPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(R.strings.surveys)),
      body: Builder(
        builder: (context) {
          presenter.loadData();

          handleSessionExpired(presenter.isSessionExpiredStream);

          return StreamBuilder<SurveyResultViewModel>(
              stream: presenter.surveyResultStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ReloadScreen(
                    error: snapshot.error.toString(),
                    reload: presenter.loadData,
                  );
                } else if (snapshot.hasData) {
                  return SurveyResult(snapshot.data!);
                }

                return Center(child: CircularProgressIndicator());
              });
        },
      ),
    );
  }
}
