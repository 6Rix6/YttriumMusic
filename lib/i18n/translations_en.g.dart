///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsGeneralEn general = TranslationsGeneralEn._(_root);
	late final TranslationsSettingEn setting = TranslationsSettingEn._(_root);
}

// Path: general
class TranslationsGeneralEn {
	TranslationsGeneralEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Success'
	String get success => 'Success';

	/// en: 'Error'
	String get error => 'Error';

	/// en: 'Failed'
	String get failed => 'Failed';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'OK'
	String get ok => 'OK';

	/// en: 'Enable'
	String get enable => 'Enable';

	/// en: 'Enabled'
	String get enabled => 'Enabled';

	/// en: 'Disable'
	String get disable => 'Disable';

	/// en: 'Disabled'
	String get disabled => 'Disabled';
}

// Path: setting
class TranslationsSettingEn {
	TranslationsSettingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Setting'
	String get title => 'Setting';

	late final TranslationsSettingAccountEn account = TranslationsSettingAccountEn._(_root);
	late final TranslationsSettingIfaceEn iface = TranslationsSettingIfaceEn._(_root);
}

// Path: setting.account
class TranslationsSettingAccountEn {
	TranslationsSettingAccountEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Account'
	String get title => 'Account';

	/// en: 'Sign In'
	String get signIn => 'Sign In';

	/// en: 'Sign Out'
	String get signOut => 'Sign Out';

	/// en: 'Signed in successfully'
	String get signInSuccess => 'Signed in successfully';

	/// en: 'Signed out successfully'
	String get signOutSuccess => 'Signed out successfully';

	/// en: 'Failed to sign in'
	String get signInFailed => 'Failed to sign in';

	late final TranslationsSettingAccountGoogleEn google = TranslationsSettingAccountGoogleEn._(_root);
}

// Path: setting.iface
class TranslationsSettingIfaceEn {
	TranslationsSettingIfaceEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Interface'
	String get title => 'Interface';

	late final TranslationsSettingIfaceAppearanceEn appearance = TranslationsSettingIfaceAppearanceEn._(_root);
	late final TranslationsSettingIfaceNotificationsEn notifications = TranslationsSettingIfaceNotificationsEn._(_root);
	late final TranslationsSettingIfaceDisplayModeEn displayMode = TranslationsSettingIfaceDisplayModeEn._(_root);
}

// Path: setting.account.google
class TranslationsSettingAccountGoogleEn {
	TranslationsSettingAccountGoogleEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sign in with Google account'
	String get description => 'Sign in with Google account';
}

// Path: setting.iface.appearance
class TranslationsSettingIfaceAppearanceEn {
	TranslationsSettingIfaceAppearanceEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Appearance'
	String get title => 'Appearance';

	late final TranslationsSettingIfaceAppearanceThemeEn theme = TranslationsSettingIfaceAppearanceThemeEn._(_root);
}

// Path: setting.iface.notifications
class TranslationsSettingIfaceNotificationsEn {
	TranslationsSettingIfaceNotificationsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Notifications'
	String get title => 'Notifications';
}

// Path: setting.iface.displayMode
class TranslationsSettingIfaceDisplayModeEn {
	TranslationsSettingIfaceDisplayModeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Display Mode'
	String get title => 'Display Mode';
}

// Path: setting.iface.appearance.theme
class TranslationsSettingIfaceAppearanceThemeEn {
	TranslationsSettingIfaceAppearanceThemeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Theme'
	String get title => 'Theme';

	/// en: 'Customize the look and feel.'
	String get description => 'Customize the look and feel.';

	late final TranslationsSettingIfaceAppearanceThemeThemeModeEn themeMode = TranslationsSettingIfaceAppearanceThemeThemeModeEn._(_root);
	late final TranslationsSettingIfaceAppearanceThemeDynamicColorEn dynamicColor = TranslationsSettingIfaceAppearanceThemeDynamicColorEn._(_root);
}

// Path: setting.iface.appearance.theme.themeMode
class TranslationsSettingIfaceAppearanceThemeThemeModeEn {
	TranslationsSettingIfaceAppearanceThemeThemeModeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Theme Mode'
	String get title => 'Theme Mode';

	/// en: 'Light'
	String get light => 'Light';

	/// en: 'Dark'
	String get dark => 'Dark';

	/// en: 'System'
	String get system => 'System';
}

// Path: setting.iface.appearance.theme.dynamicColor
class TranslationsSettingIfaceAppearanceThemeDynamicColorEn {
	TranslationsSettingIfaceAppearanceThemeDynamicColorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Dynamic Color'
	String get title => 'Dynamic Color';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'general.success' => 'Success',
			'general.error' => 'Error',
			'general.failed' => 'Failed',
			'general.cancel' => 'Cancel',
			'general.ok' => 'OK',
			'general.enable' => 'Enable',
			'general.enabled' => 'Enabled',
			'general.disable' => 'Disable',
			'general.disabled' => 'Disabled',
			'setting.title' => 'Setting',
			'setting.account.title' => 'Account',
			'setting.account.signIn' => 'Sign In',
			'setting.account.signOut' => 'Sign Out',
			'setting.account.signInSuccess' => 'Signed in successfully',
			'setting.account.signOutSuccess' => 'Signed out successfully',
			'setting.account.signInFailed' => 'Failed to sign in',
			'setting.account.google.description' => 'Sign in with Google account',
			'setting.iface.title' => 'Interface',
			'setting.iface.appearance.title' => 'Appearance',
			'setting.iface.appearance.theme.title' => 'Theme',
			'setting.iface.appearance.theme.description' => 'Customize the look and feel.',
			'setting.iface.appearance.theme.themeMode.title' => 'Theme Mode',
			'setting.iface.appearance.theme.themeMode.light' => 'Light',
			'setting.iface.appearance.theme.themeMode.dark' => 'Dark',
			'setting.iface.appearance.theme.themeMode.system' => 'System',
			'setting.iface.appearance.theme.dynamicColor.title' => 'Dynamic Color',
			'setting.iface.notifications.title' => 'Notifications',
			'setting.iface.displayMode.title' => 'Display Mode',
			_ => null,
		};
	}
}
