import 'package:flutter/material.dart';
import 'package:gentle/components/BottomSheet/tip_bottomsheet.dart';

enum TipType {
  quote,
  stem,
}

class TipModel {
  final TipType type;
  String quote;
  String attribution;

  String stem;

  TipModel.quote({
    this.type = TipType.quote,
    @required this.quote,
    @required this.attribution,
  });

  TipModel.stem({
    this.type = TipType.stem,
    @required this.stem,
  });
}

class TipStackProvider extends ChangeNotifier {
  static List<TipModel> requestTips = [
    TipModel.stem(
      stem: 'Something amazing just happened! It was',
    ),
    TipModel.stem(
      stem: 'I\'ve been feeling low lately because',
    ),
    TipModel.stem(
      stem: 'I\'m having a tough time because',
    ),
    TipModel.stem(
      stem: 'Hello! How is',
    ),
    TipModel.stem(
      stem: 'I\'m scared that',
    ),
    TipModel.stem(
      stem: 'Today, I',
    ),
    TipModel.stem(
      stem: 'Do you ever',
    ),
    TipModel.stem(
      stem: 'How do I',
    ),
    TipModel.stem(
      stem: 'I\'ve been feeling great lately because',
    ),
    TipModel.stem(
      stem: 'Can you recommend a',
    ),
    TipModel.stem(
      stem: 'Anybody have any advice for',
    ),
    TipModel.stem(
      stem: 'I\'m worried about',
    ),
    TipModel.stem(
      stem: 'If anybody needs a good',
    ),
    TipModel.stem(
      stem: 'I\'m about to',
    ),
    TipModel.stem(
      stem: 'I just started',
    ),
    TipModel.stem(
      stem: 'I hope everyone',
    ),
    TipModel.stem(
      stem: 'Do you ever',
    ),
    TipModel.stem(
      stem: 'Have a recommendation for',
    ),
    TipModel.stem(
      stem: 'I want some kindness about',
    ),
    TipModel.stem(
      stem: 'A positive thing that happened today was',
    ),
    TipModel.stem(
      stem: 'I was really happy that',
    ),
    TipModel.stem(
      stem: 'My favorite',
    ),
    TipModel.stem(
      stem: 'I was really happy that',
    ),
    TipModel.stem(
      stem: 'I decided that',
    ),
    TipModel.stem(
      stem: 'I learned how to',
    ),
    TipModel.stem(
      stem: 'The most important thing is',
    ),
    TipModel.stem(
      stem: 'I learned that',
    ),
    TipModel.stem(
      stem: 'I realized that',
    ),
    TipModel.stem(
      stem: 'I was really happy that',
    ),
    TipModel.stem(
      stem: 'I like',
    ),
    TipModel.stem(
      stem: 'My friend is',
    ),
    TipModel.stem(
      stem: 'My family is',
    ),
    TipModel.stem(
      stem: 'My job is',
    ),
    TipModel.stem(
      stem: 'I love when',
    ),
    TipModel.stem(
      stem: 'In the future',
    ),
    TipModel.stem(
      stem: 'Something I\'m hoping for is',
    ),
    TipModel.stem(
      stem: 'It\'s my right to',
    ),
    TipModel.stem(
      stem: 'I believe that',
    ),
    TipModel.stem(
      stem: 'Sometimes, it helps to',
    ),
    TipModel.stem(
      stem: 'I fear that',
    ),
    TipModel.stem(
      stem: 'One day, I want to',
    ),
    TipModel.stem(
      stem: 'I\'m going to make',
    ),
    TipModel.stem(
      stem: 'I have a plan to',
    ),
    TipModel.stem(
      stem: 'My new year\'s resolution is',
    ),
    TipModel.stem(
      stem: 'Would you like to',
    ),
    TipModel.stem(
      stem: 'My dream is to',
    ),
    TipModel.stem(
      stem: 'I want to invent',
    ),
    TipModel.stem(
      stem: 'What is your favorite',
    ),
    TipModel.stem(
      stem: 'Yesterday, I',
    ),
    TipModel.stem(
      stem: 'Could you please write me a',
    ),
    TipModel.stem(
      stem: 'The thing I love about',
    ),
    TipModel.stem(
      stem: 'What would you say if',
    ),
    TipModel.stem(
      stem: 'If you were me,',
    ),
    TipModel.stem(
      stem: 'Do you',
    ),
    TipModel.stem(
      stem: 'If you could make a',
    ),
    TipModel.stem(
      stem: 'What would it be like if',
    ),
    TipModel.stem(
      stem: 'Do you think it\'s fair that',
    ),
    TipModel.stem(
      stem: 'Something important to me is',
    ),
    TipModel.stem(
      stem: 'Where do you go when',
    ),
  ];

