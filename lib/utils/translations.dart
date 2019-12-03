String onboardingPage2Heading(String language) {
  if (language == 'en') {
    return 'Find Customers!';
  } else if (language == 'hi') {
    return 'Bhada Dhundo!';
  } else if (language == 'mr') {
    return 'Bhadacha Dhundhacha!';
  } else {
    return 'Translation error';
  }
}
