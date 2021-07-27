import 'package:flutter/material.dart';

import '../../pages.dart';
import 'components.dart';

class SurveyAnswer extends StatelessWidget {
  final SurveyAnswerViewModel viewModel;

  const SurveyAnswer(
    this.viewModel,
  );

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildItems() {
      final List<Widget> children = [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              viewModel.answer,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        Text(
          viewModel.percent,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        viewModel.isCurrentAnswer ? ActiveIcon() : DisableIcon(),
      ];

      if (viewModel.image?.isNotEmpty ?? false) {
        children.insert(
            0,
            Image.network(
              viewModel.image!,
              width: 40,
            ));
      }

      return children;
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          padding: EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildItems(),
          ),
        ),
        Divider(height: 1)
      ],
    );
  }
}
