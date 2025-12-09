#pragma magic [ 50 52 ] @ 0x02
#pragma magic [ 53 56 5a 61 ] @ 0x00

#pragma description Roland Structured Storage files (MC/MV/SH-4d/Zencore SVz/Fantom)

#pragma pattern_limit 10000000

#pragma endian little

//
// Version 1, 1/12/2025
//
// Pattern for Roland Structured Storage (as I call it)
// Structure is seen on MC/MV/SH-4d/Fantom (well 6 and 06) not seen others.
// Its going to be slow for MC/MV due to size (10 seconds ish on my 9700X)
//
// support/releases on discord https://discord.gg/7tbkX7rAGQ
//
//

import std.io;
import std.sys;
import std.Array;
import type.base;

using h32 = type::Hex<u32>;
using h16 = type::Hex<u16>;
using h8 = type::Hex<u8>;


//========================= pulled in from zen decode xml
struct PCMT_CMN {      // byte length 64
    char  NAME[16];
    u8    CATEGORY;                // Category (0 to 50) 
    padding[1];
    u16   PHRASE;                  // Reserved (0 to 0) 
    u8    LEVEL;                   // Level (0 to 127) 
    s8    PAN;                     // Pan (-64 to 63) 
    padding[2];
    u8    PRIORITY;                // Priority (0 to 1) 
    s8    PIT_CRS;                 // Tone Coarse Tune (-48 to 48) 
    s8    PIT_FINE;                // Tone Fine Tune (-50 to 50) 
    s8    OCTAVE;                  // Octave Shift (-3 to 3) 
    u8    STRETCH;                 // Stretch Tune Depth (0 to 3) 
    u8    ANALOG_FEEL;             // Analog Feel (0 to 127) 
    u8    MONO_POLY;               // Mono/Poly (0 to 1) 
    u8    LEGATO_SW;               // Legato Switch (0 to 1) 
    u8    RETRIG_INTVL;            // Legato Retrigger Interval (0 to 13) 
    u8    PORTA_SW;                // Portamento Switch (0 to 1) 
    u8    PORTA_MODE;              // Portamento Mode (0 to 1) 
    u8    PORTA_TYPE;              // Portamento Type (0 to 1) 
    padding[1];
    u8    PORTA_START;             // Portamento Start (0 to 1) 
    u16   PORTA_TIME;              // Portamento Time (0 to 1023) 
    u8    BEND_RANGE_UP;           // Bend Range Up (0 to 48) 
    u8    BEND_RANGE_DW;           // Bend Range Down (0 to 48) 
    u8    BEND_MODE;               // Bend Mode (0 to 1) 
    u8    SOFT_LEVEL_SENS;         // Soft Level Sens (0 to 100) 
    u8    PHRASE_OCT;              // Reserved (0 to 0) 
    u8    PHRASE_VEL_RATE;         // Reserved (0 to 0) 
    u8    PHRASE_VEL_SHIFT;        // Reserved (0 to 0) 
    u8    SYMP_DEPTH;              // Reserved (0 to 0) 
    u8    PORTA_CRV;               // Portamento Curve Type (0 to 2) 
    u8    PTL_LFO_LOCK;            // Partial LFO Phase Lock (0 to 1) 
    padding[14];
};
struct PCMS_PMT {      // byte length 36
    u8    STRUCT12;                // Structure1-2 (0 to 4) 
    u8    STRUCT34;                // Structure3-4 (0 to 4) 
    padding[2];
    u8    RING12_LEVEL;            // RING1-2 Level (0 to 127) 
    u8    RING34_LEVEL;            // RING3-4 Level (0 to 127) 
    u8    RING_OSC1_LEVEL;         // RING OSC1 Level (0 to 127) 
    u8    RING_OSC2_LEVEL;         // RING OSC2 Level (0 to 127) 
    u8    RING_OSC3_LEVEL;         // RING OSC3 Level (0 to 127) 
    u8    RING_OSC4_LEVEL;         // RING OSC4 Level (0 to 127) 
    padding[2];
    u16   XMOD12_DEPTH;            // CrossMod1-2 Depth (0 to 10800) 
    u16   XMOD34_DEPTH;            // CrossMod3-4 Depth (0 to 10800) 
    u8    XMOD_OSC1_LEVEL;         // CrossMod OSC1 Level (0 to 127) 
    u8    XMOD_OSC2_LEVEL;         // CrossMod OSC2 Level (0 to 127) 
    u8    XMOD_OSC3_LEVEL;         // CrossMod OSC3 Level (0 to 127) 
    u8    XMOD_OSC4_LEVEL;         // CrossMod OSC4 Level (0 to 127) 
    u8    PTL_PHS_LOCK;            // Partial Phase Lock (0 to 1) 
    u8    XMOD2_12_DEPTH;          // CrossMod2 1-2 Depth (0 to 127) 
    u8    XMOD2_34_DEPTH;          // CrossMod2 3-4 Depth (0 to 127) 
    padding[13];
};
struct PCMT_PTL {      // byte length 124
    u8    LEVEL;                   // Level (0 to 127) 
    padding[1];
    s8    PIT_CRS;                 // Coarse Tune (-48 to 48) 
    s8    PIT_FINE;                // Fine Tune (-50 to 50) 
    u16   PIT_RND;                 // Random Pitch Depth (0 to 1200) 
    s8    PAN;                     // Pan (-64 to 63) 
    u8    PAN_KF;                  // Pan Keyfollow (-100 to 100) 
    u8    PAN_RND;                 // Random Pan Depth (0 to 63) 
    s8    PAN_ALT;                 // Alternate Pan Depth (-64 to 63) 
    u8    ENV_MODE;                // Envelope Mode (0 to 1) 
    u8    DELAY_MODE;              // Delay Mode (0 to 3) 
    u8    DLY_TIME_SYNC;           // DelayTime Sync (0 to 1) 
    u8    DLY_TIME_NOTE;           // DelayTime (note) (0 to 21) 
    u16   DLY_TIME;                // DelayTime (0 to 1023) 
    u8    CHO_SEND;                // Chorus Send Level (0 to 127) 
    u8    REV_SEND;                // Reverb Send Level (0 to 127) 
    u8    RX_BEND;                 // Receive Bender (0 to 1) 
    u8    RX_EXPR;                 // Receive Expression (0 to 1) 
    u8    RX_HOLD;                 // Receive Hold-1 (0 to 1) 
    u8    REDAMP_SW;               // Redamper Switch (0 to 1) 
    u8    OUT_ASGN;                // Output Assign (0 to 1) 
    u8    WAV_GTYPE;               // Wave Group Type (0 to 3) 
    u16   WAV_GID;                 // Wave Group ID (0 to 16383) 
    u16   WAV_NUM_L;               // Wave Number L (0 to 16383) 
    u16   WAV_NUM_R;               // Wave Number R (0 to 16383) 
    u8    WAV_GAIN;                // Gain (0 to 5) 
    u8    FXM_SW;                  // FXM Switch (0 to 1) 
    u8    FXM_COLOR;               // FXM Color (1 to 4) 
    u8    FXM_DEPTH;               // FXM Depth (0 to 16) 
    u16   PIT_KF;                  // Pitch Keyfollow (-200 to 200) 
    u8    SOFT_EQ_SENS;            // Soft EQ Sens (0 to 100) 
    u8    FILTER_TYPE;             // TVF Filter Type (0 to 6) 
    padding[2];
    u16   CUTOFF;                  // TVF Cutoff Frequency (0 to 1023) 
    u16   CUTOFF_KF;               // TVF Cutoff Keyfollow (-200 to 200) 
    u8    CUTOFF_VCRV;             // TVF Cutoff Velocity Curve (0 to 7) 
    u8    CUTOFF_VSENS;            // TVF Cutoff Velocity Sens (-100 to 100) 
    u16   RESO;                    // TVF Resonance (0 to 1023) 
    u8    RESO_VSENS;              // TVF Resonance Velocity Sens (-100 to 100) 
    u8    BIAS_LEVEL;              // Bias Level (-100 to 100) 
    u8    BIAS_POS;                // Bias Position (0 to 127) 
    u8    BIAS_DIR;                // Bias Direction (0 to 3) 
    u8    LEVEL_VCRV;              // TVA Level Velocity Curve (0 to 7) 
    u8    LEVEL_VSENS;             // TVA Level Velocity Sens (-100 to 100) 
    u8    PENV_TKF;                // Pitch Env Time Keyfollow (-100 to 100) 
    u8    FENV_TKF;                // TVF Env Time Keyfollow (-100 to 100) 
    u8    AENV_TKF;                // TVA Env Time Keyfollow (-100 to 100) 
    u8    VIB_PIT_SENS;            // Vibrato Pitch Sens (-100 to 100) 
    u8    VIB_CUT_SENS;            // Vibrato Cutoff Sens (-100 to 100) 
    u8    VIB_AMP_SENS;            // Vibrato Level Sens (-100 to 100) 
    u8    Matrix_Control_1_SRC;    // Matrix Control 1 Source (0 to 108) 
    u8    Matrix_Control_1_DST1;   // Matrix Control 1 Destination 1 (0 to 48) 
    s8    Matrix_Control_1_SENS1;  // Matrix Control 1 Sens 1 (-63 to 63) 
    u8    Matrix_Control_1_DST2;   // Matrix Control 1 Destination 2 (0 to 48) 
    s8    Matrix_Control_1_SENS2;  // Matrix Control 1 Sens 2 (-63 to 63) 
    u8    Matrix_Control_1_DST3;   // Matrix Control 1 Destination 3 (0 to 48) 
    s8    Matrix_Control_1_SENS3;  // Matrix Control 1 Sens 3 (-63 to 63) 
    u8    Matrix_Control_1_DST4;   // Matrix Control 1 Destination 4 (0 to 48) 
    s8    Matrix_Control_1_SENS4;  // Matrix Control 1 Sens 4 (-63 to 63) 
    padding[3];
    u8    Matrix_Control_2_SRC;    // Matrix Control 2 Source (0 to 108) 
    u8    Matrix_Control_2_DST1;   // Matrix Control 2 Destination 1 (0 to 48) 
    s8    Matrix_Control_2_SENS1;  // Matrix Control 2 Sens 1 (-63 to 63) 
    u8    Matrix_Control_2_DST2;   // Matrix Control 2 Destination 2 (0 to 48) 
    s8    Matrix_Control_2_SENS2;  // Matrix Control 2 Sens 2 (-63 to 63) 
    u8    Matrix_Control_2_DST3;   // Matrix Control 2 Destination 3 (0 to 48) 
    s8    Matrix_Control_2_SENS3;  // Matrix Control 2 Sens 3 (-63 to 63) 
    u8    Matrix_Control_2_DST4;   // Matrix Control 2 Destination 4 (0 to 48) 
    s8    Matrix_Control_2_SENS4;  // Matrix Control 2 Sens 4 (-63 to 63) 
    padding[3];
    u8    Matrix_Control_3_SRC;    // Matrix Control 3 Source (0 to 108) 
    u8    Matrix_Control_3_DST1;   // Matrix Control 3 Destination 1 (0 to 48) 
    s8    Matrix_Control_3_SENS1;  // Matrix Control 3 Sens 1 (-63 to 63) 
    u8    Matrix_Control_3_DST2;   // Matrix Control 3 Destination 2 (0 to 48) 
    s8    Matrix_Control_3_SENS2;  // Matrix Control 3 Sens 2 (-63 to 63) 
    u8    Matrix_Control_3_DST3;   // Matrix Control 3 Destination 3 (0 to 48) 
    s8    Matrix_Control_3_SENS3;  // Matrix Control 3 Sens 3 (-63 to 63) 
    u8    Matrix_Control_3_DST4;   // Matrix Control 3 Destination 4 (0 to 48) 
    s8    Matrix_Control_3_SENS4;  // Matrix Control 3 Sens 4 (-63 to 63) 
    padding[3];
    u8    Matrix_Control_4_SRC;    // Matrix Control 4 Source (0 to 108) 
    u8    Matrix_Control_4_DST1;   // Matrix Control 4 Destination 1 (0 to 48) 
    s8    Matrix_Control_4_SENS1;  // Matrix Control 4 Sens 1 (-63 to 63) 
    u8    Matrix_Control_4_DST2;   // Matrix Control 4 Destination 2 (0 to 48) 
    s8    Matrix_Control_4_SENS2;  // Matrix Control 4 Sens 2 (-63 to 63) 
    u8    Matrix_Control_4_DST3;   // Matrix Control 4 Destination 3 (0 to 48) 
    s8    Matrix_Control_4_SENS3;  // Matrix Control 4 Sens 3 (-63 to 63) 
    u8    Matrix_Control_4_DST4;   // Matrix Control 4 Destination 4 (0 to 48) 
    s8    Matrix_Control_4_SENS4;  // Matrix Control 4 Sens 4 (-63 to 63) 
    padding[3];
    u8    DAMP_FREE;               // Damper Free Note (0 to 127) 
    u8    STEREO_WIDTH;            // Stereo Width (0 to 100) 
    s8    STEREO_DETN;             // Stereo Detune (-50 to 50) 
    u8    DF_DCY_OFST;             // Damper Free Decay Offset (-100 to 100) 
    u8    TEMPO_SYNC;              // Wave Tempo Sync (0 to 1) 
    padding[11];
};
struct PTL_PENV {      // byte length 24
    u8    DEPTH;                   // Pitch Env Depth (-100 to 100) 
    u8    VSENS;                   // Pitch Env Velocity Sens (-100 to 100) 
    u8    T1_VSENS;                // Pitch Env T1 Velocity Sens (-100 to 100) 
    u8    T4_VSENS;                // Pitch Env T4 Velocity Sens (-100 to 100) 
    u16   T1;                      // Pitch Env Time1 (0 to 1023) 
    u16   T2;                      // Pitch Env Time2 (0 to 1023) 
    u16   T3;                      // Pitch Env Time3 (0 to 1023) 
    u16   T4;                      // Pitch Env Time4 (0 to 1023) 
    u16   L0;                      // Pitch Env Level0 (-511 to 511) 
    u16   L1;                      // Pitch Env Level1 (-511 to 511) 
    u16   L2;                      // Pitch Env Level2 (-511 to 511) 
    u16   L3;                      // Pitch Env Level3 (-511 to 511) 
    u16   L4;                      // Pitch Env Level4 (-511 to 511) 
    u8    VCRV;                    // Pitch Env Velocity Curve (0 to 7) 
    padding[1];
};
struct PTL_FENV {      // byte length 24
    s8    DEPTH;                   // TVF Env Depth (-63 to 63) 
    u8    VCRV;                    // TVF Env Velocity Curve (0 to 7) 
    u8    VSENS;                   // TVF Env Velocity Sens (-100 to 100) 
    u8    T1_VSENS;                // TVF Env T1 Velocity Sens (-100 to 100) 
    u8    T4_VSENS;                // TVF Env T4 Velocity Sens (-100 to 100) 
    padding[1];
    u16   T1;                      // TVF Env Time1 (0 to 1023) 
    u16   T2;                      // TVF Env Time2 (0 to 1023) 
    u16   T3;                      // TVF Env Time3 (0 to 1023) 
    u16   T4;                      // TVF Env Time4 (0 to 1023) 
    u16   L0;                      // TVF Env Level0 (0 to 1023) 
    u16   L1;                      // TVF Env Level1 (0 to 1023) 
    u16   L2;                      // TVF Env Level2 (0 to 1023) 
    u16   L3;                      // TVF Env Level3 (0 to 1023) 
    u16   L4;                      // TVF Env Level4 (0 to 1023) 
};
struct PTL_AENV {      // byte length 16
    u8    T1_VSENS;                // TVA Env Time1 Velocity Sens (-100 to 100) 
    u8    T4_VSENS;                // TVA Env Time4 Velocity Sens (-100 to 100) 
    u16   T1;                      // TVA Env Time1 (0 to 1023) 
    u16   T2;                      // TVA Env Time2 (0 to 1023) 
    u16   T3;                      // TVA Env Time3 (0 to 1023) 
    u16   T4;                      // TVA Env Time4 (0 to 1023) 
    u16   L1;                      // TVA Env Level1 (0 to 1023) 
    u16   L2;                      // TVA Env Level2 (0 to 1023) 
    u16   L3;                      // TVA Env Level3 (0 to 1023) 
};
struct PTL_LFO {      // byte length 104
    u8    LFO_1_FORM;              // LFO 1 Waveform (0 to 10) 
    u8    LFO_1_RATE_SYNC;         // LFO 1 Rate Sync (0 to 1) 
    u8    LFO_1_RATE_NOTE;         // LFO 1 Rate (note) (0 to 22) 
    u8    LFO_1_STEP_MAX;          // LFO 1 Step Size (0 to 15) 
    u16   LFO_1_RATE;              // LFO 1 Rate (0 to 1023) 
    u8    LFO_1_OFST;              // LFO 1 Offset (-100 to 100) 
    u8    LFO_1_RATE_DETN;         // LFO 1 Rate Detune (0 to 127) 
    u16   LFO_1_DELAY;             // LFO 1 Delay Time (0 to 1023) 
    u8    LFO_1_DELAY_KF;          // LFO 1 Delay Time Keyfolow (-100 to 100) 
    u8    LFO_1_FADE_MODE;         // LFO 1 Fade Mode (0 to 3) 
    u16   LFO_1_FADE;              // LFO 1 Fade Time (0 to 1023) 
    u8    LFO_1_KEY_TRIG;          // LFO 1 Key Trigger (0 to 1) 
    u8    LFO_1_PIT_DEPTH;         // LFO 1 Pitch Depth (-100 to 100) 
    u8    LFO_1_TVF_DEPTH;         // LFO 1 TVF Depth (-100 to 100) 
    u8    LFO_1_TVA_DEPTH;         // LFO 1 TVA Depth (-100 to 100) 
    s8    LFO_1_PAN_DEPTH;         // LFO 1 PAN Depth (-63 to 63) 
    u8    LFO_1_PHASE_POS;         // LFO 1 Phase Position (0 to 3) 
    u8    LFO_1_STEP_1;            // LFO 1 Step 1 (-72 to 72) 
    u8    LFO_1_STEP_2;            // LFO 1 Step 2 (-72 to 72) 
    u8    LFO_1_STEP_3;            // LFO 1 Step 3 (-72 to 72) 
    u8    LFO_1_STEP_4;            // LFO 1 Step 4 (-72 to 72) 
    u8    LFO_1_STEP_5;            // LFO 1 Step 5 (-72 to 72) 
    u8    LFO_1_STEP_6;            // LFO 1 Step 6 (-72 to 72) 
    u8    LFO_1_STEP_7;            // LFO 1 Step 7 (-72 to 72) 
    u8    LFO_1_STEP_8;            // LFO 1 Step 8 (-72 to 72) 
    u8    LFO_1_STEP_9;            // LFO 1 Step 9 (-72 to 72) 
    u8    LFO_1_STEP_10;           // LFO 1 Step 10 (-72 to 72) 
    u8    LFO_1_STEP_11;           // LFO 1 Step 11 (-72 to 72) 
    u8    LFO_1_STEP_12;           // LFO 1 Step 12 (-72 to 72) 
    u8    LFO_1_STEP_13;           // LFO 1 Step 13 (-72 to 72) 
    u8    LFO_1_STEP_14;           // LFO 1 Step 14 (-72 to 72) 
    u8    LFO_1_STEP_15;           // LFO 1 Step 15 (-72 to 72) 
    u8    LFO_1_STEP_16;           // LFO 1 Step 16 (-72 to 72) 
    u8    LFO_1_STEP_CURVE_1;      // LFO 1 Step Curve 1 (0 to 36) 
    u8    LFO_1_STEP_CURVE_2;      // LFO 1 Step Curve 2 (0 to 36) 
    u8    LFO_1_STEP_CURVE_3;      // LFO 1 Step Curve 3 (0 to 36) 
    u8    LFO_1_STEP_CURVE_4;      // LFO 1 Step Curve 4 (0 to 36) 
    u8    LFO_1_STEP_CURVE_5;      // LFO 1 Step Curve 5 (0 to 36) 
    u8    LFO_1_STEP_CURVE_6;      // LFO 1 Step Curve 6 (0 to 36) 
    u8    LFO_1_STEP_CURVE_7;      // LFO 1 Step Curve 7 (0 to 36) 
    u8    LFO_1_STEP_CURVE_8;      // LFO 1 Step Curve 8 (0 to 36) 
    u8    LFO_1_STEP_CURVE_9;      // LFO 1 Step Curve 9 (0 to 36) 
    u8    LFO_1_STEP_CURVE_10;     // LFO 1 Step Curve 10 (0 to 36) 
    u8    LFO_1_STEP_CURVE_11;     // LFO 1 Step Curve 11 (0 to 36) 
    u8    LFO_1_STEP_CURVE_12;     // LFO 1 Step Curve 12 (0 to 36) 
    u8    LFO_1_STEP_CURVE_13;     // LFO 1 Step Curve 13 (0 to 36) 
    u8    LFO_1_STEP_CURVE_14;     // LFO 1 Step Curve 14 (0 to 36) 
    u8    LFO_1_STEP_CURVE_15;     // LFO 1 Step Curve 15 (0 to 36) 
    u8    LFO_1_STEP_CURVE_16;     // LFO 1 Step Curve 16 (0 to 36) 
    u8    LFO_2_FORM;              // LFO 2 Waveform (0 to 10) 
    u8    LFO_2_RATE_SYNC;         // LFO 2 Rate Sync (0 to 1) 
    u8    LFO_2_RATE_NOTE;         // LFO 2 Rate (note) (0 to 22) 
    u8    LFO_2_STEP_MAX;          // LFO 2 Step Size (0 to 15) 
    u16   LFO_2_RATE;              // LFO 2 Rate (0 to 1023) 
    u8    LFO_2_OFST;              // LFO 2 Offset (-100 to 100) 
    u8    LFO_2_RATE_DETN;         // LFO 2 Rate Detune (0 to 127) 
    u16   LFO_2_DELAY;             // LFO 2 Delay Time (0 to 1023) 
    u8    LFO_2_DELAY_KF;          // LFO 2 Delay Time Keyfolow (-100 to 100) 
    u8    LFO_2_FADE_MODE;         // LFO 2 Fade Mode (0 to 3) 
    u16   LFO_2_FADE;              // LFO 2 Fade Time (0 to 1023) 
    u8    LFO_2_KEY_TRIG;          // LFO 2 Key Trigger (0 to 1) 
    u8    LFO_2_PIT_DEPTH;         // LFO 2 Pitch Depth (-100 to 100) 
    u8    LFO_2_TVF_DEPTH;         // LFO 2 TVF Depth (-100 to 100) 
    u8    LFO_2_TVA_DEPTH;         // LFO 2 TVA Depth (-100 to 100) 
    s8    LFO_2_PAN_DEPTH;         // LFO 2 PAN Depth (-63 to 63) 
    u8    LFO_2_PHASE_POS;         // LFO 2 Phase Position (0 to 3) 
    u8    LFO_2_STEP_1;            // LFO 2 Step 1 (-72 to 72) 
    u8    LFO_2_STEP_2;            // LFO 2 Step 2 (-72 to 72) 
    u8    LFO_2_STEP_3;            // LFO 2 Step 3 (-72 to 72) 
    u8    LFO_2_STEP_4;            // LFO 2 Step 4 (-72 to 72) 
    u8    LFO_2_STEP_5;            // LFO 2 Step 5 (-72 to 72) 
    u8    LFO_2_STEP_6;            // LFO 2 Step 6 (-72 to 72) 
    u8    LFO_2_STEP_7;            // LFO 2 Step 7 (-72 to 72) 
    u8    LFO_2_STEP_8;            // LFO 2 Step 8 (-72 to 72) 
    u8    LFO_2_STEP_9;            // LFO 2 Step 9 (-72 to 72) 
    u8    LFO_2_STEP_10;           // LFO 2 Step 10 (-72 to 72) 
    u8    LFO_2_STEP_11;           // LFO 2 Step 11 (-72 to 72) 
    u8    LFO_2_STEP_12;           // LFO 2 Step 12 (-72 to 72) 
    u8    LFO_2_STEP_13;           // LFO 2 Step 13 (-72 to 72) 
    u8    LFO_2_STEP_14;           // LFO 2 Step 14 (-72 to 72) 
    u8    LFO_2_STEP_15;           // LFO 2 Step 15 (-72 to 72) 
    u8    LFO_2_STEP_16;           // LFO 2 Step 16 (-72 to 72) 
    u8    LFO_2_STEP_CURVE_1;      // LFO 2 Step Curve 1 (0 to 36) 
    u8    LFO_2_STEP_CURVE_2;      // LFO 2 Step Curve 2 (0 to 36) 
    u8    LFO_2_STEP_CURVE_3;      // LFO 2 Step Curve 3 (0 to 36) 
    u8    LFO_2_STEP_CURVE_4;      // LFO 2 Step Curve 4 (0 to 36) 
    u8    LFO_2_STEP_CURVE_5;      // LFO 2 Step Curve 5 (0 to 36) 
    u8    LFO_2_STEP_CURVE_6;      // LFO 2 Step Curve 6 (0 to 36) 
    u8    LFO_2_STEP_CURVE_7;      // LFO 2 Step Curve 7 (0 to 36) 
    u8    LFO_2_STEP_CURVE_8;      // LFO 2 Step Curve 8 (0 to 36) 
    u8    LFO_2_STEP_CURVE_9;      // LFO 2 Step Curve 9 (0 to 36) 
    u8    LFO_2_STEP_CURVE_10;     // LFO 2 Step Curve 10 (0 to 36) 
    u8    LFO_2_STEP_CURVE_11;     // LFO 2 Step Curve 11 (0 to 36) 
    u8    LFO_2_STEP_CURVE_12;     // LFO 2 Step Curve 12 (0 to 36) 
    u8    LFO_2_STEP_CURVE_13;     // LFO 2 Step Curve 13 (0 to 36) 
    u8    LFO_2_STEP_CURVE_14;     // LFO 2 Step Curve 14 (0 to 36) 
    u8    LFO_2_STEP_CURVE_15;     // LFO 2 Step Curve 15 (0 to 36) 
    u8    LFO_2_STEP_CURVE_16;     // LFO 2 Step Curve 16 (0 to 36) 
};
struct PTL_EQ {      // byte length 16
    u16   LO_GAIN;                 // EQ Low Gain (-240 to 240) 
    u16   MID_GAIN;                // EQ Mid Gain (-240 to 240) 
    u16   HI_GAIN;                 // EQ High Gain (-240 to 240) 
    u16   LO_FREQ;                 // EQ Low Frequency (20 to 16000) 
    u16   MID_FREQ;                // EQ Mid Frequency (20 to 16000) 
    u16   HI_FREQ;                 // EQ High Frequency (20 to 16000) 
    u8    MID_Q;                   // EQ Mid Q (5 to 160) 
    u8    SW;                      // EQ Switch (0 to 1) 
    padding[2];
};
struct PCMS_CMN {      // byte length 20
    u8    UNISON_SW;               // Unison Switch (0 to 1) 
    u8    UNISON_SIZE;             // Unison Size (2 to 8) 
    u8    UNISON_DETN;             // Unison Detune (0 to 100) 
    padding[1];
    u8    BEND_RANGE_FINE_UP;      // Bend Range Fine Up (0 to 100) 
    u8    BEND_RANGE_FINE_DW;      // Bend Range Fine Down (0 to 100) 
    u8    RND_PIT_VAL;             // Pitch Drift (0 to 255) 
    u8    RND_PIT_NUM;             // Pitch Drift Cycle Number (0 to 8) 
    u8    CONDITION;               // Condition (0 to 100) 
    padding[11];
};
struct PCMT_PMT {      // byte length 52
    u8    VEL_CTRL;                // Velocity Control (0 to 3) 
    u8    PMT_LEVEL_CRV;           // PMT Level Curve (0 to 1) 
    padding[2];
    u8    PMT_1_PTL_SW;            // PMT 1 Partial Switch (0 to 1) 
    padding[3];
    u8    PMT_1_KRANGE_LO;         // PMT 1 KeyRange Lower (0 to 127) 
    u8    PMT_1_KRANGE_UP;         // PMT 1 KeyRange Upper (0 to 127) 
    u8    PMT_1_KFADE_LO;          // PMT 1 KeyFade Lower (0 to 127) 
    u8    PMT_1_KFADE_UP;          // PMT 1 KeyFade Upper (0 to 127) 
    u8    PMT_1_VRANGE_LO;         // PMT 1 VeloRange Lower (1 to 127) 
    u8    PMT_1_VRANGE_UP;         // PMT 1 VeloRange Upper (1 to 127) 
    u8    PMT_1_VFADE_LO;          // PMT 1 VeloFade Lower (0 to 127) 
    u8    PMT_1_VFADE_UP;          // PMT 1 VeloFade Upper (0 to 127) 
    u8    PMT_2_PTL_SW;            // PMT 2 Partial Switch (0 to 1) 
    padding[3];
    u8    PMT_2_KRANGE_LO;         // PMT 2 KeyRange Lower (0 to 127) 
    u8    PMT_2_KRANGE_UP;         // PMT 2 KeyRange Upper (0 to 127) 
    u8    PMT_2_KFADE_LO;          // PMT 2 KeyFade Lower (0 to 127) 
    u8    PMT_2_KFADE_UP;          // PMT 2 KeyFade Upper (0 to 127) 
    u8    PMT_2_VRANGE_LO;         // PMT 2 VeloRange Lower (1 to 127) 
    u8    PMT_2_VRANGE_UP;         // PMT 2 VeloRange Upper (1 to 127) 
    u8    PMT_2_VFADE_LO;          // PMT 2 VeloFade Lower (0 to 127) 
    u8    PMT_2_VFADE_UP;          // PMT 2 VeloFade Upper (0 to 127) 
    u8    PMT_3_PTL_SW;            // PMT 3 Partial Switch (0 to 1) 
    padding[3];
    u8    PMT_3_KRANGE_LO;         // PMT 3 KeyRange Lower (0 to 127) 
    u8    PMT_3_KRANGE_UP;         // PMT 3 KeyRange Upper (0 to 127) 
    u8    PMT_3_KFADE_LO;          // PMT 3 KeyFade Lower (0 to 127) 
    u8    PMT_3_KFADE_UP;          // PMT 3 KeyFade Upper (0 to 127) 
    u8    PMT_3_VRANGE_LO;         // PMT 3 VeloRange Lower (1 to 127) 
    u8    PMT_3_VRANGE_UP;         // PMT 3 VeloRange Upper (1 to 127) 
    u8    PMT_3_VFADE_LO;          // PMT 3 VeloFade Lower (0 to 127) 
    u8    PMT_3_VFADE_UP;          // PMT 3 VeloFade Upper (0 to 127) 
    u8    PMT_4_PTL_SW;            // PMT 4 Partial Switch (0 to 1) 
    padding[3];
    u8    PMT_4_KRANGE_LO;         // PMT 4 KeyRange Lower (0 to 127) 
    u8    PMT_4_KRANGE_UP;         // PMT 4 KeyRange Upper (0 to 127) 
    u8    PMT_4_KFADE_LO;          // PMT 4 KeyFade Lower (0 to 127) 
    u8    PMT_4_KFADE_UP;          // PMT 4 KeyFade Upper (0 to 127) 
    u8    PMT_4_VRANGE_LO;         // PMT 4 VeloRange Lower (1 to 127) 
    u8    PMT_4_VRANGE_UP;         // PMT 4 VeloRange Upper (1 to 127) 
    u8    PMT_4_VFADE_LO;          // PMT 4 VeloFade Lower (0 to 127) 
    u8    PMT_4_VFADE_UP;          // PMT 4 VeloFade Upper (0 to 127) 
};
struct INST_CMN {      // byte length 152
    char  NAME[16];
    u8    CATEGORY;                // Category (0 to 21) 
    u8    LEVEL;                   // Level (0 to 127) 
    u8    SRC_KEY;                 // Source Key (0 to 127) 
    s8    PIT_FINE;                // Fine Tune (-50 to 50) 
    u16   PIT_RND;                 // Random Pitch Depth (0 to 1200) 
    u8    PAN_RND;                 // Random Pan Depth (0 to 63) 
    s8    PAN_ALT;                 // Alternate Pan Depth (-64 to 63) 
    u8    ASGN_TYPE;               // Assign Type (0 to 1) 
    u8    ENV_MODE;                // Envelope Mode (0 to 1) 
    u8    WMT_VEL_CTRL;            // WMT Velocity Control (0 to 2) 
    padding[1];
    u8    WMT_1_SW;                // WMT 1 Wave Switch (0 to 1) 
    u8    WMT_1_WAV_GTYPE;         // WMT 1 Wave Group Type (0 to 2) 
    u16   WMT_1_WAV_GID;           // WMT 1 Wave Group ID (0 to 16383) 
    u16   WMT_1_WAV_NUM_L;         // WMT 1 Wave Number L (0 to 16383) 
    u16   WMT_1_WAV_NUM_R;         // WMT 1 Wave Number R (0 to 16383) 
    u8    WMT_1_WAV_GAIN;          // WMT 1 Wave Gain (0 to 5) 
    u8    WMT_1_FXM_SW;            // WMT 1 Wave FXM Switch (0 to 1) 
    u8    WMT_1_FXM_COLOR;         // WMT 1 Wave FXM Color (1 to 4) 
    u8    WMT_1_FXM_DEPTH;         // WMT 1 Wave FXM Depth (0 to 16) 
    s8    WMT_1_PIT_CRS;           // WMT 1 Wave Coarse Tune (-48 to 48) 
    s8    WMT_1_PIT_FINE;          // WMT 1 Wave Fine Tune (-50 to 50) 
    s8    WMT_1_PAN;               // WMT 1 Wave Pan (-64 to 63) 
    u8    WMT_1_PAN_RND_SW;        // WMT 1 Wave Random Pan Sw (0 to 1) 
    u8    WMT_1_PAN_ALT_SW;        // WMT 1 Wave Alternate Pan Sw (0 to 2) 
    u8    WMT_1_LEVEL;             // WMT 1 Wave Level (0 to 127) 
    padding[1];
    u8    WMT_1_DELAY_MODE;        // WMT 1 Delay Mode (0 to 3) 
    u8    WMT_1_DLY_TIME_SYNC;     // WMT 1 DelayTime Sync (0 to 1) 
    u8    WMT_1_DLY_TIME_NOTE;     // WMT 1 DelayTime (note) (0 to 21) 
    u16   WMT_1_DLY_TIME;          // WMT 1 DelayTime (0 to 1023) 
    u8    WMT_1_VRANGE_LO;         // WMT 1 VeloRange Lower (1 to 127) 
    u8    WMT_1_VRANGE_UP;         // WMT 1 VeloRange Upper (1 to 127) 
    u8    WMT_1_VFADE_LO;          // WMT 1 VeloFade Lower (0 to 127) 
    u8    WMT_1_VFADE_UP;          // WMT 1 VeloFade Upper (0 to 127) 
    u8    WMT_2_SW;                // WMT 2 Wave Switch (0 to 1) 
    u8    WMT_2_WAV_GTYPE;         // WMT 2 Wave Group Type (0 to 2) 
    u16   WMT_2_WAV_GID;           // WMT 2 Wave Group ID (0 to 16383) 
    u16   WMT_2_WAV_NUM_L;         // WMT 2 Wave Number L (0 to 16383) 
    u16   WMT_2_WAV_NUM_R;         // WMT 2 Wave Number R (0 to 16383) 
    u8    WMT_2_WAV_GAIN;          // WMT 2 Wave Gain (0 to 5) 
    u8    WMT_2_FXM_SW;            // WMT 2 Wave FXM Switch (0 to 1) 
    u8    WMT_2_FXM_COLOR;         // WMT 2 Wave FXM Color (1 to 4) 
    u8    WMT_2_FXM_DEPTH;         // WMT 2 Wave FXM Depth (0 to 16) 
    s8    WMT_2_PIT_CRS;           // WMT 2 Wave Coarse Tune (-48 to 48) 
    s8    WMT_2_PIT_FINE;          // WMT 2 Wave Fine Tune (-50 to 50) 
    s8    WMT_2_PAN;               // WMT 2 Wave Pan (-64 to 63) 
    u8    WMT_2_PAN_RND_SW;        // WMT 2 Wave Random Pan Sw (0 to 1) 
    u8    WMT_2_PAN_ALT_SW;        // WMT 2 Wave Alternate Pan Sw (0 to 2) 
    u8    WMT_2_LEVEL;             // WMT 2 Wave Level (0 to 127) 
    padding[1];
    u8    WMT_2_DELAY_MODE;        // WMT 2 Delay Mode (0 to 3) 
    u8    WMT_2_DLY_TIME_SYNC;     // WMT 2 DelayTime Sync (0 to 1) 
    u8    WMT_2_DLY_TIME_NOTE;     // WMT 2 DelayTime (note) (0 to 21) 
    u16   WMT_2_DLY_TIME;          // WMT 2 DelayTime (0 to 1023) 
    u8    WMT_2_VRANGE_LO;         // WMT 2 VeloRange Lower (1 to 127) 
    u8    WMT_2_VRANGE_UP;         // WMT 2 VeloRange Upper (1 to 127) 
    u8    WMT_2_VFADE_LO;          // WMT 2 VeloFade Lower (0 to 127) 
    u8    WMT_2_VFADE_UP;          // WMT 2 VeloFade Upper (0 to 127) 
    u8    WMT_3_SW;                // WMT 3 Wave Switch (0 to 1) 
    u8    WMT_3_WAV_GTYPE;         // WMT 3 Wave Group Type (0 to 2) 
    u16   WMT_3_WAV_GID;           // WMT 3 Wave Group ID (0 to 16383) 
    u16   WMT_3_WAV_NUM_L;         // WMT 3 Wave Number L (0 to 16383) 
    u16   WMT_3_WAV_NUM_R;         // WMT 3 Wave Number R (0 to 16383) 
    u8    WMT_3_WAV_GAIN;          // WMT 3 Wave Gain (0 to 5) 
    u8    WMT_3_FXM_SW;            // WMT 3 Wave FXM Switch (0 to 1) 
    u8    WMT_3_FXM_COLOR;         // WMT 3 Wave FXM Color (1 to 4) 
    u8    WMT_3_FXM_DEPTH;         // WMT 3 Wave FXM Depth (0 to 16) 
    s8    WMT_3_PIT_CRS;           // WMT 3 Wave Coarse Tune (-48 to 48) 
    s8    WMT_3_PIT_FINE;          // WMT 3 Wave Fine Tune (-50 to 50) 
    s8    WMT_3_PAN;               // WMT 3 Wave Pan (-64 to 63) 
    u8    WMT_3_PAN_RND_SW;        // WMT 3 Wave Random Pan Sw (0 to 1) 
    u8    WMT_3_PAN_ALT_SW;        // WMT 3 Wave Alternate Pan Sw (0 to 2) 
    u8    WMT_3_LEVEL;             // WMT 3 Wave Level (0 to 127) 
    padding[1];
    u8    WMT_3_DELAY_MODE;        // WMT 3 Delay Mode (0 to 3) 
    u8    WMT_3_DLY_TIME_SYNC;     // WMT 3 DelayTime Sync (0 to 1) 
    u8    WMT_3_DLY_TIME_NOTE;     // WMT 3 DelayTime (note) (0 to 21) 
    u16   WMT_3_DLY_TIME;          // WMT 3 DelayTime (0 to 1023) 
    u8    WMT_3_VRANGE_LO;         // WMT 3 VeloRange Lower (1 to 127) 
    u8    WMT_3_VRANGE_UP;         // WMT 3 VeloRange Upper (1 to 127) 
    u8    WMT_3_VFADE_LO;          // WMT 3 VeloFade Lower (0 to 127) 
    u8    WMT_3_VFADE_UP;          // WMT 3 VeloFade Upper (0 to 127) 
    u8    WMT_4_SW;                // WMT 4 Wave Switch (0 to 1) 
    u8    WMT_4_WAV_GTYPE;         // WMT 4 Wave Group Type (0 to 2) 
    u16   WMT_4_WAV_GID;           // WMT 4 Wave Group ID (0 to 16383) 
    u16   WMT_4_WAV_NUM_L;         // WMT 4 Wave Number L (0 to 16383) 
    u16   WMT_4_WAV_NUM_R;         // WMT 4 Wave Number R (0 to 16383) 
    u8    WMT_4_WAV_GAIN;          // WMT 4 Wave Gain (0 to 5) 
    u8    WMT_4_FXM_SW;            // WMT 4 Wave FXM Switch (0 to 1) 
    u8    WMT_4_FXM_COLOR;         // WMT 4 Wave FXM Color (1 to 4) 
    u8    WMT_4_FXM_DEPTH;         // WMT 4 Wave FXM Depth (0 to 16) 
    s8    WMT_4_PIT_CRS;           // WMT 4 Wave Coarse Tune (-48 to 48) 
    s8    WMT_4_PIT_FINE;          // WMT 4 Wave Fine Tune (-50 to 50) 
    s8    WMT_4_PAN;               // WMT 4 Wave Pan (-64 to 63) 
    u8    WMT_4_PAN_RND_SW;        // WMT 4 Wave Random Pan Sw (0 to 1) 
    u8    WMT_4_PAN_ALT_SW;        // WMT 4 Wave Alternate Pan Sw (0 to 2) 
    u8    WMT_4_LEVEL;             // WMT 4 Wave Level (0 to 127) 
    padding[1];
    u8    WMT_4_DELAY_MODE;        // WMT 4 Delay Mode (0 to 3) 
    u8    WMT_4_DLY_TIME_SYNC;     // WMT 4 DelayTime Sync (0 to 1) 
    u8    WMT_4_DLY_TIME_NOTE;     // WMT 4 DelayTime (note) (0 to 21) 
    u16   WMT_4_DLY_TIME;          // WMT 4 DelayTime (0 to 1023) 
    u8    WMT_4_VRANGE_LO;         // WMT 4 VeloRange Lower (1 to 127) 
    u8    WMT_4_VRANGE_UP;         // WMT 4 VeloRange Upper (1 to 127) 
    u8    WMT_4_VFADE_LO;          // WMT 4 VeloFade Lower (0 to 127) 
    u8    WMT_4_VFADE_UP;          // WMT 4 VeloFade Upper (0 to 127) 
    u8    FILTER_TYPE;             // TVF Filter Type (0 to 6) 
    padding[1];
    u16   CUTOFF;                  // TVF Cutoff Frequency (0 to 1023) 
    u8    CUTOFF_VCRV;             // TVF Cutoff Velocity Curve (0 to 7) 
    u8    CUTOFF_VSENS;            // TVF Cutoff Velocity Sens (-100 to 100) 
    u16   RESO;                    // TVF Resonance (0 to 1023) 
    u8    RESO_VSENS;              // TVF Resonance Velocity Sens (-100 to 100) 
    u8    LEVEL_VCRV;              // TVA Level Velocity Curve (0 to 7) 
    u8    LEVEL_VSENS;             // TVA Level Velocity Sens (-100 to 100) 
    u8    TEMPO_SYNC;              // Wave Tempo Sync (0 to 1) 
};
struct PCMS_PTL {      // byte length 36
    u8    OSC_TYPE;                // OSC Type (0 to 4) 
    u8    VA_FORM;                 // VA Waveform (0 to 8) 
    u16   SYNC_WAV_NUM;            // PCM-Sync Wave Number (0 to 16383) 
    u8    PW;                      // Pulse Width (0 to 127) 
    s8    PWM_DEPTH;               // PWM Depth (-63 to 63) 
    u8    SSAW_DETUNE;             // SuperSAW Detune (0 to 127) 
    u8    CLICK_TYPE;              // Click Type (0 to 3) 
    u16   HPF_CUTOFF;              // HPF Cutoff (0 to 1023) 
    u8    FILTER_TYPE;             // Filter Type (0 to 1) 
    u8    FILTER_SLOPE;            // Filter Slope (0 to 2) 
    u8    ADSR_ENV_SW;             // ADSREnv Switch (0 to 1) 
    u8    FAT;                     // Fat (0 to 127) 
    u8    VCF_TYPE;                // VCF Type (0 to 3) 
    u8    OSC_ATT;                 // OSC Attenuator (0 to 255) 
    u8    CUTOFF_KF_BP;            // Cutoff Keyfollow Base Point (0 to 127) 
    u8    VA_INVERT_SW;            // VA Waveform Invert Switch (0 to 1) 
    s8    FENV_FINE_DEPTH;         // TVF Env Fine Depth (-63 to 63) 
    u8    PENV_LFO_TRIG_SW;        // PENV LFO Trigger Switch (0 to 1) 
    u8    FENV_LFO_TRIG_SW;        // FENV LFO Trigger Switch (0 to 1) 
    u8    AENV_LFO_TRIG_SW;        // AENV LFO Trigger Switch (0 to 1) 
    u8    PITCH_DOWN_DEPTH;        // Pitch Down Depth (0 to 120) 
    u8    VCF_GC;                  // VCF Gain Correction (0 to 127) 
    u8    VA_INIT_PHASE;           // VA Init Phase (0 to 72) 
    padding[11];
};
struct PCMR_CMN {      // byte length 28
    char  NAME[16];
    padding[2];
    u16   PHRASE;                  // Phrase Number (0 to 65535) 
    u8    LEVEL;                   // Level (0 to 127) 
    padding[2];
    u8    PHRASE_VEL_RATE;         // Phrase Velo Rate (1 to 200) 
    u8    PHRASE_VEL_SHIFT;        // Phrase Velo Shift (-100 to 100) 
    padding[3];
};
struct RCMP {      // byte length 8
    u8    SW;                      // Comp Switch (0 to 1) 
    u8    ATTCK;                   // Comp Attack Time (0 to 100) 
    u8    RELEASE;                 // Comp Release Time (0 to 99) 
    s8    THRESHOLD;               // Comp Threshold (-60 to 0) 
    u8    RATIO;                   // Comp Ratio (0 to 7) 
    u8    KNEE;                    // Comp Knee (0 to 30) 
    s8    POSTGAIN;                // Comp Output Gain (-48 to 48) 
    u8    OUT_ASGN;                // Comp Output Assign (0 to 10) 
};
struct PCMR_PTL {      // byte length 20
    u16   INST_NUM;                // Inst Number (0 to 32768) 
    u8    INST_GTYPE;              // Inst Bank (0 to 2) 
    padding[1];
    u16   INST_GID;                // Inst Group ID (0 to 16383) 
    u8    LEVEL;                   // Level (0 to 127) 
    padding[1];
    s8    PAN;                     // Pan (-64 to 63) 
    u8    CHO_SEND;                // Chorus Send Level (0 to 127) 
    u8    REV_SEND;                // Reverb Send Level (0 to 127) 
    u8    MUTE_GRP;                // Mute Group (0 to 31) 
    u8    OUT_ASGN;                // Output Assign (0 to 7) 
    s8    KEY_OFST;                // Key Offset (-24 to 24) 
    s8    PIT_FINE_OFST;           // Fine Tune Offset (-50 to 50) 
    u8    CUTOFF_OFST;             // TVF Cutoff Offset (-100 to 100) 
    u8    RESO_OFST;               // TVF Resonance Offset (-100 to 100) 
    u8    TVA_ATK_OFST;            // TVA Attack Time Offset (-100 to 100) 
    u8    TVA_DCY_OFST;            // TVA Decay Time Offset (-100 to 100) 
    u8    TVA_REL_OFST;            // TVA Release Time Offset (-100 to 100) 
};
struct MFX {      // byte length 84
    u8    mfxType;                 // Type (0 to 93) 
    u8    mfxSwitch;               // MFX Switch (0 to 1) 
    u8    choSend;                 // MFX Chorus Send Level (0 to 127) 
    u8    revSend;                 // MFX Reverb Send Level (0 to 127) 
    u8    ctrlSrc1;                // MFX CtrlSrc 1 (0 to 100) 
    s8    ctrlSens1;               // MFX CtrlSens 1 (-63 to 63) 
    u8    ctrlSrc2;                // MFX CtrlSrc 2 (0 to 100) 
    s8    ctrlSens2;               // MFX CtrlSens 2 (-63 to 63) 
    u8    ctrlSrc3;                // MFX CtrlSrc 3 (0 to 100) 
    s8    ctrlSens3;               // MFX CtrlSens 3 (-63 to 63) 
    u8    ctrlSrc4;                // MFX CtrlSrc 4 (0 to 100) 
    s8    ctrlSens4;               // MFX CtrlSens 4 (-63 to 63) 
    u8    ctrlAsgn_1;              // MFX CtrlAsgn 1 (0 to 11) 
    u8    ctrlAsgn_2;              // MFX CtrlAsgn 2 (0 to 11) 
    u8    ctrlAsgn_3;              // MFX CtrlAsgn 3 (0 to 11) 
    u8    ctrlAsgn_4;              // MFX CtrlAsgn 4 (0 to 11) 
    s16   param_1;                 // MFX Parameter 1 (-20000 to 20000) 
    s16   param_2;                 // MFX Parameter 2 (-20000 to 20000) 
    s16   param_3;                 // MFX Parameter 3 (-20000 to 20000) 
    s16   param_4;                 // MFX Parameter 4 (-20000 to 20000) 
    s16   param_5;                 // MFX Parameter 5 (-20000 to 20000) 
    s16   param_6;                 // MFX Parameter 6 (-20000 to 20000) 
    s16   param_7;                 // MFX Parameter 7 (-20000 to 20000) 
    s16   param_8;                 // MFX Parameter 8 (-20000 to 20000) 
    s16   param_9;                 // MFX Parameter 9 (-20000 to 20000) 
    s16   param_10;                // MFX Parameter 10 (-20000 to 20000) 
    s16   param_11;                // MFX Parameter 11 (-20000 to 20000) 
    s16   param_12;                // MFX Parameter 12 (-20000 to 20000) 
    s16   param_13;                // MFX Parameter 13 (-20000 to 20000) 
    s16   param_14;                // MFX Parameter 14 (-20000 to 20000) 
    s16   param_15;                // MFX Parameter 15 (-20000 to 20000) 
    s16   param_16;                // MFX Parameter 16 (-20000 to 20000) 
    s16   param_17;                // MFX Parameter 17 (-20000 to 20000) 
    s16   param_18;                // MFX Parameter 18 (-20000 to 20000) 
    s16   param_19;                // MFX Parameter 19 (-20000 to 20000) 
    s16   param_20;                // MFX Parameter 20 (-20000 to 20000) 
    s16   param_21;                // MFX Parameter 21 (-20000 to 20000) 
    s16   param_22;                // MFX Parameter 22 (-20000 to 20000) 
    s16   param_23;                // MFX Parameter 23 (-20000 to 20000) 
    s16   param_24;                // MFX Parameter 24 (-20000 to 20000) 
    s16   param_25;                // MFX Parameter 25 (-20000 to 20000) 
    s16   param_26;                // MFX Parameter 26 (-20000 to 20000) 
    s16   param_27;                // MFX Parameter 27 (-20000 to 20000) 
    s16   param_28;                // MFX Parameter 28 (-20000 to 20000) 
    s16   param_29;                // MFX Parameter 29 (-20000 to 20000) 
    s16   param_30;                // MFX Parameter 30 (-20000 to 20000) 
    s16   param_31;                // MFX Parameter 31 (-20000 to 20000) 
    s16   param_32;                // MFX Parameter 32 (-20000 to 20000) 
    padding[4];
};
struct MDLSYN0 {      // byte length 112
    u8    MODEL;                   // Model (0 to 5) 
    u8    LFOWAVE;                 // LFO WAVE FORM (0 to 10) 
    u16   LFORATE;                 // LFO RATE (0 to 1023) 
    u16   LFODLY;                  // LFO DELAY TIME (0 to 1023) 
    u8    OSC1MOD;                 // OSC1 MOD (-100 to 100) 
    u8    OSC1PENV;                // OSC1 PITCH ENV DEPTH (-100 to 100) 
    u8    OSC1DEST;                // OSC1 DEST SELECT (0 to 2) 
    u8    OSC1ENVS;                // OSC1 ENVT SELECT (0 to 1) 
    u16   OSC1WAVE;                // OSC1 WAVE FORM (0 to 27) 
    u8    OSC1FEET;                // OSC1 FEET (0 to 4) 
    s8    OSC1COARSE;              // OSC1 COARSE TUNE (-48 to 48) 
    s8    OSC1FINE;                // OSC1 FINE TUNE (-50 to 50) 
    u8    OSC1LOWFREQ;             // OSC1 LOW FREQ PITCH (0 to 127) 
    u8    OSC1MODE;                // OSC1 MODE (0 to 1) 
    s8    OSC1PWM;                 // OSC1 PWM DEPTH (-63 to 63) 
    u8    OSC1PLSW;                // OSC1 PULSE WIDTH (0 to 127) 
    u8    OSC1PLSM;                // OSC1 PULSE WIDTH MODE (0 to 2) 
    u8    OSC2MOD;                 // OSC2 MOD (-100 to 100) 
    u8    OSC2PENV;                // OSC2 PITCH ENV DEPTH (-100 to 100) 
    u16   OSC2WAVE;                // OSC2 WAVE FORM (0 to 27) 
    u8    OSC2FEET;                // OSC2 FEET (0 to 4) 
    s8    OSC2COARSE;              // OSC2 COARSE TUNE (-48 to 48) 
    s8    OSC2FINE;                // OSC2 FINE TUNE (-50 to 50) 
    u8    OSC2LOWFREQ;             // OSC2 LOW FREQ PITCH (0 to 127) 
    u8    OSC2MODE;                // OSC2 MODE (0 to 1) 
    u8    OSC2PW;                  // OSC2 PULSE WIDTH (0 to 127) 
    u8    OSC3MOD;                 // OSC3 MOD (-100 to 100) 
    u8    OSC3PENV;                // OSC3 PITCH ENV DEPTH (-100 to 100) 
    u16   OSC3WAVE;                // OSC3 WAVE FORM (0 to 27) 
    u8    OSC3FEET;                // OSC3 FEET (0 to 4) 
    s8    OSC3COARSE;              // OSC3 COARSE TUNE (-48 to 48) 
    s8    OSC3FINE;                // OSC3 FINE TUNE (-50 to 50) 
    u8    OSC3LOWFREQ;             // OSC3 LOW FREQ PITCH (0 to 127) 
    u8    OSC3MODE;                // OSC3 MODE (0 to 1) 
    u8    NOISE;                   // NOISE (0 to 1) 
    u16   MODDPTH;                 // MOD DEPTH (0 to 10800) 
    u8    MODMODE;                 // MOD MODE (0 to 3) 
    u8    MXROSC1;                 // OSC1 LEVEL (0 to 255) 
    u8    MXROSC2;                 // OSC2 LEVEL (0 to 255) 
    u8    MXROSC3;                 // OSC3 LEVEL (0 to 255) 
    u8    MXRNOISE;                // NOISE LEVEL (0 to 255) 
    s8    MXRENVD;                 // MIXER ENV DEPTH (-63 to 63) 
    u8    MXRENVS;                 // MIXER ENV SELECT (0 to 1) 
    u8    MXRDYNA;                 // MIXER DYNAMICS (0 to 3) 
    u8    FLTTYPE;                 // FILTER TYPE (0 to 3) 
    u8    FLTHPF2;                 // FILTER HPF STEP (0 to 3) 
    u16   FLTHPF1;                 // FILTER HPF (0 to 1023) 
    u16   FLTFREQ;                 // FILTER FREQ (0 to 1023) 
    u16   FLTRESO;                 // FILTER RESO (0 to 1023) 
    u16   FLTENVD;                 // FILTER ENV DEPTH (-1023 to 1023) 
    u8    FLTENVS;                 // FILTER ENV SELECT (0 to 1) 
    u8    FLTSLOPE;                // FILTER SLOPE (0 to 2) 
    u16   FLTKYBD;                 // FILTER KEY FOLLOW (-200 to 200) 
    u8    FLTMOD;                  // FILTER MOD (-100 to 100) 
    padding[1];
    u8    AMPLVL;                  // AMP LEVEL (0 to 127) 
    u8    AMPMOD1;                 // AMP MOD (-100 to 100) 
    u8    AMPMOD2;                 // AMP MOD STEP (0 to 3) 
    u8    AMPENVS;                 // AMP ENV SELECT (0 to 3) 
    u16   ENV1A;                   // ENV1 ATTACK (0 to 1023) 
    u16   ENV1D;                   // ENV1 DECAY (0 to 1023) 
    u16   ENV1S;                   // ENV1 SUSTAIN (0 to 1023) 
    u16   ENV1R;                   // ENV1 RELEASE (0 to 1023) 
    u8    ENV1KYBD1;               // ENV1 KEY FOLLOW (-100 to 100) 
    u8    ENV1KYBD2;               // ENV1 KEY FOLLOW STEP (0 to 6) 
    u16   ENV2A;                   // ENV2 ATTACK (0 to 1023) 
    u16   ENV2D;                   // ENV2 DECAY (0 to 1023) 
    u16   ENV2S;                   // ENV2 SUSTAIN (0 to 1023) 
    u16   ENV2R;                   // ENV2 RELEASE (0 to 1023) 
    u8    ENV2MODE;                // ENV2 MODE (0 to 2) 
    u8    ENV2KYBD1;               // ENV2 KEY FOLLOW (-100 to 100) 
    u8    ENV2KYBD2;               // ENV2 KEY FOLLOW STEP (0 to 3) 
    u8    DYNPTCH;                 // DYNAMICS PITCH (0 to 3) 
    u8    DYNFLTT;                 // DYNAMICS FILTER (0 to 3) 
    u8    DYNAMP;                  // DYNAMICS AMP (0 to 3) 
    u8    PCHDRFT;                 // PITCH DRIFT (0 to 255) 
    u8    BNDPTCH2;                // BENDER PITCH DEPTH STEP (0 to 3) 
    s8    BNDFLT;                  // BENDER FILTER DEPTH (-63 to 63) 
    s8    BNDLFO;                  // MODULATION LFO DEPTH (-63 to 63) 
    u16   BNDPTCH1;                // BENDER PITCH DEPTH (0 to 4800) 
    u16   PTATIME;                 // PORTAMENT TIME (0 to 1023) 
    u8    PTAMODE;                 // PORTAMENT MODE (0 to 2) 
    u8    KBDMODE;                 // KEY MODE (0 to 3) 
    u8    EXPAND;                  // PARAMETER EXPANSION SWITCH (0 to 1) 
    u8    CONDITION;               // CONDITION (0 to 100) 
    u8    PTACRV;                  // PORTAMENT CURVE TYPE (0 to 3) 
    s8    AFT_LFO;                 // AFTER TOUCH SENS LFO (-63 to 63) 
    s8    AFT_FREQ;                // AFTER TOUCH SENS FREQ (-63 to 63) 
    s8    AFT_LEV;                 // AFTER TOUCH SENS LEVEL (-63 to 63) 
    padding[2];
};
struct MDLJD800COM {      // byte length 44
    u8    LEVEL;                   // Level (0 to 100) 
    u8    KEYA_RNG_LO;             // Key Range A Low (0 to 127) 
    u8    KEYA_RNG_HI;             // Key Range A High (0 to 127) 
    u8    KEYB_RNG_LO;             // Key Range B Low (0 to 127) 
    u8    KEYB_RNG_HI;             // Key Range B High (0 to 127) 
    u8    KEYC_RNG_LO;             // Key Range C Low (0 to 127) 
    u8    KEYC_RNG_HI;             // Key Range C High (0 to 127) 
    u8    KEYD_RNG_LO;             // Key Range D Low (0 to 127) 
    u8    KEYD_RNG_HI;             // Key Range D High (0 to 127) 
    u8    BND_RNG_DW;              // Bender Range Down (0 to 48) 
    u8    BND_RNG_UP;              // Bender Range Up (0 to 12) 
    u8    AFT_BEND;                // After Touch Bend Sens (0 to 26) 
    u8    SOLO_SW;                 // Solo Switch (0 to 1) 
    u8    LEGATO_SW;               // Solo Legato Switch (0 to 1) 
    u8    PORT_SW;                 // Portamento Switch (0 to 1) 
    u8    PORT_MODE;               // Portamento Mode (0 to 1) 
    u8    PORT_TIME;               // Portamento Time (0 to 100) 
    u8    EQ_MID_Q;                // EQ Mid Q (5 to 160) 
    u16   EQ_LO_F;                 // EQ Low Frequency (20 to 16000) 
    u16   EQ_MID_F;                // EQ Mid Frequency (20 to 16000) 
    u16   EQ_HI_F;                 // EQ High Frequency (20 to 16000) 
    u16   EQ_LO_G;                 // EQ Low Gain (-240 to 240) 
    u16   EQ_MID_G;                // EQ Mid Gain (-240 to 240) 
    u16   EQ_HI_G;                 // EQ High Gain (-240 to 240) 
    u8    EQ_SW;                   // EQ Switch (0 to 1) 
    u8    UNISON;                  // Unison Switch (0 to 1) 
    padding[12];
};
struct MDLJD800PTL {      // byte length 80
    u8    PTL_SW;                  // Layer Partial Switch (0 to 1) 
    u8    ACT_SW;                  // Active Partial Switch (0 to 1) 
    u8    VELO_CRV;                // Velocity Curve (0 to 3) 
    u8    HOLD_CTRL;               // Hold Control Switch (0 to 1) 
    u8    LFO1_WAV;                // LFO1:Waveform (0 to 4) 
    u8    LFO1_SYNC;               // LFO1:Rate sync (0 to 1) 
    u8    LFO1_RATE;               // LFO1:Rate (0 to 100) 
    u8    LFO1_NOTE;               // LFO1:Rate nt (0 to 22) 
    u8    LFO1_DLY;                // LFO1:Delay time (0 to 101) 
    s8    LFO1_FADE;               // LFO1:Fade time (-50 to 50) 
    u8    LFO1_OFST;               // LFO1:Offset (0 to 2) 
    u8    LFO1_KEY;                // LFO1:Key trig (0 to 1) 
    u8    LFO2_WAV;                // LFO2:Waveform (0 to 4) 
    u8    LFO2_SYNC;               // LFO2:Rate Sync (0 to 1) 
    u8    LFO2_RATE;               // LFO2:Rate (0 to 100) 
    u8    LFO2_NOTE;               // LFO2:Rate nt (0 to 22) 
    u8    LFO2_DLY;                // LFO2:Delay Time (0 to 101) 
    s8    LFO2_FADE;               // LFO2:Fade time (-50 to 50) 
    u8    LFO2_OFST;               // LFO2:Offset (0 to 2) 
    u8    LFO2_KEY;                // LFO2:Key trig (0 to 1) 
    u16   WAV_NUM;                 // WG:Waveform (0 to 16383) 
    u8    WAV_SRC;                 // WG:Wave source (0 to 49) 
    u8    WAV_GAIN;                // WG:Wave gain (0 to 5) 
    s8    PIT_COARSE;              // WG:Pitch coarse (-48 to 48) 
    s8    PIT_FINE;                // WG:Pitch fine (-50 to 50) 
    u8    PIT_RND;                 // WG:Pitch random (0 to 100) 
    u8    PIT_KF;                  // WG:Pitch KF (0 to 16) 
    u8    BENDER_SW;               // WG:Bender Sw (0 to 1) 
    u8    AFT_BEND_SW;             // WG:Atch bend sw (0 to 1) 
    s8    LFO1_DEP;                // WG:LFO1 depth (-50 to 50) 
    s8    LFO2_DEP;                // WG:LFO2 depth (-50 to 50) 
    s8    LEVER_SENS;              // WG:Lever sens (-50 to 50) 
    s8    AFT_SENS;                // WG:Atch msens (-50 to 50) 
    s8    PENV_VSENS;              // Pitch Env Velocity Sens (-50 to 50) 
    s8    PENV_T_VS;               // Pitch Env Time Velocity Sens (-50 to 50) 
    s8    PENV_T_KF;               // Pitch Env Time Keyfollow (-10 to 10) 
    s8    PENV_L0;                 // Pitch Env L0 (-50 to 50) 
    s8    PENV_L1;                 // Pitch Env L1 (-50 to 50) 
    s8    PENV_L2;                 // Pitch Env L2 (-50 to 50) 
    u8    PENV_T1;                 // Pitch Env T1 (0 to 100) 
    u8    PENV_T2;                 // Pitch Env T2 (0 to 100) 
    u8    PENV_T3;                 // Pitch Env T3 (0 to 100) 
    u8    TVF_FLT;                 // TVF:Filter mode (0 to 2) 
    u8    TVF_CUTOFF;              // TVF:Cutoff freq (0 to 100) 
    u8    TVF_RESO;                // TVF:Resonance (0 to 100) 
    u8    TVF_KF;                  // TVF:Cutoff KF (0 to 40) 
    s8    TVF_AFT;                 // TVF:Atch sens (-50 to 50) 
    u8    TVF_LFO;                 // TVF:LFO select (0 to 1) 
    s8    TVF_LFO_DEP;             // TVF:LFO depth (-50 to 50) 
    s8    TVF_ENV_DEP;             // TVF:ENV depth (-50 to 50) 
    s8    FENV_VSENS;              // F-ENV:Velo sens (-50 to 50) 
    s8    FENV_T_VS;               // F-ENV:T vsens (-50 to 50) 
    s8    FENV_T_KF;               // F-ENV:Time KF (-10 to 10) 
    u8    FENV_L1;                 // F-ENV:Level 1 (0 to 100) 
    u8    FENV_L2;                 // F-ENV:Level 2 (0 to 100) 
    u8    FENV_SUS;                // F-ENV:Sus Level (0 to 100) 
    u8    FENV_L4;                 // F-ENV:Level 4 (0 to 100) 
    u8    FENV_T1;                 // F-ENV:Time 1 (0 to 100) 
    u8    FENV_T2;                 // F-ENV:Time 2 (0 to 100) 
    u8    FENV_T3;                 // F-ENV:Time 3 (0 to 100) 
    u8    FENV_T4;                 // F-ENV:Time 4 (0 to 100) 
    u8    TVA_BS_DIR;              // TVA Bias Direction (0 to 2) 
    u8    TVA_BS_KEY;              // TVA Bias Point (0 to 127) 
    s8    TVA_BS_LVL;              // TVA:Bias level (-10 to 10) 
    u8    TVA_LEVEL;               // TVA:Level (0 to 100) 
    s8    TVA_AFT;                 // TVA After Touch Sens (-50 to 50) 
    u8    TVA_LFO;                 // TVA:LFO select (0 to 1) 
    s8    TVA_LFO_DEP;             // TVA:LFO depth (-50 to 50) 
    s8    AENV_VSENS;              // A-ENV:Velo sens (-50 to 50) 
    s8    AENV_T_VS;               // A-ENV:T vsens (-50 to 50) 
    s8    AENV_T_KF;               // A-ENV:Time KF (-10 to 10) 
    u8    AENV_L1;                 // A-ENV:Level 1 (0 to 100) 
    u8    AENV_L2;                 // A-ENV:Level 2 (0 to 100) 
    u8    AENV_SUS;                // A-ENV:Sus level (0 to 100) 
    u8    AENV_T1;                 // A-ENV:Time 1 (0 to 100) 
    u8    AENV_T2;                 // A-ENV:Time 2 (0 to 100) 
    u8    AENV_T3;                 // A-ENV:Time 3 (0 to 100) 
    u8    AENV_T4;                 // A-ENV:Time 4 (0 to 100) 
    padding[1];
};
struct MDLJD800FxB {      // byte length 32
    u8    SEQUENCE;                // Sequence (0 to 5) 
    u8    DLY_SW;                  // DL Switch (0 to 1) 
    u8    DLY_C_SYNC;              // Delay Center (sync sw) (0 to 1) 
    u8    DLY_C_TIME;              // Delay Center (time) (0 to 125) 
    u8    DLY_C_NOTE;              // Delay Center (note) (0 to 21) 
    u8    DLY_L_SYNC;              // Delay Left (sync sw) (0 to 1) 
    u8    DLY_L_TIME;              // Delay Left (time) (0 to 125) 
    u8    DLY_L_NOTE;              // Delay Left (note) (0 to 21) 
    u8    DLY_R_SYNC;              // Delay Right (sync sw) (0 to 1) 
    u8    DLY_R_TIME;              // Delay Right (time) (0 to 125) 
    u8    DLY_R_NOTE;              // Delay Right (note) (0 to 21) 
    u8    DLY_C_LEV;               // Center Level (0 to 100) 
    u8    DLY_L_LEV;               // Left Level (0 to 100) 
    u8    DLY_R_LEV;               // Right Level (0 to 100) 
    u8    DLY_FB;                  // Delay Feedback (0 to 98) 
    u8    CHO_SW;                  // Chorus Sw (0 to 1) 
    u8    CHO_RATE;                // Chorus Rate (0 to 99) 
    u8    CHO_DEPTH;               // Chorus Depth (0 to 100) 
    u8    CHO_DLY;                 // Chorus Delay (0 to 99) 
    u8    CHO_FB;                  // Chorus Feedback (0 to 98) 
    u8    CHO_LEV;                 // Chorus Level (0 to 100) 
    u8    REV_SW;                  // Reverb Sw (0 to 1) 
    u8    REV_TYPE;                // Reverb Type (0 to 9) 
    u8    REV_DLY;                 // Reverb Pre Delay (0 to 120) 
    u8    REV_ER_LEV;              // Reverb ER Lev (0 to 100) 
    u8    REV_HF_DAMP;             // Reverb HF Damp (0 to 16) 
    u8    REV_TIME;                // Reverb Time (0 to 99) 
    u8    REV_LEV;                 // Reverb Level (0 to 100) 
    u8    BAL;                     // Balance (0 to 100) 
    u8    LEVEL;                   // Level (0 to 127) 
    padding[2];
};
struct MDLVDN {      // byte length 32
    u8    MSTR_LVL;                // Level (0 to 127) 
    u8    MIC_LVL;                 // Mic Direct Level (0 to 127) 
    u8    VOC_LVL;                 // Vocoder Level (0 to 127) 
    u8    ALGO;                    // Algorithm (0 to 25) 
    u8    CRR_TYPE;                // Carrier Type (0 to 1) 
    u8    RSV_CRR_BASIC;           // Reserved (0 to 0) 
    u8    LEVEL;                   // Carrier Basic Level (0 to 127) 
    s8    PAN;                     // Carrier Basic Pan (-64 to 63) 
    s8    PIT_CRS;                 // Carrier Basic Coarse Tune (-48 to 48) 
    s8    PIT_FINE;                // Carrier Basic Fine Tune (-50 to 50) 
    s8    OCTAVE;                  // Carrier Basic Octave Shift (-2 to 2) 
    padding[21];
};
struct TONECOM {      // byte length 20
    char  NAME[16];
    u8    CATEGORY;                // Category (0 to 50) 
    u8    RSRV8;                   // Reserved (0 to 0) 
    u16   RSRV16;                  // Reserved (0 to 0) 
};
struct PCMEX {      // byte length 1632
    PCMT_CMN        pcmt_cmn;      // Block Length 64 Total Length 64
    MFX             mfx;           // Block Length 84 Total Length 84
    PCMT_PMT        pcmt_pmt;      // Block Length 52 Total Length 52
    PCMT_PTL        pcmt_ptl[4];   // Block Length 124 Total Length 496
    PTL_PENV        ptl_penv[4];   // Block Length 24 Total Length 96
    PTL_FENV        ptl_fenv[4];   // Block Length 24 Total Length 96
    PTL_AENV        ptl_aenv[4];   // Block Length 16 Total Length 64
    PTL_LFO         ptl_lfo[4];    // Block Length 104 Total Length 416
    PTL_EQ          ptl_eq[4];     // Block Length 16 Total Length 64
    PCMS_CMN        pcms_cmn;      // Block Length 20 Total Length 20
    PCMS_PMT        pcms_pmt;      // Block Length 36 Total Length 36
    PCMS_PTL        pcms_ptl[4];   // Block Length 36 Total Length 144
};
struct PCMR {      // byte length 3328
    PCMR_CMN        pcmr_cmn;      // Block Length 28 Total Length 28
    MFX             mfx;           // Block Length 84 Total Length 84
    RCMP            rcmp[6];       // Block Length 8 Total Length 48
    PCMR_PTL        pcmr_ptl[88];  // Block Length 20 Total Length 1760
    PTL_EQ          ptl_eq[88];    // Block Length 16 Total Length 1408
};
struct MdlSynPrm0 {      // byte length 216
    MDLSYN0         mdlsyn0;       // Block Length 112 Total Length 112
    MFX             mfx;           // Block Length 84 Total Length 84
    TONECOM         tonecom;       // Block Length 20 Total Length 20
};


