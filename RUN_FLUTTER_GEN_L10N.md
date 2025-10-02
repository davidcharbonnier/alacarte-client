# IMPORTANT: Generate Localization Files

After adding new localization strings to the `.arb` files, you must regenerate the localization code.

## Run This Command:

```bash
cd /home/david/perso/alacarte-client
flutter gen-l10n
```

This will generate the `searchItemsByName()` method and make it available in `AppLocalizations`.

## What This Does:

- Reads `lib/l10n/app_en.arb` and `lib/l10n/app_fr.arb`
- Generates Dart code in `lib/flutter_gen/gen_l10n/`
- Creates methods for all localization keys
- Makes `context.l10n.searchItemsByName()` available

## After Running:

The error `The method 'searchItemsByName' isn't defined for the type 'AppLocalizations'` will be resolved.

## Note:

This is a **standard Flutter workflow** - any time you add/modify `.arb` files, you must run `flutter gen-l10n` to regenerate the localization code.

---

**Quick Fix:** Run `flutter gen-l10n` now!
