import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/dimens.dart';
import 'widgets/app_info_view.dart';
import 'widgets/faq_view.dart';
import 'widgets/feedback_view.dart';
import 'widgets/location_services_view.dart';
import 'widgets/units_view.dart';

/// Mirrors Quake/Features/Settings/SettingsView.swift.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: Dimens.smallMargin),
        children: [
          _SectionHeader('Configuration'),
          _SettingsRow(
            title: 'Units',
            icon: AppConstants.unitsSettingsIcon,
            color: AppColors.mint,
            builder: (_) => const UnitsView(),
          ),
          _SettingsRow(
            title: 'Location Services',
            icon: AppConstants.locationSettingsIcon,
            color: AppColors.orange,
            builder: (_) => const LocationServicesView(),
          ),
          const SizedBox(height: Dimens.largeMargin),
          _SectionHeader('General'),
          _SettingsRow(
            title: 'App Info',
            icon: AppConstants.infoSettingsIcon,
            color: AppColors.red,
            builder: (_) => const AppInfoView(),
          ),
          _SettingsRow(
            title: 'FAQ',
            icon: AppConstants.faqSettingsIcon,
            color: AppColors.blue,
            builder: (_) => const FAQView(),
          ),
          _SettingsRow(
            title: 'Feedback',
            icon: AppConstants.feedbackSettingsIcon,
            color: AppColors.green,
            builder: (_) => const FeedbackView(),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimens.semiLargeMargin,
        Dimens.smallMargin,
        Dimens.semiLargeMargin,
        Dimens.smallMargin,
      ),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final WidgetBuilder builder;

  const _SettingsRow({
    required this.title,
    required this.icon,
    required this.color,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: builder)),
      minVerticalPadding: Dimens.mediumMargin,
      leading: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withOpacity(Dimens.imageOpacity),
          borderRadius: BorderRadius.circular(Dimens.mediumMargin),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title),
      trailing: Icon(AppConstants.chevronRightIcon, color: Theme.of(context).colorScheme.outline),
    );
  }
}
