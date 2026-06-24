# 🇯🇵 TabiLenS (타비렌즈)
> **일본 여행자를 위한 실시간 메뉴판 글씨 번역, 문화 가이드 및 주문 도우미 서비스**

TabiLenS는 일본 현지에서 메뉴판을 읽기 힘들어하는 한국인 여행자들을 위해 개발된 Flutter 기반의 모바일/웹 어플리케이션입니다. 단순한 글씨 번역을 넘어 음식의 유래, 맛의 특징, 그리고 매장에서 바로 활용할 수 있는 상황별 일본어 주문 회화와 발음 듣기(TTS) 기능까지 한눈에 제공합니다.

---

## ✨ 주요 기능 (Key Features)

### 1. 🔍 AI 기반 일본어 영역 인식 (OCR & Object Detection)
* **스마트 영역 검출**: 카메라 촬영 또는 갤러리 이미지 속 일본어 단어(세로쓰기, 손글씨, 간판 포함)를 Gemini 2.5 Flash를 이용해 감지하고 터치하기 쉬운 박스로 띄워줍니다.
* **EXIF 회전 보정**: 스마트폰 방향 정보(EXIF)로 인해 글씨 영역과 박스 위치가 어긋나지 않도록 이미지 픽셀 단위를 전처리하여 완벽한 좌표 정렬을 구현했습니다.
* **터치 영역 최적화**: 미세한 좌표 밀림 및 크롭 방지를 위해 상하좌우 안전 패딩 마진(Padding Margin)을 적용하여 터치 편의성을 높였습니다.

### 2. 💡 한국어 번역 & 일본 문화 해설
* **자연스러운 번역**: 어색한 기계 번역 대신 한국인 입맛과 정서에 맞는 자연스러운 한국어 메뉴 명칭을 제안합니다.
* **문화적 해설**: 해당 메뉴의 유래, 맛의 특징, 식재료 및 식감 정보와 같은 풍부한 가이드라인을 제공합니다.
* **실전 이용 꿀팁**: 맵기 조절, 소스 조합, 먹는 방법 등 현지 매장에서 알아두면 유용한 정보를 함께 제공합니다.

### 3. 🗣️ 현지 맞춤형 예문 & 발음 듣기 (TTS)
* **상황 맞춤 주문 회화**: 선택한 메뉴를 활용해 점원에게 바로 요청할 수 있는 실제 회화 문장(예: *"~을 하나 주세요"*, *“~은 빼주세요”* 등)을 동적으로 생성합니다.
* **발음 및 뜻 표기**: 일본어 원문, 한국어 한자 발음(예: *"코레오 히토츠 쿠다사이"*), 그리고 번역 결과를 동시에 제공합니다.
* **TTS 음성 지원**: 오디오 아이콘을 탭하면 `flutter_tts` 엔진을 통해 원어민 발음으로 직접 음성을 듣고 따라 할 수 있습니다.

### 4. 🖼️ 메뉴 대표 참고 사진 노출
* 사용자가 선택한 단어를 분석하여, 해당 요리/대상을 표현하는 가장 최적의 고화질 대표 참고 사진을 화면에 보여줍니다.
* 이미지 검색 키워드 최적화를 통해 엉뚱한 비음식 사진이 나오는 현상을 차단했습니다.

### 5. 📂 이모지 즐겨찾기 폴더 관리
* **개인화된 폴더 생성**: 사용자가 직접 원하는 폴더 이름과 이모지 아이콘(🍱, 🍜, 🍣, 🚇 등)을 골라 커스텀 폴더를 생성할 수 있습니다.
* **즐겨찾기 저장/삭제**: 분석 결과 화면에서 우측 상단 별표(⭐)를 통해 바로 즐겨찾기 폴더에 추가할 수 있으며, 스와이프 제스처를 통해 간편하게 삭제할 수 있습니다.

### 6. 💾 껐다 켜도 안전한 로컬 자동 저장
* `shared_preferences`를 사용해 앱을 완전히 종료했다가 다시 실행해도 **즐겨찾기 폴더 구성, 즐겨찾기 목록, 지난 번역 기록(History)**이 사라지지 않고 유지됩니다.

### 7. 🎨 세련된 디자인 및 입체적 애니메이션
* **스플래시 인트로**: 첫 구동 시 로고와 타이틀이 화면 중앙에 1.2초간 머무른 후, 상단으로 부드럽게 올라가며 나머지 조작 버튼들이 순차적으로 나타나는 인터랙티브 인트로 애니메이션을 제공합니다.
* **다크/라이트 모드**: 시스템 설정에 맞추어 자동으로 전환되는 완성도 높은 반응형 UI 테마를 제공합니다.

---

## 🛠️ 기술 스택 (Tech Stack)

* **Framework**: Flutter (Dart)
* **State Management**: Flutter Riverpod
* **AI Engine**: Google Gemini API (`google_generative_ai`)
* **Local Database**: SharedPreferences
* **Hardware Interop**: Image Picker (Camera & Gallery), Flutter TTS (Text-to-Speech)
* **CI/CD & Deployment**: GitHub Actions (GitHub Pages Web 호스팅 자동화)

---

## 🚀 시작하기 (Getting Started)

### Prerequisites

이 앱을 실행하고 빌드하기 위해서는 [Flutter SDK](https://docs.flutter.dev/get-started/install)가 필요하며, Gemini API 호출을 위해 Google AI Studio 키가 필요합니다.

### 1. 환경 설정 (.env)
프로젝트 루트 디렉토리에 `.env` 파일을 생성하고 본인의 Gemini API Key를 작성해 줍니다.
```env
GEMINI_API_KEY=your_actual_gemini_api_key_here
```

### 2. 패키지 설치
의존성 라이브러리를 설치합니다.
```bash
flutter pub get
```

### 3. 로컬 실행
```bash
flutter run
```

---

## 🌐 웹 배포 및 CI/CD (GitHub Pages)

본 프로젝트는 GitHub Actions를 통해 `main` 브랜치에 코드가 푸시되면 자동으로 빌드되어 GitHub Pages 웹 버전으로 배포됩니다.
* **설정 파일**: [deploy.yml](file:///Users/yijoohyoung/Documents/Python_Workspace/DetectAndExplain/.github/workflows/deploy.yml)
* **배포 설정 주의사항**:
  - GitHub Pages 서비스 제공을 위해 레포지토리의 **Settings -> Pages -> Build and deployment -> Source** 설정을 **`GitHub Actions`**로 선택해주시기 바랍니다.
