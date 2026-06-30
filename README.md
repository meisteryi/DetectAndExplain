# 🇯🇵 TabiLenS (타비렌즈)

> **일본 여행자를 위한 실시간 메뉴판 번역, 식문화 가이드 및 주문 도우미 서비스**
>
> *"세로쓰기로 빼곡한 일본어 메뉴판, 어떤 음식인지 몰라 난감했던 적이 있으신가요? TabiLenS가 해결해 드립니다."*

TabiLenS는 일본 현지를 여행하는 한국인들이 메뉴판이나 간판을 읽을 때 겪는 언어적·문화적 장벽을 해소하기 위해 개발된 **Flutter 기반의 멀티플랫폼(Android / iOS / Web) 애플리케이션**입니다. 

단순히 텍스트를 기계적으로 번역하는 것을 넘어, **음식의 유래, 맛의 특징, 식재료 정보(알레르기 예방)**를 친절하게 해설해 줍니다. 또한 현장에서 즉시 활용할 수 있는 **상황별 맞춤 주문 회화와 TTS(Text-to-Speech) 원어민 발음 듣기 기능**까지 제공하여 일본 여행의 즐거움을 더해 줍니다.

---

## ✨ 핵심 기능 (Key Features)

### 1. 🔍 지능형 일본어 영역 검출 & 이미지 보정 (OCR & Boundary Box Detection)
* **스마트 영역 검출**: 일본어의 다양한 특징(세로쓰기, 흘림체 손글씨, 간판, 저조도 환경)을 **Gemini 2.5 Flash**를 사용하여 정확히 인식하고, 사용자가 선택하기 쉬운 터치 박스 형태로 화면에 시각화합니다.
* **EXIF 회전 보정 (Auto Rotation Correction)**: 스마트폰 카메라 촬영 방향(EXIF 메타데이터)에 의해 원본 이미지와 터치 박스 좌표가 어긋나는 문제를 방지하기 위해, 원본 이미지 자체의 픽셀 방향을 정렬하는 전처리 모듈을 탑재했습니다.
* **터치 영역 세밀 조정 (Padding Margin)**: 미세한 좌표 밀림이나 텍스트 가장자리가 잘리는 현상을 보완하기 위해 터치 박스 주변에 일정한 안전 여백(Padding)을 적용하여 원활한 사용자 경험을 제공합니다.

### 2. 💡 한국어 맞춤 번역 & 현지 식문화 가이드
* **자연스러운 현지화 번역**: 단순히 사전적인 직역 대신, 한국인이 이해하기 쉬운 보편적인 한글 메뉴 이름으로 변환합니다.
* **풍부한 문화 해설**: 해당 메뉴의 유래, 조리 방식, 식재료 및 대표적인 식감 정보 등을 알기 쉽게 해설합니다.
* **실전 주문 꿀팁**: 맵기 단계 선택 요령, 소스 조합법, 오리지널 먹는 방법 등 현지 식당에서 유용하게 쓸 수 있는 정보를 가이드해 줍니다.

### 3. 🗣️ 개인 맞춤형 주문 문장 생성 & 발음 지원 (TTS)
* **상황별 동적 회화 생성**: 사용자가 탭하여 선택한 메뉴 이름을 기반으로 점원에게 바로 요청할 수 있는 실제 문장(예: *"~을 하나 주세요"*, *“~에서 와사비는 빼주세요”* 등)을 실시간으로 구성합니다.
* **한글 발음 및 뜻 표기**: 일본어 표기와 함께 한국어 한자 독음 및 원어 발음(예: *"코레오 히토츠 쿠다사이"*), 그리고 각 회화의 한국어 번역을 동시에 확인할 수 있습니다.
* **네이티브 TTS (Text-to-Speech)**: 스피커 아이콘을 탭하면 `flutter_tts` 라이브러리를 통해 네이티브 발음이 오디오로 제공되므로 직접 듣고 쉽게 따라 하거나 점원에게 들려줄 수 있습니다.

### 4. 🖼️ 직관적인 대표 음식 이미지 노출
* 사용자가 검색/선택한 음식의 정확한 이해를 돕기 위해, 대표적인 참고용 음식 사진을 띄워줍니다.
* 엉뚱한 이미지가 매칭되지 않도록 검색 최적화 파이프라인을 거쳐 실제 요리에 적합한 고화질 이미지를 렌더링합니다.

### 5. 📂 이모지 커스텀 즐겨찾기 폴더 관리
* **나만의 폴더 구성**: 사용자가 직접 원하는 이름과 이모지(🍱, 🍜, 🍣, 🚇 등)를 매칭하여 즐겨찾기 폴더를 자유롭게 커스터마이징할 수 있습니다.
* **간편한 보관 & 삭제**: 메뉴 분석 화면에서 터치 한 번으로 즐겨찾기에 추가할 수 있으며, 스와이프 제스처를 통해 불필요한 북마크를 즉시 삭제할 수 있습니다.

### 6. 💾 영구 로컬 자동 저장 (Local Persistence)
* `shared_preferences`를 사용하여 사용자가 관리하는 즐겨찾기 폴더, 즐겨찾기 항목 리스트 및 과거 번역 내역(History)이 디바이스 내부에 자동 저장됩니다. 앱을 재부팅해도 소중한 기록이 유실되지 않습니다.

