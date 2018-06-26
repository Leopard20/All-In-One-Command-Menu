////////////////////////////////
// Grab config values and start
////////////////////////////////
//AIO_debug = getnumber(configfile>> "AIO_AICOVER_Key_Setting"  >> "AIO_DEBUG");

//AIO_key = getnumber(configfile>> "AIO_AIMENU_Key_Setting"  >> "AIO_key");
//AIO_mapkey = getnumber(configfile>> "AIO_AIMENU_Key_Setting"  >> "AIO_mapkey");
//AIO_key = 73;
//AIO_HC_Module_Enabled = 1; AIO_Zeus_Enabled = 1; AIO_force_Zeus_enabled = false;
//AIO_Zeus_Enabled = getNumber (configfile >> "AIO_AIMENU_Settings" >> "AIO_Zeus_Enabled");
//AIO_HC_Module_Enabled = getNumber (configfile >> "AIO_AIMENU_Settings" >> "AIO_High_Command_Enabled");

0 = [] execVM "AIO_AIMENU\postInit.sqf";
0 = [1] execVM "AIO_AIMENU\zeus.sqf";
0 = [] execVM "AIO_AIMENU\createHCmodule.sqf";




	

