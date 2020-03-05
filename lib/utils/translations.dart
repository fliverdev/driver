String onboardingPageHeading(String language) {
  if (language == 'en') {
    return 'Find Customers!';
  } else if (language == 'hi') {
    return 'भाड़ा ढूंढे!';
  } else if (language == 'mr') {
    return 'भाड़ा शोध!';
  } else {
    return 'Translation error';
  }
}

String onboardingPageTitle1(String language) {
  if (language == 'en') {
    return 'How does it work?';
  } else if (language == 'hi') {
    return 'यह कैसे काम करता है?';
  } else if (language == 'mr') {
    return 'हे कसे काम करते?';
  } else {
    return 'Translation error';
  }
}

String onboardingPageTitle1Body1(String language) {
  if (language == 'en') {
    return 'Find out where Riders are waiting for Rickshaws';
  } else if (language == 'hi') {
    return 'पास में सवार का पता लगाएँ और उनकी ओर दिशाएँ प्राप्त करें';
  } else if (language == 'mr') {
    return 'झवळच्या भाडा ना शोध आणि त्यांच्या काढे जायचा रस्ता पण';
  } else {
    return 'Translation error';
  }
}

String onboardingPageTitle2(String language) {
  if (language == 'en') {
    return 'How do I get to know?';
  } else if (language == 'hi') {
    return 'मुझे कैसे सूचित किया जाएगा?';
  } else if (language == 'mr') {
    return 'मला कसे सूचित केले जाईल?';
  } else {
    return 'Translation error';
  }
}

String onboardingPageTitle2Body2(String language) {
  if (language == 'en') {
    return 'When new Riders mark their location, you will get notified.';
  } else if (language == 'hi') {
    return 'जैसे ही नए सवार चिह्नित किए जाएंगे हम आपको एक नोटिफिकेशन भेज देंगे';
  } else if (language == 'mr') {
    return 'नवीन रायडर्स चिन्हांकित होताच आम्ही आपल्याला एक सूचना पाठवू';
  } else {
    return 'Translation error';
  }
}

String onboardingPageTitle3(String language) {
  if (language == 'en') {
    return 'Is it free?';
  } else if (language == 'hi') {
    return 'क्या यह मुफ्त है?';
  } else if (language == 'mr') {
    return 'हे विनामूल्य आहे का?';
  } else {
    return 'Translation error';
  }
}

String onboardingPageTitle3Body3(String language) {
  if (language == 'en') {
    return 'Yes, it is completely free!';
  } else if (language == 'hi') {
    return 'हाँ, यह एप्लिकेशन पूरी तरह से मुक्त है!';
  } else if (language == 'mr') {
    return 'होय हा, अँप ऑटो चालकों वापरणे पूर्णपणे विनामूल्य आहे!';
  } else {
    return 'Translation error';
  }
}

String onboardingPageButton(String language) {
  if (language == 'en') {
    return 'Let\'s Go!';
  } else if (language == 'hi') {
    return 'शुरू करो';
  } else if (language == 'mr') {
    return 'सुरु करू!';
  } else {
    return 'Translation error';
  }
}

String shareButton(String language) {
  if (language == 'en') {
    return 'Share';
  } else if (language == 'hi') {
    return 'शेयर';
  } else if (language == 'mr') {
    return 'सामायिक';
  } else {
    return 'Translation error';
  }
}

String chat(String language) {
  if (language == 'en') {
    return 'Chat';
  } else if (language == 'hi') {
    return 'बातचीत';
  } else if (language == 'mr') {
    return 'गप्पा';
  } else {
    return 'Translation error';
  }
}

String loadingMessages(String language) {
  if (language == 'en') {
    return 'Loading messages...';
  } else if (language == 'hi') {
    return 'लोड हो रहा है...';
  } else if (language == 'mr') {
    return 'लोड करीत आहे...';
  } else {
    return 'Translation error';
  }
}

String messagePlaceholderText(String language) {
  if (language == 'en') {
    return 'Talk to others';
  } else if (language == 'hi') {
    return 'दूसरों से बात करें';
  } else if (language == 'mr') {
    return 'इतरांशी बोला';
  } else {
    return 'Translation error';
  }
}

String sendMessageText(String language) {
  if (language == 'en') {
    return 'Send message';
  } else if (language == 'hi') {
    return 'मेसेज भेजें';
  } else if (language == 'mr') {
    return 'संदेश पाठवा';
  } else {
    return 'Translation error';
  }
}

String recenter(String language) {
  if (language == 'en') {
    return 'Recenter';
  } else if (language == 'hi') {
    return 'रेसेण्टर';
  } else if (language == 'mr') {
    return 'रेसेण्टर';
  } else {
    return 'Translation error';
  }
}

String noConnection(String language) {
  if (language == 'en') {
    return 'Oops...there\'s no Internet!';
  } else if (language == 'hi') {
    return 'इंटरनेट नहीं है!';
  } else if (language == 'mr') {
    return 'इंटरनेट नाही आहे!';
  } else {
    return 'Translation error';
  }
}

String fetchingLocation(String language) {
  if (language == 'en') {
    return 'Fetching location...';
  } else if (language == 'hi') {
    return 'आपका लोकेशन ढूंढ रहे है...';
  } else if (language == 'mr') {
    return 'आपले लोकेशन शोधत आहे...';
  } else {
    return 'Translation error';
  }
}

String markerTextDestination(String language, String destination) {
  if (language == 'en') {
    return 'Going to $destination';
  } else if (language == 'hi') {
    return '$destination जा रहा हैं';
  } else if (language == 'mr') {
    return '$destination जाता आहे';
  } else {
    return 'Translation error';
  }
}

String markerTextLooking(String language) {
  if (language == 'en') {
    return 'Looking for a Rickshaw';
  } else if (language == 'hi') {
    return 'ऑटो की तलाश में हैं';
  } else if (language == 'mr') {
    return 'ऑटो शोधत आहे';
  } else {
    return 'Translation error';
  }
}
