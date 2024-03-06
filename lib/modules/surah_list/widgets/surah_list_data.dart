import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran_app/common/constants/constant.dart';
import 'package:quran_app/l10n/l10n.dart';
import 'package:quran_app/modules/surah_list/models/surah.dart';
import 'package:quran_app/modules/surah_list/widgets/rub_el_hizb.dart';

class SurahListData extends StatelessWidget {
  const SurahListData({
    super.key,
    required List<Surah> surah,
  }) : _surah = surah;

  final List<Surah> _surah;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Expanded(
      child: ColoredBox(
        color: backgroundColor,
        child: _surah.isNotEmpty
            ? ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: _surah.length,
                separatorBuilder: (_, i) => Divider(
                  color: backgroundColor2,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return _buildItem(index, context);
                },
              )
            : Expanded(
                child: Center(
                  child: Text(
                    l10n.errorNoSurahFound,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: backgroundColor2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
      ),
    );
  }

  ListTile _buildItem(int index, BuildContext context) {
    return ListTile(
      leading: RubElHizb(
        number: _surah[index].number.toString(),
      ),
      title: Text(
        _surah[index].nameTransliteration,
        style: mediumText.copyWith(
          color: Colors.black,
        ),
      ),
      subtitle: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: _surah[index].nameTranslation,
                    style: smallText.copyWith(
                      color: backgroundColor2.withOpacity(0.7),
                    ),
                  ),
                  const WidgetSpan(
                    child: SizedBox(
                      width: 5,
                    ),
                  ),
                  if (_surah[index].revelation == 'Makkiyyah')
                    WidgetSpan(
                      child: SvgPicture.asset(
                        '$iconAsset/mecca.svg',
                        width: 12,
                        color: backgroundColor2,
                      ),
                    )
                  else
                    WidgetSpan(
                      child: SvgPicture.asset(
                        '$iconAsset/medina.svg',
                        width: 16,
                        color: backgroundColor2,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      dense: true,
      trailing: Text(
        _surah[index].nameShort,
        style: arabicText,
      ),
      onTap: () {
        log(_surah[index].nameTransliteration);
        // Navigator.push<MaterialPageRoute<dynamic>>(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => SurahPage(
        //       noSurah: _surah[index].numberOfSurah! - 1,
        //       dataQuran: dataQuran,
        //     ),
        //   ),
        // );
      },
    );
  }
}
