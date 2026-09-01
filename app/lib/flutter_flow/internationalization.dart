import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) => Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['ru', 'en'];

  static late SharedPreferences _prefs;
  static Future initialize() async => _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) => _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString()) ? '${locale.toString()}_short' : null;
  int get languageIndex => languages().contains(languageCode) ? languages().indexOf(languageCode) : 0;

  String getText(String key) => (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? ruText = '',
    String? enText = '',
  }) =>
      [ruText, enText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    final language = locale.toString();
    return FFLocalizations.languages().contains(
      language.endsWith('_') ? language.substring(0, language.length - 1) : language,
    );
  }

  @override
  Future<FFLocalizations> load(Locale locale) => SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // HomePage
  {
    'g0zc5ir2': {
      'ru': 'Добро пожаловать,',
      'en': 'Welcome,',
    },
    'nfw5wib1': {
      'ru': 'Создать заказ',
      'en': 'Create Order',
    },
    'tm3yt4d1': {
      'ru': 'Активные заказы',
      'en': 'Active Orders',
    },
    'yuw1fhx3': {
      'ru': 'У вас нет активных заказов',
      'en': 'You have no active orders',
    },
    '47nv3ok6': {
      'ru': 'Ваши отклики',
      'en': 'Your Responses',
    },
    'ltc9tcv1': {
      'ru': 'Вы пока не откликались на заказы',
      'en': 'You have not responded to any orders yet',
    },
    '7slhpf6k': {
      'ru': 'Главная',
      'en': 'Home',
    },
    'y00uz4ol': {
      'ru': 'Добро пожаловать в DTD!',
      'en': 'Welcome to DTD!',
    },
    'mxsrvl8u': {
      'ru': 'Здесь мы расскажем подробнее про приложение',
      'en': 'Here we will tell you more about the application',
    },
    'u0tzs8bb': {
      'ru': 'Создавайте и получайте заказы',
      'en': 'Create and receive orders',
    },
    '9ey1ujn0': {
      'ru': 'Регистрируйте профиль дилера или перевозчика',
      'en': 'Register your dealer or carrier profile',
    },
    'aebhtzbu': {
      'ru': 'Общайтесь в удобном чате',
      'en': 'Communicate in a convenient chat',
    },
    'vmnndbdo': {
      'ru': 'Отправляйте сообщения, получайте необходимые фотографии и документы прямо в приложении',
      'en': 'Send messages, receive necessary photos and documents directly in the application',
    },
    'mwgqvah2': {
      'ru': 'Начните сейчас!',
      'en': 'Start now!',
    },
    '7ozce3ue': {
      'ru': 'Выберите регистрацию или просмотрите доступные вам заказы',
      'en': 'Select registration or view orders available to you',
    },
    'w5ir0wbu': {
      'ru': 'Home',
      'en': 'Home',
    },
    '7sr314uu': {
      'ru': 'DTD',
      'en': 'DTD',
    },
    '6p87yxyc': {
      'ru': 'Home',
      'en': 'Home',
    },
    's1vx6lal': {
      'ru': 'Пропустить',
      'en': 'Skip',
    },
    'k4bnarhu': {
      'ru': 'Войти',
      'en': 'Sign In',
    },
    'ula38v6o': {
      'ru': 'Пропустить',
      'en': 'Skip',
    },
    'c5rm27c4': {
      'ru': 'Email',
      'en': 'Email',
    },
    '5nltyrrq': {
      'ru': 'Пароль',
      'en': 'Password',
    },
    'euk9u5dv': {
      'ru': 'Введите адрес электронной почты',
      'en': 'Enter your email address',
    },
    'rfntuu0v': {
      'ru': 'Email не валидный',
      'en': 'Email is not valid',
    },
    '5swt7rcd': {
      'ru': 'Please choose an option from the dropdown',
      'en': 'Please choose an option from the dropdown',
    },
    'rvxmeg42': {
      'ru': 'Введите пароль',
      'en': 'Enter password',
    },
    'oojy0aqx': {
      'ru': 'Минимум 6 символов',
      'en': 'Minimum 6 characters',
    },
    '768a0mzo': {
      'ru': 'Please choose an option from the dropdown',
      'en': 'Please choose an option from the dropdown',
    },
    '6if0p3b3': {
      'ru': 'Забыли пароль?',
      'en': 'Forgot your password?',
    },
    'acasd5zo': {
      'ru': 'Войти',
      'en': 'Sign In',
    },
    'gwkcsbwq': {
      'ru': 'Или',
      'en': 'Or',
    },
    'fwqegc5m': {
      'ru': 'Продолжить через Google',
      'en': 'Continue via Google',
    },
    'xzb9yht0': {
      'ru': 'Продолжить через Facebook',
      'en': 'Continue via Facebook',
    },
    '4ar63fsz': {
      'ru': 'Продолжить через Apple',
      'en': 'Continue with Apple',
    },
    '2pnbw4yp': {
      'ru': 'Нет аккаунта?',
      'en': 'Don\'t have an account?',
    },
    '58ug9af8': {
      'ru': ' Регистрация',
      'en': 'Sign Up',
    },
    'bx4uahlr': {
      'ru': 'Home',
      'en': 'Home',
    },
    'bvkakg87': {
      'ru': 'Введите свой email',
      'en': 'Enter your email',
    },
    'fkobj0sq': {
      'ru': 'Email',
      'en': 'Email',
    },
    'h1rshxli': {
      'ru': 'Введите адрес электронной почты',
      'en': 'Enter your email address',
    },
    'nvvbgdc9': {
      'ru': 'Email не валидный',
      'en': 'Email is not valid',
    },
    '3dh5sx06': {
      'ru': 'Please choose an option from the dropdown',
      'en': 'Please choose an option from the dropdown',
    },
    'mcymnvvk': {
      'ru': 'Отправить код',
      'en': 'Send Code',
    },
    'sd8pdcpt': {
      'ru': 'Нет аккаунта?',
      'en': 'Don\'t have an account?',
    },
    'e8hx0elz': {
      'ru': ' Регистрация',
      'en': 'Sign Up',
    },
    'rij2vyvj': {
      'ru': 'Забыли пароль?',
      'en': 'Forgot your password?',
    },
    'ctlltv27': {
      'ru': 'Home',
      'en': 'Home',
    },
    'vb8uky6n': {
      'ru': 'Email',
      'en': 'Email',
    },
    '6x8abrdd': {
      'ru': 'Пароль',
      'en': 'Password',
    },
    'fwlzolsq': {
      'ru': 'Повторите пароль',
      'en': 'Repeat Password',
    },
    'f37ivz6n': {
      'ru': 'Введите адрес электронной почты',
      'en': 'Enter your email address',
    },
    'tnk7xi8x': {
      'ru': 'Email не валидный',
      'en': 'Email is not valid',
    },
    'czek7wi9': {
      'ru': 'Please choose an option from the dropdown',
      'en': 'Please choose an option from the dropdown',
    },
    '71vwd9ex': {
      'ru': 'Введите пароль',
      'en': 'Enter password',
    },
    '0v37py3i': {
      'ru': 'Минимум 6 символов',
      'en': 'Minimum 6 characters',
    },
    'rk0pk31m': {
      'ru': 'Please choose an option from the dropdown',
      'en': 'Please choose an option from the dropdown',
    },
    'x7h1239x': {
      'ru': 'Повторите пароль',
      'en': 'Repeat Password',
    },
    'n2dou5rz': {
      'ru': 'Минимум 6 символов',
      'en': 'Minimum 6 characters',
    },
    'vt79meg0': {
      'ru': 'Please choose an option from the dropdown',
      'en': 'Please choose an option from the dropdown',
    },
    'u986eymn': {
      'ru': 'Продолжить',
      'en': 'Continue',
    },
    'd93hani8': {
      'ru': 'При регистрации вы соглашаетесь с нашими',
      'en': 'By registering you agree to our',
    },
    'tizdmcvn': {
      'ru': ' Условиями использования',
      'en': 'Terms of Use',
    },
    '7ihu5e7a': {
      'ru': ' и ',
      'en': ' and ',
    },
    'vzph52vy': {
      'ru': 'Политикой Конфиденциальности.',
      'en': 'Privacy Policy.',
    },
    "k1nml7hh": {"ru": "Или", "en": "Or"},
    "wix6a4uf": {"ru": "Регистрация через Google", "en": "Sign up with Google"},
    "mivwzm78": {"ru": "Регистрация через Facebook", "en": "Sign up with Facebook"},
    "9z6rld50": {"ru": "Регистрация через Apple", "en": "Sign up with Apple"},
    "c1x4ewgw": {"ru": "Уже есть аккаунт?", "en": "Already have an account?"},
    "sjhscejd": {"ru": " Войти", "en": "Log in"},
    "g71km0qh": {"ru": "Создайте аккаунт", "en": "Create an account"},
    "fdj52sgv": {"ru": "Home", "en": "Home"},
    "jpn4xs95": {"ru": "50%", "en": "50%"},
    "1izef6bt": {"ru": "Добавить фото", "en": "Add Photo"},
    "qi6vhve8": {"ru": "Ваше имя", "en": "Your Name"},
    "kktyb8cp": {"ru": "Контактный номер телефона", "en": "Contact Phone Number"},
    "01b2flz5": {"ru": "+7", "en": "+7"},
    "9q86ynt7": {"ru": "Введите имя", "en": "Enter Name"},
    "ins31qgv": {"ru": "Минимум 6 символов", "en": "At least 6 characters"},
    "5tzyqgca": {"ru": "Email не валидный", "en": "Invalid Email"},
    "k7wzzs1t": {"ru": "Please choose an option from the dropdown", "en": "Please choose an option from the dropdown"},
    "yl8ft85x": {"ru": "Введите номер телефона", "en": "Enter Phone Number"},
    "5wvyt6zt": {"ru": "Номер не валидный", "en": "Invalid Number"},
    "7q8bn0sn": {"ru": "Please choose an option from the dropdown", "en": "Please choose an option from the dropdown"},
    "ztj4xibk": {"ru": "Далее", "en": "Next"},
    "fzqfnyss": {"ru": "Пропустить", "en": "Skip"},
    "f154sbeo": {"ru": "Заполните профиль", "en": "Complete Profile"},
    "yrrvkflg": {"ru": "Home", "en": "Home"},
    "9c9k73vh": {"ru": "Далее", "en": "Next"},
    "z5e6j9hx": {"ru": "Пропустить", "en": "Skip"},
    "chqzzntl": {"ru": "Заполните профиль", "en": "Complete Profile"},
    "xub5nezs": {"ru": "Home", "en": "Home"},
    "kephjo9u": {
      "ru": "Для идентификации необходимо заполнить ваши данные",
      "en": "To verify your identity, please fill in your details"
    },
    "ha47uvje": {"ru": "Название компании", "en": "Company Name"},
    "3xf4ad0w": {"ru": "Номер перевозчика", "en": "Carrier Number"},
    "oh1l6hxg": {"ru": "Номер водительских прав", "en": "Driver's License Number"},
    "irgp8ktm": {"ru": "Водительские права", "en": "Driver's License"},
    "0wge1f35": {"ru": "Файл загружен", "en": "File Uploaded"},
    "c782yqr5": {"ru": "Введите название компании", "en": "Enter Company Name"},
    "893c4qb6": {"ru": "Минимум 3 символа", "en": "At least 3 characters"},
    "c80pvg7r": {"ru": "Email не валидный", "en": "Invalid Email"},
    "rr4yq034": {"ru": "Please choose an option from the dropdown", "en": "Please choose an option from the dropdown"},
    "u2zbq5gt": {"ru": "Введите номер перевозчика", "en": "Enter Carrier Number"},
    "xjrxm5vo": {"ru": "Минимум 3 символа", "en": "At least 3 characters"},
    "ppow481k": {"ru": "Please choose an option from the dropdown", "en": "Please choose an option from the dropdown"},
    "l60f1e35": {"ru": "Введите номер водительских прав", "en": "Enter Driver's License Number"},
    "zqr7knos": {"ru": "Минимум 3 символа", "en": "At least 3 characters"},
    "0tv3yh4i": {"ru": "Please choose an option from the dropdown", "en": "Please choose an option from the dropdown"},
    "4033ooas": {"ru": "Завершить регистрацию", "en": "Complete Registration"},
    "bigi7ln2": {"ru": "Введите данные", "en": "Enter Details"},
    "33s2hlnk": {"ru": "Home", "en": "Home"},
  },

  // fill_profile_diller
  {
    "2433wuac": {
      "ru": "Для идентификации необходимо заполнить ваши данные",
      "en": "To verify your identity, please fill in your details"
    },
    "ckjpp31m": {"ru": "Номер дилерской лицензии", "en": "Dealer License Number"},
    "2omgqltf": {"ru": "Номер прав", "en": "License Number"},
    "58k4nuc8": {"ru": "Дата выдачи", "en": "Issue Date"},
    "e32actky": {"ru": "ДД/ММ/ГГ", "en": "DD/MM/YY"},
    "365ocsfw": {"ru": "Водительские права", "en": "Driver's License"},
    "365ocsfw2": {"ru": "Фото лицензии", "en": "License Photo"},
    "wc7z7gma": {"ru": "Файл загружен", "en": "File Uploaded"},
    "qjkt0ibr": {"ru": "Введите номер дилерской лицензии", "en": "Enter Dealer License Number"},
    "1gcocwp3": {"ru": "Please choose an option from the dropdown", "en": "Please choose an option from the dropdown"},
    "17byxfqr": {"ru": "Введите номер прав", "en": "Enter License Number"},
    "3310en34": {"ru": "Please choose an option from the dropdown", "en": "Please choose an option from the dropdown"},
    "47hirxlq": {"ru": "Выберите дату выдачи", "en": "Select Issue Date"},
    "m5royfxr": {"ru": "Please choose an option from the dropdown", "en": "Please choose an option from the dropdown"},
    "3w77w7wy": {"ru": "Далее", "en": "Next"},
    "xm4e6d83": {"ru": "Введите данные", "en": "Enter Details"},
    "91o10itm": {"ru": "Home", "en": "Home"}
  },
