// ignore_for_file: use_build_context_synchronously

import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tamirci/core/extensions/ext_string.dart';
import 'package:tamirci/core/h_hive.dart';
import 'package:tamirci/core/local_values.dart';
import 'package:tamirci/locale_keys.dart';
import 'package:tamirci/pages/image_page/image_page_view.dart';
import 'package:tamirci/router.dart';

import '../service_page/service_page_view.dart';

class ScannerPageView extends StatefulWidget {
  const ScannerPageView({super.key, this.servicePage});

  final ServicePages? servicePage;

  @override
  State<ScannerPageView> createState() => _ScannerPageViewState();
}

class _ScannerPageViewState extends State<ScannerPageView> {
  InputImage? inputImage;
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  final List<String> _lines = [];
  final List<String> _blocks = [];

  bool _showGroup = false;
  String? path;

  @override
  void initState() {
    super.initState();
    context.afterBuild((p0) => _afterBuild());
  }

  @override
  void dispose() {
    textRecognizer.close();
    super.dispose();
  }

  Future<void> _afterBuild() async {
    String? oldPath = HHive.getSettings(HiveSettings.lastScanPath);

    _pickImage(oldPath);
  }

  Future<void> _pickImage([String? pathOld]) async {
    path = pathOld;

    if (pathOld.isEmptyOrNull) {
      final cameraResult = await CustomDialog.showDialogRadioList(
            context,
            items: [
              LocaleKeys.camera,
              LocaleKeys.gallery,
            ],
          ) ??
          0;

      final r = await ImagePicker().pickImage(
          source: cameraResult == 0 ? ImageSource.camera : ImageSource.gallery);
      path = r?.path;
    }

    if (path.isEmptyOrNull) return;

    _blocks.clear();
    _lines.clear();

    HHive.putSettings(HiveSettings.lastScanPath, path);

    inputImage = InputImage.fromFilePath(path!);

    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage!);

    for (TextBlock block in recognizedText.blocks) {
      _blocks.add(block.text.trim());
      for (TextLine line in block.lines) {
        _lines.add(line.text.trim());
      }
    }

    setState(() {});
  }

  void _copy(String t) {
    t.copy();

    CustomSnackbar.showSnackBar(context: context, text: LocaleKeys.copied);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (path.isNotEmptyAndNull) {
            context.push(PagePaths.image, extra: MImagePage(path: path));
          }
        },
        label: const Text(LocaleKeys.seeImage),
        icon: const Icon(Icons.image),
      ),
      appBar: _appBar(),
      body: _body(),
    );
  }

  Widget _body() {
    List<String> list = _showGroup ? _blocks : _lines;
    return Padding(
      padding: LocalValues.paddingPage(context),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SwitchListTile.adaptive(
              title: const Text(LocaleKeys.lineGroup),
              secondary: const Icon(Icons.line_weight_outlined),
              value: _showGroup,
              onChanged: (value) {
                setState(() {
                  _showGroup = value;
                });
              },
            ),
            SizedBox(
              width: double.maxFinite,
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Text(
                        list[index],
                        style: context.textTheme.titleMedium,
                      ).expanded,
                      IconButton(
                        onPressed: () => _copy(list[index]),
                        icon: const Icon(Icons.copy),
                      )
                    ],
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: list.length,
                shrinkWrap: true,
              ),
            ),
            context.sizedBox(height: Values.paddingHeightMedium),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(LocaleKeys.textScanner),
      actions: [
        IconButton(onPressed: _pickImage, icon: const Icon(Icons.refresh)),
      ],
    );
  }
}
