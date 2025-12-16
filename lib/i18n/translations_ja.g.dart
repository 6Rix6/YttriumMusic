///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsJa with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsJa({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ja,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ja>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsJa _root = this; // ignore: unused_field

	@override 
	TranslationsJa $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsJa(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsGeneralJa general = _TranslationsGeneralJa._(_root);
	@override late final _TranslationsSettingJa setting = _TranslationsSettingJa._(_root);
}

// Path: general
class _TranslationsGeneralJa implements TranslationsGeneralEn {
	_TranslationsGeneralJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get success => '成功';
	@override String get error => 'エラー';
	@override String get failed => '失敗';
	@override String get cancel => 'キャンセル';
	@override String get ok => 'OK';
	@override String get enable => '有効化';
	@override String get enabled => '有効';
	@override String get disable => '無効化';
	@override String get disabled => '無効';
}

// Path: setting
class _TranslationsSettingJa implements TranslationsSettingEn {
	_TranslationsSettingJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '設定';
	@override late final _TranslationsSettingAccountJa account = _TranslationsSettingAccountJa._(_root);
	@override late final _TranslationsSettingIfaceJa iface = _TranslationsSettingIfaceJa._(_root);
}

// Path: setting.account
class _TranslationsSettingAccountJa implements TranslationsSettingAccountEn {
	_TranslationsSettingAccountJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'アカウント';
	@override String get signIn => 'サインイン';
	@override String get signOut => 'サインアウト';
	@override String get signInSuccess => 'サインインに成功しました';
	@override String get signOutSuccess => 'サインアウトに成功しました';
	@override String get signInFailed => 'サインインに失敗しました';
	@override late final _TranslationsSettingAccountGoogleJa google = _TranslationsSettingAccountGoogleJa._(_root);
}

// Path: setting.iface
class _TranslationsSettingIfaceJa implements TranslationsSettingIfaceEn {
	_TranslationsSettingIfaceJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'インターフェース';
	@override late final _TranslationsSettingIfaceAppearanceJa appearance = _TranslationsSettingIfaceAppearanceJa._(_root);
	@override late final _TranslationsSettingIfaceNotificationsJa notifications = _TranslationsSettingIfaceNotificationsJa._(_root);
	@override late final _TranslationsSettingIfaceDisplayModeJa displayMode = _TranslationsSettingIfaceDisplayModeJa._(_root);
}

// Path: setting.account.google
class _TranslationsSettingAccountGoogleJa implements TranslationsSettingAccountGoogleEn {
	_TranslationsSettingAccountGoogleJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get description => 'Googleアカウントでサインイン';
}

// Path: setting.iface.appearance
class _TranslationsSettingIfaceAppearanceJa implements TranslationsSettingIfaceAppearanceEn {
	_TranslationsSettingIfaceAppearanceJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '外観';
	@override late final _TranslationsSettingIfaceAppearanceThemeJa theme = _TranslationsSettingIfaceAppearanceThemeJa._(_root);
}

// Path: setting.iface.notifications
class _TranslationsSettingIfaceNotificationsJa implements TranslationsSettingIfaceNotificationsEn {
	_TranslationsSettingIfaceNotificationsJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '通知';
}

// Path: setting.iface.displayMode
class _TranslationsSettingIfaceDisplayModeJa implements TranslationsSettingIfaceDisplayModeEn {
	_TranslationsSettingIfaceDisplayModeJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '表示モード';
}

// Path: setting.iface.appearance.theme
class _TranslationsSettingIfaceAppearanceThemeJa implements TranslationsSettingIfaceAppearanceThemeEn {
	_TranslationsSettingIfaceAppearanceThemeJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'テーマ';
	@override String get description => 'アプリの外観をカスタマイズします。';
	@override late final _TranslationsSettingIfaceAppearanceThemeThemeModeJa themeMode = _TranslationsSettingIfaceAppearanceThemeThemeModeJa._(_root);
	@override late final _TranslationsSettingIfaceAppearanceThemeDynamicColorJa dynamicColor = _TranslationsSettingIfaceAppearanceThemeDynamicColorJa._(_root);
}

// Path: setting.iface.appearance.theme.themeMode
class _TranslationsSettingIfaceAppearanceThemeThemeModeJa implements TranslationsSettingIfaceAppearanceThemeThemeModeEn {
	_TranslationsSettingIfaceAppearanceThemeThemeModeJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'テーマモード';
	@override String get light => 'ライト';
	@override String get dark => 'ダーク';
	@override String get system => 'システム';
}

// Path: setting.iface.appearance.theme.dynamicColor
class _TranslationsSettingIfaceAppearanceThemeDynamicColorJa implements TranslationsSettingIfaceAppearanceThemeDynamicColorEn {
	_TranslationsSettingIfaceAppearanceThemeDynamicColorJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ダイナミックカラー';
}

/// The flat map containing all translations for locale <ja>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsJa {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'general.success' => '成功',
			'general.error' => 'エラー',
			'general.failed' => '失敗',
			'general.cancel' => 'キャンセル',
			'general.ok' => 'OK',
			'general.enable' => '有効化',
			'general.enabled' => '有効',
			'general.disable' => '無効化',
			'general.disabled' => '無効',
			'setting.title' => '設定',
			'setting.account.title' => 'アカウント',
			'setting.account.signIn' => 'サインイン',
			'setting.account.signOut' => 'サインアウト',
			'setting.account.signInSuccess' => 'サインインに成功しました',
			'setting.account.signOutSuccess' => 'サインアウトに成功しました',
			'setting.account.signInFailed' => 'サインインに失敗しました',
			'setting.account.google.description' => 'Googleアカウントでサインイン',
			'setting.iface.title' => 'インターフェース',
			'setting.iface.appearance.title' => '外観',
			'setting.iface.appearance.theme.title' => 'テーマ',
			'setting.iface.appearance.theme.description' => 'アプリの外観をカスタマイズします。',
			'setting.iface.appearance.theme.themeMode.title' => 'テーマモード',
			'setting.iface.appearance.theme.themeMode.light' => 'ライト',
			'setting.iface.appearance.theme.themeMode.dark' => 'ダーク',
			'setting.iface.appearance.theme.themeMode.system' => 'システム',
			'setting.iface.appearance.theme.dynamicColor.title' => 'ダイナミックカラー',
			'setting.iface.notifications.title' => '通知',
			'setting.iface.displayMode.title' => '表示モード',
			_ => null,
		};
	}
}