// fill_profile_car_numbers
  {
    "oane6xmt": {"ru": "Добавьте номер автомобиля", "en": "Add Vehicle Number"},
    "77grakml": {"ru": "Номер авто", "en": "Vehicle Number"},
    "4d7wim9b": {"ru": "Например, 4567AA", "en": "e.g., 4567AA"},
    "90nliwbe": {"ru": "Ваши номера", "en": "Your Numbers"},
    "m1whe20l": {"ru": "Завершить регистрацию", "en": "Complete Registration"},
    "x0z61hue": {"ru": "Добавьте номер", "en": "Add Number"},
    "vbzefsy2": {"ru": "Home", "en": "Home"}
  },
// OrderTab
  {
    "uk4nasyp": {"ru": "Заказы", "en": "Orders"},
    "error": {"ru": "Произошла ошибка", "en": "Something went wrong"},
    "today": {"ru": "Сегодня", "en": "Today"},
    "yesterday": {"ru": "Вчера", "en": "Yesterday"},
    "fill_field": {"ru": "Заполните поле", "en": "Please fill in the field"},
    "end_dispute": {"ru": "Завершить спор и заказ", "en": "End Dispute and Order"}
  },
// ChatTab
  {
    "h5ybncw9": {"ru": "Page Title", "en": "Page Title"},
    "p4xzs9g2": {"ru": "Чат", "en": "Chat"},
    "p4xzs9g3": {"ru": "Поддержка", "en": "Support"}
  },
  // ProfileTab
  //TODO3
  {
    "d1dmyum3": {"ru": "Профиль", "en": "Profile"},
    "vxq4yoj9": {"ru": "Кошелёк", "en": "Wallet"},
    "rr5t5e6d": {"ru": "Ваш баланс", "en": "Your Balance"},
    "7qmi50b2": {"ru": "Пополнить", "en": "Top Up"},
    "90k5qz14": {"ru": "Профиль", "en": "Profile"}
  },
  // CreateDealPage
  {
    "puetag84": {"ru": "Отменить", "en": "Cancel"},
    "82c89450": {"ru": "Home", "en": "Home"}
  },
  // DillerActiveDeals
  {
    "gqbw82ra": {"ru": "Активные заказы", "en": "Active Orders"},
    "op322ixk": {"ru": "Home", "en": "Home"}
  },

  // DillerDisputeDeals
  {
    "uk5wdd6r": {"ru": "Спор открыт", "en": "Dispute Opened"},
    "d2ei2rc7": {"ru": "Home", "en": "Home"}
  },