//=========================
// dataStartOffset includes this 16 byte header.
// the data could be CRC32 checksums (one for each element of the array)
// or offsets from the start of this to elements in an array if the elements
// are variable length like in an SVZ user samples chunk.
struct ZenArray<type> {
    h32 count;
    h32 elementSize;
    u32 dataStartOffset;
    h32 notSure;
    
    // offset includes size of this header
    if (dataStartOffset>16) {
        u32 dataLength = dataStartOffset-16;
        if (dataLength%4 == 0)
            u32 extraArrayData[dataLength/4];
        else
            u8 extraArrayData[dataLength];     
    }
         
    type elements[count];
};

struct ZenUnknownArray {
    h32 count;
    h32 elementSize;
    u32 dataStartOffset;
    h32 notSure;
    
    // offset includes size of this header
    if (dataStartOffset>16) {
        u32 dataLength = dataStartOffset-16;
        if (dataLength%4 == 0)
            u32 extraArrayData[dataLength/4];
        else
            u8 extraArrayData[dataLength];     
    }
         
    std::Array<std::Array<u8, elementSize>, count> elements;
};

struct ZenChecksummedArray<type> {
    h32 count;
    h32 elementSize;
    u32 dataStartOffset;
    h32 notSure;
    
    // offset includes size of this header
    if (dataStartOffset>16) {
        std::assert( (dataStartOffset % 4) ==0,"Checksummed array not divisible by 4");
        u32 dataLength = dataStartOffset-16;
        h32 checksums[dataLength/4];
    }
         
