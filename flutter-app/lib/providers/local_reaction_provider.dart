import 'package:flutter/material.dart';
import 'package:gentle/models/local_reaction_model.dart';

class LocalReactionProvider extends ChangeNotifier {
  final List<LocalReactionModel> _localReactions = [];
  List<LocalReactionModel> get localReactions => _localReactions;

  void addLocalReaction(LocalReactionModel reaction) {
    if (_localReactions.contains(reaction)) {
      debugPrint(
          'Attempted to add an already existing local reaction: $reaction');
      return;
    }

    _localReactions.add(reaction);
    notifyListeners();
  }
}
