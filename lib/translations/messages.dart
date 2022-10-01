import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'search': 'Search',
          'no-result': 'Oops! No results',
          'watch': 'Watch',
          'to-bookmark': 'Add to bookmark',
        },
        'ua_UA': {
          'search': 'Пошук',
          'no-result': 'Ой! Немає результатів',
          'watch': 'Дивитись',
          'to-bookmark': 'Додати до закладок',
        }
      };
}
