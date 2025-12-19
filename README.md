# Personal Portfolio

A beautiful, responsive personal portfolio built with Flutter for cross-platform deployment (Web, Mobile, Desktop).

## Features

- **Hero Section**: Animated typing effect with elegant welcome screen
- **About Me**: Profile image with skills badges and bio
- **Experience Timeline**: Vertical timeline with glowing animated circles
- **Education Timeline**: Similar elegant timeline for academic background
- **Projects Carousel**: Horizontal swipeable cards with smooth page indicator
- **Contact Section**: Contact cards and social media links
- **Responsive Design**: Optimized for mobile, tablet, and desktop

## Design

- Dark theme with gold/amber accents
- Elegant typography using Cormorant Garamond font
- Smooth animations and hover effects
- Glassmorphism-inspired cards

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/personal-portfolio.git
cd personal-portfolio
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# For web
flutter run -d chrome

# For mobile (iOS/Android)
flutter run

# For desktop
flutter run -d macos  # or windows/linux
```

### Build for Production

```bash
# Web
flutter build web --release

# Android
flutter build apk --release

# iOS
flutter build ios --release

# macOS
flutter build macos --release
```

## Customization

### Personal Information

Edit the following files to add your information:

1. **About Section** (`lib/sections/about_section.dart`):
   - Update name, title, and bio
   - Replace profile image
   - Modify skills badges

2. **Experience Section** (`lib/sections/experience_section.dart`):
   - Add your work experience entries

3. **Education Section** (`lib/sections/education_section.dart`):
   - Add your educational background

4. **Projects Section** (`lib/sections/projects_section.dart`):
   - Add your project cards with images and descriptions

5. **Contact Section** (`lib/sections/contact_section.dart`):
   - Update email, location, and social links

### Theme Customization

Edit `lib/theme/app_theme.dart` to change:
- Colors (primary, accent, background)
- Typography
- Spacing and sizing

### Adding Profile Image

1. Add your image to `assets/images/`
2. Update `lib/sections/about_section.dart` to use:
```dart
Image.asset('assets/images/your-photo.jpg')
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── pages/
│   └── portfolio_page.dart   # Main portfolio page
├── sections/
│   ├── hero_section.dart     # Hero/landing section
│   ├── about_section.dart    # About me section
│   ├── experience_section.dart
│   ├── education_section.dart
│   ├── projects_section.dart
│   ├── contact_section.dart
│   └── footer_section.dart
├── widgets/
│   ├── glowing_timeline.dart # Timeline component
│   ├── project_card.dart     # Project card component
│   └── section_header.dart   # Section header component
└── theme/
    └── app_theme.dart        # Theme configuration
```

## Dependencies

- `google_fonts`: Beautiful typography
- `font_awesome_flutter`: Social media icons
- `url_launcher`: Open links
- `smooth_page_indicator`: Page indicator for carousel
- `animated_text_kit`: Typing animation effect

## Deployment to GitHub Pages

1. Build the web version:
```bash
flutter build web --release --base-href /your-repo-name/
```

2. Deploy the `build/web` folder to GitHub Pages

## License

MIT License - feel free to use this template for your own portfolio!

## Credits

Built with Flutter


