#define DEFAULT_HUNGER_FACTOR 0.05 // Factor of how fast mob nutrition decreases
#define DEFAULT_THIRST_FACTOR 0.03 // Factor of how fast mob hydration decreases

#define XENOMORPH_HUNGER_FACTOR 0.09 // Larger
#define XENOMORPH_THIRST_FACTOR 0.09 // Closed cycle body

#define SYNTHETIC_HUNGER_FACTOR 0.05 // We're more energy efficient than humans
#define SYNTHETIC_THIRST_FACTOR 0.2 // Gotta cool down fast

#define REM 0.01 // Means 'Reagent Effect Multiplier'. This is a ratio of how much reagents are consumed per tick

#define CHEM_TOUCH 1
#define CHEM_INGEST 2
#define CHEM_INJECT 3

#define MINIMUM_CHEMICAL_VOLUME 0.0000001

#define REAGENTS_OVERDOSE 30

#define CHEM_SYNTH_ENERGY 500 // How much energy does it take to synthesize 1 unit of chemical, in Joules.

#define CE_STABLE         "stable"       // Stabilizing brain, pulse and breathing
#define CE_ANTIBIOTIC     "antibiotic"   // Spaceacilin
#define CE_BLOODRESTORE   "bloodrestore" // Iron/nutriment
#define CE_PAINKILLER     "painkiller"   // Reduces the impact of shock/pain
#define CE_ALCOHOL        "alcohol"      // Liver filtering
#define CE_ALCOHOL_TOXIC  "alcotoxic"    // Liver damage
#define CE_SPEEDBOOST     "gofast"       // Stimulants
#define CE_SLOWDOWN       "goslow"       // Slowdown
#define CE_PULSE          "xcardic"      // increases or decreases heart rate
#define CE_NOPULSE        "heartstop"    // stops heartbeat
#define CE_ANTITOX        "antitox"      // Removes toxins
#define CE_OXYGENATED     "oxygen"       // Helps oxygenate the brain.
#define CE_BRAIN_REGEN    "brainfix"     // Allows the brain to recover after injury
#define CE_TOXIN          "toxins"       // Generic toxins, stops autoheal.
#define CE_BREATHLOSS     "breathloss"   // Adjust breathing rate
#define CE_MIND    		  "mindbending"  // Stabilizes or wrecks mind. Used for hallucinations
#define CE_CRYO 	      "cryogenic"    // Prevents damage from being frozen
#define CE_BLOCKAGE	      "blockage"     // Gets in the way of blood circulation, higher the worse
#define CE_SQUEAKY		  "squeaky"      // Helium voice. Squeak squeak.
#define CE_THIRDEYE       "thirdeye"     // Gives xray vision.
#define CE_SEDATE         "sedate"       // Applies sedation effects, i.e. paralysis, inability to use items, etc.
#define CE_ENERGETIC      "energetic"    // Speeds up stamina recovery.
#define	CE_VOICELOSS      "whispers"     // Lowers the subject's voice to a whisper
#define CE_GLOWINGEYES    "eyeglow"      // Causes eyes to glow.
#define CE_PRESSURE		  "pressure"
#define CE_BLOOD_THINNING "thinning"
#define CE_SREC           "srec"         // Prevents SREC from growing and slightly improves the symptoms. In high numbers can purge SREC.

#define CE_REGEN_BRUTE   "bruteheal"    // Causes brute damage to regenerate.
#define CE_REGEN_BURN    "burnheal"     // Causes burn damage to regenerate.

#define GET_CHEMICAL_EFFECT(X, C) (LAZYACCESS(X.chem_effects, C) || 0)

//reagent flags
#define IGNORE_MOB_SIZE BITFLAG(0)
#define AFFECTS_DEAD    BITFLAG(1)

#define HANDLE_REACTIONS(_reagents)  if(!QDELETED(_reagents)) { SSmaterials.active_holders[_reagents] = TRUE; }
#define UNQUEUE_REACTIONS(_reagents) SSmaterials.active_holders -= _reagents

#define REAGENT_LIST(R) (R.reagents?.get_reagents() || "No reagent holder")

#define REAGENTS_FREE_SPACE(R) (R?.maximum_volume - R?.total_volume)
#define REAGENT_VOLUME(REAGENT_HOLDER, REAGENT_TYPE) (REAGENT_HOLDER?.reagent_volumes && REAGENT_HOLDER.reagent_volumes[REAGENT_TYPE])
#define REAGENT_DATA(REAGENT_HOLDER, REAGENT_TYPE)   (REAGENT_HOLDER?.reagent_data    && REAGENT_HOLDER.reagent_data[REAGENT_TYPE])

#define MAT_SOLVENT_NONE     0
#define MAT_SOLVENT_MILD     0.1
#define MAT_SOLVENT_MODERATE 0.2
#define MAT_SOLVENT_STRONG   0.3

#define DIRTINESS_STERILE -2
#define DIRTINESS_CLEAN   -1
#define DIRTINESS_NEUTRAL  0

#define DEFAULT_GAS_ACCELERANT /decl/material/gas/hydrogen
#define DEFAULT_GAS_OXIDIZER   /decl/material/gas/oxygen
