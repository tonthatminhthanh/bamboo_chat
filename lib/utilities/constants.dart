const double BUTTON_WIDTH = 150.0;
const double BUTTON_HEIGHT = 40.0;
const String DEFAULT_AVATAR = "https://firebasestorage.googleapis.com/v0/b/"
    "bamboochat-79a3f.appspot.com/o/Images%2FAvatars%2Fblank_avatar.png"
    "?alt=media&token=3e715ea3-595f-431e-ba36-dc4a7b377e39";
RegExp password_regex
= RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@!%*#?&_])[A-Za-z\d@!%*#?&_]{8,}$');