// EditDeal
  {
    "5o4f87t3": {"ru": "Page Title", "en": "Page Title"},
    "24yoje76": {"ru": "Home", "en": "Home"}
  },
// WalletPage
  {
    "q381mube": {"ru": "Пополнение кошелька", "en": "Wallet Top-Up"},
    "s55fspw7": {"ru": "Ваш баланс", "en": "Your Balance"},
    "6tsztnuk": {"ru": "Выберите пакет для пополнения", "en": "Choose a Top-Up Package"},
    "342i8y21": {"ru": "Пакет Стандарт", "en": "Standard Package"},
    "gpy8bfc1": {"ru": "25\$", "en": "\$25"},
    "afx3fr6j": {"ru": "Hello World", "en": "Hello World"},
    "xi3paej3": {"ru": "Оплатить", "en": "Pay"},
    "lmuww1r0": {"ru": "Home", "en": "Home"}
  },
// HistoryPage
  {
    "nmf3l6bm": {"ru": "История заказов", "en": "Order History"},
    "19xytohs": {
      "ru": "У вас нет завершенных\nзаказов на данный момент",
      "en": "You have no completed\norders at this time"
    },
    "wa5qzmui": {"ru": "Home", "en": "Home"}
  },
// ReviewsPage
  {
    "vmgty51i": {"ru": "Отзывы", "en": "Reviews"},
    "8kcp3y40": {"ru": "У вас пока нет отзывов", "en": "You have no reviews yet"},
    "otcdzo5g": {"ru": "Home", "en": "Home"}
  },

  {
    // TransactionsPage
    "jewjbyo3": {"ru": "История операций", "en": "Transaction History"},
    "2rjx5ks0": {"ru": "У вас пока нет транзакций", "en": "You have no transactions yet"},
    "39q8l5fk": {"ru": "Оплата отклика", "en": "Response Payment"},
    "3k2ajh6y": {"ru": "Home", "en": "Home"},
    // EditProfile
    "dy0ui8k1": {"ru": "Редактирование профиля", "en": "Edit Profile"},
    "ghevves9": {"ru": "50%", "en": "50%"},
    "rofl3rt0": {"ru": "Изменить фото", "en": "Change Photo"},
    "h8pygj5n": {"ru": "Имя", "en": "Name"},
    "eh3m3o8g": {"ru": "Ваше имя", "en": "Your Name"},
    "nff3ohbg": {"ru": "Контактный номер телефона", "en": "Contact Phone Number"},
    "khu7giqs": {"ru": "+7", "en": "+7"},
    "25wu7x7c": {"ru": "Введите имя", "en": "Enter Name"},
    "c4c9jipe": {"ru": "Минимум 6 символов", "en": "Minimum 6 characters"},
    "zlk6k0he": {"ru": "Please choose an option from the dropdown", "en": "Please choose an option from the dropdown"},
    "ccupewx5": {"ru": "Введите номер телефона", "en": "Enter Phone Number"},
    "5we5khxm": {"ru": "Номер не валидный", "en": "Invalid Number"},
    "pvfb07zo": {"ru": "Please choose an option from the dropdown", "en": "Please choose an option from the dropdown"},
    "i4orpypq": {"ru": "Сохранить", "en": "Save"},
    "nm168pa6": {"ru": "Home", "en": "Home"},
    // EditDillerProfile1
    "n6pc1bjf": {"ru": "Введите данные", "en": "Enter Data"},
    "ycmvgs8i": {
      "ru": "Для идентификации необходимо заполнить ваши данные",
      "en": "To verify your identity, please provide your information"
    },
    "hhdtc3wc": {"ru": "Номер дилерской лицензии", "en": "Dealer License Number"},
    "zf4miei7": {"ru": "Номер прав", "en": "License Number"},
    "jyhi1ber": {"ru": "Дата выдачи", "en": "Date of Issue"},
    "1yw2zwli": {"ru": "ДД/ММ/ГГ", "en": "DD/MM/YY"},
    "wf76quu1": {"ru": "Водительские права", "en": "Driver's License"},
    "sngqkw2e": {"ru": "Файл загружен", "en": "File Uploaded"},
    "q0fdkyjd": {"ru": "Введите номер дилерской лицензии", "en": "Enter Dealer License Number"},
    "lse6gpm6": {"ru": "Please choose an option from the dropdown", "en": "Please choose an option from the dropdown"},
    "mo8mbnho": {"ru": "Введите номер прав", "en": "Enter License Number"},
    "hfmr89r0": {"ru": "Please choose an option from the dropdown", "en": "Please choose an option from the dropdown"},
    "6x1mb5w0": {"ru": "Выберите дату выдачи", "en": "Select Date of Issue"},
    "9j9n3eop": {"ru": "Please choose an option from the dropdown", "en": "Please choose an option from the dropdown"},
    "7y3kmflq": {"ru": "Сохранить", "en": "Save"},
    "u56224yn": {"ru": "Home", "en": "Home"},
    // EditDillerProfile2
    "jdoodok9": {"ru": "Номер авто", "en": "Car Number"},
    "i75iiq4j": {"ru": "Добавьте номер автомолибя", "en": "Add Car Number"},
    "smlxqd06": {"ru": "Номер авто", "en": "Car Number"},
    "npdere1w": {"ru": "Например, 4567AA", "en": "For example, 4567AA"},
    "07sp7k2g": {"ru": "Ваши номера", "en": "Your Numbers"},
    "y2arpqli": {"ru": "Сохранить", "en": "Save"},
    "l6oyfws8": {"ru": "Home", "en": "Home"},
    // EditCarrierProfile1
    "svde0kpt": {"ru": "Ваши данные", "en": "Your Information"},
    "ni5c385g": {"ru": "Название компании", "en": "Company Name"},
    "r6ibq11p": {"ru": "Название компании", "en": "Company Name"},
    "bzccoayw": {"ru": "Номер перевозчика", "en": "Carrier Number"},
    "luwsr74l": {"ru": "Номер перевозчика", "en": "Carrier Number"},
    "yjhrpux0": {"ru": "Номер водительских прав", "en": "Driver's License Number"},
    "ym2hbjf8": {"ru": "Номер водительских прав", "en": "Driver's License Number"},
    "padtz505": {"ru": "Введите название компании", "en": "Enter Company Name"},
    "u5pvefpq": {"ru": "Минимум 3 символа", "en": "Minimum 3 characters"},
    "pqqs5mk8": {"ru": "Email не валидный", "en": "Invalid Email"},
    "etei8sq6": {"ru": "Please choose an option from the dropdown", "en": "Please choose an option from the dropdown"},
    "kzn0dss5": {"ru": "Введите номер перевозчика", "en": "Enter Carrier Number"},
    "88g95i67": {"ru": "Минимум 3 символа", "en": "Minimum 3 characters"},
    "svw8j3ph": {"ru": "Please choose an option from the dropdown", "en": "Please choose an option from the dropdown"},
    "qvpxvw24": {"ru": "Введите номер водительских прав", "en": "Enter Driver's License Number"},
    "rwn4l28z": {"ru": "Минимум 3 символа", "en": "Minimum 3 characters"},
    "c6wssbi3": {"ru": "Please choose an option from the dropdown", "en": "Please choose an option from the dropdown"},
    "b8fcbmey": {"ru": "Home", "en": "Home"},
    // Восстановлено: в экспорте FlutterFlow строки потерялись и превратились
    // в '?????????' / '?????? ?????????' — кириллица не выжила кодировку.
    "ecp1save": {"ru": "Сохранить", "en": "Save"},
    "ecp1saved": {"ru": "Данные сохранены", "en": "Data saved"}
  },
  // UserBannedPage
  {
    "njbmsc09": {"ru": "Выйти", "en": "Logout"},
    "gtnutexh": {"ru": "Home", "en": "Home"}
  },
  // UserProfile
  {
    "6y194gm2": {"ru": "Профиль", "en": "Profile"},
    "gawsd999": {"ru": "Заказов пока нет", "en": "No orders yet"},
    "09vg7p2l": {"ru": "Просмотреть все", "en": "View all"},
    "w5luwqu9": {"ru": "Профиль", "en": "Profile"}
  },
  // NotificationsPage
  {
    "cugu2ifh": {"ru": "Уведомления", "en": "Notifications"},
    "l5ve4uhx": {"ru": "Вас выбрали!", "en": "You've been selected!"},
    "d22txapx": {"ru": "Ваш отклик на заказ № 23 был одобрен", "en": "Your response to order № 23 has been approved"},
    "h0e8ms35": {"ru": "Вчера", "en": "Yesterday"},
    "t7j3std9": {"ru": "У вас нет уведомлений", "en": "You have no notifications"},
    "7zp7f7b4": {"ru": "Home", "en": "Home"}
  },
  {
    "wny8w3hs": {"ru": "Фильтры", "en": "Filters"},
    "cr7bvjc2": {"ru": "Сбросить", "en": "Reset"},
    "af8giade": {"ru": "Рейтинг создателя", "en": "Creator's rating"},
    "yjf2jb9e": {"ru": "5.0", "en": "5.0"},
    "qpkvx59m": {"ru": "4.0 и выше", "en": "4.0 and above"},
    "4cl1g9ev": {"ru": "3.0 и выше", "en": "3.0 and above"},
    "0iwl5wpw": {"ru": "любой", "en": "any"},
    "yhgpvkg3": {"ru": "Стоимость", "en": "Cost"},
    "bi8z1fri": {"ru": "Мин", "en": "Min"},
    "zqzhahnh": {"ru": "Макс", "en": "Max"},
    "xf0jdmda": {"ru": "Аукцион", "en": "Auction"},
    "8a6xg93w": {"ru": "Option 1", "en": "Option 1"},
    "d0398rux": {"ru": "Все аукционы", "en": "All auctions"},
    "8qoye7t7": {"ru": "Search for an item...", "en": "Search for an item..."},
    "yfim2ls3": {"ru": "Локация", "en": "Location"},
    "9txcht42": {"ru": "Все города", "en": "All cities"},
    "hm93fsx1": {"ru": "Сохранить", "en": "Save"},
    "7pk0d8jv": {"ru": "Home", "en": "Home"}
  },
  // FilterLocationPage
  {
    "kyd3t5yu": {"ru": "Локация", "en": "Location"},
    "agpce6fx": {"ru": "Локация", "en": "Location"},
    "v9o7868x": {"ru": "Все города", "en": "All cities"},
    "u9koen24": {"ru": "Сохранить", "en": "Save"},
    "8927p2r9": {"ru": "Дать доступ к местоположению", "en": "Allow access to location"},
    "r3jwqfcq": {
      "ru": "Нам нужно знать ваше местоположение, чтобы показывать заказы рядом",
      "en": "We need to know your location to show nearby orders"
    },
    "g8pzikgj": {"ru": "Дать доступ", "en": "Allow access"},
    "g5qxacsa": {"ru": "Home", "en": "Home"}
  },
  // DealDetailDiller
  {
    "p761qnat": {"ru": "Цена", "en": "Price"},
    "enf40y4g": {"ru": "Срок исполнения", "en": "Execution time"},
    "s1rbxyrb": {"ru": "4567АА", "en": "4567AA"},
    "m5i0oitl": {"ru": "Описание заказа", "en": "Order description"},
    "h002oe0y": {"ru": "Исполнитель", "en": "Contractor"},
    "qvsmobpy": {"ru": "Запросить геолокацию", "en": "Request geolocation"},
    "qvsmobpy2": {"ru": "Геолокация запрошена", "en": "Geolocation requested"},
    "1qe9usak": {"ru": "(32 отзыва)", "en": "(32 reviews)"},
    "d628bnfz": {"ru": "Завершить заказ", "en": "Complete order"},
    "8k35nufy": {"ru": "Home", "en": "Home"}
  },
  {
    "nedm0qh9": {"ru": "Цена", "en": "Price"},
    "am35vsuv": {"ru": "Срок исполнения", "en": "Execution time"},
    "km": {"ru": "км", "en": "km"},
    "79f6biyf": {"ru": "Расстояние", "en": "Distance"},
    "ljobcg24": {"ru": "Местоположение", "en": "Location"},
    "htvzh1i7": {"ru": "Построить маршрут", "en": "Build route"},
    "w7p1ksui": {"ru": "Дилер", "en": "Dealer"},
    "93kun0dk": {"ru": "отзыва", "en": "reviews"},
    "5vc1l2lf": {"ru": "Описание заказа", "en": "Order description"},
    "m5momf7w": {"ru": "Способ оплаты", "en": "Payment method"},
    "svl0x6kw": {"ru": "Откликнуться", "en": "Respond"},
    "tsxx2v7a": {"ru": "Home", "en": "Home"}
  },
  // ChatRoomPage
  {
    "wixmthah": {"ru": "", "en": ""},
    "g08fv5o2": {"ru": "Напишите сообщение...", "en": "Type a message..."},
    "jzmjbbf9": {"ru": "Home", "en": "Home"}
  },
  {
    "edzf8z5c": {"ru": "Завершить регистрацию?", "en": "Complete registration?"},
    "wkc1gy0c": {"ru": "Ваш профиль не будет сохранен", "en": "Your profile will not be saved"},
    "iut1gfwf": {"ru": "Назад", "en": "Back"},
    "uksfuvh0": {"ru": "Завершить", "en": "Complete"}
  },
  {
    "834ufven": {"ru": "Далее", "en": "Next"}
  },
  {
    "kiu4okb1": {"ru": "Активные заказы", "en": "Active orders"},
    "l6n2fo2r": {"ru": "У вас нет активных заказов", "en": "You have no active orders"},
    "05lj71fe": {"ru": "Создавайте заказы и находите исполнителей", "en": "Create orders and find contractors"}
  },
  {
    "k5v6aa9r": {"ru": "Название машины", "en": "Car name"},
    "zpjizta7": {"ru": "Например, Ауди А5", "en": "For example, Audi A5"},
    "c7d8b4vr": {"ru": "Фото транспорта", "en": "Transport photos"},
    "c7d8b4vr2": {"ru": "Фотографии", "en": "Photos"},
    "64hmfy70": {"ru": "Далее", "en": "Next"}
  },
  {
    "hvjdr22h": {"ru": "Описание заказа", "en": "Order description"},
    "cix8cr0r": {"ru": "Добавить описание", "en": "Add description"},
    "6wxkjzv7": {"ru": "Далее", "en": "Next"}
  },
  {
    "le0i477y": {"ru": "Местоположение транспорта", "en": "Transport location"},
    "772fktfe": {"ru": "Адрес объекта", "en": "Object address"},
    "nkkkg4f1": {"ru": "Показать на карте", "en": "Show on map"},
    "7yyrs8y3": {"ru": "Далее", "en": "Next"}
  },
  {
    "6cir7a9p": {"ru": "Выбор аукциона", "en": "Auction selection"},
    "3qli34up": {"ru": "Option 1", "en": "Option 1"},
    "mrtxxggk": {"ru": "Выберите аукцион", "en": "Select an auction"},
    "lv6rf6y3": {"ru": "Введите название аукциона", "en": "Enter auction name"},
    "xgd4lv6v": {"ru": "Далее", "en": "Next"}
  },
  {
    "gf191p0n": {"ru": "Дата доставки транспорта", "en": "Transport delivery date"},
    "gf191p0n2": {"ru": "Дата доставки", "en": "Delivery date"},
    "ka9eitiu": {"ru": "Далее", "en": "Next"}
  },
  {
    "bzpqc8mq": {"ru": "Стоимость заказа", "en": "Order cost"},
    "gl2ptc5b": {"ru": "Предпочитаемая цена выполнения", "en": "Preferred execution price"},
    "wevlhiw0": {"ru": "Стоимость заказа", "en": "Order cost"},
    "lrpkz4z3": {"ru": "Оплата наличными", "en": "Cash payment"},
    "hosr19li": {"ru": "Оплата картой", "en": "Card payment"},
    "tfisew47": {"ru": "Далее", "en": "Next"}
  },
  {
    "gknitk6o": {"ru": "Прикрепить файл", "en": "Attach file"},
    "gknitk6o2": {"ru": "Файл", "en": "File"},
    "gknitk6o3": {"ru": "Фото", "en": "Photo"},
    "files": {"ru": "Файлы", "en": "Files"},
    "4wr8zluz": {
      "ru": "Например, оплаченный счет на аукцион, который является пропуском на выезд",
      "en": "For example, a paid auction invoice, which serves as an exit pass"
    },
    "ftny370e": {"ru": "Файл добавлен", "en": "File added"},
    "fk34a0zo": {"ru": "Файл загружен", "en": "File uploaded"},
    "1hellx4h": {"ru": "Опубликовать заказ", "en": "Publish order"}
  },
  // success_createdeal_custom_alert
  {
    "81ngjs9e": {"ru": "Ваш заказ опубликован", "en": "Your order has been published"},
    "jvwl13og": {"ru": "С вашего счета списано", "en": "Deducted from your account"},
    "jvwl13og2": {"ru": "токенов", "en": "tokens"},
    "sc89sgil": {"ru": "Далее", "en": "Next"}
  },
  {
    "min20r03": {"ru": "У вас осталось 3 бесплатных заказа.", "en": "You have 3 free orders left."},
    "min20r031": {"ru": "У вас осталось", "en": "You have"},
    "min20r0312": {"ru": "бесплатных заказа.", "en": "free orders left."},
    "1igl46s7": {
      "ru": "У каждого пользователя есть возможность создать 3 бесплатных заказа.  \nДалее каждый заказ - 10 токенов.",
      "en": "Each user can create 3 free orders. \nAfterwards, each order costs 10 tokens."
    },
    "10x62s2a": {"ru": "Закрыть", "en": "Close"},
    "jmqh2f95": {"ru": "Продолжить", "en": "Continue"}
  },
  {
    "pfejgxti": {"ru": "Пополните кошелек.", "en": "Top up your wallet."},
    "dgm5fp3p": {
      "ru": "Ваш лимит исчерпан. Пополните баланс, чтобы разместить заказ.",
      "en": "Your limit has been reached. Top up your balance to place an order."
    },
    "dgm5fp3p2": {
      "ru": "Ваш лимит исчерпан. Пополните баланс, чтобы откликнуться на заказ.",
      "en": "Your limit has been reached. Top up your balance to respond to an order."
    },
    "5itrru8d": {"ru": "Закрыть", "en": "Close"},
    "h6bkyrim": {"ru": "Пополнить", "en": "Top up"}
  },
  {
    "d1xyjpft": {"ru": "Активные заказы", "en": "Active orders"},
    "c0xa63ls": {"ru": "отклика", "en": "response"},
    "ynwnh0p6": {"ru": "Спор открыт", "en": "Dispute opened"}
  },
  {
    "z350nw0r": {"ru": "У вас нет активных заказов на данный момент", "en": "You have no active orders at the moment"}
  },
  {
    "juonngii": {"ru": "Отменён", "en": "Cancelled"},
    "p6rcq0n5": {"ru": "Алексей", "en": "Alexey"}
  },
  {
    "hj9lsbje": {"ru": "Отзывы", "en": "Reviews"},
    "jt3ud1l1": {"ru": "Отзывов пока нет", "en": "No reviews yet"},
    "gyrqgctd": {"ru": "Просмотреть все", "en": "View all"},
    "reviews": {"ru": "отзывов", "en": "reviews"},
    "no_reviews": {"ru": "(нет отзывов)", "en": "(no reviews)"}
  },
  {
    "tfx0cz1h": {"ru": "История заказов", "en": "Order history"},
    "gt3p2m8b": {"ru": "Заказов пока нет", "en": "No orders yet"},
    "s1d7w77x": {"ru": "Просмотреть все", "en": "View all"}
  },
  {
    "3gp2epa4": {"ru": "Отменён", "en": "Cancelled"},
    "expgmjv6": {"ru": "Алексей", "en": "Alexey"}
  },
  {
    "ctpzkjap": {"ru": "История заказов", "en": "Order history"},
    "5jx45ts4": {"ru": "Заказов пока нет", "en": "No orders yet"},
    "q87mfrss": {"ru": "Просмотреть все", "en": "View all"}
  },
  {
    "1bfvjn7y": {"ru": "История операций", "en": "Transaction history"},
    "iegasi4g": {"ru": "Операций пока нет", "en": "No transactions yet"},
    "rug8otza": {"ru": "Оплата отклика", "en": "Response payment"},
    "rug8otza2": {"ru": "Оплата заказа", "en": "Order payment"},
    "rug8otza3": {"ru": "Возврат средств", "en": "Refund"},
    "ls78jsfq": {"ru": "Просмотреть все", "en": "View all"}
  },
  {
    "5w6uhdnu2": {"ru": "Оплата", "en": "Payment"},
    "5w6uhdnu": {"ru": "Способ оплаты", "en": "Payment method"},
    "ypf67ehe": {"ru": "Оплата картой", "en": "Card payment"},
    "6btlup18": {"ru": "ApplePay", "en": "ApplePay"},
    "show_more": {"ru": "Читать больше", "en": "Show more"},
    "show_less": {"ru": "Свернуть", "en": "Show less"},
    "no_responses": {"ru": "Откликов нет", "en": "No responses"},
    "responses": {"ru": "Отклики", "en": "Responses"},
    "all": {"ru": "Всего", "en": "Total"},
    "61c2q34345fof": {"ru": "Откликнулся на заказ", "en": "Responded to order"}
  },
  {
    "3jqlm3ry": {"ru": "Выйти из аккаунта?", "en": "Log out?"},
    "61c2qfof": {"ru": "Нет", "en": "No"},
    "5sbvgtak": {"ru": "Да", "en": "Yes"}
  },
  {
    "mr5w94ku": {"ru": "Удалить аккаунт?", "en": "Delete account?"},
    "xpue1fsn": {"ru": "Нет", "en": "No"},
    "o4b5ejk4": {"ru": "Да", "en": "Yes"}
  },
  {
    "t8gwz8md": {"ru": "Поиск заказов", "en": "Order search"},
    "k8fz241e": {"ru": "1", "en": "1"},
    "hy2hyda0": {
      "ru": "Заказов нет\nОбновите страницу или измените фильтры",
      "en": "No orders\nRefresh the page or change the filters"
    },
    "ac4bd5ty": {"ru": "Обновить", "en": "Refresh"}
  },
  {
    "orkltun1": {"ru": "1", "en": "1"}
  },
  // no_deals_map_alert
  {
    "ktm9x39o": {
      "ru": "Заказов нет",
      "en": "No orders",
    },
    "bepyq8yc": {
      "ru": "Обновите страницу или измените фильтры",
      "en": "Refresh the page or change the filters",
    },
    "tgkd0zew": {
      "ru": "Обновить",
      "en": "Refresh",
    }
  },
