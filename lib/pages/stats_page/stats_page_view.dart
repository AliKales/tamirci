// ignore_for_file: use_build_context_synchronously

import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tamirci/core/firebase/f_auth.dart';
import 'package:tamirci/core/firebase/f_firestore.dart';
import 'package:tamirci/core/local_values.dart';
import 'package:tamirci/core/models/m_stat.dart';
import 'package:tamirci/locale_keys.dart';
import 'package:tamirci/widgets/buttons.dart';
import 'package:tamirci/widgets/c_dropdown_menu.dart';
import 'package:tamirci/widgets/charts/bar_chart.dart';
import 'package:tamirci/widgets/charts/line_chart.dart';
import 'package:tamirci/widgets/charts/pie_chart.dart';

part 'stats_view.dart';

class StatsPageView extends StatefulWidget {
  const StatsPageView({super.key});

  @override
  State<StatsPageView> createState() => _StatsPageViewState();
}

class _StatsPageViewState extends State<StatsPageView> {
  static final List<int> _years = [2023, 2024];
  static final List<int> _months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  MStat? _stat;

  int? _selectedMonth;
  int? _selectedYear;

  Future<void> _continue() async {
    if (_selectedMonth == null || _selectedYear == null) {
      CustomSnackbar.showSnackBar(context: context, text: LocaleKeys.fillAll);
      return;
    }

    CustomProgressIndicator.showProgressIndicator(context);

    final r = await FFirestore.get(FirestoreCol.shops,
        doc: FAuth.uid,
        subs: [
          FirestoreSub(
              col: FirestoreCol.stats, doc: "$_selectedMonth-$_selectedYear"),
        ]);

    context.pop();

    if (r.hasError) {
      CustomSnackbar.showSnackBar(context: context, text: "Error");
      return;
    }

    if (r.response == null || !r.response!.exists) {
      CustomSnackbar.showSnackBar(context: context, text: LocaleKeys.noResult);
      return;
    }

    setState(() {
      _stat = MStat.fromJson(r.response!.data()!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: LocalValues.paddingPage(context),
        child: _stat == null ? _startView() : _StatsView(stat: _stat!),
      ),
    );
  }

  Column _startView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          LocaleKeys.chooseMonthYear,
          style: context.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CDropdownMenu(
              labels: _months.map((e) => e.toString()).toList(),
              label: LocaleKeys.month,
              width: 0.35.toDynamicWidth(context),
              setSearchIcon: false,
              enableFilter: false,
              requestFocusOnTap: false,
              onChanged: (value) {
                if (value == null) return;
                _selectedMonth = _months[value];
              },
            ),
            CDropdownMenu(
              labels: _years.map((e) => e.toString()).toList(),
              label: LocaleKeys.year,
              width: 0.35.toDynamicWidth(context),
              setSearchIcon: false,
              enableFilter: false,
              requestFocusOnTap: false,
              onChanged: (value) {
                if (value == null) return;
                _selectedYear = _years[value];
              },
            ),
          ],
        ),
        Buttons(context, LocaleKeys.continuee, _continue).filled(),
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(LocaleKeys.stats),
    );
  }
}
