// ==============================
// Jasmine Flower (茉莉花)
// Traditional Chinese Folk Song
// ==============================

Bowed bow => NRev reverb => dac;

0.08 => reverb.mix;
0.8 => bow.gain;


0.5 => bow.bowPressure;     // lighter pressure for smoother tone
0.35 => bow.bowPosition;    // closer to bridge for brighter, more focused sound
0.8 => bow.vibratoFreq;     // vibrato rate
0.03 => bow.vibratoGain;    // vibrato depth

0.0 => float vibratoDepth;

// Tempo
100 => float bpm;
(60.0 / bpm)::second => dur beat;
beat / 2 => dur eighth;
beat / 4 => dur sixteenth;

// Jasmine Flower melody in MIDI notes (C major, starting on E)
// The traditional melody
[
    64, 64, 67, 69, 67, 64,    // E E G A G E
    60, 62, 64, 65, 64,        // C D E F E
    60, 62, 64, 60, 69, 67,    // C D E C A G
    64, 67, 69, 72, 69, 67, 64 // E G A C A G E
] @=> int notes[];

// Note durations (in eighths)
[
    2, 2, 2, 2, 2, 4,          // phrase 1
    2, 2, 2, 2, 4,             // phrase 2
    2, 2, 2, 2, 2, 4,          // phrase 3
    2, 2, 2, 2, 2, 2, 4        // phrase 4
] @=> int durations[];

// Play the melody with physical bowed string model
fun void playMelody() {
    <<< "Playing Jasmine Flower (茉莉花) with bowed string model..." >>>;

    for(0 => int i; i < notes.size(); i++) {
        // Set frequency
        Std.mtof(notes[i]) => bow.freq;

        // Adjust vibrato based on note length
        if(durations[i] >= 3) {
            6.0 => bow.vibratoFreq;
            0.04 => bow.vibratoGain;  // more vibrato on long notes
        } else {
            5.0 => bow.vibratoFreq;
            0.015 => bow.vibratoGain;  // subtle on short notes
        }

        // Start bowing (velocity/intensity)
        0.8 => bow.noteOn;

        // Hold the note
        (durations[i] * eighth) - 80::ms => now;

        // Stop bowing
        1.0 => bow.noteOff;

        // Brief silence between notes
        80::ms => now;
    }

    <<< "Melody complete!" >>>;
}

// Play once
playMelody();
