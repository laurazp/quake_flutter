import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants.dart';
import '../../../core/design/dimens.dart';
import '../../../data/models/message_type.dart';
import '../../../widgets/feedback_card.dart';
import '../settings_view_model.dart';

/// Mirrors Quake/Features/Settings/Elements/FeedbackView.swift.
///
/// MFMailComposeViewController has no direct Flutter equivalent, so
/// sending is done two ways: with no attachment a prefilled `mailto:` link
/// opens straight into the device's mail app (closest match to the
/// original); with a screenshot attached the native share sheet is used
/// instead, since `mailto:` cannot carry file attachments.
class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  final SettingsViewModel _viewModel = SettingsViewModel();
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onChanged);
    _viewModel.loadAppInfo();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onChanged);
    _viewModel.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await _imagePicker.pickImage(source: source, imageQuality: 80);
    if (image != null) {
      _viewModel.setSelectedImage(image);
    }
  }

  Future<void> _showAttachmentOptions() async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_rounded),
              title: const Text('Open camera'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close_rounded),
              title: const Text('Cancel'),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  String _composeBody() {
    return '${_messageController.text}\n\n'
        '-----------------------\n\n'
        'App Name: ${_viewModel.appName}\n'
        'App Version: ${_viewModel.appVersion}\n'
        'App Build: ${_viewModel.appBuild}\n'
        'Device OS: ${_viewModel.deviceModel}\n'
        'OS Version: ${_viewModel.deviceSystemVersion}';
  }

  Future<void> _sendFeedback() async {
    _viewModel.setMessageText(_messageController.text);
    final image = _viewModel.selectedImage;
    final body = _composeBody();
    final subject = _viewModel.selectedType.label;

    if (image != null) {
      await Share.shareXFiles([XFile(image.path)], text: '$subject\n\n$body');
      return;
    }

    final uri = Uri(
      scheme: 'mailto',
      path: AppConstants.feedbackRecipient,
      query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );

    final launched = await launchUrl(uri);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot send mail from this device.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send Feedback')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimens.semiLargeMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FeedbackCard(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text('Topic', style: TextStyle(fontSize: 16)),
                    ),
                    PopupMenuButton<MessageType>(
                      onSelected: _viewModel.setSelectedType,
                      itemBuilder: (context) => [
                        for (final type in MessageType.values)
                          PopupMenuItem(value: type, child: Text(type.label)),
                      ],
                      child: Chip(
                        label: Text(_viewModel.selectedType.label),
                        avatar: const Icon(Icons.expand_more_rounded, size: 18),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                TextField(
                  controller: _messageController,
                  minLines: 3,
                  maxLines: 6,
                  decoration: const InputDecoration(hintText: 'Write your message here…'),
                ),
              ],
            ),
            FeedbackCard(
              children: [
                InkWell(
                  onTap: _showAttachmentOptions,
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text('Select attachment', style: TextStyle(fontSize: 16)),
                      ),
                      if (_viewModel.selectedImage != null)
                        Padding(
                          padding: const EdgeInsets.only(right: Dimens.smallMargin),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.file(
                              File(_viewModel.selectedImage!.path),
                              width: 32,
                              height: 32,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      Icon(AppConstants.chevronRightIcon, size: 18),
                    ],
                  ),
                ),
              ],
            ),
            FeedbackCard(
              children: [
                _InfoRow(label: 'Platform', value: _viewModel.deviceModel),
                const SizedBox(height: Dimens.smallMargin),
                _InfoRow(label: 'OS Version', value: _viewModel.deviceSystemVersion),
              ],
            ),
            FeedbackCard(
              children: [
                _InfoRow(label: 'Name', value: _viewModel.appName),
                const SizedBox(height: Dimens.smallMargin),
                _InfoRow(label: 'Version', value: _viewModel.appVersion),
                const SizedBox(height: Dimens.smallMargin),
                _InfoRow(label: 'Build', value: _viewModel.appBuild),
              ],
            ),
            const SizedBox(height: Dimens.smallMargin),
            ElevatedButton(
              onPressed: _sendFeedback,
              child: const Text('Send Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
        Text(value, style: TextStyle(color: Theme.of(context).colorScheme.outline)),
      ],
    );
  }
}