### 7. 🎨 감각적이고 반응성 높은 모던 UI/UX
* **인터랙티브 인트로 스플래시**: 앱 최초 구동 시 브랜드 아이덴티티를 살린 로고와 문구가 화면에 머물렀다가 부드럽게 위로 미끄러져 이동하며 메인 기능들이 서서히 드러나는 고급스러운 화면 연출을 구현했습니다.
* **하모니 테마 & 반응형 다크 모드**: 눈의 피로를 최소화하기 위해 섬세하게 보정된 다크 테마와 세련된 라이트 테마를 탑재했으며, 시스템 설정에 맞춰 자동으로 변환됩니다.

---

## 🏗️ 프로젝트 구조 (Project Directory Structure)

```text
lib/
├── main.dart                       # 앱의 진입점 및 초기화 설정
├── core/
│   └── constants/
│       └── env_keys.dart           # 환경 변수 및 설정 키 정의
├── data/
│   └── models/
│       └── detected_text_block.dart # OCR로 검출된 텍스트 블록의 데이터 모델
├── providers/
│   ├── favorites_provider.dart     # 즐겨찾기 상태 관리 및 로컬 저장소 동기화
│   └── gemini_provider.dart        # Gemini API 호출 및 이미지 분석 상태 관리
└── screens/
    ├── home_screen.dart            # 메인 홈 화면 (카메라 촬영, 갤러리 불러오기 및 인트로 애니메이션)
    ├── text_selection_screen.dart  # 이미지 내 인식된 일본어 영역 선택 화면
    ├── result_screen.dart          # 음식 설명, 추천 예문, TTS 및 즐겨찾기 등록 화면
    ├── favorites_screen.dart       # 이모지 폴더별 즐겨찾기 관리 화면
    └── history_screen.dart         # 최근에 스캔한 번역 내역 확인 화면
```

---

## 🛠️ 기술 스택 (Tech Stack)

* **Cross-Platform Framework**: Flutter (Dart SDK `^3.12.1`)
* **State Management**: Flutter Riverpod (`^2.5.1`) — 비즈니스 로직 분리 및 상태 모니터링 최적화
* **AI & Machine Learning**: Google Gemini API (`google_generative_ai ^0.4.0`) — OCR 영역 검출 및 가이드 제공
* **Text-to-Speech**: `flutter_tts ^4.2.5` — 원어 발음 안내
* **Local Storage**: `shared_preferences ^2.5.5` — 오프라인 영구 저장 구현
* **Environment Configuration**: `flutter_dotenv ^5.1.0` — API Key 안전 관리
* **CI/CD & Deployment**: GitHub Actions & GitHub Pages (Web 자동 호스팅 배포 연동)

---

## 🚀 시작하기 & 빌드 가이드 (Getting Started & Build Guide)

### 1. 사전 요구사항 (Prerequisites)
* 디바이스에 설치된 [Flutter SDK](https://docs.flutter.dev/get-started/install)
* Google AI Studio에서 발급받은 [Gemini API Key](https://aistudio.google.com/)

### 2. 환경 변수 설정
프로젝트 루트 디렉토리에 `.env` 파일을 생성하고 발급받은 Gemini API 키를 작성해 줍니다.
```env
GEMINI_API_KEY=your_actual_gemini_api_key_here
```
> **주의**: `.env` 파일은 민감한 정보를 담고 있으므로 절대 버전 관리 시스템(Git)에 노출되지 않도록 주의하십시오. (.gitignore에 기본 등록되어 있습니다.)

### 3. 패키지 설치 및 로컬 실행
```bash
# 의존성 패키지 내려받기
flutter pub get

# 로컬 시뮬레이터/디바이스에서 실행
flutter run
```

---

## 📦 플랫폼별 빌드 방법 (Production Build)

### 🤖 Android (APK Build)
배포 및 설치 가능한 단일 APK 파일을 생성합니다.
```bash
flutter build apk --release
```
* **결과물 경로:** `build/app/outputs/flutter-apk/app-release.apk`
* 기기에 직접 복사하거나 Google Play Console에 업로드하여 배포할 수 있습니다.

### 🍎 iOS (IPA Build)
Xcode 빌드를 거쳐 테스트 및 배포용 IPA 패키지를 만듭니다. 개발 환경 테스트 목적이라면 **Development(개발자용) 배포 방법**을 통해 아래와 같이 생성할 수 있습니다.
```bash
flutter build ipa --export-method=development
```
* **결과물 경로:** `build/ios/ipa/Runner.ipa`
* 정식 App Store 릴리즈를 위해서는 Xcode 프로젝트에서 올바른 iOS Distribution 인증서 및 Bundle Identifier (`com.example` 외의 고유 식별자)를 등록하고 `flutter build ipa` 명령을 실행해야 합니다.

### 🌐 Web (GitHub Pages Deployment)
본 프로젝트는 GitHub Actions 워크플로우를 활용하여 자동 빌드 및 배포가 구성되어 있습니다.
* **CI/CD 설정 파일:** `.github/workflows/deploy.yml`
* `main` 브랜치에 푸시하면 자동으로 빌드되어 지정된 GitHub Pages 도메인으로 배포됩니다.
* **설정 방법**: 해당 레포지토리의 **Settings -> Pages -> Build and deployment -> Source** 항목을 **`GitHub Actions`**로 지정해 주시면 작동합니다.
