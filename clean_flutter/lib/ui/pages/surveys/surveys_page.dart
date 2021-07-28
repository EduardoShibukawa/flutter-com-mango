import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';
import 'components/components.dart';

class SurveysPage extends StatelessWidget {
  final SurveysPresenter presenter;

  SurveysPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          R.strings.surveys,
        ),
      ),
      body: Builder(
        builder: (context) {
          presenter.loadData();

          presenter.navigateToStream.listen((page) {
            if (page.isNotEmpty) {
              Get.toNamed(page);
            }
          });

          return StreamBuilder<List<SurveyViewModel>>(
            stream: presenter.surveysStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error!.toString(),
                  reload: presenter.loadData,
                );
              } else if (snapshot.hasData) {
                return Provider(
                  create: (_) => presenter,
                  child: SurveyItems(snapshot.data!),
                );
              }

              return Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