// end_confirm_deal_alert
  {
    "4vxuz22d": {
      "ru": "Завершить заказ?",
      "en": "Complete the order?",
    },
    "fdl67k2g": {
      "ru": "Нет",
      "en": "No",
    },
    "9aar1wrx": {
      "ru": "Да",
      "en": "Yes",
    }
  },
// deal_complete_success_alert
  {
    "4dyyovjd": {
      "ru": "Завершение заказа",
      "en": "Order completion",
    },
    "69rw895m": {
      "ru": "Ожидайте подтверждения о завершении заказа от исполнителя",
      "en": "Awaiting confirmation of order completion from the contractor",
    },
    "3lwtsbfj": {
      "ru": "Закрыть",
      "en": "Close",
    }
  },
// cancel_deal_alert
  {
    "0kjnx5z4": {
      "ru": "Отменить заказ?",
      "en": "Cancel the order?",
    },
    "suydx2yq": {
      "ru": "Нет",
      "en": "No",
    },
    "90ewdcee": {
      "ru": "Да",
      "en": "Yes",
    }
  },
// deal_canceled_alert
  {
    "2xhh82er": {
      "ru": "Вы отменили заказ",
      "en": "You canceled the order",
    },
    "noyny85i": {
      "ru": "Назначенный исполнитель будет оповещен об отмене заказа",
      "en": "The assigned contractor will be notified of the cancellation",
    },
    "d9d3vvn3": {
      "ru": "Закрыть",
      "en": "Close",
    }
  },
