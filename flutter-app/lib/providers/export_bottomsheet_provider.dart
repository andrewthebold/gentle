import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:gentle/models/letter_model.dart';
import 'package:gentle/models/request_item_model.dart';
import 'package:gentle/providers/user_provider.dart';
import 'package:path_provider/path_provider.dart';

class ExportBottomsheetProvider extends ChangeNotifier {
  UserProvider _userProvider;

  bool _loading = false;
  bool get loading => _loading;
  String _requestCSVData;
  String _lettersSentCSVData;
  String _lettersReceivedCSVData;
  bool get dataFetched =>
      _requestCSVData != null &&
      _lettersSentCSVData != null &&
      _lettersReceivedCSVData != null;

  void handleUserProviderUpdate({
    @required UserProvider userProvider,
  }) {
    if (_userProvider != userProvider) {
      _userProvider = userProvider;
      notifyListeners();
    }
  }

  Future<void> fetchData() async {
    _loading = true;
    notifyListeners();

    try {
      final db = Firestore.instance;
      final requestDocs = await db
          .collection('requests')
          .where('requesterID', isEqualTo: _userProvider.user.id)
          .orderBy('creationDate')
          .getDocuments();

      final lettersSentDocs = await db
          .collection('letters')
          .where('letterSenderID', isEqualTo: _userProvider.user.id)
          .orderBy('creationDate')
          .getDocuments();

      final lettersReceivedDocs = await db
          .collection('letters')
          .where('recipientID', isEqualTo: _userProvider.user.id)
          .where('published', isEqualTo: true)
          .getDocuments();

      final requests = requestDocs.documents
          .map((doc) => RequestItemModel.fromFirestore(doc));
      final lettersSent = lettersSentDocs.documents
          .map((doc) => LetterModel.fromFirestore(doc));
      final lettersReceived = lettersReceivedDocs.documents
          .map((doc) => LetterModel.fromFirestore(doc));

      final List<List<String>> formattedRequests = [];
      for (final request in requests) {
        formattedRequests.add(<String>[
          'request',
          request.creationDate.toString(),
          request.requestMessage,
          EnumToString.parse(request.requesterAvatar),
        ]);
      }
      _requestCSVData = const ListToCsvConverter().convert(formattedRequests);

      final List<List<String>> formattedLettersSent = [];
      for (final letter in lettersSent) {
        formattedLettersSent.add(<String>[
          'letterSent',
          letter.creationDate.toString(),
          'Request: ${letter.requestMessage}',
          'Requester Avatar: ${EnumToString.parse(letter.requestCreatorAvatar)}',
          'Your Message: ${letter.letterMessage}',
          'Your Avatar: ${EnumToString.parse(letter.letterSenderAvatar)}',
          'Reaction: ${EnumToString.parse(letter.reactionType)}',
        ]);
      }
      _lettersSentCSVData =
          const ListToCsvConverter().convert(formattedLettersSent);

      final List<List<String>> formattedLettersReceived = [];
      for (final letter in lettersReceived) {
        formattedLettersReceived.add(<String>[
          'letterReceived',
          letter.creationDate.toString(),
          'Your Request: ${letter.requestMessage}',
          'Your Avatar: ${EnumToString.parse(letter.requestCreatorAvatar)}',
          'Sender Message: ${letter.letterMessage}',
          'Sender Avatar: ${EnumToString.parse(letter.letterSenderAvatar)}',
          'Reaction: ${EnumToString.parse(letter.reactionType)}',
        ]);
      }
      _lettersReceivedCSVData =
          const ListToCsvConverter().convert(formattedLettersReceived);

      _loading = false;
      notifyListeners();
    } on Exception catch (_) {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> sendMail() async {
    final dir = await getTemporaryDirectory();
    final fileRequests = File('${dir.path}/requests.csv');
    await fileRequests.writeAsString(_requestCSVData);
    final fileLettersSent = File('${dir.path}/lettersSent.csv');
    await fileLettersSent.writeAsString(_lettersSentCSVData);
    final fileLettersReceived = File('${dir.path}/lettersReceived.csv');
    await fileLettersReceived.writeAsString(_lettersReceivedCSVData);

    final MailOptions mailOptions = MailOptions(
      subject: 'My Gentle Data',
      attachments: [
        fileRequests.path,
        fileLettersSent.path,
        fileLettersReceived.path
      ],
    );

    await FlutterMailer.send(mailOptions);
  }

  Future<void> copyToClipboard() async {
    await Clipboard.setData(ClipboardData(
      text:
          '$_requestCSVData\r\n$_lettersSentCSVData\r\n$_lettersReceivedCSVData',
    ));
  }
}