    type elements[count];
};

// for an array thats only ever going to have 1 entry
struct Zen1Array {
    h32 count;
    h32 elementSize;            // should just be one for this
    u32 dataStartOffset;
    h32 notSure;
    
    // offset includes size of this header
    if (dataStartOffset>16) {
        u32 dataLength = dataStartOffset-16;
        if (dataLength%4 == 0)
            u32 extraArrayData[dataLength/4];
        else
            u8 extraArrayData[h32];     
    }
          
};

struct ZenArrayWithChecksum<type> {
    h32 count;
    h32 elementSize;
    h32 dataStartOffset;  // should be 0x14 = 20
    h32 notSure;
    
    h32 CRC32;    
    type elements[count];
};

struct Patch {
    char name[16];
    padding[1616];
    };

struct DrumPatch {
    char name[16];
    padding[3312];
};

struct DrumInfo {
    INST_CMN cmn;
    PTL_PENV pEnv;
    PTL_FENV fEnv;
    PTL_AENV aEnv;
    };    // 216
       
struct DrumKitInfo {
    DrumInfo drums[88];
};

struct TrackDrumKitInfo {
    DrumKitInfo clipBased[16];
    DrumKitInfo trackBased;
};

enum TrackType :u8 {Synth=0,Drum,Looper,None=0xff};
enum SoundSource :u8 { Track=0, Clip };
enum OnOff :u8 { Off=0, On };
enum Output :u8 { MainMix=0, AssignOut };

