# DUMMY

[ -f dummy_z_config.inc ] && DUMMY="dummy_z_config.inc"
[ -f "../dummy_z_config.inc" ] && DUMMY="../dummy_z_config.inc"
[ -f "rp-mt-scripts/dummy_z_config.inc" ] && DUMMY="rp-mt-scripts/dummy_z_config.inc"

[ "$DUMMY" = "" ] && echo "rp-mt-scripts never configured, can't find dummy, bailing.  Unzip a fresh install." && exit

source $DUMMY
