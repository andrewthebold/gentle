import 'package:gentle/components/avatar.dart';
import 'package:flutter/widgets.dart';
import 'package:gentle/models/inbox_item_model.dart';

class EnvelopeSenderName extends StatelessWidget {
  final InboxItemModel item;

  const EnvelopeSenderName({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Avatar(
      avatarName: item.linkedContentAvatar,
    );
  }
}