// take_login_alert
  {
    "zocc1ipm": {
      "ru": "Авторизация",
      "en": "Authorization",
    },
    "g3o3tby2": {
      "ru": "Чтобы смотреть этот раздел, вы\nдолжны быть авторизованы",
      "en": "You must be logged in to view this section",
    },
    "0fcq4r9q": {
      "ru": "Регистрация",
      "en": "Register",
    },
    "szbqe1kk": {
      "ru": "Войти",
      "en": "Log in",
    }
  },
// response_deal_bottom
  {
    "ex95uar3": {
      "ru": "Откликнуться",
      "en": "Respond",
    },
    "mwr5hz4j": {
      "ru": "Предложить свою цену",
      "en": "Offer your price",
    },
    "s3yj9p3u": {
      "ru": "500",
      "en": "500",
    },
    "qawx4bdz": {
      "ru": "Откликнуться (-10 токенов)",
      "en": "Respond (-10 tokens)",
    }
  },
// response_success_alert
  {
    "4zdd76wq": {
      "ru": "Вы откликнулись на заказ",
      "en": "You responded to the order",
    },
    "hpqpb1ej": {
      "ru": "Ожидайте подтверждение",
      "en": "Await confirmation",
    },
    "257q4wf9": {
      "ru": "Далее",
      "en": "Next",
    }
  },