struct TrackInfo {
    h32 u1;
    TrackType trackType;
    SoundSource source;
    padding[13];
    Output output;
    padding[16];
    u8 trackColour;
    padding[219];
};


struct Unknown4 {
    padding[4];
    h32 unk;
    OnOff eq;
    padding[3];
}; //12

struct TrackDrumPatches {
    PCMR clipBased[16];
    PCMR trackBased;
    };
    
struct TrackTonePatches {
   PCMEX clipBased[16];
   PCMEX trackBased;
};

// 16 notes per event MC
struct NoteData {
    u8 mutePercent[16];
    u8 note[16];         // ff if off
    u8 velocity[16];
    s8 start[16];       // -50 - 99%
    u8 end[16];         // 0-99, 100=tie
    u8 subStep[16];     // 0=Off, 1/2, 1/3, 1/4, Flam
};

// sixteen motion data but split into 2 lots of 8. MC
struct MotionData {     // ff = no value or 0-127
    u8 filter[8];
    u8 mod[8];
    u8 fx[8];
    u8 sound[8];
    u8 filter2[8];
    u8 mod2[8];
    u8 fx2[8];
    u8 sound2[8];
};
    
struct ClipSomething {
    char name[16];
    padding[2];
    TrackType trackType;
    padding[5];
    u8 TxProgramChangeNumber;
    u8 TxProgramChangeLSB;
    u8 TxProgramChangeMSB;
    padding[741];
    u8 scale;           // 0=1/8
    u8 stepLen;
    padding[4];
    u16 length; // 0=off 1-512
    u8 shuffle;
    u8 direction; // 0=fwd rev fwd+rev inv rnd
    padding[1];
    u8 nextClip; // 254=stay 255=stop 0..15=clip1...clip16
    padding[180];
    NoteData noteData[128];
    MotionData motionData[160];
    u8 unk[128];
};

