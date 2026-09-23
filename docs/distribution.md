## Automação de build e distribuição

Clone e instale:

```bash
git clone https://github.com/callonlogin-ops/credit-store.git
cd credit-store
chmod +x scripts/*.sh
./scripts/install.sh
nano .env.local
```

## Build Android

Defina `ANDROID_PROJECT_DIR` para um projeto Android contendo `gradlew`:

```bash
ANDROID_PROJECT_DIR=../MeuAndroid ./scripts/build-android.sh
```

Os artefatos de release ficam em `dist/android`.

## Upload da Credit Store

```bash
export CREDIT_API_URL=https://seu-dominio
export CREDIT_SESSION='valor-do-cookie-credit_session'
export APP_TITLE='Meu app'
export APP_DESCRIPTION='Descrição'
export APP_CATEGORY=Produtividade
export APP_VERSION=1.0.0
export APK_FILE=./dist/android/app-release.apk
./scripts/upload-apk.sh
```

## Download

```bash
export CREDIT_API_URL=https://seu-dominio
export APP_SLUG=meu-app-123
export OUTPUT_FILE=./downloads/app.apk
./scripts/download-apk.sh
```

## Play Console

Configure uma conta de serviço com acesso ao Play Console, instale Fastlane e execute `scripts/publish-google-play.sh` com `GOOGLE_PACKAGE_NAME`, `GOOGLE_JSON_KEY`, `ANDROID_AAB` e `GOOGLE_TRACK=internal`.

## Apple

A Apple não distribui APK. Use um IPA assinado, App Store Connect API key e `scripts/publish-apple.sh` para TestFlight/App Store Connect.

## Amazon

Configure o endpoint e token liberados para sua conta Amazon Appstore e execute `scripts/publish-amazon.sh`. Não grave credenciais no Git; use variáveis de ambiente ou GitHub Secrets.
