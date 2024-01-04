part of 'stats_page_view.dart';

class _StatsView extends StatefulWidget {
  const _StatsView({super.key, required this.stat});

  final MStat stat;

  @override
  State<_StatsView> createState() => __StatsViewState();
}

class __StatsViewState extends State<_StatsView> {
  MStat get _stat => widget.stat;

  static final _months = [
    "Ocak",
    "Şubat",
    "Mart",
    "Nisan",
    "Mayıs",
    "Haziran",
    "Temmuz",
    "Ağustos",
    "Eylül",
    "Ekim",
    "Kasım",
    "Aralık"
  ];

  static final List<MapEntry<String, Color>> _allColors = [
    const MapEntry("bej", Color(0xFFF5F5DC)),
    const MapEntry("beyaz", Color.fromARGB(255, 214, 214, 214)),
    const MapEntry("bordo", Color(0xFF800000)),
    const MapEntry("füme", Color(0xFF757a80)),
    const MapEntry("gri", Colors.grey),
    const MapEntry("gümüş gri", Color(0xFFC0C0C0)),
    const MapEntry("kahverengi", Colors.brown),
    const MapEntry("kırmızı", Colors.red),
    const MapEntry("lacivert", Color(0xFF000080)),
    const MapEntry("mavi", Colors.blue),
    const MapEntry("mor", Colors.purple),
    const MapEntry("pembe", Colors.pink),
    const MapEntry("sarı", Colors.yellow),
    const MapEntry("siyah", Colors.black),
    const MapEntry("şampanya", Color(0xFFebc8b2)),
    const MapEntry("turkuaz", Color(0xFF30D5C8)),
    const MapEntry("turuncu", Colors.orange),
    const MapEntry("yeşil", Colors.green),
  ];

  @override
  void initState() {
    super.initState();
  }

  String get _date {
    int? month = _stat.month;
    if (month == null) "";

    return "${_months[month! - 1]} ${_stat.year}";
  }

  List<MapEntry<String, double>> get _getVehicleStat {
    Map<String, int> makes = _stat.vehicleMakes ?? {};

    var list =
        makes.keys.map((e) => MapEntry(e, makes[e]?.toDouble() ?? 0)).toList();

    list.removeWhere((element) => element.key == "null");

    list.sort((a, b) => b.value.compareTo(a.value));

    list = list.sublistSafe(0, 6);

    list.shuffle();

    return list;
  }

  List<MapEntry<String, double>> get _getVehicleYears {
    final years = _stat.vehicleYears ?? {};
    var list =
        years.keys.map((e) => MapEntry(e, years[e]?.toDouble() ?? 0)).toList();
    list.removeWhere((element) => element.key == "null");
    list.sort(
      (a, b) => b.key.toInt.compareTo(a.key.toInt),
    );

    return list;
  }

  List<PieItem> get _colorItems {
    final colors = widget.stat.colors ?? {};

    return colors.keys
        .map((e) => PieItem(
              title: colors[e].toString(),
              value: colors[e]?.toDouble() ?? 0,
              color: _allColors
                      .firstWhereOrNull((element) => element.key == e)
                      ?.value ??
                  Color.fromARGB(0, 0, 0, 0),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_date, style: context.textTheme.headlineMedium!.toBold),
          const Divider(),
          _text("Toplam müşteri sayısı:", _stat.customersLength.toString()),
          _text("Yeni müşteri sayısı:", _stat.newCustomers.toString()),
          _padding(),
          _text("Toplam araç sayısı:", _stat.vehiclesLength.toString()),
          _text("Yeni araç sayısı:", _stat.newVehicles.toString()),
          _padding(),
          _text("Toplam servis sayısı:", _stat.servicesLength.toString()),
          const Divider(),
          _padding(),
          Text("Araç Marka İstatistiği", style: context.textTheme.titleMedium),
          CBarChart(
            width: 0.85.toDynamicWidth(context),
            height: 0.85.toDynamicWidth(context),
            datas: _getVehicleStat,
          ),
          _padding(),
          Text("Araç Renk İstatistiği", style: context.textTheme.titleMedium),
          CPieChart(
            items: _colorItems,
            width: 0.85.toDynamicWidth(context),
            height: 0.85.toDynamicWidth(context),
          ),
          _padding(),
          Text("Araç Model (Yıl) İstatistiği",
              style: context.textTheme.titleMedium),
          CLineChart(datas: _getVehicleYears),
        ],
      ),
    );
  }

  Widget _padding() {
    return context.sizedBox(height: Values.paddingHeightSmallX);
  }

  Widget _text(String text, String value) {
    return Row(
      children: [
        Text(text, style: context.textTheme.titleLarge).expanded,
        Text(value, style: context.textTheme.titleLarge),
      ],
    );
  }
}