struct TrackClipInfo {
    ClipSomething clipBased[16];
    ClipSomething trackBased;
};

struct LooperClipInfo {
    char name[16];
    padding[196];
};

struct TrackLooperInfo {
    LooperClipInfo clipBased[16];
    LooperClipInfo trackBased;
};

struct PRJData {
    u32 start=$;
    std::print("st {0} el {1} s {2}",start,parent.elementSize,parent.elementSize-($-start));
    char name[16];
    u16 tempoTimes100;
    padding[26];
    u8 scale;       // 0=1/8, 1/16, 1/32, 1/4T, 1/8T, 1/16T
    u8 stepLen;   
    padding [466];
    TrackInfo trackInfo[8];
    Unknown4 u4[8];
    u8 z1[0x680];
    
    // these are groups of 136, 9x8. 8 things for clip based, 1 for track based, repeated 8 times.
    TrackClipInfo clipInfo[8];
    TrackTonePatches tones[8];
    TrackDrumPatches drums[8];
    TrackDrumKitInfo drumKitInfo[8];
    TrackLooperInfo looperInfo[8];
};

struct PRJChapter {
    ZenArray<PRJData> data;
};

struct STPChapter {
};

struct SYSChapter {
};

struct SampleInfo {
    char name[16];
    padding[48];
    bool present;  // loop type? 
    h8 volume;
    h8 tune; //cents
    padding[1];
    u8 gain;  // 0,6,12
    u8 note;
    padding[2];
    u32 startFrame;
    u32 loopFrame;
    u32 endFrame;
};
    
