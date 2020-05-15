import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gentle/exceptions.dart';
import 'package:gentle/models/user_model.dart';
import 'package:gentle/providers/report_provider.dart';

enum ReportStatus {
  unsolved,
  solved,
}

enum ContentType {
  request,
  letter,
}

class ReportModel {
  // NOTE: We don't use this model on the client right now, so there's no logic
  // to create or define one.

  /// Commits a report to the server and hides the related content for the user.
  static Future<void> dangerousCommitReport({
    @required String contentToReportID,
    @required String contentToReportCreatorID,
    @required ContentType contentToReportType,
    @required ReportOption reportOption,
    @required String contentToReportExcerpt,
    @required UserModel user,
  }) async {
    if (contentToReportID == null) {
      throw const ReportInvalidDataException(
          message: 'Null contentToReportID provided for report');
    }
    if (contentToReportCreatorID == null) {
      throw const ReportInvalidDataException(
          message: 'Null contentToReportCreatorID provided for report');
    }
    if (contentToReportType == null) {
      throw const ReportInvalidDataException(
          message: 'Null contentToReportType provided for report');
    }
    if (reportOption == null) {
      throw const ReportInvalidDataException(
          message: 'Null reportOption provided for report');
    }
    if (reportOption == ReportOption.block) {
      throw const ReportInvalidDataException(
          message: 'Attempted to commit a report with a "block" option');
    }
    if (contentToReportExcerpt == null) {
      throw const ReportInvalidDataException(
          message: 'Null contentToReportExcerpt provided for report');
    }
    if (user == null) {
      throw const ReportInvalidDataException(
          message: 'Null user provided for report');
    }

    final db = Firestore.instance;
    final batch = db.batch();

    // Hide the content on report
    UserModel.dangerousAddHideContentWriteToBatch(
      batch: batch,
      user: user,
      contentToHideCreatorID: contentToReportCreatorID,
      contentIDToHide: contentToReportID,
      contentType: contentToReportType,
    );

    final reportDoc = db.collection('reports').document();
    batch.setData(reportDoc, <String, dynamic>{
      'id': reportDoc.documentID,
      'creationDate': FieldValue.serverTimestamp(),
      'status': EnumToString.parse(ReportStatus.unsolved),
      'contentID': contentToReportID,
      'contentCreatorID': contentToReportCreatorID,
      'contentType': EnumToString.parse(contentToReportType),
      'contentExcerpt': contentToReportExcerpt,
      'reportOption': EnumToString.parse(reportOption),
      'reporterID': user.id,
    });

    await batch.commit();
  }
}
