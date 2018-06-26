if (player getvariable ["tpw_nv",0] == 0) then 
    { 
        { 
        _x addItem "NVGoggles"; 
        _x assignItem "NVGoggles"; 
        _x setvariable ["tpw_goggles",(goggles _x)]; 
        removegoggles _x; 
        } foreach units (group player); 
    player setvariable ["tpw_nv",1]; 
    } else 
    { 
        { 
        _x unassignItem "NVGoggles"; 
        _x removeItem "NVGoggles"; 
        _x addgoggles (_x getvariable "tpw_goggles"); 
        _x assignitem (_x getvariable "tpw_goggles"); 
        } foreach units (group player); 
    player setvariable ["tpw_nv",0]; 
    }; 