// chat_empty_comp
  {
    "o4xbt6fu": {
      "ru": "Сообщений пока нет",
      "en": "No messages yet",
    }
  },
// open_disput_bottom
  {
    "0xr421z3": {
      "ru": "Открыть спор",
      "en": "Open dispute",
    },
    "uagnpwy5": {
      "ru": "Опишите свою проблему",
      "en": "Describe your problem",
    },
    "q2yraz3s": {
      "ru": "Описание",
      "en": "Description",
    },
    "opjpvczo": {
      "ru": "Прикрепить файл",
      "en": "Attach file",
    },
    "rzn3ot99": {
      "ru": "Вы сможете завершить заказ только после завершения спора",
      "en": "You can only complete the order after the dispute is resolved",
    },
    "ovxh81yc": {
      "ru": "Отменить",
      "en": "Cancel",
    },
    "l9qyvf77": {
      "ru": "Отправить",
      "en": "Send",
    }
  },
// send_review_bottom
  {
    "ur0c4uzh": {
      "ru": "Оставить отзыв",
      "en": "Leave a review",
    },
    "ur0c4uzh2": {
      "ru": "Вы оставили отзыв",
      "en": "You left a review",
    },
    "4ib7prrj": {
      "ru": "Насколько вам понравилась работать с заказчиком?",
      "en": "How much did you enjoy working with the client?",
    },
    "9b3gu3q1": {
      "ru": "Здесь вы можете написать отзыв о заказчике",
      "en": "Here you can write a review about the client",
    },
    "m175a7pr": {
      "ru": "Отменить",
      "en": "Cancel",
    },
    "4ij9t7b4": {
      "ru": "Отправить",
      "en": "Send",
    }
  },
