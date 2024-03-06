// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran_app/common/constants/constant.dart';
import 'package:quran_app/common/services/preferences.dart';
import 'package:quran_app/common/widgets/app_loading.dart';
import 'package:quran_app/common/widgets/base_page.dart';
import 'package:quran_app/common/widgets/custom_app_bar.dart';
import 'package:quran_app/l10n/l10n.dart';
import 'package:quran_app/modules/home/widgets/input_box.dart';
import 'package:quran_app/modules/surah_list/models/surah.dart';
import 'package:quran_app/modules/surah_list/widgets/surah_list_data.dart';

class SurahListPage extends StatefulWidget {
  const SurahListPage({super.key});

  @override
  State<SurahListPage> createState() => _SurahListPageState();
}

class _SurahListPageState extends State<SurahListPage> with WidgetsBindingObserver {
  List<Surah> _dataSurah = [];
  List<Surah> _surah = [];

  Future<void> readJson() async {
    final surahResponse = await rootBundle.loadString('$sourcesAsset/surahs.json');
    final surahData = surahFromJson(surahResponse);
    setState(() {
      _dataSurah = surahData;
      _surah = surahData;
    });
  }

  void _onSearch(String key) {
    final keyword = key.toLowerCase().replaceAll(RegExp("[^0-9a-zA-Z']"), '');
    if (keyword == '') {
      setState(() {
        _surah = _dataSurah;
      });
    } else {
      setState(() {
        _surah = _dataSurah
            .where(
              (element) => element.nameTransliteration
                  .toLowerCase()
                  .replaceAll(
                    RegExp("[^0-9a-zA-Z']"),
                    '',
                  )
                  .contains(keyword),
            )
            .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    readJson();
  }

  void goToSurah({int? noSurah, bool? startScroll}) {
    // Navigator.push<MaterialPageRoute<dynamic>>(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => SurahPage(
    //       noSurah: noSurah!,
    //       dataQuran: _dataSurah,
    //       startScroll: startScroll,
    //     ),
    //   ),
    // );
  }

  MaterialBanner _showMaterialBanner(BuildContext context) {
    return MaterialBanner(
      content: Text(
        context.l10n.lastReadError,
        style: smallText,
      ),
      backgroundColor: backgroundColor2,
      actions: [
        OutlinedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
            goToSurah(noSurah: 0, startScroll: false);
          },
          child: Text(
            context.l10n.alFatiha,
            style: smallText.copyWith(color: backgroundColor2),
          ),
        ),
        OutlinedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
          child: Text(
            context.l10n.close,
            style: smallText.copyWith(color: backgroundColor2),
          ),
        ),
      ],
    );
  }

  Future<void> navigateToLastRead() async {
    final preferences = await Preferences.getInstance();
    final numberSurah = preferences.getLastSurahRead();
    if (numberSurah == 0) {
      ScaffoldMessenger.of(context)
        ..removeCurrentMaterialBanner()
        ..showMaterialBanner(_showMaterialBanner(context));
    } else {
      goToSurah(noSurah: numberSurah - 1, startScroll: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BasePage(
        appBar: CustomAppBar(
          onBackTapped: () {
            ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
            Navigator.of(context).pop();
          },
          height: MediaQuery.of(context).size.height / 5.5,
          title: l10n.surahListPageAppBarTitle,
          content: InputBox(
            labelText: l10n.findSurah,
            onChanged: _onSearch,
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: backgroundColor2,
          onPressed: navigateToLastRead,
          icon: SvgPicture.asset(
            '$iconAsset/last_read.svg',
            width: 30,
          ),
          label: Text(
            l10n.lastRead,
            style: smallText,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_dataSurah.isNotEmpty)
              SurahListData(
                surah: _surah,
              )
            else
              const AppLoading(),
          ],
        ),
      ),
    );
  }
}