struct Unk1 {
    char name[16];
    padding[512];
    };
    
struct USR {
    Patch patches[64];
    DrumPatch drums[64];
    DrumInfo clipInfo[5632];
    SampleInfo sampleInfo[500];
    Unk1 dontKnow[128];
};

struct USRChapter {
    Zen1Array array;
    USR usr;
};

struct LooperDirectoryInfo {
    u32 index;          // array index+32? or 0xffffffff if not used
    u32 sampleCount;
    u32 frequency;
    u32 channelCount;
};

struct LPPTrackDirectoryInfo {
    LooperDirectoryInfo clipDirectory[16]; 
};

struct LPPChapter {
    Zen1Array array;
    LPPTrackDirectoryInfo tracks[8];
};

/*
    Samples are 32 bit little endian integer, but with 16x compression past a point
    if stereo, left samples in a block first, then right samples.    
    
    if (decodedValue & 0x80000000) {
      decodedValue =  (decodedValue & 0x7fffffff)
      negative=true;
    }
           
   if ( decodedValue >= 0x20000000 ) {
       decodedValue = decodedValue - 0x22000000;    // rebase
       decodedValue = decodedValue * 16;          // 16x scale .. dont use shift in JS as it will convert signed and bugger up the result
       decodedValue = decodedValue + 0x20000000;   // rebase  
   }
       
  if (negative)
    decodedValue = -decodedValue

*/
struct LPDSampleEntry {
    h32 length;
    h32 offset;
    h32 u1;
    h32 u2;
    if (length!=0) {
        u32 start = parent.parent.LPDDataStart + offset;
        u8 sample[length] @ start;
    }
};