// deal_end_alert
  {
    "4jbuakgw": {
      "ru": "Завершение заказа",
      "en": "Order completion",
    },
    "kovuft6w": {
      "ru": "Ожидайте подтверждения о завершении заказа от заказчика",
      "en": "Awaiting confirmation of order completion from the client",
    },
    "k4bxgtai": {
      "ru": "Закрыть",
      "en": "Close",
    }
  },
// end_confirm_disput_alert
  {
    "o2o37704": {
      "ru": "Завершить спор?",
      "en": "End the dispute?",
    },
    "9noybsk0": {
      "ru": "Заказ также будет завершен",
      "en": "The order will also be completed",
    },
    "h54j8ifg": {
      "ru": "Нет",
      "en": "No",
    },
    "a75ag4nc": {
      "ru": "Да",
      "en": "Yes",
    }
  },
// send_complain_bottom
  {
    "bnrx8tji": {
      "ru": "Пожаловаться",
      "en": "Report",
    },
    "fser5rko": {
      "ru": "Опишите свою проблему",
      "en": "Describe your problem",
    },
    "x0hpzhj6": {
      "ru": "Описание",
      "en": "Description",
    },
    "69dqmpx9": {
      "ru": "Отменить",
      "en": "Cancel",
    },
    "pd5jrim3": {
      "ru": "Отправить",
      "en": "Send",
    },
    "no_result": {
      "ru": "Ничего не найдено",
      "en": "No result found",
    }
  },
// payment_failed_alert
  {
    "10ecjxmh": {
      "ru": "Отказ!",
      "en": "Declined!",
    },
    "rz51srav": {
      "ru": "Недостаточно средств",
      "en": "Insufficient funds",
    },
    "yrxjmqmw": {
      "ru": "Закрыть",
      "en": "Close",
    }
  },
