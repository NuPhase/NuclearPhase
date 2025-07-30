USERNAME="Pl3aseJust3ndMySuffering"
PPT="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"
PORT=1480
THREADS=4

cd
cd NuclearPhase
git pull -u $USERNAME -p $PPT
DreamMaker nuclear_phase.dme
screen DreamDaemon nuclear_phase.dmb $PORT -trusted -logself -map-threads $THREADS -profile