
window.SpeechRecognition = webkitSpeechRecognition || window.SpeechRecognition;
const synth = window.speechSynthesis;
recognition = new SpeechRecognition();
recognition.interimResults = true;

function speak(action) {
    const utterThis = new SpeechSynthesisUtterance(action);
    synth.speak(utterThis);
  };

function dictate() {
    recognition.stop();
    recognition.start();
    recognition.onresult = (event) => {
        const speechToText = event.results[0][0].transcript;
        console.log(speechToText);
        
        if (event.results[0].isFinal) {
            console.log(event.results[0][0].transcript);
        }
    };
    };

window.logger = (flutter_value) => {
   console.log({ js_context: this, flutter_value });
}