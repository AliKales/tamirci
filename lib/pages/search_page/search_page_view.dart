import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:tamirci/core/local_values.dart';
import 'package:tamirci/locale_keys.dart';
import 'package:tamirci/widgets/buttons.dart';
import 'package:tamirci/widgets/c_text_field.dart';

part 'mixin_search_page.dart';

class SearchPageView extends StatefulWidget {
  const SearchPageView({super.key});

  @override
  State<SearchPageView> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<SearchPageView> with _MixinSearchPage {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  Padding _body() {
    return Padding(
      padding: LocalValues.paddingPage(context),
      child: Column(
        children: [
          _searchWidget(),
          ...List.generate(
            _Filter.values.length,
            (index) => RadioListTile<_Filter>(
              value: _Filter.values[index],
              groupValue: selectedFilter,
              onChanged: onFilterChange,
              title: Text(_Filter.values[index].label),
            ),
          ),
          context.sizedBox(height: Values.paddingHeightSmallX),
          Buttons(context, LocaleKeys.search, () {}).filled(),
        ],
      ),
    );
  }

  ValueListenableBuilder<bool> _searchWidget() {
    return ValueListenableBuilder(
      valueListenable: isTexting,
      builder: (context, val, _) {
        return CTextField(
          filled: true,
          isHighRadius: true,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: val ? _closeIcon() : null,
          onChanged: onSearchText,
          controller: tECSearch,
        );
      },
    );
  }

  Widget _closeIcon() {
    return IconButton(
      onPressed: clearSearch,
      icon: const Icon(Icons.close),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(LocaleKeys.search),
    );
  }
}