// payment_success_alert
  {
    "x0zeyvul": {
      "ru": "Кошелек пополнен",
      "en": "Wallet topped up",
    },
    "4ra7p0wq": {
      "ru": "Закрыть",
      "en": "Close",
    },
    "edit": {
      "ru": "Редактировать",
      "en": "Edit",
    },
    "cancel_deal": {
      "ru": "Отменить заказ",
      "en": "Cancel deal",
    },
    "open_disput": {
      "ru": "Открыть спор",
      "en": "Open dispute",
    },
    "edit_deal_title": {
      "ru": "Редактирование заказа",
      "en": "Edit deal",
    },
    "diller_status_in_search": {
      "ru": "Поиск исполнителя",
      "en": "Searching for a contractor",
    },
    "diller_status_in_confirm": {
      "ru": "Ожидайте подтверждение",
      "en": "Awaiting confirmation",
    },
    "diller_status_in_active": {
      "ru": "В работе",
      "en": "In progress",
    },
    "diller_status_in_dispute": {
      "ru": "Спор открыт",
      "en": "Dispute opened",
    },
    "diller_status_in_canceled": {
      "ru": "Публикация отклонена",
      "en": "Publication rejected",
    },
    "diller_status_in_canceled_by_diller": {
      "ru": "Публикация отменена",
      "en": "Publication canceled",
    },
    "diller_status_in_confirm_complete": {
      "ru": "Ожидается завершение",
      "en": "Completion pending",
    },
    "diller_status_in_complete": {
      "ru": "Заказ завершен",
      "en": "Order completed",
    },
    "carrier_status_in_confirm": {
      "ru": "Вас назначили",
      "en": "You've been assigned",
    },
    "carrier_status_in_search": {
      "ru": "Вы откликнулись",
      "en": "You responded",
    },
    "deals1": {
      "ru": "заказа",
      "en": "order",
    },
    "deals2": {
      "ru": "заказ",
      "en": "order",
    },
    "responses1": {
      "ru": "отклика",
      "en": "response",
    },
    "responses2": {
      "ru": "отклик",
      "en": "response",
    },
    "geo_request": {
      "ru": "запрос на геолокацию",
      "en": "location request",
    },
    "asdasd3g": {
      "ru": "Утвердил вас на заказ",
      "en": "Approved you for the order",
    },
    "reject": {
      "ru": "Отклонить",
      "en": "Reject",
    },
    "go_to_chat": {
      "ru": "Перейти в чат",
      "en": "Go to chat",
    },
    "accept": {
      "ru": "Подтвердить",
      "en": "Accept",
    },
    "documents": {
      "ru": "Документы",
      "en": "Documents",
    },
    "complained": {
      "ru": "Жалоба отправлена",
      "en": "Complaint sent",
    },
    "cancel_response": {
      "ru": "Отменить отклик",
      "en": "Cancel response",
    },
    "select_carrier": {
      "ru": "Подтвердить исполнителя",
      "en": "Confirm contractor",
    },
    "select_carrier_price": {
      "ru": "Согласованная стоимость",
      "en": "Agreed price",
    },
    "select_carrier_car_number": {
      "ru": "Номер автомобиля",
      "en": "Car number",
    },
    "select_carrier_car_number_hint": {
      "ru": "Выберите номер",
      "en": "Choose number",
    },
    "dsg45g3g": {
      "ru": "Заполните стоимость",
      "en": "Enter the price",
    },
    "dsg45g3g2": {
      "ru": "Выберите номер",
      "en": "Choose number",
    },
    "buy": {
      "ru": "Оплатить",
      "en": "Pay",
    },
    "buy_succes": {
      "ru": "Оплата прошла успешно",
      "en": "Payment was successful",
    },
    "carrier_verification_title": {
      "ru": "Верификация перевозчика",
      "en": "Carrier verification",
    },
    "carrier_verification_desc": {
      "ru":
          "Укажите номера DOT и MC — мы сверим их с реестром FMCSA. После проверки в ваших заказах появится отметка «Проверен».",
      "en":
          "Enter your DOT and MC numbers — we check them against the FMCSA registry. Once confirmed, a \"Verified\" badge appears on your deals.",
    },
    "dot_number_label": {
      "ru": "Номер DOT",
      "en": "DOT number",
    },
    "dot_number_hint": {
      "ru": "Например, 1234567",
      "en": "For example, 1234567",
    },
    "mc_number_label": {
      "ru": "Номер MC",
      "en": "MC number",
    },
    "mc_number_hint": {
      "ru": "Например, 123456",
      "en": "For example, 123456",
    },
    "verify_button": {
      "ru": "Проверить",
      "en": "Verify",
    },
    "verifying_text": {
      "ru": "Проверяем...",
      "en": "Verifying...",
    },
    "verification_success": {
      "ru": "Верификация пройдена",
      "en": "Verification complete",
    },
    "verification_error": {
      "ru": "Не удалось пройти верификацию",
      "en": "Verification failed",
    },
    "validation_error": {
      "ru": "Проверьте введённые номера",
      "en": "Check the entered numbers",
    },
    "verification_not_found": {
      "ru": "Номер не найден в реестре FMCSA",
      "en": "Number not found in the FMCSA registry",
    },
    "verification_mismatch": {
      "ru": "Авторитет FMCSA отозван или недействителен",
      "en": "FMCSA authority is revoked or inactive",
    },
    "verification_unavailable": {
      "ru": "Реестр временно недоступен, попробуйте позже",
      "en": "Registry is temporarily unavailable, try again later",
    }
  },
  // Miscellaneous
  {
    'w1utxpzw': {
      'ru': 'For upload images',
      'en': '',
    },
    'uqju92ul': {
      'ru': 'For upload images',
      'en': '',
    },
    'pnaan06i': {
      'ru': 'For receive app notifications',
      'en': '',
    },
    'u5egg7wh': {
      'ru': 'For easy access to your current location',
      'en': '',
    },
    'vdp2vbkz': {
      'ru': '',
      'en': '',
    },
    'ugfxdje7': {
      'ru': '',
      'en': '',
    },
    '7hv0m42d': {
      'ru': '',
      'en': '',
    },
    '0i91tn78': {
      'ru': '',
      'en': '',
    },
    'ye8y0fza': {
      'ru': '',
      'en': '',
    },
    'mcs3yj9c': {
      'ru': '',
      'en': '',
    },
    '2jc8gilm': {
      'ru': '',
      'en': '',
    },
    '96a9yi30': {
      'ru': '',
      'en': '',
    },
    '880uir5o': {
      'ru': '',
      'en': '',
    },
    'dwmrkx6r': {
      'ru': '',
      'en': '',
    },
    'dx611jno': {
      'ru': '',
      'en': '',
    },
    'aagawl6g': {
      'ru': '',
      'en': '',
    },
    '0qvjeve0': {
      'ru': '',
      'en': '',
    },
    'm4fut9zc': {
      'ru': '',
      'en': '',
    },
    'gyjlxtxm': {
      'ru': '',
      'en': '',
    },
    '0yk7bqsn': {
      'ru': '',
      'en': '',
    },
    'f548976u': {
      'ru': '',
      'en': '',
    },
    'iuy85z44': {
      'ru': '',
      'en': '',
    },
    'ec6lgtbp': {
      'ru': '',
      'en': '',
    },
    '308auhqo': {
      'ru': '',
      'en': '',
    },
    '8v0qbs35': {
      'ru': '',
      'en': '',
    },
    'pviu2v6w': {
      'ru': '',
      'en': '',
    },
    'cenlfmzi': {
      'ru': '',
      'en': '',
    },
    '81qdrxgq': {
      'ru': '',
      'en': '',
    },
    'ms631o22': {
      'ru': '',
      'en': '',
    },
  },
].reduce((a, b) => a..addAll(b));
