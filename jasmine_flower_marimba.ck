// ==============================
// Jasmine Flower (茉莉花)
// Traditional Chinese Folk Song - Marimba Version
// ==============================

// Audio setup - Multiple sine waves for warm marimba tone
SinOsc fund => ADSR env => Gain mix => JCRev reverb => dac;
SinOsc harm2 => env;
SinOsc harm3 => env;
TriOsc harm4 => env;

// Mixing for warm, woody marimba sound
0.6 => fund.gain;
0.25 => harm2.gain;
0.15 => harm3.gain;
0.08 => harm4.gain;

0.25 => reverb.mix;
0.8 => mix.gain;

// Marimba envelope (quick attack, medium-fast decay, no sustain)
env.set(2::ms, 150::ms, 0.0, 200::ms);

// Tempo
100 => float bpm;
(60.0 / bpm)::second => dur beat;
beat / 2 => dur eighth;

// Jasmine Flower melody - middle register for marimba
[
    60, 60, 63, 65, 63, 60,    // C C Eb F# Eb C
    56, 58, 60, 61, 60,        // Ab Bb C Db C
    56, 58, 60, 56, 65, 63,    // Ab Bb C Ab F# Eb
    60, 63, 65, 68, 65, 63, 60 // C Eb F# Ab F# Eb C
] @=> int notes[];

// Note durations (in eighths)
[
    2, 2, 2, 2, 2, 4,          // phrase 1
    2, 2, 2, 2, 4,             // phrase 2
    2, 2, 2, 2, 2, 4,          // phrase 3
    2, 2, 2, 2, 2, 2, 4        // phrase 4
] @=> int durations[];

// Play the melody with marimba
fun void playMelody() {
    <<< "Playing Jasmine Flower (茉莉花) with marimba..." >>>;

    for(0 => int i; i < notes.size(); i++) {
        // Base frequency
        Std.mtof(notes[i]) => float baseFreq;

        // Set harmonics for woody marimba timbre
        baseFreq => fund.freq;
        baseFreq * 4.0 => harm2.freq;  // 2 octaves up
        baseFreq * 10.0 => harm3.freq; // inharmonic for wood character
        baseFreq * 16.0 => harm4.freq; // high partials

        // Strike with varied intensity
        env.keyOn();

        // Let note decay naturally with timing variation
        Math.random2f(-0.04, 0.06) => float timing;
        (durations[i] * eighth) * (1.0 + timing) => dur noteDuration;

        // Subtle breath at phrase endings
        if(i == 5 || i == 10 || i == 16 || i == 23) {
            noteDuration + (eighth * 0.25) => noteDuration;
        }

        noteDuration => now;
    }

    // Final resonance
    beat => now;

    <<< "Melody complete!" >>>;
}

// Play once
playMelody();
