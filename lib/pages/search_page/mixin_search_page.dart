part of 'search_page_view.dart';

enum _Filter {
  plate(LocaleKeys.plate),
  customerID(LocaleKeys.phone),
  idNo(LocaleKeys.idNo),
  taxNo(LocaleKeys.taxNo),
  name(LocaleKeys.name),
  surname(LocaleKeys.lastName),
  fullName(LocaleKeys.nameSurname),
  chassisNo(LocaleKeys.chassisNo),
  engineNo(LocaleKeys.engineNo);

  final String label;

  const _Filter(this.label);
}

mixin _MixinSearchPage<T extends StatefulWidget> on State<T> {
  final tECSearch = TextEditingController();
  String searchText = "";
  final isTexting = ValueNotifier(false);

  _Filter selectedFilter = _Filter.values.first;

  @override
  void dispose() {
    tECSearch.dispose();
    super.dispose();
  }

  void onSearchText(String? t) {
    searchText = t ?? "";
    if (t == "") {
      isTexting.value = false;
    } else if (!isTexting.value) {
      isTexting.value = true;
    }
  }

  void clearSearch() {
    tECSearch.clear();
    onSearchText("");
  }

  void onFilterChange(_Filter? filter) {
    setState(() {
      selectedFilter = filter ?? _Filter.values.first;
    });
  }
}