struct LPDTrackSampleArray {
    LPDSampleEntry clipSamples[16];
};

struct LPDChapter {
    u32 start = $;
    
    h32 entries;
    h32 length;
    h32 startOffset;
    h32 u1;
    char id[4];
    h32 u2,u3,u4;
    u32 LPDDataStart = $;
    LPDTrackSampleArray tracks[8];
    
    // LPDSampleEntry will mark the sample blocks, we need to move current 
    // point past LPDChapter or rest will be marked as leftover
    $ = start+length+startOffset;
};

/** ---------------
 * Sample data is 16 bit LE PCM (at least for MC/MV, all i have seen), 
 * but encoded with an XOR algorithm.
 *
 * Acutal data is padded into block of totalDataSize (or totalDataSize/2 for stereo).
 * 64 bytes of 0 at beginning
 * total length is padded out multiples of 512
 * minimum number of unused data to end of padding is 128. less than that, add another 512 to it
 * if stereo, this rule applies to both halves
 *
 * xor encode/decode algorithm in JS (both inputs arrays)
 *
 *        function xorTransform(data, key) {
 *           const k = key.length;
 *           const out = new Array(data.length);
 *       
 *           for (let i = 0; i < data.length; i++) {
 *               out[i] = data[i] ^ key[i % k];
 *           }
 *       
 *           return out;
 *       }
 *
 *  const key = [
 *      0x06, 0x00, 0x00, 0x00, 0x1a, 0x00, 0x10, 0x00, 0x02, 0x00,
 *      0x08, 0x00, 0x02, 0x00, 0x16, 0x00, 0x00, 0x00, 0x00, 0x00 ];
 *
*/

