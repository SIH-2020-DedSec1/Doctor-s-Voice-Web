
window.SpeechRecognition = webkitSpeechRecognition || window.SpeechRecognition;
recognition = new SpeechRecognition();
recognition.interimResults = false;


var dictateFunction =  () {
    recognition.stop();
    recognition.start();
    recognition.onresult = (event) => {
        if (event.results[0].isFinal) {
            console.log(event.results[0][0].transcript);
            transcription = event.results[0][0].transcript;
            return transcription;
        }   
    };
};

window.logger = (flutter_value) => {
   console.log({ js_context: this, flutter_value });
}