  static List<TipModel> letterWriteTips = [
    // Quotes
    TipModel.quote(
      quote: 'Everyone has the right to life, liberty and security of person.',
      attribution: 'Universal Declaration of Human Rights',
    ),
    TipModel.quote(
      quote: 'All human beings are born free and equal in dignity and rights.',
      attribution: 'Universal Declaration of Human Rights',
    ),
    TipModel.quote(
      quote:
          'Sometimes it takes only one act of kindness and caring to change a person’s life',
      attribution: 'Jackie Chan',
    ),
    TipModel.quote(
      quote: 'You can accomplish by kindness what you cannot by force.',
      attribution: 'Pubilius Syrus',
    ),
    TipModel.quote(
      quote:
          'You have power over your mind - not outside events. Realize this, and you will find strength',
      attribution: 'Marcus Aurelius',
    ),
    TipModel.quote(
      quote: 'We can’t help everyone, but everyone can help someone.',
      attribution: 'Ronald Reagan',
    ),
    TipModel.quote(
      quote:
          'No one is useless in this world who lightens the burdens of another.',
      attribution: 'Charles Dickens',
    ),
    TipModel.quote(
      quote: 'Help from a stranger is better than sympathy from a relative',
      attribution: 'Matshona Dhliwayo',
    ),
    TipModel.quote(
      quote:
          'How wonderful it is that nobody need wait a single moment before starting to improve the world',
      attribution: 'Anne Frank',
    ),
    TipModel.quote(
      quote:
          'Get up, stand up, Stand up for your rights. Get up, stand up, Don\'t give up the fight',
      attribution: 'Bob Marley',
    ),
    TipModel.quote(
      quote: 'One has a moral responsibility to disobey unjust laws',
      attribution: 'Martin Luther King Jr.',
    ),
    TipModel.quote(
      quote:
          'Love is our true destiny. We do not find the meaning of life by ourselves alone - we find it with another.',
      attribution: 'Thomas Merton',
    ),
    TipModel.quote(
      quote: 'Silence is of different kinds, and breathes different meanings.',
      attribution: 'Charlotte Brontë',
    ),
    TipModel.quote(
      quote:
          'Every single human soul has more meaning and value than the whole of history.',
      attribution: 'Nikolai Berdyaev',
    ),
    TipModel.quote(
      quote: 'It all meant something. Until it didn\'t.',
      attribution: 'Dave Eggers',
    ),
    TipModel.quote(
      quote:
          'The Internet is the Petri dish of humanity. We can\'t control what grows in it, but we don\'t have to watch either.',
      attribution: 'Tiffany Madison',
    ),
    TipModel.quote(
      quote:
          'The truth is, everyone is going to hurt you. You just got to find the ones worth suffering for.',
      attribution: 'Bob Marley',
    ),
    TipModel.quote(
      quote:
          'No person is your friend who demands your silence, or denies your right to grow.',
      attribution: 'Alice Walker',
    ),
    TipModel.quote(
      quote: 'Do I not destroy my enemies when I make them my friends?',
      attribution: 'Abraham Lincoln',
    ),
    // Stems
    TipModel.stem(
      stem: 'I\'m really happy that',
    ),
    TipModel.stem(
      stem: 'Hey there! Thank you for',
    ),
    TipModel.stem(
      stem: 'I hope you\'re',
    ),
    TipModel.stem(
      stem: 'It\'s really great to hear that',
    ),
    TipModel.stem(
      stem: 'I want you to know that',
    ),
    TipModel.stem(
      stem: 'Hugs. I\'m wishing you',
    ),
    TipModel.stem(
      stem: 'Whenever I',
    ),
    TipModel.stem(
      stem: 'I\'ve felt that way before when',
    ),
    TipModel.stem(
      stem: 'I\'m excited that',
    ),
    TipModel.stem(
      stem: 'I\'m so sorry that',
    ),
    TipModel.stem(
      stem: 'If I could',
    ),
    TipModel.stem(
      stem: 'Sometimes, it\'s',
    ),
    TipModel.stem(
      stem: 'I recommend',
    ),
    TipModel.stem(
      stem: 'I care about you because',
    ),
    TipModel.stem(
      stem: 'I like that you',
    ),
    TipModel.stem(
      stem: 'I\'m a big fan of',
    ),
    TipModel.stem(
      stem: 'I understand what you\'re saying because',
    ),
    TipModel.stem(
      stem: 'Wishing that you',
    ),
    TipModel.stem(
      stem: 'Something important to me is',
    ),
    TipModel.stem(
      stem: 'You are a valuable person because',
    ),
    TipModel.stem(
      stem: 'This inspires me because',
    ),
    TipModel.stem(
      stem: 'I know that feeling because',
    ),
    TipModel.stem(
      stem: 'Same. I feel like',
    ),
    TipModel.stem(
      stem: 'I believe in you because',
    ),
    TipModel.stem(
      stem: 'I share your concern that',
    ),
    TipModel.stem(
      stem: 'I\'m hearing that',
    ),
    TipModel.stem(
      stem: 'It sounds like you\'re',
    ),
    TipModel.stem(
      stem: 'It\'s really interesting that',
    ),
    TipModel.stem(
      stem: 'This will pass. I know because',
    ),
    TipModel.stem(
      stem: 'Love yourself. I believe that',
    ),
    TipModel.stem(
      stem: 'Take your time and',
    ),
    TipModel.stem(
      stem: 'Hey, it\'s alright. I hope you\'re',
    ),
  ];

  List<TipModel> _tips = [];
  List<TipModel> get tips => _tips;

  int _cursor = 0;
  int get cursor => _cursor;

  TipStackProvider({
    @required TipBottomSheetType type,
  }) {
    if (type == TipBottomSheetType.request) {
      _tips = TipStackProvider.requestTips.sublist(0);
    } else if (type == TipBottomSheetType.letter) {
      _tips = TipStackProvider.letterWriteTips.sublist(0);
    }
    _tips.shuffle();
  }

  void popTip() {
    _cursor += 1;

    if (_cursor > _tips.length - 1) {
      _cursor = 0;
    }

    notifyListeners();
  }
}
