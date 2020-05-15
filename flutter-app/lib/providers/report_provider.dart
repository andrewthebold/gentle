import 'package:flutter/material.dart';
import 'package:gentle/components/BottomSheet/error_bottomsheet.dart';
import 'package:gentle/effects.dart';
import 'package:gentle/exceptions.dart';
import 'package:gentle/models/report_model.dart';
import 'package:gentle/models/user_model.dart';
import 'package:gentle/theme.dart';

class ReportProvider extends ChangeNotifier {
  ReportBottomsheetStatus _status = ReportBottomsheetStatus.selecting;
  ReportBottomsheetStatus get status => _status;

  ReportOption _selectedOption;
  ReportOption get selectedOption => _selectedOption;
  ReportOption _lastSelectedOption;
  ReportOption get lastSelectedOption => _lastSelectedOption;

  final String _contentToReportID;
  final String _contentToReportCreatorID;
  final ContentType _contentToReportType;
  final String _contentToReportExcerpt;
  UserModel _user;

  bool get selectedOptionIsDestructive =>
      _selectedOption == ReportOption.block ||
      (_selectedOption == null && _lastSelectedOption == ReportOption.block);

  bool get selectable => _status == ReportBottomsheetStatus.selecting;

  bool get submitButtonVisible =>
      _selectedOption != null && _status == ReportBottomsheetStatus.selecting;
  bool get loadingIndicatorVisible =>
      _selectedOption != null && _status == ReportBottomsheetStatus.sending;

  void select(ReportOption option) {
    _lastSelectedOption = _selectedOption;
    _selectedOption = option;
    notifyListeners();
  }

  ReportProvider({
    @required String contentToReportID,
    @required String contentToReportCreatorID,
    @required ContentType contentToReportType,
    @required String contentToReportExcerpt,
  })  : _contentToReportID = contentToReportID,
        _contentToReportCreatorID = contentToReportCreatorID,
        _contentToReportType = contentToReportType,
        _contentToReportExcerpt = contentToReportExcerpt;

  Future<void> handleUserUpdate({@required UserModel user}) async {
    if (user == _user) {
      return;
    }

    _user = user;
  }

  Future<void> submitReport({
    @required BuildContext context,
  }) async {
    if (_selectedOption == null ||
        _status != ReportBottomsheetStatus.selecting) {
      return;
    }

    _status = ReportBottomsheetStatus.sending;
    notifyListeners();

    try {
      if (_user == null) {
        throw const ReportInvalidDataException(
            message: 'Attempted to submit report with null user');
      }

      if (_selectedOption == ReportOption.block) {
        await UserModel.dangerousBlockUser(
            user: _user, userIDToBlock: _contentToReportCreatorID);
      } else {
        await ReportModel.dangerousCommitReport(
          contentToReportID: _contentToReportID,
          contentToReportCreatorID: _contentToReportCreatorID,
          contentToReportType: _contentToReportType,
          reportOption: _selectedOption,
          contentToReportExcerpt: _contentToReportExcerpt,
          user: _user,
        );
      }
    } on Exception catch (exception, stackTrace) {
      await ErrorBottomSheet.reportAndShow(context,
          ReportCreateException(capturedException: exception), stackTrace);

      _status = ReportBottomsheetStatus.selecting;
      notifyListeners();
      return;
    }

    await Effects.playHapticSuccess();

    _status = ReportBottomsheetStatus.success;
    notifyListeners();
  }
}

enum ReportBottomsheetStatus { selecting, sending, success }

enum ReportOption {
  spam,
  abuse,
  concern,
  pii,
  other,

  // block is a [ReportOption] for the convenience of showing it in the report modal.
  block,
}

class ReportItem {
  final String label;
  final ReportOption option;
  final List<ReportSubItem> subitems;
  final bool isDestructive;

  final String successTitle;
  final List<ReportSubItem> successSubItems;

  const ReportItem({
    @required this.label,
    @required this.option,
    @required this.subitems,
    this.isDestructive = false,
    @required this.successTitle,
    @required this.successSubItems,
  });
}

class ReportSubItem {
  final String text;
  final AssetImage icon;
  final Color color;

  const ReportSubItem({
    @required this.text,
    @required this.icon,
    this.color = Palette.blue,
  });
}
