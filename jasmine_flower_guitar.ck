// ==============================
// Jasmine Flower (茉莉花)
// Traditional Chinese Folk Song - Guitar Version
// ==============================

// Audio setup - STK StifKarp (Karplus-Strong plucked string = classic guitar sound)
StifKarp guitar => LPF filter => JCRev reverb => dac;

0.25 => reverb.mix;
0.6 => guitar.gain;

// Filter for warmer, mellower tone
1200 => filter.freq;
1.0 => filter.Q;

// Guitar parameters for warm, mellow acoustic sound
0.6 => guitar.pickupPosition;  // further from bridge = warmer, less twang
0.7 => guitar.sustain;         // longer sustain for smoother sound
0.85 => guitar.stretch;        // softer, more realistic string behavior

// Tempo
100 => float bpm;
(60.0 / bpm)::second => dur beat;
beat / 2 => dur eighth;

// Jasmine Flower melody in MIDI notes (lower register for guitar)
[
    48, 48, 51, 53, 51, 48,    // E E G A G E (a bit lower)
    44, 46, 48, 49, 48,        // C D E F E
    44, 46, 48, 44, 53, 51,    // C D E C A G
    48, 51, 53, 56, 53, 51, 48 // E G A C A G E
] @=> int notes[];

// Note durations (in eighths)
[
    2, 2, 2, 2, 2, 4,          // phrase 1
    2, 2, 2, 2, 4,             // phrase 2
    2, 2, 2, 2, 2, 4,          // phrase 3
    2, 2, 2, 2, 2, 2, 4        // phrase 4
] @=> int durations[];

// Play the melody with human feel
fun void playMelody() {
    <<< "Playing Jasmine Flower (茉莉花) with guitar..." >>>;

    for(0 => int i; i < notes.size(); i++) {
        // Set frequency
        Std.mtof(notes[i]) => guitar.freq;

        // Vary pluck strength for expression
        // Longer notes = softer, shorter notes = bit stronger
        if(durations[i] >= 3) {
            Math.random2f(0.5, 0.7) => guitar.pluck;  // gentle on long notes
        } else {
            Math.random2f(0.6, 0.85) => guitar.pluck;  // varied on short notes
        }

        // Add subtle timing variation (rubato - human imperfection)
        Math.random2f(-0.05, 0.08) => float timing;
        (durations[i] * eighth) * (1.0 + timing) => dur noteDuration;

        // Slight pause at phrase endings (natural breathing)
        if(i == 5 || i == 10 || i == 16 || i == 23) {
            noteDuration + (eighth * 0.3) => noteDuration;
        }

        // Let note ring with human timing
        noteDuration => now;
    }

    // Final ring out
    beat * 1.5 => now;

    <<< "Melody complete!" >>>;
}

// Play once
playMelody();