struct SMPd {               // samples
    char header[4];         // SMPd
    h32 u1;
    h32 totalDataSize;              // total size of all data in this SMPd including padding, both channels
    h32 sampleDataSizePerChannel;   // amount of actual sample data in each channel, ignoring padding
    char name[16];
    u8 sampleNumber;
    u8 stereoFlag;          // 0x80 stereo
    padding[2];
    u32 sampleRate;
    h32 u3;
    h32 u4;
    
    if (stereoFlag) {
        u8 totalData[totalDataSize] @ $;
        u32 singleChannelDataSize = totalDataSize/2;
        
        u8 leftSampleData[sampleDataSizePerChannel] @ $+64;
        u8 leftDataBlock[singleChannelDataSize];
        
        u8 rightData[sampleDataSizePerChannel] @ $+64;
        u8 rightDataBlock[singleChannelDataSize];
    } else {
        u8 sampleData[sampleDataSizePerChannel] @ $+64;
        u8 totalData[totalDataSize];
    }
};

struct SMPh {               // Sample list header
    char header[4];
    h32 headerSize;          // 
    h32 always2IThink;       // no idea
    h32 numSampleChunks;     //
    u8 extra[headerSize-16]; // always appears to be 16 0s but YMMV
    
    SMPd data[numSampleChunks];
};

struct USDChapter {
    Zen1Array array;
    if (array.elementSize>0)
        SMPh smph;
};

//

//---------------------  SH4D  ------------------

struct PatternInfoSH4D {    //32
    u8 patternLevel;
    padding[20];
    u8 voiceReserve[5];
    u8 chainLength;
    padding[2];
    u8 patternChainOn;
    u8 nextPattern;
    padding[1];
};

struct PartInfoSH4D {       //88
    u8 unknown3[11];
    u8 bank;                // 0=user, 64=SH4-d,68=SH3-d,69=Sync,70=SH-101
    u8 patch;
    u8 level;
    s8 pan;
    u8 unknown[19];
    u8 chorus;
    u8 reverb;
    u8 delay;
    u8 unknown2[49];
    u8 flag1;
    u8 mixerLevel;    
};

struct PartInfoSH4D_3 { // 12
    u8 unknown[12];
};

struct PartInfoSH4D_4 { // 84
    u8 unknown[84];
};

struct PartInfoSH4D_2 { //24
    u8 stepLength;          // -1 of val
    u8 firstStep;           // -1 of val
    u8 firstStepOn;
    u8 lastStep;            // -1 of val
    u8 lastStepOn;
    u8 scale;               // 0=1/8,1/16,1/32,1/4t,1/8t,1/16t
    u8 playMode;            // 0=fwd,rev,fwd+rev,inv,rnd
    u8 gateLengthOffset;    // 80=centre
    u8 shuffle;
    u8 smooth;              // 1=off,2=on
    u8 motionOn;            
    u8 mute;
    padding[12];    
};

struct StepDataSH4D {
    u8 note[8];         // or FF for none
    u8 velocity[8];
    u8 gate[8];         // 0-100, 101=TIE
    u8 motionCC[4];     // FF for none
    u8 motionValue[4];
    u8 probibility[8];
    u8 sub[8];          // Off, flam=1, 1/4, 1/3, 1/2, +10%...+90%
    u8 unknown[4];
};

struct PartNoteDataSH4D {
    StepDataSH4D steps[64];
};

struct PRFd {
    char name[16];
    PatternInfoSH4D patternInfo;
    PartInfoSH4D partInfo[5];
    padding[4];
    PartInfoSH4D_3 partInfo3[5];
    PartInfoSH4D_4 partInfo4[5];
    padding[1256];
    PartInfoSH4D_2 partInfo2[5];
    PartNoteDataSH4D notes[5];
};

struct PRFdChapter {
    ZenArray<PRFd> array;
};
//-----------------------------------------------


//-----------------------------------------------
struct RHIa {
    MdlSynPrm0 MdlSynPrm0[88];
};

struct RHIaChapter {
    ZenArray<RHIa> array;
};
//-----------------------------------------------


//-----------------------------------------------
struct RHYa {
    PCMR pcmr;
};

struct RHYaChapter {
    ZenArray<RHYa> array;
};
//-----------------------------------------------


//-----------------------------------------------
struct MDLa {
    PCMEX pcmex;
    u8 model[416];
};

struct MDLaChapter {
    ZenChecksummedArray<MDLa> array;
};
//-----------------------------------------------


//-----------------------------------------------
struct PATaChapter {
    ZenChecksummedArray<PCMEX> array;
};

struct PATcHeader { // SH-4d 16
    u8 unknown[6];
    u8 flag1;   // set to 6 for everything except wavetable and drawing (7)
    padding[1];
    u8 model;   // 16=SH-4d,SH-3d,Sync,SH-101,Cross FM,Ring,Wavetable,Drawing,Chord,Juno 106,PCM,Scep,Harmonic
    padding[7];    
};

struct PATc {       // SH-4d
    PATcHeader header;
    PCMEX pcmex;
    u8 model[400];  // 416 minus unknown above.
};

struct PATcChapter {
    ZenArray<PATc> array;
};
//-----------------------------------------------


//-----------------------------------------------
struct DIFa {
};

struct DIFaChapter {
    ZenChecksummedArray<DIFa> array;
};
//-----------------------------------------------

//-----------------------------------------------

struct UnknownChapter {
    ZenUnknownArray array;
};
//-----------------------------------------------


struct ChapterData {
    u32 start = $;
    
    match(parent.type, parent.model) {
        ("PRJa", _) : PRJChapter prj;
        ("USDa", _) : USDChapter usd;
        ("USRa", _) : USRChapter usr;
        ("LPPa", _) : LPPChapter lpp;
        ("LPDa", _) : LPDChapter lpd;
        ("DIFa", _) : DIFaChapter difa;
        ("MDLa", _) : MDLaChapter mdla;
        ("PATa", _) : PATaChapter pata;
        ("PATc", _) : PATcChapter patc;
        ("RHIa", _) : RHIaChapter rhia;
        ("RHYa", _) : RHYaChapter rhya;
        ("PRFd", _) : PRFdChapter prfd;
        ("USPa","ZCOR") : UnknownChapter u1;
        (_,_)  : UnknownChapter u2;
    }
        
    std::print("Chapter {0} start={1:08x} length={2:08x} leftover={3:08x}",parent.type,start,parent.length,parent.length-($-start));
    char leftOvers[parent.length-($-start)];
};

struct ChapterPointer {
    char type[4];
    char model[4];
    $+=4;       // skip start
    h32 length;    
    $-=8;   // start
    
    u32 tempPtr = $;
    if (length>0)
        ChapterData *data : h32 @ $;
    else
        h32 start;

    $=tempPtr+4;
    $+=4; // skip length
};

struct Header {
    u16 chapterPointersBlockLength;
    char id[2];
    char id2[4];
    padding [8];    
};


Header header @0x00;

u32 numberOfChapters = (header.id=="PR" || header.id=="SV" || header.id=="CL")? (header.chapterPointersBlockLength + 2 - 16) / 16 : header.id2[0];

ChapterPointer chapterPointers[numberOfChapters] @(sizeof(Header));