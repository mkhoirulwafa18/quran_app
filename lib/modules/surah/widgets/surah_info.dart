import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran_app/common/constants/constant.dart';
import 'package:quran_app/common/widgets/app_loading.dart';
import 'package:quran_app/modules/surah/cubit/murattal_cubit.dart';
import 'package:quran_app/modules/surah_list/widgets/rub_el_hizb.dart';

class SurahInfo extends StatefulWidget {
  const SurahInfo({
    super.key,
    required this.numberSurah,
    required this.title,
    required this.translation,
    required this.revelation,
    required this.totalAyat,
  });

  final int numberSurah;
  final String title;
  final String translation;
  final String revelation;
  final int totalAyat;

  @override
  State<SurahInfo> createState() => _SurahInfoState();
}

class _SurahInfoState extends State<SurahInfo> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    context.read<MurattalCubit>().init(
          context,
          widget.numberSurah,
          widget.totalAyat,
        );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (val) {
        context.read<MurattalCubit>().dispose();
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: backgroundColor2,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 40,
                  ),
                  RubElHizb(
                    number: widget.numberSurah.toString(),
                    color: backgroundColor,
                  ),
                  BlocBuilder<MurattalCubit, MurattalState>(
                    builder: (context, state) {
                      if (state is MurattalPlaying) {
                        return GestureDetector(
                          onTap: () {
                            context.read<MurattalCubit>().pause(context);
                          },
                          child: Icon(
                            Icons.stop_circle,
                            color: backgroundColor,
                            size: 40,
                          ),
                        );
                      }
                      if (state is MurattalLoaded || state is MurattalPaused) {
                        return GestureDetector(
                          onTap: () {
                            context.read<MurattalCubit>().play(context);
                          },
                          child: Icon(
                            Icons.play_circle,
                            color: backgroundColor,
                            size: 40,
                          ),
                        );
                      } else {
                        return const AppLoading();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                widget.title,
                style: mediumText,
              ),
              Text(
                widget.translation,
                style: TextStyle(
                  color: backgroundColor.withOpacity(0.5),
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                '${widget.revelation} - ${widget.totalAyat} ayat',
                style: smallText,
              ),
              if (widget.numberSurah != 1) ...[
                const SizedBox(
                  height: 16,
                ),
                SvgPicture.asset(
                  '$iconAsset/basmalah.svg',
                  width: 0.4.sw,
                  color: backgroundColor,
                ),
              ] else
                const SizedBox(),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
