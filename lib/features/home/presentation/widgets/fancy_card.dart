import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/recharge/presentation/bloc/recharge_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FancyCard extends StatefulWidget {
  final String title;
  final String? subtitle;

  const FancyCard({super.key, required this.title, required this.subtitle});

  @override
  State<FancyCard> createState() => _FancyCardState();
}

class _FancyCardState extends State<FancyCard> {
  bool hideBalance = true;

  void onToggleBalance() {
    setState(() => hideBalance = !hideBalance);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CustomPaint(
        painter: FancyBackgroundPainter(),
        child: Container(
          width: 327,
          height: 220,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   widget.title,
              //   style: Theme.of(
              //     context,
              //   ).textTheme.titleLarge?.copyWith(color: Colors.white),
              // ),
              // if (widget.subtitle != '') ...[
              //   const SizedBox(height: 8),
              //   Text(
              //     widget.subtitle ?? '',
              //     style: Theme.of(
              //       context,
              //     ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
              //   ),
              // ],
              // const SizedBox(height: 8),
              BlocBuilder<RechargeBloc, RechargeState>(
                builder: (context, state) {
                  if (state is GetWalletInfoSuccessState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ---- Header: Đã kết nối + Icon Dividex ----
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppThemes.successColor,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                intl.conected,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),

                            Row(
                              children: [
                                // App icon
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                        "lib/assets/images/Logo.png",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.phoneNumber,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(color: Colors.white),
                                ),
                                const SizedBox(height: 4),
                                // ---- Full name ----
                                Text(
                                  state.fullName,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      intl.balance,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(color: Colors.white),
                                    ),
                                    const SizedBox(width: 6),
                                    GestureDetector(
                                      onTap: onToggleBalance,
                                      child: Icon(
                                        hideBalance
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                // ---- Balance ----
                                Text(
                                  hideBalance ? "••••••••" : state.balance,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // ---- Footer icons ----
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.list, color: Colors.white),
                                const SizedBox(width: 4),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.totalTransactions.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall?.copyWith(color: Colors.white),
                                    ),
                                    Text(
                                      intl.transaction,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.latestTime,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall?.copyWith(color: Colors.white),
                                    ),
                                    Text(
                                      intl.lastTransaction,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  return Container(
                    color: Colors.transparent,
                    child: SpinKitFadingCircle(color: AppThemes.borderColor),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FancyBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = AppThemes.primary1Color;
    final paint2 = Paint()..color = AppThemes.primary3Color;
    final paint3 = Paint()..color = AppThemes.primary5Color;

    // nền chính
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint2);

    // nửa hình tròn to bên trái
    canvas.drawCircle(Offset(0, size.height), size.height * 0.8, paint1);

    // hình tròn nhỏ bên phải
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      size.height * 0.4,
      paint3,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
